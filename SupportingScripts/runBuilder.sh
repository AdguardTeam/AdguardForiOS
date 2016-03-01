#!/bin/bash

#  runBuilder.sh
#  
#
#  Created by Roman Sokolov on 26.10.15.
#

echo "============================== BUILD BUILDER ==================================="
xcodebuild -workspace "${SRCROOT}/../AdguardSafariExtension-iOS.xcworkspace" -scheme "Builder" -configuration "${CONFIGURATION}" -derivedDataPath "${SYMROOT}"


echo "================================ RUN BUILDER ==================================="
"${BUILDER_DIR}"/Builder --${CONFIGURATION} "${BUILDER_RESOURCES_DIR}" || exit 1

echo "============================ RUN BUILDER DONE =================================="
