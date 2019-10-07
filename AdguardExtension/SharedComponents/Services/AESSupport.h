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
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

extern NSString * _Nonnull AESSupportSubjectPrefixFormat;

@protocol AESharedResourcesProtocol, SafariServiceProtocol, AntibannerControllerProtocol, ConfigurationServiceProtocol;

@protocol AESSupportProtocol <NSObject>

- (void)sendMailBugReportWithParentController:(nonnull UIViewController *)parent;

- (nullable NSURL*) composeWebReportUrlForSite:(nullable NSURL*)siteUrl;

- (void)exportLogsWithParentController:(nonnull UIViewController *)parent sourceView: (nonnull UIView*)sourceView sourceRect:(CGRect)sourceRect;

@end

@interface AESSupport : NSObject <AESSupportProtocol, MFMailComposeViewControllerDelegate>
@property (nullable) id<ConfigurationServiceProtocol> configurationService;
- (nonnull instancetype) initWithResources: (nonnull id<AESharedResourcesProtocol>) resources
                      safariSevice: (nonnull id<SafariServiceProtocol>) safariService
                         antibannerController: (nonnull id<AntibannerControllerProtocol>) antibannerController;

@end
