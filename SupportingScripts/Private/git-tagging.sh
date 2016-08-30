#!/bin/sh

#  git-tagging.sh
#  
#
#  Created by Roman Sokolov on 30.08.16.
#  Copyright (c) 2016 Performix. All rights reserved.

echo "Git Tagging (Beta/Release branch) Script Running..."

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
echo "Creating tag for current version."
echo "git tag -a v$AG_VERSION.$AG_BUILD -m '$AG_PRODUCT $BTYPE version $AG_VERSION (AG_BUILD)'"

#git tag -a v$AG_VERSION.$AG_BUILD -m '$AG_PRODUCT $BTYPE version $AG_VERSION (AG_BUILD)'
#git push origin --tags
fi
