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
#import "AEUIPlayerViewController.h"
#import "ADomain/ADomain.h"
#import "NSString+Utils.h"

#define URL_TEMPLATE                    @"https://cdn.adguard.com/public/Adguard/iOS/videotutorial/4.0/%@/%@.mp4"

#define DEFAULT_TUTORIAL_VIDEO          @"ManageContentBlocker"
#define HIDE_NAVIGATION_DELAY 4 // seconds

@implementation AEUIPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, [ADLocales lang], DEFAULT_TUTORIAL_VIDEO]];
    
    if (videoURL) {
        [self createPlayerForUrl:videoURL];
    }
}

- (void)dealloc {
    [self removePlayer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:
        (UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)playerEnd:(NSNotification *)noti {
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW,
                      (int64_t)(HIDE_NAVIGATION_DELAY * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
}

- (void)createPlayerForUrl:(NSURL *)videoURL {
    
    AVPlayer *player  = [AVPlayer playerWithURL:videoURL];
    
    [player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playerEnd:)
     name:AVPlayerItemDidPlayToEndTimeNotification
     object:player.currentItem];
    
    self.player = player;
    
    if (player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        [self.player play];
    }
}

- (void)removePlayer {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isEqual:self.player.currentItem] && [keyPath isEqualToString:@"status"]) {

        AVPlayerStatus status = [change[NSKeyValueChangeNewKey] intValue];

        if (status == AVPlayerItemStatusFailed) {

            NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, ADL_DEFAULT_LANG, DEFAULT_TUTORIAL_VIDEO]];

            if (videoURL) {
                [self removePlayer];
                [self createPlayerForUrl:videoURL];
            }

        }
        else if (status == AVPlayerItemStatusReadyToPlay) {
            [self.player play];
        }
    }
}

@end
