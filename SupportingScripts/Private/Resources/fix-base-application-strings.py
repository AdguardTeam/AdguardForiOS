#!/usr/bin/python

#  fix-base-application-strings.py
#  
#
#  Created by Roman Sokolov on 15.01.16.
#

import json, os, os.path, re, codecs, md5, urllib2, time, hashlib, sys


apikey = "1XWeEWpeodFLldJPepIgIzHhKHEq8Jy0"
secretkey = "DASNmQ9kJCYBxhH7DbQ3bs1AJkawPBfi"

appStringsProject = "44557"
localizationFile="Localizable.strings"
actionLocalizationFile="ActionExtensionLocalizable.strings"

baseLocale = "en-US-POSIX"

# Project shared resources root
theSharedRoot=os.environ['SRCROOT'] + "/SharedComponents"

# Project root
theRoot=os.environ['SRCROOT']
# Project app root
theAppRoot=os.environ['SRCROOT'] + "/AdguardApp"
# Project action root
theActionRoot=os.environ['SRCROOT'] + "/ActionExtension"

# Project temporary directory
tempDir = os.environ['PROJECT_TEMP_DIR'] + "/locales-convertor"


strings = []

if not os.path.exists(tempDir):
    os.makedirs(tempDir)

##############  Functions definitions ###################


def downlodEnAndConvertFile(theFile, toStrings):
    locale= "en"
    temp_path= tempDir + "/" + locale + "_" + theFile
    command = "python ./download.py -l en -p " + appStringsProject + " -o \"" + temp_path + "\" -f " + theFile + " -a " + apikey + " -s " + secretkey
    
    print("Path to temp file..")
    print(temp_path)
    
    print("Downloading \"" + theFile + "\"  for EN.. "),
    
    result = os.system(command)
    
    if result != 0:
        print("Fail")
        raise Exception("Can't download EN localization file.")
    
    print("Done")

    print("Converting string file \"" + theFile + "\".."),
    with codecs.open(temp_path, encoding='utf-16') as f:
        for line in f:
            reResult = re.search(r'^("(?:(?=(\\?))\2.)*?")', line, re.U)
            if reResult:
                first = reResult.group(1)
                pos = len(first)+3
                toStrings.append([first, line[pos:].rstrip(';\n')])

    print("Done")


# Function for getting Oneskyapp active locales

def getLocalesFromOneskyapp(projectId, fileName):
    
    print("Getting locales for project: " + projectId + ", file: \"" + fileName + "\"..")
    resultLocales = []
    
    timestamp = str(int(time.time()))
    devHash = md5.new(timestamp + secretkey).hexdigest()
    
    url = "https://platform.api.onesky.io/1/projects/"
    url += projectId
    url += "/languages"
    url += "?api_key="
    url += apikey
    url += "&timestamp="
    url += timestamp
    url += "&dev_hash="
    url += devHash
    
    response = urllib2.urlopen(url)
    responseJson = response.read()
    responseJson = json.loads(responseJson)
    progress = ""
    for localeData in responseJson['data']:
        progress = localeData['translation_progress'].encode('utf-8')
        locale = localeData['code'].encode('utf-8')
        
        if locale != baseLocale and progress != r'0.0%':
            print("    Locale \"" + locale + "\" " + progress + " translated")
            resultLocales.append(locale.encode('ascii'))

    print("Done")
    
    return resultLocales

# Processing string files

def stringFileDownload(project, locale, fileName):
    localePath = tempDir + "/" + locale
    if not os.path.exists(localePath):
        os.makedirs(localePath)
    
    filePath = localePath + "/" + fileName

    print("Downloding \"" + filePath + "\" file.. "),
    command = "python ./download.py -l " + locale + " -p " + project + " -o \"" + filePath + "\" -f " + fileName + " -a " + apikey + " -s " + secretkey
    
    result = os.system(command)
    
    if result != 0:
        print("Fail")
        raise Exception("Can't download \"" + locale + "\" localization file.")

    print("Done")

def stringProcessing(locale, theFile):
    
    localePath = tempDir + "/" + locale
    if not os.path.exists(localePath):
        os.makedirs(localePath)
    
    filePath = localePath + "/" + theFile

    print("Processing \"" + filePath + "\" file.. ")
    fileContent = u""
    
    needUpload = False
    with codecs.open(filePath, 'r', encoding='utf-16', buffering=0) as f:
        fileContent = f.read()
        
        for theString in strings:
            cutFrom = theString[0]
            cutTo = theString[1]
            if cutFrom != cutTo:
                try:
                    fileContent.index(cutFrom)
                    needUpload = True
                    fileContent = fileContent.replace(cutFrom, cutTo)
                except:
                    pass

    if needUpload:
        print("    Saving file.. "),
        with codecs.open(filePath, "wb", encoding='utf-16') as f:
            f.write(fileContent)
        print("Done")
        
        print("    Uploading file to oneskyapp (" + locale + ").. "),
        
        command = "python ./upload.py -l " + locale + " -p " + appStringsProject + " -f \"" + filePath + "\" -a " + apikey + " -s " + secretkey + " -r IOS_STRINGS"
        
        result = os.system(command)

        if result != 0:
            print("Fail")
            raise Exception("Can't upload localization file \"" + theFile + "\".")

        print("Done")
    else:
        print("No changes")

# ===========================================


# ===========================================
# Downloding EN locale strings from oneskyapp

downlodEnAndConvertFile(localizationFile, strings)
downlodEnAndConvertFile(actionLocalizationFile, strings)

# ===========================================
# Processing sources (.m)


print("Getting project source files.. "),

mFiles = []
command = "find " + theRoot + " -name \\*.m"
with os.popen(command) as f:
    for line in f:
        mFiles.append(line.rstrip('\n'))

if len(mFiles) == 0:
    print("Fail")
    raise Exception("Can't obtain m files from source root.")

print("Done")


for filePath in mFiles:
    
    print("Processing \"" + filePath + "\" file.. "),
    fileContent = u""
    with codecs.open(filePath, 'r', encoding='utf-8', buffering=0) as f:
        fileContent = f.read()

        for theString in strings:
            fileContent = fileContent.replace(theString[0], theString[1])

    with codecs.open(filePath, "wb", encoding='utf-8') as f:
        f.write(fileContent)

    print("Done")

print("======================================")


# ===========================================
# Downloading other locales for  .strings . stringsdict files

locales = getLocalesFromOneskyapp(appStringsProject, localizationFile)
for locale in locales:
    stringFileDownload(appStringsProject, locale, localizationFile)
    stringFileDownload(appStringsProject, locale, actionLocalizationFile)

# ===========================================
# Generating and uploading new Base .strings . stringsdict files

print "Uploading Application Strings for Base locale..",

command = "rm -v \"" + theAppRoot + "/Base.lproj/" + localizationFile + "\"; find " + theAppRoot + " -name \\*.m | xargs genstrings -o " + theAppRoot + "/Base.lproj; find " + theSharedRoot + " -name \\*.m | xargs genstrings -a -o " + theAppRoot + "/Base.lproj; python ./upload.py -l " + baseLocale + " -p " + appStringsProject + " -f \"" + theAppRoot + "/Base.lproj/" + localizationFile + "\" -a " + apikey + " -s " + secretkey + " -r IOS_STRINGS"

result = os.system(command)

if result != 0:
    print("Fail")
    raise Exception("Can't upload localization file: \"" + localizationFile + "\".")
print "Done"

tempFileName = tempDir + "/" + actionLocalizationFile
command = "rm -v \"" + theActionRoot + "/Base.lproj/" + localizationFile + "\"; find " + theActionRoot + " -name \\*.m | xargs genstrings -o " + theActionRoot + "/Base.lproj; find " + theSharedRoot + " -name \\*.m | xargs genstrings -a -o " + theActionRoot + "/Base.lproj; cp -vf \"" + theActionRoot + "/Base.lproj/" + localizationFile + "\" \"" + tempFileName + "\"; python ./upload.py -l " + baseLocale + " -p " + appStringsProject + " -f \"" + tempFileName + "\" -a " + apikey + " -s " + secretkey + " -r IOS_STRINGS; rm -v \"" + tempFileName + "\""

result = os.system(command)

if result != 0:
    print("Fail")
    raise Exception("Can't upload localization file: \"" + actionLocalizationFile + "\".")
print "Done"

print("Wating at 10 seconds..")
time.sleep(10)

# ===========================================
# Uploading other locales for  .strings . stringsdict files


for locale in locales:
    stringProcessing(locale, localizationFile)
    stringProcessing(locale, actionLocalizationFile)
