#!/bin/sh

#  getExtResources.sh

#   This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
#   Copyright © 2015-2017 Performix LLC. All rights reserved.
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


LibsFile="${SRCROOT}/ActionExtension/js/adguard-assistant.js"
DnscryptResolversFile="${SRCROOT}/AdguardPro/Resources/dnscrypt-resolvers.csv"

Download()
{
echo -n "${1}"
curl -s "${1}" >> "${2}"
if [ ! $? == 0 ]; then
echo " - fail"
rm -f "${2}"
exit 1
fi

echo " - done"
}

echo "Downloading external libs sources.."

rm -f "$LibsFile"

Download "${ACTION_JAVASCRIPT_ASSISTANT_REMOTE}" "$LibsFile"


echo "Downloading dnscrypt resolvers list.."

rm -f "$DnscryptResolversFile"

Download "${DNS_CRYPT_RESOLVERS_REMOTE}" "$DnscryptResolversFile"


echo "Done"
