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
#import "AEUILoadingModalController.h"

@interface AEUILoadingModalController (){
    
    NSString *_loadingMessageText;
    BOOL _hideCancelButton;
}

@end

@implementation AEUILoadingModalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loadingMessage.text = _loadingMessageText;
    self.cancelButton.hidden = _hideCancelButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)hideCancelButton{
    
    return _hideCancelButton;
}

- (void)setHideCancelButton:(BOOL)hideCancelButton{
    
    _hideCancelButton = hideCancelButton;
    if (self.cancelButton) {
        
        self.cancelButton.hidden = _hideCancelButton;
    }
}

- (NSString *)loadingMessageText{
    
    return _loadingMessageText;
}

- (void)setLoadingMessageText:(NSString *)loadingMessageText{
    
    _loadingMessageText = loadingMessageText;
    
    if (self.loadingMessage) {
        self.loadingMessage.text = _loadingMessageText;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickCancel:(id)sender {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    if (self.cancelAction && [self.delegate respondsToSelector:self.cancelAction]) {
        [self.delegate performSelector:self.cancelAction withObject:self];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
#pragma clang diagnostic pop
}

@end
