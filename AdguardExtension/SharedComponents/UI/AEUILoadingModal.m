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
#import "AEUILoadingModal.h"
#import "ACommons/ACSystem.h"
#import "NSString+Utils.h"

NSString *AEUILoadingModalIdentifier = @"loadingModal";


@implementation AEUILoadingModal{
    
    id _observer;
}

static AEUILoadingModal *lmSingleton;

- (id)init{
    
    if (self == lmSingleton) {
        self = [super init];
        if (self) {
            
            _observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                
                // remove modal controller if memory warning
                if (!self.loadingModal.presentingViewController) {
                    _loadingModal = nil;
                }
 
            }];
        }
        return self;
    }
    
    return nil;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:_observer];
}

+ (id)singleton{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        lmSingleton = [AEUILoadingModal alloc];
        lmSingleton = [lmSingleton init];
    });
    
    return lmSingleton;
}

- (void)loadingModalShowWithParent:(UIViewController*)parent message:(NSString *)message cancelAction:(SEL)cancelAction completion:(dispatch_block_t)completionBlock {
    
    if (!self.loadingModal) {
        UIStoryboard *board = parent.storyboard;
        _loadingModal = [board instantiateViewControllerWithIdentifier:AEUILoadingModalIdentifier];
        self.loadingModal.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.loadingModal.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    self.loadingModal.delegate = parent;
    self.loadingModal.cancelAction = cancelAction;
    self.loadingModal.hideCancelButton = (cancelAction == nil);
    self.loadingModal.loadingMessageText = message;
        
    if (self.loadingModal.presentingViewController == nil) {
        [parent presentViewController:self.loadingModal animated:YES completion:completionBlock];
    }
    else if (completionBlock){
        completionBlock();
    }
}

- (void)standardLoadingModalShowWithParent:(UIViewController *)parent completion:(dispatch_block_t)completionBlock{
    
    NSString *convertingMessage = ACLocalizedString(@"safari_filters_loading", @"(AEUILoadingModal) Standard message when filter conversion is performed.");

    [self loadingModalShowWithParent:parent message:convertingMessage cancelAction:nil  completion:completionBlock];
}

- (void)loadingModalHide{

    [self loadingModalHideWithCompletion:nil];
}

- (void)loadingModalHideWithCompletion:(dispatch_block_t)completionBlock{
    
    [ACSSystemUtils callOnMainQueue:^{
        
        [self.loadingModal dismissViewControllerAnimated:YES completion:completionBlock];
    }];
}


@end
