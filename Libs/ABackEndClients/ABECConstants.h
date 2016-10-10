/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015 Performix LLC. All rights reserved.

    Adguard for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Adguard for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/
#ifndef Adguard_ABECConstants_h
#define Adguard_ABECConstants_h

/**
 iOS platform identificator.
 */
#define ABEC_PLATFORM_IOS       @"ABEC_PLATFORM_IOS"
/**
 OS X platform identificator.
 */
#define ABEC_PLATFORM_OSX       @"ABEC_PLATFORM_OSX"

/////////////////////////////////////////////////////////////////////
#pragma mark Only iOS code here
/////////////////////////////////////////////////////////////////////
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS

#define ABEC_DEFAULT_PLATFORM          ABEC_PLATFORM_IOS

#define ABEC_BACKEND_READ_TIMEOUT      10

/////////////////////////////////////////////////////////////////////
#pragma mark Only OS X code here
/////////////////////////////////////////////////////////////////////
#elif TARGET_OS_MAC

#define ABEC_DEFAULT_PLATFORM          ABEC_PLATFORM_OSX

#define ABEC_BACKEND_READ_TIMEOUT      60

/////////////////////////////////////////////////////////////////////
#pragma mark Common code here
/////////////////////////////////////////////////////////////////////
#endif

#endif
