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
#import "AEUIWelcomePageController.h"
#import "ADomain/ADLocales.h"

NSString *AEUIWelcomePageTitleKey =          @"title";
NSString *AEUIWelcomePageLabelKey =          @"label";
NSString *AEUIWelcomePageImageNameKey =      @"imageName";
NSString *AEUIWelcomePageButtonTitleKey =    @"buttonTitle";
NSString *AEUIWelcomePageButtonActionKey =   @"buttonSelector";

@interface AEUIWelcomePageController ()

@end

@implementation AEUIWelcomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.welcomeTitle.text = _properties[AEUIWelcomePageTitleKey];
    self.welcomeLabel.text = _properties[AEUIWelcomePageLabelKey];
    NSString *welcomeImageName = _properties[AEUIWelcomePageImageNameKey];
    if (welcomeImageName) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-%@",welcomeImageName, [ADLocales lang]]];
        if (!image) {
            image = [UIImage imageNamed:welcomeImageName];
        }
        self.welcomeImage.image = image;
    }
    else {
        self.welcomeImage.hidden = YES;
    }

    NSString *buttonAction = _properties[AEUIWelcomePageButtonActionKey];
    if (buttonAction && [self respondsToSelector:NSSelectorFromString(buttonAction)]) {
        
        [self.actionButton setTitle: _properties[AEUIWelcomePageButtonTitleKey ] forState:UIControlStateNormal];
        [self.actionButton addTarget:self action:NSSelectorFromString(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        self.actionButton.hidden = NO;
//        [self.view setNeedsLayout];
//        [self.view layoutIfNeeded];
    }

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

- (IBAction)clickFinish:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
