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
#import "AESSupport.h"
#import "ADomain/ADomain.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "ACommons/ACFiles.h"
#import "AESharedResources.h"
#import "NSData+GZIP.h"
#import "AESAntibanner.h"
#import "ASDModels/ASDFilterObjects.h"
#import "ABECRequest.h"
#import "AESharedResources.h"
#import "Adguard-Swift.h"
#import "vendors/SSZipArchive/SSZipArchive.h"

NSString *AESSupportSubjectPrefixFormat = @"[%@ for iOS] Bug report";

#define SUPPORT_ADDRESS         @"support@adguard.com"


#define BOOL_TO_STRING(A)       A ? @"Enabled" : @"Disabled"
#define DEFAULT_USER_EMAIL      @"_undefined@mail.com"
#define SEND_LOG_DISABLED       @"SendingLogDisabled"

#define LOG_DELIMETER_FORMAT    @"\r\n-------------------------------------------------------------\r\n"\
@"LOG FILE:%@"\
@"\r\n-------------------------------------------------------------\r\n"

#define REPORT_URL @"https://reports.adguard.com/new_issue.html"

#define REPORT_PARAM_PRODUCT @"product_type"
#define REPORT_PARAM_VERSION @"product_version"
#define REPORT_PARAM_BROWSER @"browser"
#define REPORT_PARAM_URL @"url"
#define REPORT_PARAM_FILTERS @"filters"
#define REPORT_PARAM_SYSTEM_WIDE @"ios.systemwide"
#define REPORT_PARAM_SIMPLIFIED @"ios.simplified"
#define REPORT_PARAM_CUSTOM_DNS @"ios.CustomDNS"
#define REPORT_PARAM_DNS @"ios.DNS"

#define REPORT_PRODUCT @"iOS"
#define REPORT_BROWSER @"Safari"

#define REPORT_DNS_ADGUARD @"Default"
#define REPORT_DNS_ADGUARD_FAMILY @"Family"
#define REPORT_DNS_OTHER @"Other"

@interface AESSupport() {
    AESharedResources *_sharedResources;
    SafariService* _safariService;
    id<AESAntibannerProtocol> _antibanner;
    id<DnsFiltersServiceProtocol> _dnsFiltersService;
    id<DnsProvidersServiceProtocol> _dnsProviders;
    id<ConfigurationServiceProtocol> _configurationService;
        
    id<SupportServiceProtocol> _support;
    id<ADProductInfoProtocol> _productInfo;
}

@end


/////////////////////////////////////////////////////////////////////
#pragma mark - AESSupport
/////////////////////////////////////////////////////////////////////

@implementation AESSupport

/////////////////////////////////////////////////////////////////////
#pragma mark Initialize
/////////////////////////////////////////////////////////////////////

- (id)initWithResources:(id)resources
           safariSevice:(id)safariService
             antibanner:(id<AESAntibannerProtocol>)antibanner
      dnsFiltersService:(id<DnsFiltersServiceProtocol>) dnsFiltersService
           dnsProviders:(id<DnsProvidersServiceProtocol>) dnsProviders
          configuration:(id<ConfigurationServiceProtocol>) configuration
      complexProtection:(id<ComplexProtectionServiceProtocol>) complexProtection
       networtkSettings:(id<NetworkSettingsServiceProtocol>) networkSettings
            productInfo:(id<ADProductInfoProtocol>) productInfo
{
    
    self = [super init];
    if (self) {
        _sharedResources = resources;
        _safariService = safariService;
        _antibanner = antibanner;
        _dnsFiltersService = dnsFiltersService;
        _dnsProviders = dnsProviders;
        _configurationService = configuration;
        _productInfo = productInfo;
        
        _support = [[SupportService alloc] initWithResources:resources
                                               configuration:configuration
                                           complexProtection:complexProtection
                                                dnsProviders:dnsProviders
                                             networkSettings:networkSettings
                                                  dnsFilters:dnsFiltersService];
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////
- (void)exportLogsWithParentController:(nonnull UIViewController *)parent sourceView: (UIView*)sourceView sourceRect:(CGRect) sourceRect{
    NSString *stringUrl = [[NSString alloc] initWithString:[self createArchivedLogs]];
    NSURL *url = [NSURL fileURLWithPath:stringUrl];
    
    if (url) {
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        
        [parent presentViewController:activityController animated:YES completion:nil];
        activityController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            [[NSFileManager defaultManager] removeItemAtPath:stringUrl error:nil];
        };
        
        if (activityController.popoverPresentationController){
            activityController.popoverPresentationController.sourceView = sourceView;
            activityController.popoverPresentationController.sourceRect = sourceRect;
        }
    }
}

- (void)sendMailBugReportWithParentController:(UIViewController *)parent{
    
    if ([MFMailComposeViewController canSendMail]) {
        @autoreleasepool {
            
            MFMailComposeViewController *compose = [MFMailComposeViewController new];
            [compose setMessageBody:@"" isHTML:NO];
            [compose setSubject:[NSString stringWithFormat:AESSupportSubjectPrefixFormat, AE_PRODUCT_NAME]];
            NSData *stateData = [[self applicationState] dataUsingEncoding:NSUTF8StringEncoding];
            if (stateData) {
                [compose addAttachmentData:stateData mimeType:@"text/plain" fileName:@"state.txt"];
            }
            NSDictionary<NSString*, NSData*> *jsonDatas = [self compressedJsons];
            [jsonDatas enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull filename, NSData * _Nonnull data, BOOL * _Nonnull stop) {
                [compose addAttachmentData:data mimeType:@"application/x-gzip" fileName:filename];
            }];
            
            // Flush Logs
            [[ACLLogger singleton] flush];
            //
            
            for (NSURL *item in [self appLogsUrls]) {
                
                
                NSData *logData = [self applicationLogFromURL:item];
                if (logData.length) {
                    NSString *fileName = [NSString stringWithFormat:@"%@.gz", [item lastPathComponent]];
                    [compose addAttachmentData:logData mimeType:@"application/x-gzip" fileName:fileName];
                }
                else {
                    NSData* content = [NSData dataWithContentsOfURL:item];
                    if (content) {
                        NSString *fileName = [NSString stringWithFormat:@"%@.gz", [item lastPathComponent]];
                        [compose addAttachmentData:content mimeType:@"application/x-gzip" fileName:fileName];
                    }
                }
            }
            [compose setToRecipients:@[SUPPORT_ADDRESS]];
            compose.mailComposeDelegate = self;
            
            [parent presentViewController:compose animated:YES completion:nil];
        }
        
    }
    else{
        [ACSSystemUtils showSimpleAlertForController:parent withTitle:ACLocalizedString(@"common_error_title", @"")
                                             message:ACLocalizedString(@"bug_report_sending_error", @"(AEUIAboutController) Alert message if user have no e-mail account on device")];
    }
}

- (NSURL *)composeWebReportUrlForSite:(nullable NSURL *)siteUrl {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if(siteUrl) {
        params[REPORT_PARAM_URL] = siteUrl;
    }
    
    params[REPORT_PARAM_PRODUCT] = REPORT_PRODUCT;
    params[REPORT_PARAM_VERSION] = _productInfo.version;
    params[REPORT_PARAM_BROWSER] = REPORT_BROWSER;
    
    NSMutableString *filtersString = [NSMutableString new];
    NSArray* filterIDs = _antibanner.activeFilterIDs;
    
    for (NSNumber *filterId in filterIDs) {
        
        NSString* format = filterId == filterIDs.firstObject ? @"%@" : @".%@";
        [filtersString appendFormat:format, filterId];
    }
    params[REPORT_PARAM_FILTERS] = filtersString.copy;
    
    params[REPORT_PARAM_SIMPLIFIED] =  [[_sharedResources sharedDefaults] boolForKey:AEDefaultsJSONConverterOptimize] ? @"true" : @"false";
    
    NSString* dnsServerParam = nil;
    BOOL custom = NO;
    
    DnsServerInfo * dnsServer = _dnsProviders.activeDnsServer;
    if([DnsServerInfo.adguardDnsIds containsObject: dnsServer.serverId]) {
        dnsServerParam = REPORT_DNS_ADGUARD;
    }
    else if ([DnsServerInfo.adguardFamilyDnsIds containsObject: dnsServer.serverId]) {
        dnsServerParam = REPORT_DNS_ADGUARD_FAMILY;
    }
    else if(dnsServer) {
        dnsServerParam = REPORT_DNS_OTHER;
        custom = YES;
    }
    
    if(dnsServerParam) {
        params[REPORT_PARAM_DNS] = dnsServerParam;
        
        if(custom) {
            params[REPORT_PARAM_CUSTOM_DNS] = dnsServer.name;
        }
    }
    
    params[REPORT_PARAM_SYSTEM_WIDE] = @"false";
    
    NSString *paramsString = [ABECRequest createStringFromParameters:params];
    NSString *url = [NSString stringWithFormat:@"%@?%@", REPORT_URL, paramsString];
    
    return [NSURL URLWithString: url];
}


/////////////////////////////////////////////////////////////////////
#pragma mark Mail Compose Delegate Methods
/////////////////////////////////////////////////////////////////////

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


/////////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
/////////////////////////////////////////////////////////////////////////

///   Returns some software info to the support message
- (NSString *)applicationState{
    @autoreleasepool {
        
        NSMutableString *sb = [NSMutableString stringWithFormat:@"Application version: %@", [_productInfo buildVersion]];
        
        NSURL *supportFolder = [_sharedResources sharedLogsURL];
        if (supportFolder) {
            [sb appendFormat:@"\r\nApplication lifetime: %@", [ACFFileUtils fileCreatedTimeForUrl:supportFolder]];
        }
        UIDevice *dev = [UIDevice currentDevice];
        [sb appendFormat:@"\r\n\r\nDevice: %@", [dev model]];
        [sb appendFormat:@"\r\nPlatform: %@", [dev systemName]];
        [sb appendFormat:@"\r\nOS: %@", [dev systemVersion]];
        [sb appendFormat:@"\r\nID: %@", [[dev identifierForVendor] UUIDString]];
        
        [sb appendFormat:@"\r\n\r\nLocale: %@", [ADLocales lang]];
        [sb appendFormat:@"\r\nRegion: %@", [ADLocales region]];
        
        [sb appendFormat:@"\r\n\r\nOptimized enabled: %@", ([[_sharedResources sharedDefaults] boolForKey:AEDefaultsJSONConverterOptimize] ? @"YES" : @"NO")];
    
        [sb appendFormat:@"\r\n\r\nAEDefaultsGeneralContentBlockerRulesCount: %@",[[_sharedResources sharedDefaults] objectForKey:AEDefaultsGeneralContentBlockerRulesCount]];
        [sb appendFormat:@"\r\nAEDefaultsPrivacyContentBlockerRulesCount: %@",[[_sharedResources sharedDefaults] objectForKey:AEDefaultsPrivacyContentBlockerRulesCount]];
        [sb appendFormat:@"\r\nAEDefaultsSocialContentBlockerRulesCount: %@",[[_sharedResources sharedDefaults] objectForKey:AEDefaultsSocialContentBlockerRulesCount]];
        [sb appendFormat:@"\r\nAEDefaultsOtherContentBlockerRulesCount: %@",[[_sharedResources sharedDefaults] objectForKey:AEDefaultsOtherContentBlockerRulesCount]];
        [sb appendFormat:@"\r\nAEDefaultsCustomContentBlockerRulesCount: %@",[[_sharedResources sharedDefaults] objectForKey:AEDefaultsCustomContentBlockerRulesCount]];
        [sb appendFormat:@"\r\nAEDefaultsSecurityContentBlockerRulesCount: %@",[[_sharedResources sharedDefaults] objectForKey:AEDefaultsSecurityContentBlockerRulesCount]];
        
        [sb appendString:@"\r\n\r\nFilters subscriptions:"];
        NSArray *filters = [_antibanner activeFilters];
        for (ASDFilterMetadata *meta in filters)
            [sb appendFormat:@"\r\nID=%@ Name=\"%@\" Version=%@ Enabled=%@", meta.filterId, meta.name, meta.version, ([meta.enabled boolValue] ? @"YES" : @"NO")];
        
        [sb appendString:[_support proFeaturesStatus]];

        return sb;
    }
}


// Get application log data
- (NSData *)applicationLogFromURL:(NSURL *)url{
    
    @autoreleasepool {
        
        DDLogFileManagerDefault *manager = [[ACLLogFileManagerDefault alloc] initWithLogsDirectory:[url path]];
        NSArray *logFileInfos = [manager sortedLogFileInfos];
        
        NSMutableData *logData = [NSMutableData new];
        
        for (DDLogFileInfo *info in logFileInfos.reverseObjectEnumerator) {
            
            NSString* delimeter = [NSString stringWithFormat:LOG_DELIMETER_FORMAT, info.fileName];
            [logData appendData:[delimeter dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSData *fileData = [NSData dataWithContentsOfFile:info.filePath];
            if(fileData) {
                [logData appendData:fileData];
            }
        }
        
        return [logData gzippedData];
    }
}

- (NSArray *)appLogsUrls{
    
    NSURL *logs = [_sharedResources sharedLogsURL];
    return [[NSFileManager defaultManager] contentsOfDirectoryAtURL:logs includingPropertiesForKeys:@[NSURLIsDirectoryKey] options:0 error:NULL];
}

- (NSDictionary<NSString*, NSData *>*)compressedJsons{
    
    NSMutableDictionary* datas = [NSMutableDictionary new];
    
    NSDictionary* jsonDatas = [(SafariService*)_safariService allBlockingContentRules];
    [jsonDatas enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSData* _Nonnull data, BOOL * _Nonnull stop) {
        NSString *filename = [key replace:@"json" to:@"zip"];
        datas[filename] = [data gzippedData];
    }];

    return datas;
}

-(NSString *)createArchivedLogs{
    // Create archive name with date stamp
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"DDMMYYYYHHMISS"];
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [formatter stringFromDate:currentDate];
    
    // Directory path and archive path
    NSString *baseUrl = [NSTemporaryDirectory() stringByAppendingString:@"logs/"];
    NSString *archiveName = [@"adguardforios_logs_" stringByAppendingString:dateString];
    archiveName = [NSTemporaryDirectory() stringByAppendingString:archiveName];
    archiveName = [archiveName stringByAppendingString:@".zip"];
    // Create directory with path
    [[NSFileManager defaultManager] createDirectoryAtPath:baseUrl
                              withIntermediateDirectories:YES attributes:nil error:nil];
    
    __block NSURL *fileUrl = [NSURL new];
    // Append jsondatas to archive
    NSDictionary<NSString*, NSData*> *jsonDatas = [self compressedJsons];
    [jsonDatas enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull filename, NSData * _Nonnull data, BOOL * _Nonnull stop) {
        // Append file to directory
        fileUrl = [NSURL fileURLWithPath: [baseUrl stringByAppendingString:filename]];
        [data writeToURL:fileUrl atomically:NO];
    }];
    // Append application state to archive
    NSData *stateData = [[self applicationState] dataUsingEncoding:NSUTF8StringEncoding];
    fileUrl = [NSURL fileURLWithPath: [baseUrl stringByAppendingString:@"state.txt"]];
    [stateData writeToURL:fileUrl atomically:NO];
    
    // Flush Logs
    [[ACLLogger singleton] flush];
    //
    // Append flush logs
    for (NSURL *item in [self appLogsUrls]) {
        NSData *logData = [self applicationLogFromURL:item];
        if (logData.length) {
            NSString *fileName = [NSString stringWithFormat:@"%@.gz", [item lastPathComponent]];
            fileUrl = [NSURL fileURLWithPath: [baseUrl stringByAppendingString: fileName]];
            [logData writeToURL:fileUrl atomically:NO];
        }
        else {
            NSData* content = [NSData dataWithContentsOfURL:item];
            if (content) {
                NSString *fileName = [NSString stringWithFormat:@"%@.gz", [item lastPathComponent]];
                fileUrl = [NSURL fileURLWithPath: [baseUrl stringByAppendingString: fileName]];
                [content writeToURL:fileUrl atomically:NO];
            }
        }
    }
    
    // Archive directory
    if ([SSZipArchive createZipFileAtPath:archiveName withContentsOfDirectory: baseUrl]) {
        [[NSFileManager defaultManager] removeItemAtPath:baseUrl error:nil];
        return archiveName;
    }
    // return archive url
    return nil;
}

-(NSArray<WifiException*>*)getExceptions {
    NSString *fileName = @"NetworkSettings";
    NSData *data = [_sharedResources loadDataFromFileRelativePath:fileName];
    if (data) {
        NSError *error = nil;
        NSMutableArray<WifiException*>* exceptions =
        [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        return exceptions;
    }
    return nil;
}

@end
