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
#import "AEUIMainController.h"
#import "ADomain/ADomain.h"
#import "ACommons/ACLang.h"
#import "AESharedResources.h"
#import "AppDelegate.h"
#import "AEUIWelcomePagerDataSource.h"
#import "AEService.h"
#import "AESAntibanner.h"
#import "AESSupport.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIMainController Constants
/////////////////////////////////////////////////////////////////////

#define ITUNES_APP_ID               @"1047223162"
#define ITUNES_APP_NAME             @"adguard-adblock-for-ios"
#define RATE_APP_URL_FORMAT         @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
#define SHARE_APP_URL_FORMAT        @"https://itunes.apple.com/app/id%@"

#define SHARE_APP_URL_STRING        SHARE_APP_URL_FORMAT, ITUNES_APP_ID

#define RESET_UPDATE_FILTERS_DELAY  3 //seconds
/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIMainController
/////////////////////////////////////////////////////////////////////


@interface AEUIMainController (){
    
    AEUIWelcomePagerDataSource *_welcomePageSource;
    BOOL _inCheckUpdates;
    NSString *_updateButtonTextHolder;
    NSMutableArray *_observers;
}

@end

@implementation AEUIMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.enableAdguardSwitch setOn:[[AESharedResources sharedDefaults] boolForKey:AEDefaultsAdguardEnabled]];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(refreshDynamicObjects:)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];

    self.lastUpdated.text = @"              ";
    _updateButtonTextHolder = self.checkFiltersCell.textLabel.text;

    [self refreshDynamicObjects:nil];

    [self prepareCheckUpdatesButton];
    

    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigation = self.navigationController;
    
    if ([[AEService singleton] firstRunInProgress]) {
        
        [self showWelcomeScreen];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    _welcomePageSource = nil;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (id observer in _observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Actions
/////////////////////////////////////////////////////////////////////


- (IBAction)toggleAdguard:(id)sender {

    [[AESharedResources sharedDefaults] setBool:[sender isOn] forKey:AEDefaultsAdguardEnabled];
}

- (IBAction)clickTwitter:(id)sender {

    SLComposeViewController *compose = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if (compose) {
        
        [compose setInitialText:NSLocalizedString(@"Adguard - Adblock for iOS:", @"(AEUIMainController) Share this app initial text on Twitter")];
        [compose addURL:[NSURL URLWithString:[NSString stringWithFormat:SHARE_APP_URL_STRING]]];
        [compose addImage:[UIImage imageNamed:@"share-logo"]];
        [self presentViewController:compose animated:YES completion:nil];
    }
}

- (IBAction)clickFacebook:(id)sender {
    
    SLComposeViewController *compose = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    if (compose) {
        
        BOOL result = [compose setInitialText:[NSString stringWithFormat:@"%@\n", NSLocalizedString(@"I've just installed Adguard ad blocker. If you want to surf the web ad-free as I do, check it out:", @"(AEUIMainController) Share this app initial text on Facebook")]];
        
        DDLogInfo(@"(AEUIMainController) Facebook initial text installed: %@", (result ? @"YES" : @"NO"));
        
        [compose addURL:[NSURL URLWithString:[NSString stringWithFormat:SHARE_APP_URL_STRING]]];
        [compose addImage:[UIImage imageNamed:@"share-logo"]];
        [self presentViewController:compose animated:YES completion:nil];
    }
}

- (IBAction)clickMessage:(id)sender {
    
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *compose = [MFMessageComposeViewController new];
        NSString *body = [NSString stringWithFormat:@"%@\n%@\n",
                          NSLocalizedString(@"I've just installed Adguard AdBlocker for iOS.", @"(AEUIMainController) Share this app initial text on iMessage (text row)"),
        NSLocalizedString(@"If you want to surf the web ad-free as I do, check it out:", @"(AEUIMainController) Share this app initial text on iMessage (before link row)")];
        body = [body stringByAppendingFormat:SHARE_APP_URL_STRING];
        compose.body = body;
        compose.messageComposeDelegate = self;
        [self presentViewController:compose animated:YES completion:nil];
    }
}

- (IBAction)clickMail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *compose = [MFMailComposeViewController new];
        NSString *body = [NSString stringWithFormat:@"%@\n%@\n",
                          NSLocalizedString(@"I've just installed Adguard AdBlocker for iOS.", @"(AEUIMainController) Share this app initial text on Mail Body (text row)"),
                          NSLocalizedString(@"If you want to surf the web ad-free as I do, check it out:", @"(AEUIMainController) Share this app initial text on Mail Body (before link row)")];
        body = [body stringByAppendingFormat:SHARE_APP_URL_STRING];
        [compose setMessageBody:body isHTML:NO];
        [compose setSubject:NSLocalizedString(@"Check this out!", @"(AEUIMainController) Share this app initial text on Mail Subject")];
        compose.mailComposeDelegate = self;
        
        [self presentViewController:compose animated:YES completion:nil];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Table view delegates
/////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Selected RATE APP
    if (indexPath.section == 2 && indexPath.row == 0) {

        NSURL *theURL =
            [NSURL URLWithString:[NSString stringWithFormat:RATE_APP_URL_FORMAT,
                                                            ITUNES_APP_ID]];
        [[UIApplication sharedApplication] openURL:theURL];
    }
    // Selected Check Filter Updates
    else if (!_inCheckUpdates && indexPath.section == 1 &&
               indexPath.row == 4) {

        [(AppDelegate *)[[UIApplication sharedApplication] delegate] invalidateAntibanner:YES];
    }
    else if (indexPath.section == 3 && indexPath.row == 1){
    // Selected Send Bug Report
        
        [[AESSupport singleton] sendMailBugReportWithParentController:self];
    }
}

#pragma mark Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"tutorialRunSegue"]) {
        
        UIPageViewController *destination = [segue destinationViewController];
        [self prepareWelcomeScreenForController:destination];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Message and Mail Compose Delegate Methods
/////////////////////////////////////////////////////////////////////

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Notification
/////////////////////////////////////////////////////////////////////

- (void)refreshDynamicObjects:(NSNotification *)notification {

    NSDate *checkDate = [[AESharedResources sharedDefaults] objectForKey:AEDefaultsCheckFiltersLastDate];
    if (checkDate) {
        self.lastUpdated.text = [NSDateFormatter localizedStringFromDate:checkDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    }

    BOOL enabled = NO;
    
    BOOL result = [SLComposeViewController
        isAvailableForServiceType:SLServiceTypeFacebook];
    enabled |= result;
    self.facebookButton.hidden = !result;
    
    enabled |= result = [SLComposeViewController
        isAvailableForServiceType:SLServiceTypeTwitter];
    self.twitterButton.hidden = !result;
    
    enabled |= result = [MFMessageComposeViewController canSendText];
    self.messageButton.hidden = !result;
    [self.messageButton invalidateIntrinsicContentSize];

    enabled |= result = [MFMailComposeViewController canSendMail];
    self.mailButton.hidden = !result;

    [self cell:self.shareCell setHidden:!enabled];
    [self reloadDataAnimated:YES];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
/////////////////////////////////////////////////////////////////////

- (void)showWelcomeScreen{

    UIPageViewController *pager = (UIPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"welcomePager"];
    if (pager) {
        
        [self prepareWelcomeScreenForController:pager];
        [self.navigationController pushViewController:pager animated:YES];
    }
}

- (void)prepareWelcomeScreenForController:(UIPageViewController *)pager{
    
    if (pager) {
        
        if (!_welcomePageSource) {
            _welcomePageSource = [[AEUIWelcomePagerDataSource alloc] initWithStoryboard:pager.storyboard];
        }
        if (_welcomePageSource) {
            
            pager.dataSource = _welcomePageSource;
            _welcomePageSource.currentIndex = 0;
            [pager setViewControllers:@[[_welcomePageSource currentControllerForIndex:0 ]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        }
    }
}

- (void)prepareCheckUpdatesButton {

    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.hidesWhenStopped = YES;
    activity.hidden = YES;
    //    activity.color = self.view.tintColor;

    self.checkFiltersCell.accessoryView = activity;
    self.checkFiltersCell.textLabel.textColor =
        self.checkFiltersCell.textLabel.tintColor;

    _inCheckUpdates = NO;

    _observers = [NSMutableArray arrayWithCapacity:3];
    
    // When update started
    id observer = [[NSNotificationCenter defaultCenter]
        addObserverForName:AppDelegateStartedUpdateNotification
                    object:nil
                     queue:nil
                usingBlock:^(NSNotification *_Nonnull note) {

                  self.checkFiltersCell.textLabel.enabled = NO;
                  UIActivityIndicatorView *activity =
                      (UIActivityIndicatorView *)
                          self.checkFiltersCell.accessoryView;
                  activity.hidden = NO;
                  [activity startAnimating];
                  _inCheckUpdates = YES;
                }];

    [_observers addObject:observer];
    
    // When update finished
    observer = [[NSNotificationCenter defaultCenter]
        addObserverForName:AppDelegateFinishedUpdateNotification
                    object:nil
                     queue:nil
                usingBlock:^(NSNotification *_Nonnull note) {

                    // run this only reload json process is finished
                  [[AEService singleton] onReloadContentBlockingJsonComplete:^{

                    dispatch_sync(dispatch_get_main_queue(), ^{

                        UIActivityIndicatorView *activity =
                        (UIActivityIndicatorView *)
                        self.checkFiltersCell.accessoryView;
                        [activity stopAnimating];
                        
                      // setting text of result on "Check Filter Updates"
                      NSArray *updatedMetas =
                          [note userInfo][AppDelegateUpdatedFiltersKey];
                      if (updatedMetas.count) {

                          NSString *format =
                              NSLocalizedString(@"Filters updated: %lu",
                                                @"(AEUIMainController) Button "
                                                @"- Check Filter Updates");
                          self.checkFiltersCell.textLabel.text = [NSString
                              stringWithFormat:format, updatedMetas.count];
                      } else {

                          self.checkFiltersCell.textLabel.text =
                              NSLocalizedString(@"No updates found",
                                                @"(AEUIMainController) Button "
                                                @"- Check Filter Updates");
                      }

                      NSDate *checkDate = [[AESharedResources sharedDefaults]
                          objectForKey:AEDefaultsCheckFiltersLastDate];
                      if (checkDate) {
                          self.lastUpdated.text = [NSDateFormatter
                              localizedStringFromDate:checkDate
                                            dateStyle:NSDateFormatterShortStyle
                                            timeStyle:
                                                NSDateFormatterShortStyle];
                      }
                    });

                    dispatch_after(
                        dispatch_time(DISPATCH_TIME_NOW,
                                      (int64_t)(RESET_UPDATE_FILTERS_DELAY *
                                                NSEC_PER_SEC)),
                        dispatch_get_main_queue(), ^{
                          [self resetCheckFilterUpdatesButton];
                        });
                  }];
                    
                }];

    [_observers addObject:observer];
    
    // When update failured
    observer = [[NSNotificationCenter defaultCenter]
        addObserverForName:AppDelegateFailuredUpdateNotification
                    object:nil
                     queue:nil
                usingBlock:^(NSNotification *_Nonnull note) {

                  UIActivityIndicatorView *activity =
                      (UIActivityIndicatorView *)
                          self.checkFiltersCell.accessoryView;
                  [activity stopAnimating];

                  dispatch_async(dispatch_get_main_queue(), ^{

                    // setting text of result on "Check Filter Updates"
                    self.checkFiltersCell.textLabel.text = NSLocalizedString(
                        @"Filters update error",
                        @"(AEUIMainController) Button - Check Filter Updates");
                  });

                  dispatch_after(
                      dispatch_time(
                          DISPATCH_TIME_NOW,
                          (int64_t)(RESET_UPDATE_FILTERS_DELAY * NSEC_PER_SEC)),
                      dispatch_get_main_queue(), ^{
                        [self resetCheckFilterUpdatesButton];
                      });

                }];
    [_observers addObject:observer];
}

- (void)resetCheckFilterUpdatesButton{

    self.checkFiltersCell.textLabel.enabled = YES;
    self.checkFiltersCell.textLabel.text = _updateButtonTextHolder;
    _inCheckUpdates = NO;
}

@end
