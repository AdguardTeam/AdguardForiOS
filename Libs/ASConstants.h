/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © Adguard Software Limited. All rights reserved.

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
#ifndef ASConstants_h
#define ASConstants_h


#define AS_EXECUTION_PERIOD_TIME                           3600 // 1 hours
#define AS_EXECUTION_LEEWAY                                5 // 5 seconds
#define AS_EXECUTION_DELAY                                 2 // 2 seconds

#define AS_CHECK_FILTERS_UPDATES_PERIOD                    AS_EXECUTION_PERIOD_TIME
#define AS_CHECK_FILTERS_UPDATES_FROM_UI_DELAY             AS_EXECUTION_DELAY
#define AS_CHECK_FILTERS_UPDATES_LEEWAY                    AS_EXECUTION_LEEWAY
#define AS_CHECK_FILTERS_UPDATES_DEFAULT_PERIOD            AS_EXECUTION_PERIOD_TIME*6

/// Timeout for downloading of data from the remote services
#define AS_URL_LOAD_TIMEOUT                                60



#endif /* ASConstants_h */
