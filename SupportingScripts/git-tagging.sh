#!/bin/sh

#  git-tagging.sh
#
#
#  Created by Roman Sokolov on 30.08.16.
#  Copyright (c) 2016 Performix. All rights reserved.

mainWorkspace="AdguardSafariExtension-iOS.xcworkspace"
workspaceSchemeForFree="ActionExtension"
workspaceSchemeForPro="Adguard Pro"
PROJECT_TEMP_DIR="/tmp/dev/ios.com.adguard/git-tagging-script-tmp-dir"
#====================================================

usage()
{
    echo "Usage: $0 [directory with working tree]"
}

if [ $1 ]
then cd $1
if [ ! $? == 0 ]; then
    echo "Can't change current dir to \"$1\""
    usage
    exit 1
fi
fi

if ! git diff-index --quiet HEAD --; then
echo "Tagging failed! Working copy has changes."
exit 1
fi

mkdir -pv "${PROJECT_TEMP_DIR}"

load_xcode_vars()
{
    xcodebuild -scheme "$1" -showBuildSettings | sed -e 's/^[ \t]*//' | sed -e 's/\"/\\\"/'| sed '/^\s*$/d' | awk '/^AG_+/ { print $1"="$3 }' > "${PROJECT_TEMP_DIR}/ag-vars"
    source "${PROJECT_TEMP_DIR}/ag-vars"
}

#Test current dir
if [ ! -d "$mainWorkspace" ]; then
echo "Working directory does not contain \"${mainWorkspace}\"."
echo "Usage: $0 [directory with working tree]"
exit 1
fi

echo "Git Tagging (On beta/release branch) Script Running..."

BRANCH=$( git branch -q | grep "*" | awk '{print $2}' )

if [[ $BRANCH == *"beta" ]]
then
BTYPE="beta"
fi

if [[ $BRANCH == *"release" ]]
then
BTYPE="release"
fi

if [[ $BTYPE ]]
then

    TAG_VESION_SUFIX=""
    if [[ $BRANCH == "pro/"* ]]; then

        TAG_VESION_SUFIX=".pro"
        load_xcode_vars "${workspaceSchemeForPro}"
    else
        load_xcode_vars "${workspaceSchemeForFree}"
    fi

    TAG_VERSION=v$AG_VERSION.${AG_BUILD}${TAG_VESION_SUFIX}

    echo "Creating tag for version: ${TAG_VERSION}"
    git tag -a $TAG_VERSION -m "${AG_PRODUCT} ${BTYPE} version ${AG_VERSION} (${AG_BUILD})"

    rm -f .git/hooks/pre-push
    git push origin $TAG_VERSION

    exit 0
fi

echo "Branch is not beta/release!"
exit 1
