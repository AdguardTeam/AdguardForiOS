#!/bin/sh

#  clean-script.sh
#  Builder
#
#  Created by Roman Sokolov on 24.08.15.
#  Copyright © 2015 Performiks. All rights reserved.

#!/bin/bash

ACTION=${1}

echo "Running with ACTION=${ACTION}"

case $ACTION in
# NOTE: for some reason, it gets set to "" rather than "build" when
# doing a build.
"")
;;

"clean")
echo "Clean in \"${BUILDER_RESOURCES_DIR}\""
rm -fRv "${BUILDER_RESOURCES_DIR}"
exit 0
;;

esac
