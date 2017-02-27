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
#import "AEUIEditDomainController.h"
#import "ACommons/ACLang.h"
#import "AEWhitelistDomainObject.h"

@interface AEUIEditDomainController ()

@end

@implementation AEUIEditDomainController{
    
    CGFloat _initialConstantOfBottomConstraint;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidChangeFrameWithNotification:)
     name:UIKeyboardDidChangeFrameNotification
     object:nil];

    _initialConstantOfBottomConstraint = self.bottomConstraint.constant;

    _done = NO;
    
    if (!self.domain) {
        self.domain = [AEWhitelistDomainObject new];
    }
    self.domainTextField.text = self.domain.domain;
    
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self.domainTextField becomeFirstResponder];
                   });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
#pragma mark Delegate methods
/////////////////////////////////////////////////////////////////////


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    [self clickDone:textField];
    
    return NO;
}

- (BOOL)textField:(UITextField * _Nonnull)textField
shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string{

    if ([string contains:@"/"]) {
        if (string.length > 1) {
            
            NSURL *url = [NSURL URLWithString:string];
            string = [url hostWithPort];
            if (string) {
                
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
            }
        }
        return NO;
    }
    return YES;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Actions
/////////////////////////////////////////////////////////////////////
- (IBAction)clickDone:(id)sender {
    
    if (![NSString isNullOrEmpty:self.domainTextField.text]) {
        self.domain.domain = self.domainTextField.text;
        _done = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/////////////////////////////////////////////////////////////////////
#pragma mark Private methods
/////////////////////////////////////////////////////////////////////


- (void)keyboardDidChangeFrameWithNotification:(NSNotification *)notification {
    CGFloat keyboardVerticalIncrease = [self keyboardVerticalIncreaseForNotification:notification];
    [self animateTextViewFrameForVerticalOffset:keyboardVerticalIncrease];
}

- (CGFloat)keyboardVerticalIncreaseForNotification:(NSNotification *)notification {
    CGFloat keyboardBeginY = [[UIScreen mainScreen] bounds].size.height;
    CGFloat keyboardEndY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    CGFloat keyboardVerticalIncrease = keyboardBeginY - keyboardEndY;
    return keyboardVerticalIncrease / 2;
}

- (void)animateTextViewFrameForVerticalOffset:(CGFloat)offset {
    [UIView animateWithDuration:0.5 animations:^{
        //        [self.view layoutIfNeeded];
        self.bottomConstraint.constant = _initialConstantOfBottomConstraint - offset;
    }];
}

@end
