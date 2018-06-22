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
#import "AEUIWelcomePagerDataSource.h"
#import "AEUIWelcomePageController.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIWelcomePagerDataSource
/////////////////////////////////////////////////////////////////////

@interface AEUIWelcomePagerDataSource (){
    
    NSArray *_pages;
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

        UIViewController* page1 = [_storyboard instantiateViewControllerWithIdentifier:@"welcomePage1"];
        UIViewController* page2 = [_storyboard instantiateViewControllerWithIdentifier:@"welcomePage2"];
        
        _pages = @[page1, page2];
    }

    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark <UIPageViewControllerDataSource> Methods
/////////////////////////////////////////////////////////////////////

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    for(int i = 0; i < _pages.count; ++i) {
        UIViewController *page = _pages[i];
        if(page == viewController) {
            
            _currentIndex = i;
            if(i != 0) {
                
                return _pages[i-1];
            }
            else {
                
                return nil;
            }
        }
    }

    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    for(int i = 0; i < _pages.count; ++i) {
        UIViewController *page = _pages[i];
        if(page == viewController) {
            
            _currentIndex = i;
            
            if(i != _pages.count - 1) {
                
                return _pages[i+1];
            }
            else {
                
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{

    return _pages.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{

    return _currentIndex;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Public Methods
/////////////////////////////////////////////////////////////////////


- (UIViewController *)currentControllerForIndex:(NSInteger)index{
    
    return _pages[index];
}

@end
