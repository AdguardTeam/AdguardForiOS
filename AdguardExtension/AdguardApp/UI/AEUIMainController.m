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
#import "AEUIRulesController.h"
#import "AEUICommons.h"
#import "APUIAdguardDNSController.h"

#ifdef PRO
#import "APVPNManager.h"
#endif

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIMainController Constants
/////////////////////////////////////////////////////////////////////

#ifdef PRO
#define ITUNES_APP_ID               @"1126386264"
#else
#define ITUNES_APP_ID               @"1047223162"
#endif

#define ITUNES_APP_NAME             @"adguard-adblock-for-ios"
#define RATE_APP_URL_FORMAT         @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
#define SHARE_APP_URL_FORMAT        @"https://itunes.apple.com/app/id%@"
#define VIEW_ON_GITHUB              @"https://github.com/AdguardTeam/AdguardForiOS"

#define SHARE_APP_URL_STRING        SHARE_APP_URL_FORMAT, ITUNES_APP_ID

#define RESET_UPDATE_FILTERS_DELAY  3 //seconds

#define TO_USER_FILTER_SEGUE_ID     @"toUserFilter"

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIMainController
/////////////////////////////////////////////////////////////////////


@interface AEUIMainController (){
    
    AEUIWelcomePagerDataSource *_welcomePageSource;
    BOOL _inCheckUpdates;
    NSString *_updateButtonTextHolder;
    NSMutableArray *_observers;
    
    NSString *_ruleTextHolderForAddRuleCommand;
    
}

@end

@implementation AEUIMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = AE_PRODUCT_NAME;
    
#ifdef PRO
    [self proAttachToNotifications];
    [self proUpdateAdguardDnsStatus];
   
#else
    self.hideSectionsWithHiddenRows = YES;
    [self cells:self.proSectionCells setHidden:YES];
#endif
    
    [self reloadDataAnimated:NO];
    
    
    [self.enableAdguardSwitch setOn:[[AESharedResources sharedDefaults] boolForKey:AEDefaultsAdguardEnabled]];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(refreshDynamicObjects:)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];

    self.lastUpdated.text = @"              ";
    _updateButtonTextHolder = self.checkFiltersCell.textLabel.text;

    [self refreshDynamicObjects:nil];

    [self prepareCheckUpdatesButton];

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
        
        [compose setInitialText:NSLocalizedString(@"I like Adguard for iOS - I don't see ads in Safari anymore.", @"(AEUIMainController) Share this app initial text on Twitter")];
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

- (IBAction)clickViewOnGitHub:(id)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:VIEW_ON_GITHUB]];
}

- (IBAction)clickCheckForUpdates:(id)sender {
    if (!_inCheckUpdates) {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] invalidateAntibanner:YES];
    }
}

- (IBAction)clickRateThisApp:(id)sender {
    NSURL *theURL =
    [NSURL URLWithString:[NSString stringWithFormat:RATE_APP_URL_FORMAT,
                          ITUNES_APP_ID]];
    [[UIApplication sharedApplication] openURL:theURL];
}

- (IBAction)clickSendBugReport:(id)sender {
    [[AESSupport singleton] sendMailBugReportWithParentController:self];
}

- (IBAction)clickDNS:(id)sender {
    DDLogError(@"Id %@", sender);
}

- (void)addRuleToUserFilter:(NSString *)ruleText{

    if ([NSString isNullOrEmpty:ruleText]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        _ruleTextHolderForAddRuleCommand = ruleText;
        id topController = self.navigationController.topViewController;
        if ([topController isKindOfClass:[AEUIRulesController class]]) {
            
            [topController setRuleTextForAdding:_ruleTextHolderForAddRuleCommand];
            _ruleTextHolderForAddRuleCommand = nil;
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self performSegueWithIdentifier:TO_USER_FILTER_SEGUE_ID sender:self];
        }
    });
}

#pragma mark Navigation

- (void)viewWillAppear:(BOOL)animated{
    
    [self setToolbar];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.toolbarHidden = YES;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"tutorialRunSegue"]) {
        
        UIPageViewController *destination = [segue destinationViewController];
        [self prepareWelcomeScreenForController:destination];
    }
    else if ([segue.identifier isEqualToString:TO_USER_FILTER_SEGUE_ID]){
        
        if (![NSString isNullOrEmpty:_ruleTextHolderForAddRuleCommand]) {
            
            AEUIRulesController *dest = [segue destinationViewController];
            dest.ruleTextForAdding = _ruleTextHolderForAddRuleCommand;
            _ruleTextHolderForAddRuleCommand = nil;
        }
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

#ifdef PRO
- (void)proUpdateAdguardDnsStatus{
    APVPNManager *manager = [APVPNManager singleton];
    
    switch (manager.connectionStatus) {
            
        case APVpnConnectionStatusReconnecting:
            
        case APVpnConnectionStatusConnecting:
        case APVpnConnectionStatusDisconnecting:
            self.proAdguardDnsCell.detailTextLabel.text = NSLocalizedString(@"In Progress",@"(AEUIMainController) PRO version. On the main screen. Pro section, Adguard DNS row. Current status title. When status is 'In Progress'.");
            break;
            
        default:
            
            if (manager.enabled)
                self.proAdguardDnsCell.detailTextLabel.text = [manager modeDescription:manager.vpnMode];
            else
                self.proAdguardDnsCell.detailTextLabel.text = NSLocalizedString(@"Not Connected",@"(AEUIMainController) PRO version. On the main screen. Pro section, Adguard DNS row. Current status title. When status is Not Connected.");
            break;
    }
    
}

- (void)proAttachToNotifications{
    
    id observer = [[NSNotificationCenter defaultCenter]
                 addObserverForName:APVpnChangedNotification
                 object: nil
                 queue:nil
                 usingBlock:^(NSNotification *_Nonnull note) {
                     
                     // When configuration is changed
                     
                     [self proUpdateAdguardDnsStatus];
                 }];
    
    if (observer) {
        [_observers addObject:observer];
    }
}

#endif

- (void)setToolbar{
    
    static UILabel *warning;
    
    self.navigationController.toolbarHidden = YES;
    
    NSString *warningText;
    
    //Show warning if overlimit of rules was reached.
    if ([[AESharedResources sharedDefaults] boolForKey:AEDefaultsJSONRulesOverlimitReached]) {
        
        NSUInteger rulesCount = [[[AESharedResources sharedDefaults] objectForKey:AEDefaultsJSONConvertedRules] unsignedIntegerValue];
        NSUInteger totalRulesCount = [[[AESharedResources sharedDefaults] objectForKey:AEDefaultsJSONRulesForConvertion] unsignedIntegerValue];

        warningText = [NSString stringWithFormat:NSLocalizedString(@"Too many filters enabled. Safari cannot use more than %1$lu rules. Enabled rules: %2$lu.", @"(AEUIMainController) Warning text on main screen"), rulesCount, totalRulesCount];
    }
    
    if (warningText) {
        
        UIView *toolbar = self.navigationController.toolbar;
        if (toolbar) {
            
            UIEdgeInsets insets = toolbar.layoutMargins;
            //        UIEdgeInsets rootInsets = self.navigationController.view.layoutMargins;
            CGRect frame = toolbar.bounds;
            frame.origin = CGPointMake(0, 0);
            //            frame.size.height -= insets.top + insets.bottom;
            frame.size.width -= insets.left + insets.right;
            if (!(frame.size.height <= 0 || frame.size.width <= 0)) {

                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    warning = [[UILabel alloc] initWithFrame:frame];
                    warning.textColor = AEUIC_WARNING_COLOR;
                    warning.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
                    warning.textAlignment = NSTextAlignmentCenter;
                    warning.numberOfLines = 2;
                    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:warning];
                    
                    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                    if (item) {
                        self.toolbarItems = @[spacer, item, spacer];
                    }
                });

                //                warning.lineBreakMode = NSLineBreakByWordWrapping;
                warning.text = warningText;
            }
        }
        
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

@end
