import os
import sys
import optparse
import re
import codecs
import shutil
import subprocess
import json

xib_files_list_file = "Resources/xib-files-list.txt"
xib_files_list = [line.rstrip('\n') for line in open(xib_files_list_file)]

def processLocale(locale):
    if locale == "zh-Hans":
        return "zh-CN"
    if locale == "zh-Hant":
        return "zh-TW"
    return locale

def changeEncoding(file):
    with open(file, "r") as f:
        with open("temp.strings", "w") as f2:
            content = f.read().decode("UTF-16")
            f2.write(content.lstrip().encode('UTF-8')) 
    os.rename("temp.strings", file)

def process(xibFile, stringsFile, importMode):
    print('process xib: ' + xibFile + ' strings: ' + stringsFile + ' import: ' + ('True' if importMode else 'False'))

    # skip not localized xib files
    if not os.path.isfile(stringsFile):
        return

    if importMode:
        command = 'ibtool --import-strings-file "{}" "{}" --write {}'.format(stringsFile, xibFile, xibFile)
    else:
        command = 'ibtool --generate-strings-file "{}" "{}"'.format(stringsFile, xibFile)

    print command

    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    process.wait()
    out, err = process.communicate()
    print process.returncode
    print out

    if not importMode:
        # ibtool returns utf-16 encoded files. We convert them to utf-8
        changeEncoding(stringsFile)

def processTarget(folder, importMode):
    targetPath = os.path.join(options.folder, folder)

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

        process(xibFilePath, stringsFilePath, importMode)


parser = optparse.OptionParser(usage="%prog [options]. %prog -h for help.")
parser.add_option("-f", "--project_folder", dest="folder", help="project folder", metavar="FILE")
parser.add_option("-i", "--import", action="store_true", dest="importMode", help="import from strings to xibs")
parser.add_option("-e", "--export", action="store_false", dest="importMode", help="export from xibs to strings")

(options, args) = parser.parse_args(sys.argv)

if (not options.folder):
    parser.error('Project folder not given')

importMode = options.importMode

print importMode

if importMode == None:
	importMode = True

print importMode

for dir in xib_files_list:
	processTarget(dir, importMode)
