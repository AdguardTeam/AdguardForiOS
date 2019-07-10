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
#import "ADLocales.h"
#import "ACommons/ACLang.h"

#define RESOURCE_FILE_NAME                                      @"stringUIResources"
#define RESOURCE_FILTERS_DESCRIPTION                            @"FilterDescription"
#define RESOURCE_DEFAULT_PROCESS_FOR_FILTERING_DESCRIPTION      @"DefaultProcessForFilteringDescription"
#define RESOURCE_FEEDBACK_SUBJECTS                              @"FeedbackSubjects"
#define RESOURCE_DAY_NUMBER_VARIANTS                            @"DayNumberVariants"

@interface ADLocales()

+ (void) loadStringUIResources;

@end

@implementation ADLocales

static NSDictionary *stringUIResources;

/////////////////////////////////////////////////////////////////////
#pragma mark -  Class methods
/////////////////////////////////////////////////////////////////////

+ (NSString *)lang{
    
    NSString *lang = [NSLocale.currentLocale objectForKey:NSLocaleLanguageCode];
    if (! lang) {
        lang = ADL_DEFAULT_LANG;
    }
    return lang;
}

+ (NSString *)region{
    
    NSString *region = [[NSLocale.currentLocale objectForKey:NSLocaleCountryCode] lowercaseString];
    if (! region) {
        region = ADL_DEFAULT_REGION;
    }
    
    return region;
}

+ (NSString *)canonicalLanguageIdentifier {
    
    NSString *localeIdentifier = NSLocale.currentLocale.localeIdentifier;
    return [NSLocale canonicalLanguageIdentifierFromString:localeIdentifier];
}

+ (NSArray *)filtersDescription{

    [self loadStringUIResources];
    
    NSArray *filtersDescription = stringUIResources[RESOURCE_FILTERS_DESCRIPTION];
    if (!filtersDescription)
        [[NSException appResourceUnavailableException:[NSString stringWithFormat:@"Resource key %@ in file %@.plist", RESOURCE_FILTERS_DESCRIPTION, RESOURCE_FILE_NAME]] raise];
    
    return filtersDescription;
}

+ (NSDictionary *)defaultProcessesDescription{
    
    [self loadStringUIResources];
    
    NSDictionary *processesDescription = stringUIResources[RESOURCE_DEFAULT_PROCESS_FOR_FILTERING_DESCRIPTION];
    if (!processesDescription)
        [[NSException appResourceUnavailableException:[NSString stringWithFormat:@"Resource key %@ in file %@.plist", RESOURCE_DEFAULT_PROCESS_FOR_FILTERING_DESCRIPTION, RESOURCE_FILE_NAME]] raise];
    
    return processesDescription;
    
}

+ (NSDictionary *)localizationsOfFilter:(NSUInteger)filterId{

    NSMutableDictionary *localizations = [NSMutableDictionary dictionary];

    @autoreleasepool {
        
        NSBundle *bundle = [NSBundle bundleForClass:[ADLocales class]];
        NSURL *resourceUrl;
        NSDictionary *resourceDict;
        NSArray *filtersDescription;
        for (NSString *locale in [bundle localizations]) {
            
            resourceUrl = [bundle URLForResource:RESOURCE_FILE_NAME withExtension:@"plist" subdirectory:nil localization:locale];
            if (resourceUrl)
                resourceDict = [NSDictionary dictionaryWithContentsOfURL:resourceUrl];
            else
                [[NSException appResourceUnavailableException:[RESOURCE_FILE_NAME stringByAppendingFormat:@".plist for locale: %@", locale]] raise];
            
            filtersDescription = resourceDict[RESOURCE_FILTERS_DESCRIPTION];
            if (!filtersDescription)
                [[NSException appResourceUnavailableException:[NSString stringWithFormat:@"Resource key %@ in file %@.plist for locale: %@", RESOURCE_FILTERS_DESCRIPTION, RESOURCE_FILE_NAME, locale]] raise];
            
            if (filtersDescription.count > filterId)
                localizations[locale] = filtersDescription[filterId];
        }
        
    }
    
    
    return localizations;
}

+ (NSArray *)localizedFeedbackSubjects{
    
    [self loadStringUIResources];
    
    NSArray *subjects = stringUIResources[RESOURCE_FEEDBACK_SUBJECTS];
    if (!subjects)
        [[NSException appResourceUnavailableException:[NSString stringWithFormat:@"Resource key %@ in file %@.plist", RESOURCE_FEEDBACK_SUBJECTS, RESOURCE_FILE_NAME]] raise];
    
    return subjects;
    
}

+ (void) loadStringUIResources {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *resUrl = [[NSBundle bundleForClass:[ADLocales class]] URLForResource:RESOURCE_FILE_NAME withExtension:@"plist"];
        if (resUrl)
            stringUIResources = [NSDictionary dictionaryWithContentsOfURL:resUrl];
        else
            [[NSException appResourceUnavailableException:[RESOURCE_FILE_NAME stringByAppendingString:@".plist"]] raise];
    });
}


@end
