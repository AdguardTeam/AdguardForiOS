#!/bin/bash

#  runBuilder.sh
#  
#
#  Created by Roman Sokolov on 26.10.15.
#


echo "Running with ACTION=${ACTION}"

case $ACTION in
# NOTE: for some reason, it gets set to "" rather than "build" when
# doing a build.
"")
;;

"clean")
echo "Run Clean Script..."
/bin/bash "${SRCROOT}/../Builder/Builder/clean-script.sh"
exit 0
;;

esac


echo "============================== BUILD BUILDER ==================================="
xcodebuild -workspace "${SRCROOT}/../AdguardSafariExtension-iOS.xcworkspace" -scheme "Builder" -configuration "${CONFIGURATION}" -derivedDataPath "${SYMROOT}"


echo "================================ RUN BUILDER ==================================="
echo "resource folder:"
echo "${BUILDER_RESOURCES_DIR}"
"${BUILDER_DIR}"/Builder --${CONFIGURATION} "${BUILDER_RESOURCES_DIR}" || exit 1

echo "============================ RUN BUILDER DONE =================================="
