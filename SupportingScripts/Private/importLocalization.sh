#!/bin/bash

#  importPlistLocalizations.sh
#  Adguard
#

apikey=1XWeEWpeodFLldJPepIgIzHhKHEq8Jy0
secretkey=DASNmQ9kJCYBxhH7DbQ3bs1AJkawPBfi

STRINGS_ID=44557
IBSTRINGS_ID=44554

# Project root directory
THEROOT="${SRCROOT}/AdguardApp"

# Action extension root directory
THEACTIONROOT="${SRCROOT}/ActionExtension"

# XIB FILES LIST PATH
XIBFILESLIST="./Resources/xib-files-list.txt"

####### Getting project locales

LOCALES=
for file in "${THEROOT}"/*.lproj; do
filename=$(basename "$file")
filename="${filename%.*}"
if [ "${filename}" != 'Base' ]; then
LOCALES="${LOCALES} ${filename}"
fi
done

####### Downloading XIB function
xibDownload()
{

filename=$(basename "${1}")
filename="${filename%.*}"
dir=$(dirname "${1}")

# LOCAL ROOT DIRECTORY
LOCALROOT=$(dirname "${dir}")
LOCALROOT="${SRCROOT}/${LOCALROOT}"

for locale in $LOCALES
do
echo "Download $filename for $locale locale"

python ./Resources/download.py -l $locale -p $IBSTRINGS_ID -o "${PROJECT_TEMP_DIR}/${locale}_${filename}" -f "${filename}.strings" -a $apikey -s $secretkey
if [ $? == 0 ]; then
mv -vf "${PROJECT_TEMP_DIR}/${locale}_${filename}" "${LOCALROOT}/$locale.lproj/${filename}.strings"
fi
done

}

################################
echo "========================= UPDATING XIB FILES =============================="

while read -r -u 10 file; do
if [ "${file}" ]; then
xibDownload "${file}"
fi
done 10<${XIBFILESLIST}

if [ "${file}" ]; then
xibDownload "${file}"
fi

##############################
echo "========================= UPDATING STRING FILES =============================="


file="Localizable.strings"
action_file="ActionExtensionLocalizable.strings"
pro_tunnel_file="AdguardPro.Tunnel.strings"
for locale in $LOCALES
do
echo "Download Main Application Strings for $locale locale"
python ./Resources/download.py -l $locale -p $STRINGS_ID -o "${PROJECT_TEMP_DIR}/${locale}_${file}" -f "${file}" -a $apikey -s $secretkey
if [ $? == 0 ]; then
cp -fv "${PROJECT_TEMP_DIR}/${locale}_${file}" "${THEROOT}/$locale.lproj/$file"
rm "${PROJECT_TEMP_DIR}/${locale}_${file}"
fi

echo "Download Pro Tunnel Strings for $locale locale"
python ./Resources/download.py -l $locale -p $STRINGS_ID -o "${PROJECT_TEMP_DIR}/${locale}_${pro_tunnel_file}" -f "${pro_tunnel_file}" -a $apikey -s $secretkey
if [ $? == 0 ]; then
cp -fv "${PROJECT_TEMP_DIR}/${locale}_${pro_tunnel_file}" "${THEROOT}/$locale.lproj/$pro_tunnel_file"
rm "${PROJECT_TEMP_DIR}/${locale}_${pro_tunnel_file}"
fi

echo "Download Action Extension Strings for $locale locale"
python ./Resources/download.py -l $locale -p $STRINGS_ID -o "${PROJECT_TEMP_DIR}/${locale}_${file}" -f "${action_file}" -a $apikey -s $secretkey
if [ $? == 0 ]; then
cp -fv "${PROJECT_TEMP_DIR}/${locale}_${file}" "${THEACTIONROOT}/$locale.lproj/$file"
rm "${PROJECT_TEMP_DIR}/${locale}_${file}"
fi

done



#file="Localizable.stringsdict"
#for locale in $LOCALES
#do
#echo "Download Application Strings Dict for $locale locale"
#python ./Resources/download.py -l $locale -p $STRINGS_ID -o $PROJECT_TEMP_DIR/${locale}_${file} -f $file -a $apikey -s $secretkey
#if [ $? == 0 ]; then
#cp -fv $PROJECT_TEMP_DIR/${locale}_${file} $THEROOT/$locale.lproj/$file
#rm $PROJECT_TEMP_DIR/${locale}_${file}
#fi
#done

echo "Import finished"
