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

#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - APUIDomainListController

@interface APUIDomainListController  : UIViewController <UITextViewDelegate, UISearchBarDelegate>

/**
 Block of the code, which will be performed when user press the Done key.
 */
@property (nonatomic, copy) void (^done)(NSString *text);
/**
 Initial text, which will be edited.
 */
@property (nonatomic) NSString *textForEditing;

/////////////////////////////////////////////////////////////////////
#pragma mark Outlets

@property (weak, nonatomic) IBOutlet UITextView *domainsTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seachToolBarConstraint;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIToolbar *searchToolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarItem;

/////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)clickDone:(id)sender;
- (IBAction)clickSearchNext:(id)sender;
- (IBAction)clickSearchPrev:(id)sender;


@end
