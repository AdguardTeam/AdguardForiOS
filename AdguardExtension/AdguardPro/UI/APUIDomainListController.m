/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2016 Performix LLC. All rights reserved.
 
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


#import "APUIDomainListController.h"

#define TOP_BOUNSE_LIMIT                    -5

/////////////////////////////////////////////////////////////////////
#pragma mark - APUIDomainListController

@implementation APUIDomainListController {
    
    BOOL _searchBarHidden;
    CGFloat _searchBarTopConstraintValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _searchBarTopConstraintValue = self.seachBarConstraint.constant;
    _searchBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)clickDone:(id)sender {

    NSLog(@"offset: %@", NSStringFromCGPoint(self.domainsTextView.contentOffset));
    self.domainsTextView.contentOffset = CGPointZero;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self.searchBar setNeedsUpdateConstraints];

    CGFloat absoluteTopVal = ABS(_searchBarTopConstraintValue);
    CGFloat topValue = _searchBarHidden ? TOP_BOUNSE_LIMIT : _searchBarTopConstraintValue;
    
    if (decelerate) {
        [self.searchBar resignFirstResponder];
    }

    if(scrollView.contentOffset.y < topValue)
    {
        
        _searchBarHidden = NO;
        self.seachBarConstraint.constant = 0.0f;
        [UIView animateWithDuration:0.1 animations:^{
            
            self.domainsTextView.contentInset = UIEdgeInsetsMake(absoluteTopVal, 0, 0, 0);
            [self.view layoutIfNeeded];
        }];
        [self.searchBar becomeFirstResponder];
        
    } else {

        _searchBarHidden = YES;
        [self.searchBar resignFirstResponder];
        [self.searchBar setText:@""];
        
        self.seachBarConstraint.constant = _searchBarTopConstraintValue;
        [UIView animateWithDuration:0.1 animations:^{
            
            self.domainsTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            [self.view layoutIfNeeded];
        }];
        
    }
}
@end
