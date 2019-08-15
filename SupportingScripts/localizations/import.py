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

def process(file, filename, locale, importMode):
    print('process: ' + filename + ' locale: ' + locale)

    # skip empty files
    if os.path.getsize(file) == 0:
        print('File is empty. Skip it.')
        return

    if importMode:
    	command = 'curl "https://twosky.adtidy.org/api/v1/download?format=strings&language={}&filename={}&project=ios" -o {}'.format(locale, filename, file)
    else:
        command = 'curl -XPOST https://twosky.adtidy.org/api/v1/upload -F format=strings -F language={} -F filename={} -F project=ios -F file=@{}'.format(locale, filename, file)

    print command

    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    process.wait()
    out, err = process.communicate()
    print process.returncode

    if not importMode:
	    if '"ok":true' in out:
	        print 'uplod succeeded'
	    else:
	        print 'error ' + out

def processTarget(folder, lang, importMode):
    targetPath = os.path.join(options.folder, folder)

    lprojDirs = os.listdir(targetPath)
    lprojDirs = filter(lambda dir: dir.endswith('.lproj') and not dir == 'Base.lproj', lprojDirs)
    if lang != "all" :
    	lprojDirs = filter(lambda dir: dir == lang + '.lproj', lprojDirs)

    # upload base 'en' english first
    lprojDirs = sorted(lprojDirs, key=lambda dir: dir == 'en.lproj', reverse=True)

    print(lprojDirs)

    if(len(lprojDirs)):

        for dir in lprojDirs:
            locale = dir[:-6]
            locale = processLocale(locale)
            path = os.path.join(targetPath, dir)

            print(dir)
            print(path)

            localisationFiles = os.listdir(path)
            localisationFiles = filter(lambda x: x.endswith('.strings') or x.endswith('.stringsdict'), localisationFiles)
            for file in localisationFiles:
                filepath = os.path.join(path, file)
                process(filepath, file, locale, importMode)

parser = optparse.OptionParser(usage="%prog [options]. %prog -h for help.")
parser.add_option("-f", "--project_folder", dest="folder", help="project folder", metavar="FILE")
parser.add_option("-l", "--lang", dest="lang", help="language for upload. en by default. all - for all languages", metavar="FILE")
parser.add_option("-i", "--import", action="store_true", dest="importMode", help="import")
parser.add_option("-e", "--export", action="store_false", dest="importMode", help="export")

(options, args) = parser.parse_args(sys.argv)

if (not options.folder):
    parser.error('Project folder not given')

importMode = options.importMode

print importMode

if importMode == None:
	importMode = True


lang = "en" if options.lang == None else options.lang

for dir in xib_files_list:
	processTarget(dir, lang, importMode)
