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
API_BASEDIR = "app"
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
            print("WARNING. There is no .strings file for {0}", xibFilePath)
            print("Expected file {0}", stringsFilePath)
            continue

        STORYBOARD_STRINGS[xibFilePath] = stringsFilePath

#
# This is the list of non-XIB files to localize.
#
LOCALIZABLE_FILES = []

for path in TWOSKY_CONFIG["localizable_files"]:
    targetPath = os.path.join("../", path)
    LOCALIZABLE_FILES.append(targetPath)
    os.chdir(CURRENT_DIR)

    #check files exists
    if not os.path.isfile(targetPath):
        raise FileNotFoundError("Localizable file {0} not found".format(targetPath))


DRY_RUN = False

def changeEncoding(file):
    """ Changes encoding of file from UTF-16 to UTF-8 
    """
    with open(file, "r") as f:
        with open("temp.strings", "w") as f2:
            content = f.read().decode("UTF-16")
            f2.write(content.lstrip().encode('UTF-8')) 
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
        "filename": "{0}/{1}".format(API_BASEDIR, file_name),
        "project": TWOSKY_CONFIG["project_id"]
    }

    print("Uploading {0}/{1} to the translation system".format(language, file_name))

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
    print("Exporting {0}".format(path))

    if not os.path.exists(path):
        raise FileNotFoundError(path)

    file_name = os.path.basename(path)
    file_ext = os.path.splitext(file_name)[1][1:]

    # Now upload the file
    upload_file(path, file_ext, locale, file_name)
    return


def import_localizable_file(path, locale):
    """Imports the specified localizable file from the translation system"""
    print("Importing {0}".format(path))

    file_name = os.path.basename(path)
    file_ext = os.path.splitext(file_name)[1][1:]

    # Download the file
    download_file(file_name, locale, file_ext, path)
    return


def get_xib_translation_path(path, locale):
    """Gets path to the XIB file translation given it's relative path

    For example, if path is 'ProgramLog/Base.lproj/AAProgramLog.xib' and locale is 'de',
    the translation path will be 'ProgramLog/de.lproj/AAProgramLog.strings'
    """

    path = path.replace("Base.lproj", "{0}.lproj".format(locale))
    path = os.path.splitext(path)[0] + ".strings"
    return path


def export_localizations():
    """Entry point for the exporting localizations process"""
    print("Start exporting localizations")

    for path in LOCALIZABLE_FILES:
        file_path = os.path.join(BASE_PATH, path)
        export_localizable_file(file_path, TWOSKY_CONFIG["base_locale"])

    print("Finished exporting localizations")
    return


def export_translations(locale):
    """Exports all existing translations to the specified locale
    to the translation system."""
    print("Start exporting translations to {0}".format(locale))

    for path in LOCALIZABLE_FILES:
        file_path = os.path.join(CURRENT_DIR, BASE_PATH, "{0}.lproj".format(locale), path)
        export_localizable_file(file_path, locale)

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

    if lang != 'all':
        return import_localization(lang)

    print("Start importing localizations")
    for language in TWOSKY_CONFIG["languages"]:
        print("Start importing {0} translations".format(TWOSKY_CONFIG["languages"][language]))
        import_localization(language)
    print("Finished importing localizations")
    return


def update_strings():
    """Entry point for the updating strings from xibs process"""
    print("Start updating .strings files")

    for path in STRINGS_FILES:
        strings_rel_path = get_xib_translation_path(path, TWOSKY_CONFIG["base_locale"])
        strings_path = os.path.join(CURRENT_DIR, BASE_PATH, strings_rel_path)
        xib_path = os.path.join(CURRENT_DIR, BASE_PATH, path)
        xib_to_strings(xib_path, strings_path)

    print("Finished updating .strings files")
    return


def update_xibs():
    """Entry point for the updating xibs from strings process"""
    print("Start updating .xib files")

    for path in STRINGS_FILES:
        strings_rel_path = get_xib_translation_path(path, TWOSKY_CONFIG["base_locale"])
        strings_path = os.path.join(CURRENT_DIR, BASE_PATH, strings_rel_path)
        xib_path = os.path.join(CURRENT_DIR, BASE_PATH, path)
        strings_to_xib(strings_path, xib_path)

    print("Finished updating .xib files")
    return


def print_usage():
    print("Usage:")
    print("python localization.py command arguments")
    print("commands:")
    print(" -e --export - export strings")
    print(" -i --import - import strings")
    print(" -s --generate-strings - generate strings filtes from .xib or .storyboard files")
    print(" -x --update-xibs - update .storyboard or .xib files with strings from .strings files")
    print("argumants:")
    print("-l --lang - language for export or import. Can be 'en', 'ru', etc for single locale or 'all' for all locales. Default value is 'en'. NOTE: use '-export -lang all' only if you really understand what you want.")
    print("--dry-run - test only. Do not export/import any files end do not change .strings and .xib files")

    return


def main():

    parser = optparse.OptionParser(usage="%prog [options]. %prog -h for help.")
    parser.add_option("-i", "--import", action="store_true", dest="importMode")
    parser.add_option("-e", "--export", action="store_true", dest="exportMode")
    parser.add_option("-x", "--update-xibs", action="store_true", dest="updateXibs")
    parser.add_option("-s", "--generate-strings", action="store_true", dest="generateStrings")
    parser.add_option("-l", "--lang", dest="lang", default='en')
    parser.add_option("--dry-run", action="store_true", dest="dryRun", default=False)

    (options, args) = parser.parse_args(sys.argv)

    global DRY_RUN
    DRY_RUN = options.dryRun

    if options.importMode == True:
        if options.lang == 'all':
            import_Localizations()
        else:
            import_localization(options.lang)

    elif options.exportMode == True:
        if options.lang == 'all':
            export_all_translations()
        else:
            export_translations(options.lang)
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
