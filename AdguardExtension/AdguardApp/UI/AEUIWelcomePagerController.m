//##implementation

/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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

#import "AEUIWelcomePagerController.h"

#import "AEUIWelcomePagerDataSource.h"
#import "AEUIWelcomePageController.h"
#import "AEUIUtils.h"

@interface AEUIWelcomePagerController () {
    
    AEUIWelcomePagerDataSource *_welcomePageSource;
}

@end

@implementation AEUIWelcomePagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [AEUIUtils addTitleViewToNavigationItem:self.navigationItem];
    
    _welcomePageSource = [[AEUIWelcomePagerDataSource alloc] initWithStoryboard:self.storyboard];
    
    self.dataSource = _welcomePageSource;
    _welcomePageSource.currentIndex = 0;
    [self setViewControllers:@[[_welcomePageSource currentControllerForIndex:0 ]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
