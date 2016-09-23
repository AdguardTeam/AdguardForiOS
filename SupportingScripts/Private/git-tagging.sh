#!/bin/sh

#  git-tagging.sh
#  
#
#  Created by Roman Sokolov on 30.08.16.
#  Copyright (c) 2016 Performix. All rights reserved.

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

TAG_VERSION=v$AG_VERSION.$AG_BUILD
if [[ $AG_GIT_TAG_SUFIX ]]
then

    if [[ $BRANCH != "${AG_GIT_TAG_SUFIX}/"* ]]
    then
    echo "Branch is not \"$AG_GIT_TAG_SUFIX\"!"
    exit 1
    fi

TAG_VERSION=$TAG_VERSION.$AG_GIT_TAG_SUFIX
fi

echo "Creating tag for version: $TAG_VERSION"
git tag -a $TAG_VERSION -m '$AG_PRODUCT $BTYPE version $AG_VERSION ($AG_BUILD)'

rm -f .git/hooks/pre-push
git push origin $TAG_VERSION

exit 0
fi

echo "Branch is not beta/release!"
exit 1