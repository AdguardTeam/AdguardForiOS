#!/bin/bash

#  exportLocalization.sh
#  Adguard
#
#  Copyright (c) 2014 Performix. All rights reserved.
apikey=1XWeEWpeodFLldJPepIgIzHhKHEq8Jy0
secretkey=DASNmQ9kJCYBxhH7DbQ3bs1AJkawPBfi

STRINGS_ID=44557
IBSTRINGS_ID=44554

# Project root directory
THEROOT="${SRCROOT}/AdguardApp"

# Pro version root directory
THEPROROOT="${SRCROOT}/AdguardPro"

# Shared root directory
THESHAREDROOT="${SRCROOT}/SharedComponents"

# Action extension root directory
THEACTIONROOT="${SRCROOT}/ActionExtension"

# XIB FILES LIST PATH
XIBFILESLIST="./Resources/xib-files-list.txt"

########## Uploading XIB function
xibUpload()
{

filename=$(basename "${1}")
filename="${filename%.*}"
dir=$(dirname "${1}")

echo "Uploading ${filename}.strings file for DEV locale"

# STRING FILE
FILE="${PROJECT_TEMP_DIR}/${filename}.strings"

# BASE DIRECTORY
THEBASE="${SRCROOT}/${dir}"

echo "File for processing:"
echo "${THEBASE}/${filename}.storyboard"

ibtool --generate-strings-file "${FILE}" "${THEBASE}/${filename}.storyboard"
python ./Resources/upload.py -l en_US_POSIX -p $IBSTRINGS_ID -f "${FILE}" -a $apikey -s $secretkey -r IOS_STRINGS
rm "${FILE}"
}

###################################
echo "========================= UPLOAD XIB FILES =============================="
while read -r -u 10 file; do
if [ "${file}" ]; then
xibUpload "${file}"
fi
done 10<${XIBFILESLIST}

if [ "${file}" ]; then
xibUpload "${file}"
fi

#################################
echo "========================= UPLOAD STRING FILES =============================="

echo "Uploading Application Strings for DEV locale"

file="Localizable.strings"

echo "Main App strings uploading.. "
rm -v "${THEROOT}/Base.lproj/${file}"
find "${THEROOT}" "${THESHAREDROOT}" "${THEPROROOT}" -name \*.m | xargs genstrings -o "${THEROOT}/Base.lproj"

python ./Resources/upload.py -l en_US_POSIX -p $STRINGS_ID -f "${THEROOT}/Base.lproj/${file}" -a $apikey -s $secretkey -r IOS_STRINGS

echo "Done"

echo "Pro Tunnel strings uploading.. "

file="AdguardPro.Tunnel.strings"
rm -v "${THEROOT}/Base.lproj/${file}"
find "${THEROOT}" "${THESHAREDROOT}" "${THEPROROOT}" -name \*.m | xargs genstrings -o "${THEROOT}/Base.lproj"

python ./Resources/upload.py -l en_US_POSIX -p $STRINGS_ID -f "${THEROOT}/Base.lproj/${file}" -a $apikey -s $secretkey -r IOS_STRINGS

echo "Done"

echo "Action Extension strings uploading.. "
rm -v "${THEACTIONROOT}/Base.lproj/${file}"
find "${THEACTIONROOT}" "${THESHAREDROOT}" -name \*.m | xargs genstrings -o "${THEACTIONROOT}/Base.lproj"

aFile="${PROJECT_TEMP_DIR}/ActionExtensionLocalizable.strings"
cp -vf "${THEACTIONROOT}/Base.lproj/${file}" "${aFile}"

python ./Resources/upload.py -l en_US_POSIX -p $STRINGS_ID -f "${aFile}" -a $apikey -s $secretkey -r IOS_STRINGS

rm -v "${aFile}"

echo "Done"

#echo "Uploading Application Strings Dict for DEV locale"
#file="Localizable.stringsdict"
#python ./Resources/upload.py -l en_US_POSIX -p ##### -f $THEROOT/Base.lproj/$file -a $apikey -s $secretkey -r IOS_STRINGSDICT_XML

echo "Upload finished"
