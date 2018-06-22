#!/bin/bash

#  runBuilder.sh
#  
#   This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
#   Copyright © Adguard Software Limited. All rights reserved.
#
#   Adguard for iOS is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   Adguard for iOS is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.


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
