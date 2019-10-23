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
#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - AppDelegate Constants
/////////////////////////////////////////////////////////////////////

/**
 Notification when update process started
 */
extern NSString *AppDelegateStartedUpdateNotification;
/**
 Notification when update process finished
 */
extern NSString *AppDelegateFinishedUpdateNotification;
/**
 Notification when update process failured
 */
extern NSString *AppDelegateFailuredUpdateNotification;

/**
 Key for userInfo of AppDelegateFinishedUpdateNotification that defines
 array of metadata objects of updated filters.
 */
extern NSString *AppDelegateUpdatedFiltersKey;

/**
 Open dns segue identifier
 */
extern NSString *OpenDnsSettingsSegue;

/**
 Notify user through app
 */
extern NSString *ShowCommonAlertNotification;

/**
 Notify to show status view
 */
extern NSString *ShowStatusViewNotification;

/**
 Hide status view
 */
extern NSString *HideStatusViewNotification;

/////////////////////////////////////////////////////////////////////
#pragma mark - AppDelegate
/////////////////////////////////////////////////////////////////////

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BOOL userDefaultsInitialized;

/**
 If interval between last update and current time more then update period,
 method starts the update procedure of the antibanner.
 
 @param fromUI Set to YES if calling is performed by user action. 
 In this case update process will start forcedly.
 @param interactive Set to YES if we want to start update in interactive mode.

 @return Returns YES if antibanner will start update of the filters from backend.
 */
- (BOOL)invalidateAntibanner:(BOOL)fromUI interactive:(BOOL)interactive;

- (void) resetAllSettings;


@end

