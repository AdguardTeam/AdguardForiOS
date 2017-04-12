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
#import "AEUIPlayerViewController.h"
#import "ADomain/ADomain.h"

#define URL_TEMPLATE                    @"https://cdn.adguard.com/public/Adguard/iOS/videotutorial/%@/%@.mp4"

#define DEFAULT_TUTORIAL_VIDEO          @"EnablingAdguardVideo"
#define HIDE_NAVIGATION_DELAY 2 // seconds

@interface AEUIPlayerViewController ()

@end

@implementation AEUIPlayerViewController {

    UITapGestureRecognizer *_gesture;
    BOOL _statusBarHidden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (!self.videoName) {
        self.videoName = DEFAULT_TUTORIAL_VIDEO;
    }
    
    NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, [ADLocales lang], self.videoName]];
    
    if (videoURL) {

        _gesture = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(handleGesture:)];
        _gesture.delegate = self;

        self.showsPlaybackControls = NO;
        self.allowsPictureInPicturePlayback = NO;

        [self createPlayerForUrl:videoURL];
        
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW,
                          (int64_t)(HIDE_NAVIGATION_DELAY * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
              [self.view addGestureRecognizer:_gesture];
              [[self navigationController] setNavigationBarHidden:YES
                                                         animated:YES];
              [self hideStatusBar:YES];

            });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [self removePlayer];
}

- (void)viewWillDisappear:(BOOL)animated{

    [[self navigationController] setNavigationBarHidden:NO animated:animated];
    [self hideStatusBar:NO];
    
}

- (void)hideStatusBar:(BOOL)hide {

    if (_statusBarHidden != hide) {
        _statusBarHidden = hide;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (BOOL)prefersStatusBarHidden {

    return _statusBarHidden;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:
        (UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;
{

    if (gestureRecognizer.numberOfTouches == 1) {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        [self hideStatusBar:NO];
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW,
                          (int64_t)(HIDE_NAVIGATION_DELAY * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
              [[self navigationController] setNavigationBarHidden:YES
                                                         animated:YES];
              [self hideStatusBar:YES];
            });
    }
}

- (void)playerEnd:(NSNotification *)noti {

    [self.view removeGestureRecognizer:_gesture];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self hideStatusBar:NO];

    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW,
                      (int64_t)(HIDE_NAVIGATION_DELAY * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [self.navigationController popViewControllerAnimated:YES];
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
    
    // if error occurs, we attempt replace locale specific video on default video
    if ([object isEqual:self.player.currentItem] && [keyPath isEqualToString:@"status"]) {
        
        AVPlayerStatus status = [change[NSKeyValueChangeNewKey] intValue];
        
        if (status == AVPlayerItemStatusFailed) {
            
            NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:URL_TEMPLATE, ADL_DEFAULT_LANG, self.videoName]];
            
            if (videoURL) {

                [self removePlayer];
                [self createPlayerForUrl:videoURL];
            }

        }
        else if (status == AVPlayerItemStatusReadyToPlay) {
            
            [self.player play];
        }
    }
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}



@end
