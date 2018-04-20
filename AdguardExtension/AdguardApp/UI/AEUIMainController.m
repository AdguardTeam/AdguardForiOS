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
#import "AEUIMainController.h"
#import "ADomain/ADomain.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "AESharedResources.h"
#import "AppDelegate.h"
#import "AEUIWelcomePagerDataSource.h"
#import "AEService.h"
#import "AESAntibanner.h"
#import "AESSupport.h"
#import "AEUIRulesController.h"
#import "AEUICommons.h"
#import "AEUICustomTextEditorController.h"
#import "ASDFilterObjects.h"
#import "AEUIFilterRuleObject.h"
#import "AEUIUtils.h"
#import "AEUIWhitelistController.h"
#import "AEUIPlayerViewController.h"
#import "AEUISelectableTableViewCell.h"

#import <StoreKit/StoreKit.h>


#ifdef PRO

#import "APVPNManager.h"
#import "APDnsServerObject.h"
#import "APUIProSectionFooter.h"
#import "APUIDnsServersController.h"
#import "AERDomainFilterRule.h"
#import "APSharedResources.h"

#define NBSP_CODE                       @"\u00A0"
#define LINK_URL_STRING                 @"https://adguard.com/adguard-dns/overview.html#overview"

#endif

#define VIDEO_SECTION_INDEX             0
#define PRO_SECTION_INDEX               1

#define VIDEO_IMAGE_MAX_HEIGHT 200

#define MIN_DAYS_TO_RATE_ME          7
#define MIN_TIME_INTERVAL_TO_RATE_ME MIN_DAYS_TO_RATE_ME * 24 * 3600
#define RATE_ME_TIME_AFTER_START     10 // seconds

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIMainController Constants
/////////////////////////////////////////////////////////////////////

#define ITUNES_PRO_APP_ID           @"1126386264"

#ifdef PRO
#define ITUNES_APP_ID               ITUNES_PRO_APP_ID
#else
#define ITUNES_APP_ID               @"1047223162"
#endif

#define ITUNES_APP_NAME             @"adguard-adblock-for-ios"
#define RATE_APP_URL_FORMAT         @"itms-apps://itunes.apple.com/us/app/itunes-u/id%@?action=write-review"
#define SHARE_APP_URL_FORMAT        @"https://itunes.apple.com/app/id%@"
#define VIEW_ON_GITHUB              @"https://github.com/AdguardTeam/AdguardForiOS"
#define OTHER_APPS_URL              @"http://agrd.io/ios_adguard_products"
#define BUGREPORT_URL               @"http://agrd.io/report_ios_bug"
#define GET_PRO_URL                 @"https://itunes.apple.com/app/apple-store/id1126386264?pt=31050800&ct=ios_app&mt=8"

#define SHARE_APP_URL_STRING        SHARE_APP_URL_FORMAT, ITUNES_APP_ID

#define RESET_UPDATE_FILTERS_DELAY  3 //seconds

#define TO_USER_FILTER_SEGUE_ID     @"toUserFilter"
#define TO_WHITELIST_SEGUE_ID       @"toWhitelist"
#define TO_SAFARI_VIDEO_SEGUE_ID    @"toSafariVideo"
#define TO_SETTINGS_VIDEO_SEGUE_ID  @"toSettingsVideo"


#define EDITOR_TEXT_FONT            [UIFont systemFontOfSize:[UIFont systemFontSize]]

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIMainController
/////////////////////////////////////////////////////////////////////


@interface AEUIMainController (){
    
    BOOL _inCheckUpdates;
    NSString *_updateButtonTextHolder;
    NSMutableArray *_observers;
    
    NSString *_ruleTextHolderForAddRuleCommand;

    UIBarButtonItem *_cancelNavigationItem;
    
    BOOL _contentBlockerEnabled;

#ifdef PRO
    APUIProSectionFooter *_proFooter;
#endif
}

@end

@implementation AEUIMainController

- (void)setupSwipeCell:(MGSwipeTableCell *)swipeCell swipeCellDefaultsKey:(NSString *)swipeCellDefaultsKey {
    if([[AESharedResources.sharedDefaults valueForKey:swipeCellDefaultsKey] boolValue])
    {
        [self cell:swipeCell setHidden:YES];
        [self reloadDataAnimated:NO];
    }
    else {
        
        for (UIView *view in swipeCell.subviews){
            
            if(view != swipeCell.contentView) {
                [view removeFromSuperview];
            }
        }
        
        MGSwipeButton *hideButton = [MGSwipeButton buttonWithTitle:NSLocalizedString(@"button_hide_video", @"Hide video button caption in main screen") icon:[UIImage imageNamed:@"hideIcon"] backgroundColor:[UIColor clearColor]];
        [hideButton centerIconOverText];
        
        hideButton.callback = ^BOOL(MGSwipeTableCell * _Nonnull cell) {
            
            [self cell:swipeCell setHidden:YES];
            [self reloadDataAnimated:YES];
            
            [AESharedResources.sharedDefaults setObject:@(YES) forKey:swipeCellDefaultsKey];
            
            return NO;
        };
        swipeCell.rightButtons = @[hideButton];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.title = LocalizationNotNeeded(AE_PRODUCT_NAME);
    
    _cancelNavigationItem = [[UIBarButtonItem alloc]
                             initWithTitle:NSLocalizedString(@"common_action_cancel",
                                                             @"(AEUIMainController) Text on the button that cancels an operation.")
                             style:UIBarButtonItemStylePlain target:nil action:nil];
#ifdef PRO
    
    // tunning accessibility
    self.proDnsSettingsCell.accessibilityHint = [self proShortStatusDescription];
    //-----------------
    
    [self proAttachToNotifications];
    [self updateCounters];
    self.hideSectionsWithHiddenRows = YES;
    //self.proStatusCell.accessibilityHint = [self proShortStatusDescription];
    
#else
    self.hideSectionsWithHiddenRows = YES;
    [self cells:self.proSectionCells setHidden:YES];
    [self cells:self.privacySettingsCells setHidden:YES];
    
    [self cell:self.managePrivacySettingsVideoCell setHidden:YES];
    
    self.getProButton.enabled = YES;
    self.getProButton.title = @"Get PRO";
    
    
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

    CGSize starsSize = CGSizeMake(self.view.frame.size.width, self.headerView.frame.size.height);
    self.starsLayer = [[AEUIStarsLayer alloc] initWithSize:starsSize];
    [self.headerView.layer addSublayer:self.starsLayer];
    

    [AEUIUtils addTitleViewToNavigationItem:self.navigationItem];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    
    [self setupSwipeCell:self.manageContentBlockerVideoCell swipeCellDefaultsKey:AEDefaultsHideVideoTutorial];
    [self setupSwipeCell:self.managePrivacySettingsVideoCell swipeCellDefaultsKey:AEDefaultsHideSafariVideoTutorial];
    
    [self swipeCells];
    
    [AESharedResources.sharedDefaults addObserver:self forKeyPath:AEDefaultsTotalRequestsCount options:NSKeyValueObservingOptionNew context:nil];
    
    [AESharedResources.sharedDefaults addObserver:self forKeyPath:AEDefaultsTotalRequestsTime options:NSKeyValueObservingOptionNew context:nil];
    
    [AESharedResources.sharedDefaults addObserver:self forKeyPath:AEDefaultsTotalTrackersCount options:NSKeyValueObservingOptionNew context:nil];

    
    [AESharedResources.sharedDefaults addObserver:self forKeyPath:AEDefaultsInvertedWhitelist options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    // https://github.com/AdguardTeam/AdguardForiOS/issues/731
    // on ios 9 ipad cell the background color defined in the storyboard is ignored
    if (![[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 10, .minorVersion = 0, .patchVersion = 0}]) {
        UITableViewCell.appearance.backgroundColor = CELL_BACKGROUND_COLOR;
        self.manageContentBlockerVideoCell.backgroundColor = self.managePrivacySettingsVideoCell.backgroundColor = UIColor.clearColor;
    }
}

- (void) swipeCells {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.manageContentBlockerVideoCell.contentView.frame;
        frame.origin.x += 70;
        self.manageContentBlockerVideoCell.contentView.frame = frame;

        frame = self.managePrivacySettingsVideoCell.contentView.frame;
        frame.origin.x += 70;
        self.managePrivacySettingsVideoCell.contentView.frame = frame;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [AESharedResources.sharedDefaults removeObserver:self forKeyPath:AEDefaultsInvertedWhitelist];
    
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

- (IBAction)clickViewOnGitHub:(id)sender {

    [self openUrl: [NSURL URLWithString:VIEW_ON_GITHUB]];
}

- (IBAction)clickCheckForUpdates:(id)sender {
    if (!_inCheckUpdates) {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] invalidateAntibanner:YES interactive:YES];
    }
}

- (IBAction)clickRateThisApp:(id)sender {
    NSURL *theURL =
    [NSURL URLWithString:[NSString stringWithFormat:RATE_APP_URL_FORMAT,
                          ITUNES_APP_ID]];
    [self openUrl:theURL];
}

- (IBAction)clickShare:(id)sender {
    
    NSString *message = [NSString stringWithFormat:@"%@\n%@\n",
                                          NSLocalizedString(@"share_mail_body_text", @"(AEUIMainController) Share this app initial text on Mail Body (text row)"),
                                          NSLocalizedString(@"share_mail_body_subtext", @"(AEUIMainController) Share this app initial text on Mail Body (before link row)")];
    message = [message stringByAppendingFormat:SHARE_APP_URL_STRING];
    
    NSArray *items = @[message, [UIImage imageNamed:@"share-logo"]];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    controller.modalPresentationStyle = UIModalPresentationPopover;
    controller.excludedActivityTypes = @[UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.sourceView = self.shareCell;
    popController.sourceRect = self.shareCell.bounds;
}

- (IBAction)clickSendBugReport:(id)sender {
    
    [self showReportActionSheet];
}

- (IBAction)clickGetPro:(id)sender {
    NSURL *theURL =
    [NSURL URLWithString:GET_PRO_URL];
    [self openUrl:theURL];
}

#ifdef PRO
- (IBAction)toggleStatus:(id)sender {
    
    BOOL enabled = [(UISwitch *)sender isOn];
    [[APVPNManager singleton] setEnabled:enabled];
    DDLogInfo(@"(AEUIMainController) PRO status set to:%@", (enabled ? @"YES" : @"NO"));
}
#endif

- (IBAction)clickOtherApps:(id)sender {
    
    [self openUrl:[NSURL URLWithString:OTHER_APPS_URL]];
}


#pragma mark public methods

- (void)addRuleToUserFilter:(NSString *)ruleText{

    if ([NSString isNullOrEmpty:ruleText]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        _ruleTextHolderForAddRuleCommand = ruleText;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self performSegueWithIdentifier:TO_USER_FILTER_SEGUE_ID sender:self];
        _ruleTextHolderForAddRuleCommand = nil;
    });
}

- (void)checkContentBlockerStatus {
    
    ASSIGN_WEAK(self);
    
    [AEService.singleton checkStatusWithCallback:^(BOOL enabled) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ASSIGN_STRONG(self);
            
            if(_contentBlockerEnabled != enabled) {
                
                _contentBlockerEnabled = enabled;
                
                [USE_STRONG(self).starsLayer removeFromSuperlayer];
                
                UIView* headerView = USE_STRONG(self).tableView.tableHeaderView;
                CGSize starsSize = CGSizeMake(USE_STRONG(self).view.frame.size.width, headerView.frame.size.height);
                USE_STRONG(self).starsLayer = [[AEUIStarsLayer alloc] initWithSize:starsSize];
                
                USE_STRONG(self).starsLayer.fast = enabled;
                
                [headerView.layer addSublayer:USE_STRONG(self).starsLayer];
            }
            
            self.disabledLabel.hidden = enabled;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RATE_ME_TIME_AFTER_START * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showRateMeIfNeeded];
            });
        });
    }];
}

#ifdef PRO

- (void)setProStatus:(BOOL)enabled {
    
    DDLogInfo(@"(AEUIMainController) PRO status set to:%@", (enabled ? @"YES" : @"NO"));
    [[APVPNManager singleton] setEnabled:enabled];
    self.proStatusSwitch.on = enabled;
}

#endif

#pragma mark Navigation

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self checkContentBlockerStatus];
    
    [self setToolbar];
    
#ifdef PRO
    [self proUpdateStatuses];
#endif

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.toolbarHidden = YES;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:TO_USER_FILTER_SEGUE_ID]){

        [AEUIRulesController createUserFilterControllerWithSegue:segue ruleTextHolderForAddRuleCommand:_ruleTextHolderForAddRuleCommand];
    }
    else if ([segue.identifier isEqualToString:TO_WHITELIST_SEGUE_ID]){
        
        [AEUIWhitelistController createWhitelistControllerWithSegue:segue];
        
        UIViewController* destination = [segue destinationViewController];
        destination.navigationItem.title = self.whitelistLabel.text;
    }
    else if ([segue.identifier isEqualToString:TO_SAFARI_VIDEO_SEGUE_ID]) {
        AEUIPlayerViewController* destination = [segue destinationViewController];
        destination.completionBlock = ^{
            [self.managePrivacySettingsVideoCell showSwipe:MGSwipeDirectionRightToLeft animated:YES];
        };
    }
    else if ([segue.identifier isEqualToString:TO_SETTINGS_VIDEO_SEGUE_ID]) {
        AEUIPlayerViewController* destination = [segue destinationViewController];
        destination.completionBlock = ^{
            [self.manageContentBlockerVideoCell showSwipe:MGSwipeDirectionRightToLeft animated:YES];
        };
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
- (void)refreshCheckDate {
    NSDate *checkDate = [[AESharedResources sharedDefaults] objectForKey:AEDefaultsCheckFiltersLastDate];
    if (checkDate) {
        
        BOOL today = [[NSCalendar currentCalendar] isDateInToday:checkDate];
        
        self.lastUpdated.text = [NSDateFormatter localizedStringFromDate:checkDate dateStyle: today ? NSDateFormatterNoStyle : NSDateFormatterShortStyle timeStyle: today ? NSDateFormatterShortStyle : NSDateFormatterNoStyle];
        // tunning accessibility
        self.lastUpdated.accessibilityLabel = [NSDateFormatter localizedStringFromDate:checkDate dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterShortStyle];
        //------------
    }
}

/////////////////////////////////////////////////////////////////////

- (void)refreshDynamicObjects:(NSNotification *)notification {

    [self refreshCheckDate];

    [self reloadDataAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
#ifdef PRO
    if([keyPath isEqualToString: AEDefaultsTotalRequestsCount]) {
        
        [self updateTotalRequests];
    }
    
    if([keyPath isEqualToString: AEDefaultsTotalRequestsTime]) {
        
        [self updateRequestTime];
    }
    
    if([keyPath isEqualToString: AEDefaultsTotalTrackersCount]) {
        
        [self updateTrackers];
    }
#endif
    
    if([keyPath isEqualToString:AEDefaultsInvertedWhitelist]) {
        
        id value = change[NSKeyValueChangeNewKey];
        
        BOOL inverted = NO;
        
        if([value isKindOfClass:NSNumber.class]) {
            inverted = [value boolValue];
        }
        
        self.whitelistLabel.text = inverted ? NSLocalizedString(@"inverted_whitelist_title", @"Main Controller. Inverted whitelist cell caption") : NSLocalizedString(@"whitelist_title", @"Main Controller. Whitelist cell caption");
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Table Delegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

#ifdef PRO
    if (section == PRO_SECTION_INDEX) {
        
        return [self proSectionFooter];
    }
#endif
    
    return [super tableView:tableView viewForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
#ifdef PRO
    if (section == PRO_SECTION_INDEX) {
        
        APUIProSectionFooter *footer = [self proSectionFooter];
        return [footer heightForWidth:self.view.frame.size.width];
    }
#endif
    
    return [super tableView:tableView heightForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == VIDEO_SECTION_INDEX) {
        
        UIImage *image = [UIImage imageNamed:@"video-image"];
        CGFloat desiredHeight = [UIScreen mainScreen].bounds.size.width * image.size.height / image.size.width;
        
        return MIN(desiredHeight, VIDEO_IMAGE_MAX_HEIGHT);
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
/////////////////////////////////////////////////////////////////////

- (void)showWelcomeScreen{

    UIPageViewController *pager = (UIPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"welcomePager"];
    if (pager) {
        
        [self.navigationController pushViewController:pager animated:YES];
    }
}

- (void)prepareCheckUpdatesButton {

    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.hidesWhenStopped = YES;
    activity.hidden = YES;
    activity.color = self.checkFiltersCell.detailTextLabel.textColor;

    self.checkFiltersCell.accessoryView = activity;
    
    // tunning accessibility
    UIAccessibilityTraits checkFiltersCellTraits = self.checkFiltersCell.accessibilityTraits;
    self.checkFiltersCell.accessibilityTraits = checkFiltersCellTraits | UIAccessibilityTraitButton;
    //-----------------
    
    _inCheckUpdates = NO;

    _observers = [NSMutableArray arrayWithCapacity:3];
    
    // When update started
    id observer = [[NSNotificationCenter defaultCenter]
        addObserverForName:AppDelegateStartedUpdateNotification
                    object:nil
                     queue:nil
                usingBlock:^(NSNotification *_Nonnull note) {

                      self.checkFiltersCell.textLabel.enabled = NO;
                        // tunning accessibility
                      self.checkFiltersCell.accessibilityTraits = checkFiltersCellTraits;
                        //------------
                      UIActivityIndicatorView *activity =
                          (UIActivityIndicatorView *)
                              self.checkFiltersCell.accessoryView;
                      activity.hidden = NO;
                      [activity startAnimating];
                    
                      self.lastUpdated.hidden = YES;
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
                        
                        self.lastUpdated.hidden = NO;
                        
                        // setting text of result on "Check Filter Updates"
                        NSArray *updatedMetas =
                          [note userInfo][AppDelegateUpdatedFiltersKey];
                        if (updatedMetas.count) {

                          NSString *format =
                              NSLocalizedString(@"filters_updated_%lu",
                                                @"(AEUIMainController) Button "
                                                @"- Check Filter Updates");
                          self.checkFiltersCell.textLabel.text = [NSString
                              stringWithFormat:format, updatedMetas.count];
                        } else {

                          self.checkFiltersCell.textLabel.text =
                              NSLocalizedString(@"filters_noUpdates",
                                                @"(AEUIMainController) Button "
                                                @"- Check Filter Updates");
                        }

                        [self refreshCheckDate];
                        
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

                    self.lastUpdated.hidden = NO;
                    
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
    // tunning accessibility
    self.checkFiltersCell.accessibilityTraits = self.checkFiltersCell.accessibilityTraits | UIAccessibilityTraitButton;
    //--------
    _inCheckUpdates = NO;
}

- (void) showReportActionSheet {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"common_action_cancel", @"(AEUIMainController) - report an issue actionsheet -> Cancel button caption") style:UIAlertActionStyleCancel handler:nil]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"incorrect_blocking_report", @"(AEUIMainController) - report an issue actionsheet button caption") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSURL* reportUrl = [[AESSupport singleton] composeWebReportUrlForSite:nil];
        [self openUrl:reportUrl];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"action_bug_report", @"(AEUIMainController) - report an issue actionsheet button caption") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self openUrl:[NSURL URLWithString: BUGREPORT_URL]];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"action_contact_support", @"(AEUIMainController) - report an issue actionsheet button caption") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[AESSupport singleton] sendMailBugReportWithParentController:self];
    }]];
    
    UIPopoverPresentationController *popController = [actionSheet popoverPresentationController];
    popController.sourceView = self.bugReportCell;
    popController.sourceRect = self.bugReportCell.bounds;
    
    [self presentViewController:actionSheet animated:YES completion:^{
    }];
}

- (void)setToolbar{
    
    static UILabel *warning;
    
    self.navigationController.toolbar.barTintColor = [UIColor blackColor];
    self.navigationController.toolbarHidden = YES;
    
    NSString *warningText;
    
    //Show warning if overlimit of rules was reached.
    if ([[AESharedResources sharedDefaults] boolForKey:AEDefaultsJSONRulesOverlimitReached]) {
        
        NSUInteger limit = [[[AESharedResources sharedDefaults] objectForKey:AEDefaultsJSONMaximumConvertedRules] unsignedIntegerValue];
        NSUInteger totalRulesCount = [[[AESharedResources sharedDefaults] objectForKey:AEDefaultsJSONRulesForConvertion] unsignedIntegerValue];
        
        warningText = [NSString stringWithFormat:NSLocalizedString(@"safari_rules_enabled", @"(AEUIMainController) Warning text on main screen"), limit, totalRulesCount];
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

- (void) openUrl:(NSURL*)url {
    
    if ([UIApplication.sharedApplication respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
    } else {
        [UIApplication.sharedApplication openURL:url];
    }
}

- (void) showRateMeIfNeeded {
    
    // check first launch day
    NSDate* firstLaunchDate = [AESharedResources.sharedDefaults objectForKey:AEDefaultsFirstLaunchDate];
    if(!firstLaunchDate) {
        [AESharedResources.sharedDefaults setObject:[NSDate date] forKey:AEDefaultsFirstLaunchDate];
        return;
    }
    
    if([firstLaunchDate timeIntervalSinceNow] > - MIN_TIME_INTERVAL_TO_RATE_ME) {
        return;
    }
    
    // check safari content blocker is active
    if(!_contentBlockerEnabled) {
        return;
    }
    
    // check user used safari action extension
    if(![AESharedResources.sharedDefaults boolForKey:AEDefaultsActionExtensionUsed]) {
        return;
    }
    
    [SKStoreReviewController requestReview];
    
    // reset firstLaunchDate
    [AESharedResources.sharedDefaults removeObjectForKey:AEDefaultsFirstLaunchDate];
}

/////////////////////////////////////////////////////////////////////
#pragma mark  PRO Helper Methods (Private)

#ifdef PRO

- (APUIProSectionFooter *)proSectionFooter{
    
    if (_proFooter) {
        return _proFooter;
    }
    
    _proFooter = [[APUIProSectionFooter alloc] initWithFrame:self.view.bounds];
    _proFooter.text = [self proTextForProSectionFooter];
    
    return _proFooter;
}

- (NSString *)proShortStatusDescription {
    
    return NSLocalizedString(@"privacy_module_description", @"(APUIAdguardDNSController) PRO version. On the main screen. It is the description under PRIVACY module switch.");
}

- (NSAttributedString *)proTextForProSectionFooter{
    
    NSString *message = [self proShortStatusDescription];
    
    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:message];
    
    return textString;
}

- (void)proUpdateStatuses{
    
    
    APVPNManager *manager = [APVPNManager singleton];
    
    if(manager.enabled)
        self.proDnsSettingsCell.detailTextLabel.text = manager.activeRemoteDnsServer.serverName;
    else
        self.proDnsSettingsCell.detailTextLabel.text = NSLocalizedString(@"common_switch_off", @"AEUIMainController on main screen. DNS Settings detail text, when pro mode is off");
    
    if (manager.lastError) {
        [ACSSystemUtils
         showSimpleAlertForController:self
         withTitle:NSLocalizedString(@"common_error_title",
                                     @"(APUIAdguardDNSCon"
                                     @"troller) PRO "
                                     @"version. Alert "
                                     @"title. On error.")
         message:manager.lastError.localizedDescription];
    }
    
    self.proStatusSwitch.on = manager.enabled;

    [self reloadDataAnimated:YES];
}

- (void)proAttachToNotifications{
    
    id observer = [[NSNotificationCenter defaultCenter]
                 addObserverForName:APVpnChangedNotification
                 object: nil
                 queue:nil
                 usingBlock:^(NSNotification *_Nonnull note) {
                     
                     // When configuration is changed
                     
                     [self proUpdateStatuses];
                 }];
    
    if (observer) {
        [_observers addObject:observer];
    }
}

- (void) updateCounters {
    
    [self updateTotalRequests];
    [self updateTrackers];
    [self updateRequestTime];
}

- (void) updateTotalRequests {
    
    int count = ((NSNumber*)[AESharedResources.sharedDefaults valueForKey:AEDefaultsTotalRequestsCount]).intValue;
    self.totalRequestsCountLabel.text = [NSString stringWithFormat:@"%d", count];
}

- (void) updateRequestTime {
    
    int count = ((NSNumber*)[AESharedResources.sharedDefaults valueForKey:AEDefaultsTotalRequestsCount]).intValue;
    float time = ((NSNumber*)[AESharedResources.sharedDefaults valueForKey:AEDefaultsTotalRequestsTime]).floatValue;
    float averageTime = count ? time * 1000 / count : 0;
    NSString* format = NSLocalizedString(@"average_time_format", @"(AEUIMainController) Main Screen -> average time format. Do not translate '%.f' part");
    self.avarageTimeLabel.text = [NSString stringWithFormat:format, averageTime];
}

- (void) updateTrackers {
    
    int count = ((NSNumber*)[AESharedResources.sharedDefaults valueForKey:AEDefaultsTotalTrackersCount]).intValue;
    self.trackersCountLabel.text = [NSString stringWithFormat:@"%d", count];
}

#endif

@end
