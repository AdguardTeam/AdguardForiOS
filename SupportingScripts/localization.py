#!/usr/bin/python3

import os
import sys
import subprocess
import tempfile
import shutil
import requests
import json
import glob
import optparse
import re
import xml.etree.ElementTree as ET

#
# Runtime variables
#
TEMP_DIR = tempfile.mkdtemp()
# Directory of this python file
CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))

#
# Configuration
#
API_UPLOAD_URL = "https://twosky.adtidy.org/api/v1/upload"
API_DOWNLOAD_URL = "https://twosky.adtidy.org/api/v1/download"
# Root directory of the project files (relative to this script)
BASE_PATH = "../"

# Loads twosky configuration from .twosky.json.
# This configuration file contains:
# * languages -- the list of languages we support
# * project_id -- twosky project ID
# * base_locale -- base language of our app
# * localizable_files -- list of localizable files masks
with open(os.path.join(CURRENT_DIR, "../.twosky.json"), 'r') as f:
    TWOSKY_CONFIG = json.load(f)[0]

#
# This is the map {'.strings: .storyboard'}
#

STORYBOARD_STRINGS = {}

for path in TWOSKY_CONFIG["storyboard_dirs"]:
    targetPath = os.path.join("../", path)

    xibDir = "Base.lproj"
    stringsDir = "en.lproj"
    
    path = os.path.join(targetPath, xibDir)

    print(dir)
    print(path)

    localisationFiles = os.listdir(path)
    localisationFiles = filter(lambda x: x.endswith('.storyboard'), localisationFiles)
    for xibFile in localisationFiles:
        xibFilePath = os.path.join(path, xibFile)
        stringsFile = os.path.splitext(xibFile)[0] + ".strings"
        stringsFilePath = os.path.join(targetPath, stringsDir)
        stringsFilePath = os.path.join(stringsFilePath, stringsFile)

        # check files exists
        if not os.path.isfile(stringsFilePath):
            print("WARNING. There is no .strings file for {0}".format(xibFilePath))
            print("Expected file {0}".format(stringsFilePath))
            continue

        STORYBOARD_STRINGS[xibFilePath] = stringsFilePath

#
# This is the list of non-XIB files to localize.
#
LOCALIZABLE_FILES = []

for path in TWOSKY_CONFIG["localizable_files"]:
    targetPath = os.path.join(CURRENT_DIR, BASE_PATH, path)
    LOCALIZABLE_FILES.append(targetPath)
    
    #check files exists
    if not os.path.isfile(targetPath):
        raise FileNotFoundError("Localizable file {0} not found".format(targetPath))


DRY_RUN = False

def changeEncoding(file):
    print("change encoding of file {0} from utf-16 to utf-8".format(file))
    """ Changes encoding of file from UTF-16 to UTF-8 
    """
    with open(file, "rb") as f:
        with open("temp.strings", "wb") as f2:
            content = f.read().decode('utf-16')
            f2.write(content.lstrip().encode('utf-8')) 
    os.rename("temp.strings", file)


def upload_file(path, format, language, file_name):
    """Uploads the specified file to the translation API

    Arguments:
    path -- path to the file to upload
    format -- format of the file (for instance, 'strings' or 'json')
    language -- file language
    file_name -- name of the file in the translation system
    """
    files = {"file": open(path, "rb")}
    values = {
        "format": format,
        "language": language,
        "filename": file_name,
        "project": TWOSKY_CONFIG["project_id"]
    }

    print("Uploading {0}/{1} to the translation system".format(language, file_name))
    print("file path {0}".format(path))

    if DRY_RUN:
        return

    result = requests.post(API_UPLOAD_URL, files=files, data=values)
    result_text = result.text

    if result.status_code != 200:
        raise ConnectionError("Could not upload. Response status={0}\n{1}".format(result.status_code, result_text))

    print("Response: {0}".format(result_text))
    result_json = json.loads(result_text)
    if result_json['ok'] != True:
        raise ConnectionError("Could not upload. Response status={0}\n{1}".format(result.status_code, result_text))
    return


def download_file(file_name, language, format, path):
    """Downloads the specified file from the translations system

    Arguments:
    file_name -- name of the file in the translations system
    language -- language to download
    format -- format of the file (for instance, 'strings' or 'json')
    path -- destination path where the file is to be written
    """
    print("Downloading {0}/{1} from the translation system".format(language, file_name))
    print("save to {0}".format(path))

    if DRY_RUN:
        return

    params = {
        "filename": file_name,
        "format": format,
        "project": TWOSKY_CONFIG["project_id"],
        "language": language
    }
    result = requests.get(API_DOWNLOAD_URL, params=params)
    if result.status_code != 200:
        raise ConnectionError("Could not download. Response status={0}\n{1}".format(result.status_code, result.text))

    target_dir = os.path.dirname(path)
    if not os.path.exists(target_dir):
        raise ValueError(
            "Target directory does not exist: {0}, make sure that you've added this language in XCode".format(target_dir))

    file = open(path, "wb")
    file.write(result.content)
    file.close()
    print("The file was downloaded to {0}".format(path))
    return


def xib_to_strings(xib_path, strings_path):
    """Generates a strings file from the specified xib"""
    print("Generating {0} file from {1}".format(strings_path, xib_path))

    # check both files exist
    # it is not a error. Just skip it
    if not os.path.isfile(strings_path):
        print("file {0} does not exist. Skip it.".format(strings_path))
        return

    if not os.path.isfile(xib_path):
        print("file {0} does not exist. Skip it.".format(xib_path))
        return

    if DRY_RUN:
        return

    result = subprocess.run([
        "ibtool",
        "--generate-strings-file",
        strings_path,
        xib_path
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    if len(result.stdout) > 0:
        print("ibtool stdout:\n{0}".format(result.stdout))

    if len(result.stderr) > 0:
        print("ibtool stderr:\n{0}".format(result.stderr))

    if result.returncode != 0:
        raise ChildProcessError(
            "failed to generate the .strings file from {0}. Return code {1}.".format(xib_path, result.returncode))

    if not os.path.exists(strings_path):
        raise FileNotFoundError(strings_path)

    changeEncoding(strings_path)
    # Finished generating strings
    return


def strings_to_xib(strings_path, xib_path):
    """Imports strings from the .strings file to the specified .xib"""
    print("Importing strings from {0} to {1}".format(strings_path, xib_path))

    # check both files exist
    # it is not a error. Just skip it
    if not os.path.isfile(strings_path):
        print("file {0} does not exist. Skip it.".format(strings_path))
        return

    if not os.path.isfile(xib_path):
        print("file {0} does not exist. Skip it.".format(xib_path))
        return
    
    if DRY_RUN:
        return

    result = subprocess.run([
        "ibtool",
        "--import-strings-file",
        strings_path,
        xib_path,
        "--write",
        xib_path
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    if len(result.stdout) > 0:
        print("ibtool stdout:\n{0}".format(result.stdout))

    if len(result.stderr) > 0:
        print("ibtool stderr:\n{0}".format(result.stderr))

    if result.returncode != 0:
        raise ChildProcessError(
            "failed to import strings from {0}. Return code {1}.".format(strings_path, result.returncode))

    # Finished importing strings
    return


def export_localizable_file(path, locale):
    """Uploads the specified localizable file to the translation system"""
    
    file_name = os.path.basename(path)
    file_ext = os.path.splitext(file_name)[1][1:]
    localized_file = path.replace("en.lproj", "{0}.lproj".format(locale))

    print("Exporting {0}".format(localized_file))

    if not os.path.exists(localized_file):
        raise FileNotFoundError(localized_file)
    
    # Now upload the file
    upload_file(localized_file, "macosx", locale, file_name)
    return


def import_localizable_file(path, locale):
    """Imports the specified localizable file from the translation system"""
    file_name = os.path.basename(path)
    file_ext = os.path.splitext(file_name)[1][1:]

    localized_file = path.replace("en.lproj", "{0}.lproj".format(locale))

    print("Importing {0}".format(localized_file))

    # Download the file
    download_file(file_name, locale, file_ext, localized_file)
    return


def get_translation_path(base_path, locale):
    """Gets path to the XIB file translation given it's relative path

    For example, if path is 'ProgramLog/Base.lproj/AAProgramLog.xib' and locale is 'de',
    the translation path will be 'ProgramLog/de.lproj/AAProgramLog.strings'
    """

    path = base_path.replace("Base.lproj", "{0}.lproj".format(locale))
    return path


def export_localizations():
    """Entry point for the exporting localizations process"""
    print("Start exporting localizations")

    for path in LOCALIZABLE_FILES:
        export_localizable_file(path, TWOSKY_CONFIG["base_locale"])

    print("Finished exporting localizations")
    return


def export_translations(locale):
    """Exports all existing translations to the specified locale
    to the translation system."""
    print("Start exporting translations for locale {0}".format(locale))

    for path in LOCALIZABLE_FILES:
        export_localizable_file(path, locale)

    print("Finished exporting translations to {0}".format(locale))
    return


def export_all_translations():
    """Entry point for the exporting ALL translations process"""

    print("Start exporting ALL translations")
    for language in TWOSKY_CONFIG["languages"]:
        print("Start exporting {0} translations".format(TWOSKY_CONFIG["languages"][language]))
        export_translations(language)
    print("Finihed exporting ALL translations")
    return


def import_localization(locale):
    """Imports translations to the specified language"""
    print("Start importing translations to {0}".format(locale))

    for path in LOCALIZABLE_FILES:
        import_localizable_file(path, locale)

    print("Finished importing translations to {0}".format(locale))
    return


def import_localizations():
    """Entry point for the importing localizations process"""

    print("Start importing localizations")
    for language in TWOSKY_CONFIG["languages"]:
        print("Start importing {0} translations".format(TWOSKY_CONFIG["languages"][language]))
        import_localization(language)
    print("Finished importing localizations")
    return


def update_strings():
    """Entry point for the updating strings from xibs process"""
    print("Start updating .strings files")

    for index, (xib_path, strings_path) in enumerate(STORYBOARD_STRINGS.items()):
        strings_path = os.path.join(CURRENT_DIR, strings_path)
        xib_path = os.path.join(CURRENT_DIR, xib_path)
        xib_to_strings(xib_path, strings_path)

    print("Finished updating .strings files")
    return


def update_xibs():
    """Entry point for the updating xibs from strings process"""
    print("Start updating .xib files")

    for index, (xib_path, strings_path) in enumerate(STORYBOARD_STRINGS.items()):
        strings_path = os.path.join(CURRENT_DIR, strings_path)
        xib_path = os.path.join(CURRENT_DIR, xib_path)
        strings_to_xib(strings_path, xib_path)

    print("Finished updating .xib files")
    return

def check_file_translations(path, locale):
    """Loads all strings from the base file and compares them to 
    the translated version of this file"""
    
    file_name = os.path.basename(path)
    file_ext = os.path.splitext(file_name)[1][1:]
    base_file = path
    localized_file = path.replace("en.lproj", "{0}.lproj".format(locale))

    if not os.path.exists(base_file):
        raise FileNotFoundError(base_file)

    if not os.path.exists(localized_file):
        raise FileNotFoundError(localized_file)

    base_strings_count = get_strings_number(base_file)
    localized_strings_count = get_strings_number(localized_file)

    return base_strings_count, localized_strings_count


def get_strings_number(file_path):
    """Returns number of strings in file"""
    file = open(file_path)
    file_string = file.read()
    if os.path.splitext(file_path) == '.stringsdict':
        tree = ET.parse(file_path)
        root = tree.getroot()
        strings_keys = root[0]
        return len(strings_keys)
    else:
        split_result = re.findall(r'\"(.*)\"[ ]*=[ ]*\"(.*)\";', file_string)
        return len(split_result)



def check_translation(locale):
    """Loads all strings from the base file and compares them to 
    the translated version of this file"""

    strings_count = 0
    translated_count = 0

    for path in LOCALIZABLE_FILES:
        s, t = check_file_translations(path, locale)
        strings_count += s
        translated_count += t
    percent = translated_count / strings_count * 100
    print("{0}, translated {1}%".format(locale, "%.2f" % percent))
    return


def check_translations():
    """Checks existing translations and prints their summary to the output."""
    print("Start checking translations")

    for language in TWOSKY_CONFIG["languages"]:
        if language != "en":
            check_translation(language)

    print("Finished checking translations")
    return


def print_usage():
    print("Usage:")
    print("python3 localization.py command arguments")
    print("commands:")
    print(" -e --export - export strings")
    print(" -i --import - import strings")
    print(" -c --check - checks translations and prints status")
    print(" -s --generate-strings - generate strings filtes from .xib or .storyboard files")
    print(" -x --update-xibs - update .storyboard or .xib files with strings from .strings files")
    print("arguments:")
    print("-l --lang - language for export or import. Can be 'en', 'ru', etc for single locale or 'all' for all locales. Default value is 'en'. NOTE: use '-export -lang all' only if you really understand what you want.")
    print("--dry-run - test only. Do not export/import any files end do not change .strings and .xib files")

    return


def main():
    parser = optparse.OptionParser(usage="%prog [options]. %prog -h for help.")
    parser.add_option("-i", "--import", action="store_true", dest="importMode")
    parser.add_option("-e", "--export", action="store_true", dest="exportMode")
    parser.add_option("-c", "--check", action="store_true", dest="checkTranslations")
    parser.add_option("-x", "--update-xibs", action="store_true", dest="updateXibs")
    parser.add_option("-s", "--generate-strings", action="store_true", dest="generateStrings")
    parser.add_option("-l", "--lang", dest="lang", default='en')
    parser.add_option("--dry-run", action="store_true", dest="dryRun", default=False)

    (options, args) = parser.parse_args(sys.argv)

    global DRY_RUN
    DRY_RUN = options.dryRun

    if options.importMode == True:
        if options.lang == 'all':
            import_localizations()
        else:
            import_localization(options.lang)
        # Print translations summary after import
        check_translations()
    elif options.exportMode == True:
        if options.lang == 'all':
            export_all_translations()
        else:
            export_translations(options.lang)
    elif options.checkTranslations == True:
        check_translations()    
    elif options.updateXibs == True:
        update_xibs()
    elif options.generateStrings == True:
        update_strings()
    else:
        print_usage()

# Entry point
try:
    main()
finally:
    shutil.rmtree(TEMP_DIR)
