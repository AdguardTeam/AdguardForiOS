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
#import "AEUIWelcomePagerDataSource.h"
#import "AEUIWelcomePageController.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIWelcomePagerDataSource
/////////////////////////////////////////////////////////////////////


#define LABEL_KEY           @"label"
#define IMAGE_NAME_KEY      @"imageName"
#define BUTTON_TITLE_KEY    @"buttonTitle"
#define BUTTON_ACTION_KEY   @"buttonSelector"


#define TITLE_KEY           @"title"
#define LABEL_KEY           @"label"
#define IMAGE_NAME_KEY      @"imageName"
#define BUTTON_TITLE_KEY    @"buttonTitle"
#define BUTTON_ACTION_KEY   @"buttonSelector"
#define ACC_KEY             @"accessibility"

@interface AEUIWelcomePagerDataSource (){
    
    NSArray *_steps; // array of dictionaries like @{LABEL_KEY: @"step one", IMAGE_NAME_KEY: @"welcome-image-1"}
}


@end

@implementation AEUIWelcomePagerDataSource

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)initWithStoryboard:(UIStoryboard *)storyboard {

    self = [super init];
    if (self) {
        
        _storyboard = storyboard;

        // INIT STEPS
        _currentIndex = 0;
        _steps = @[
                   @{ TITLE_KEY : NSLocalizedString(@"Meet Adguard", @"(AEUIWelcomePagerDataSource) Tutorial title, step 1"),
                      LABEL_KEY : NSLocalizedString(@"A quick tutorial will walk you through some basics of your new ad blocker.", @"(AEUIWelcomePagerDataSource) Tutorial text, step 1"),
                      ACC_KEY : NSLocalizedString(@"Welcome to Adguard! A quick tutorial will walk you through some basics of your new ad blocker.", @"(AEUIWelcomePagerDataSource) Tutorial accessibility text, step 1"),
                      IMAGE_NAME_KEY : @"welcome-logo"
                      },
                   
                   
                   @{ TITLE_KEY : NSLocalizedString(@"Let's make Adguard protect your device!", @"(AEUIWelcomePagerDataSource) Tutorial title, step 2"),
                      LABEL_KEY : NSLocalizedString(@"Go to Settings app, select Safari and open Content Blockers.\nThen enable Adguard.", @"(AEUIWelcomePagerDataSource) Tutorial text, step 2"),
                      ACC_KEY : NSLocalizedString(@"First, let's configure your device to allow Adguard protect it. Go to system Settings app, select Safari there and choose \"Content Blockers\" under the \"General\" heading. In the opened menu choose and enable Adguard.", @"(AEUIWelcomePagerDataSource) Tutorial accessibility text, step 2"),
                      IMAGE_NAME_KEY : @"welcome-step2" },
                   
                   
                   @{ TITLE_KEY : NSLocalizedString(@"Configure the ad blocking", @"(AEUIWelcomePagerDataSource) Tutorial title, step 3"),
                      LABEL_KEY : NSLocalizedString(@"Select the filters you need in the Filters section.", @"(AEUIWelcomePagerDataSource) Tutorial text, step 3"),
                      ACC_KEY : NSLocalizedString(@"Now it is time to configure the ad blocking. Return to Adguard main screen. You will find items grouped into several categories. Under \"Filters\" heading choose the item with the same name (Filters) and proceed to it.", @"(AEUIWelcomePagerDataSource) Tutorial accessibility text, step 3"),
                      IMAGE_NAME_KEY : @"welcome-step3" },
                   
                   
                   @{ TITLE_KEY : NSLocalizedString(@"Choose your tools", @"(AEUIWelcomePagerDataSource) Tutorial title, step 4"),
                      LABEL_KEY : NSLocalizedString(@"Find out what does each filter stand for by tapping on it.", @"(AEUIWelcomePagerDataSource) Tutorial text, step 4"),
                      ACC_KEY : NSLocalizedString(@"If you have any questions about a specific filter while in \"Filters\" section, select that filter. You will find the details about that filter, including it's name, status (enabled/disabled), version and description.", @"(AEUIWelcomePagerDataSource) Tutorial accessibility text, step 4"),
                      IMAGE_NAME_KEY : @"welcome-step4" },
                   
                   
                   @{ TITLE_KEY : NSLocalizedString(@"Block ads the way you want", @"(AEUIWelcomePagerDataSource) Tutorial title, step 5"),
                      LABEL_KEY : NSLocalizedString(@"You can add your own ad blocking rules in the User Filter seсtion.", @"(AEUIWelcomePagerDataSource) Tutorial text, step 5"),
                      ACC_KEY : NSLocalizedString(@"You can add your own ad blocking rules in the \"User Filter\" seсtion. You can access it from the main screen, \"Filters\" category. Open it, then, to add a rule, select and choose \"Add\" button.", @"(AEUIWelcomePagerDataSource) Tutorial accessibility text, step 5"),
                      IMAGE_NAME_KEY : @"welcome-step5" },
                   
                   
                   @{ TITLE_KEY : NSLocalizedString(@"Support favourite sites", @"(AEUIWelcomePagerDataSource) Tutorial title, step 6"),
                      LABEL_KEY : NSLocalizedString(@"If you add a website to the Whitelist, then Adguard won't be filtering it.", @"(AEUIWelcomePagerDataSource) Tutorial text, step 6"),
                      ACC_KEY : NSLocalizedString(@"You can support your favorite websites by whitelisting them. On Adguard main screen select and choose \"Whitelist\" item under the \"Filters\" heading. Then add a website to the list by selecting \"Add\" button. From now on, Adguard won't be filtering it.", @"(AEUIWelcomePagerDataSource) Tutorial accessibility text, step 6"),
                      IMAGE_NAME_KEY : @"welcome-step6" },
                   
                   
                   @{ TITLE_KEY : NSLocalizedString(@"Manage Adguard right from Safari", @"(AEUIWelcomePagerDataSource) Tutorial title, step 7"),
                      LABEL_KEY : NSLocalizedString(@"Tapping on Adguard icon will bring up a menu with additional app settings for current website.", @"(AEUIWelcomePagerDataSource) Tutorial text, step 7"),
                      ACC_KEY : NSLocalizedString(@"You can manage Adguard right from Safari browser. Bring up the browser menu while on a website by selecting \"Share\" button, then find \"Adguard\" button there and choose it. It will bring up a menu with additional app settings for current website: a switch to enable/disable Adguard for this website, options to report a missed ad or incorrect blocking.", @"(AEUIWelcomePagerDataSource) Tutorial accessibility text, step 7"),
                      IMAGE_NAME_KEY : @"welcome-step7" },
                   
                   
                   @{ TITLE_KEY : NSLocalizedString(@"That's it! Now your device is protected by Adguard!", @"(AEUIWelcomePagerDataSource) Tutorial title, step 8"),
                      LABEL_KEY : NSLocalizedString(@"Surf the web safe and ad-free, and have a nice day!", @"(AEUIWelcomePagerDataSource) Tutorial text, step 8"),
                      ACC_KEY : NSLocalizedString(@"And that's it! Now your device is protected by Adguard. Surf the web safe and ad-free, and have a nice day!", @"(AEUIWelcomePagerDataSource) Tutorial accessibility text, step 8"),
                      IMAGE_NAME_KEY : @"",
                      BUTTON_ACTION_KEY : @"clickFinish:",
                      BUTTON_TITLE_KEY : NSLocalizedString(@"Done", @"(AEUIWelcomePagerDataSource) Tutorial Button Title, step 8")
                      },
        ];
    }

    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark <UIPageViewControllerDataSource> Methods
/////////////////////////////////////////////////////////////////////

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = [(AEUIWelcomePageController *)viewController index];
    _currentIndex = index;
    if (index > 0) {
    index--;
        
        return [self currentControllerForIndex:index];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{

    NSInteger index = [(AEUIWelcomePageController *)viewController index];
    _currentIndex = index;
    if (index < (_steps.count - 1) ) {
        index++;
        
        return [self currentControllerForIndex:index];
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{

    return _steps.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{

    return _currentIndex;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Public Methods
/////////////////////////////////////////////////////////////////////


- (UIViewController *)currentControllerForIndex:(NSInteger)index{
    
    AEUIWelcomePageController *controller = [_storyboard instantiateViewControllerWithIdentifier:@"welcomePage"];
    NSDictionary *step = _steps[index];
    if (step) {
        
        controller.index = index;
        
        controller.properties = step;
        
        return controller;
    }

    return nil;
}

@end
