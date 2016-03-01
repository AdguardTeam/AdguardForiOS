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

#define DEFAULT_TUTORIAL_VIDEO          @"EnablingAdguardVideo"
#define TUTORIAL_VIDEO_EXT      @"mp4"
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
    
    NSURL *videoURL =
        [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@-%@",self.videoName, [ADLocales lang]] withExtension:TUTORIAL_VIDEO_EXT];
    if (!videoURL) {
        videoURL = [[NSBundle mainBundle] URLForResource:self.videoName withExtension:TUTORIAL_VIDEO_EXT];
    }
    
    if (videoURL) {

        _gesture = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(handleGesture:)];
        _gesture.delegate = self;

        self.player = [AVPlayer playerWithURL:videoURL];

        self.showsPlaybackControls = NO;
        self.allowsPictureInPicturePlayback = NO;

        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(playerEnd:)
                   name:AVPlayerItemDidPlayToEndTimeNotification
                 object:self.player.currentItem];

        [self.player play];
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

    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

@end
