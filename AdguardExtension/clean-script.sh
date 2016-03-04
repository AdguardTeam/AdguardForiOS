#!/bin/bash

#  clean-script.sh
#  Adguard
#
#  Created by Roman Sokolov on 04.03.16.
#  Copyright © 2016 Performiks. All rights reserved.

echo "Clean Script Running with ACTION=${ACTION}"

case $ACTION in
# NOTE: for some reason, it gets set to "" rather than "build" when
# doing a build.
"")
;;

"clean")
echo "Clean in \"${ACTION_RESOURCES_DIR}\""
rm -fRv "${ACTION_RESOURCES_DIR}"
exit 0
;;

esac

