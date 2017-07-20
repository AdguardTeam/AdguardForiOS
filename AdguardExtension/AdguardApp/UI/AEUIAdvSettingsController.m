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
#import "AEUIAdvSettingsController.h"
#import "ACommons/ACLang.h"
#import "AESharedResources.h"
#import "AEUIUtils.h"

#ifdef PRO
#import "APVPNManager.h"
#endif

#define TUNNEL_MODE_FOOTER_CELL_ID @"LinkTableViewHeaderFooterView"

@interface AEUILinkTableViewHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic) UITextView *textView;

@end

@implementation AEUILinkTableViewHeaderFooterView

- (void) setupTextView {
    self.textView = [UITextView new];
    self.textView.editable = NO;
    self.textView.scrollEnabled = NO;
    self.textView.textContainerInset = UIEdgeInsetsMake(0.0, -5.0, -5.0, -5.0);
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.accessibilityTraits = UIAccessibilityTraitStaticText;
    [self addSubview:self.textView];
}

- (instancetype)init {
    if(self = [super init]) {
        [self setupTextView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self setupTextView];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupTextView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = self.textLabel.frame;
}

@end

@interface AEUIAdvSettingsController ()

@property (nonatomic) NSAttributedString* tunnelModeFooterAttributedString;
@property (nonatomic) NSString* htmlString;

@end

@implementation AEUIAdvSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.simplifiedButton.on = [[AESharedResources sharedDefaults] boolForKey:AEDefaultsJSONConverterOptimize];
    self.wifiButton.on = [[AESharedResources sharedDefaults] boolForKey:AEDefaultsWifiOnlyUpdates];
    
    [self.tableView registerClass:[AEUILinkTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:TUNNEL_MODE_FOOTER_CELL_ID];
    
#ifdef PRO
    self.htmlString = NSLocalizedString(@"Adguard Pro works in two different modes. In the Split-Tunnel mode Adguard is compatible with so-called \"Personal VPN\" apps (full list: <a href=\"https://github.com/AdguardTeam/AdguardForiOS/issues/162\">https://github.com/AdguardTeam/AdguardForiOS/issues/162</a>). As a trade-off, in this mode Adguard may be bypassed by system in case of bad connectivity. On the contrary, in the Full-Tunnel mode Adguard can't be run along any other VPN apps, but also can't be bypassed regardless of the connection quality.", @"Advanced settings - tunnel mode description");
    
    // convert html string to attributed string
    NSData *data = [self.htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary* options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    self.tunnelModeFooterAttributedString = [[NSAttributedString alloc] initWithData:data
                                                                             options:options
                                                                  documentAttributes:nil error:&error];
    
    
    [self setTunnelModeUI:[APVPNManager.singleton tunnelMode]];
    
#else
    self.hideSectionsWithHiddenRows = YES;
    [self cell:self.splitTunnelCell setHidden:YES];
    [self cell:self.fullTunnelCell setHidden:YES];
    
    [self reloadDataAnimated:YES];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section {

    // tunning accessibility
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    
    footer.isAccessibilityElement = NO;
    footer.textLabel.isAccessibilityElement = NO;
    footer.detailTextLabel.isAccessibilityElement = NO;
    
    if (section == 0) {
        self.autoUpdateCell.accessibilityHint = footer.textLabel.text;
    }
    else if (section == 1) {
        
        self.useSimplifiedCell.accessibilityHint = footer.textLabel.text;
    }
    else if (section == 2) {
        
#ifdef PRO
        AEUILinkTableViewHeaderFooterView* footer = (AEUILinkTableViewHeaderFooterView*)view;
        
        UIFont *fontAttribute = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        NSString *textColorAttribute = [footer.textLabel.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        NSDictionary *attributes = @{NSFontAttributeName : fontAttribute, NSForegroundColorAttributeName : textColorAttribute};
        NSMutableAttributedString *mutableAttributedText = [self.tunnelModeFooterAttributedString mutableCopy];
        [mutableAttributedText addAttributes:attributes range:NSMakeRange(0, mutableAttributedText.length)];
        footer.textView.attributedText = mutableAttributedText;
        footer.textView.tintColor = tableView.tintColor;
        footer.textLabel.attributedText = mutableAttributedText;
        footer.textLabel.hidden = YES;
        footer.textView.isAccessibilityElement = NO;
        
        self.fullTunnelCell.accessibilityHint = self.splitTunnelCell.accessibilityHint = self.tunnelModeFooterAttributedString.string;
#endif
    }
}

#ifdef PRO

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 2) {
        APVpnManagerTunnelMode selectedMode =
            indexPath.row == 0 ? APVpnManagerTunnelModeSplit : APVpnManagerTunnelModeFull;
        
        [self setTunnelModeUI:selectedMode];
        [APVPNManager.singleton setTunnelMode:selectedMode];
    }
}

#endif

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if(section == 2) {
        return self.htmlString;
    }
    
    return [super tableView:tableView titleForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(section == 2) {
        return [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:TUNNEL_MODE_FOOTER_CELL_ID];
    }
    
    return [super tableView:tableView viewForFooterInSection:section];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Actions
/////////////////////////////////////////////////////////////////////

- (IBAction)toggleSimplified:(id)sender {

    BOOL oldValue = [[AESharedResources sharedDefaults] boolForKey:AEDefaultsJSONConverterOptimize];
    BOOL newValue = [sender isOn];
    
    if (oldValue != newValue) {
        
        [AESharedResources sharedDefaultsSetTempKey:AEDefaultsJSONConverterOptimize value:@(newValue)];
        [AEUIUtils invalidateJsonWithController:self completionBlock:^{
           
            [[AESharedResources sharedDefaults] setBool:newValue forKey:AEDefaultsJSONConverterOptimize];
            [AESharedResources sharedDefaultsRemoveTempKey:AEDefaultsJSONConverterOptimize];
            
        } rollbackBlock:^{
            
            [AESharedResources sharedDefaultsRemoveTempKey:AEDefaultsJSONConverterOptimize];
            [sender setOn:oldValue animated:YES];
        }];
    }
}

- (IBAction)toggleWifiOnly:(id)sender {
    
    [[AESharedResources sharedDefaults] setBool:[sender isOn] forKey:AEDefaultsWifiOnlyUpdates];
}



/////////////////////////////////////////////////////////////////////
#pragma mark helper methods
/////////////////////////////////////////////////////////////////////

#ifdef PRO
- (void)setTunnelModeUI:(APVpnManagerTunnelMode)tunnelMode {
    _fullTunnelCell.imageView.image = _splitTunnelCell.imageView.image = [UIImage imageNamed:@"table-empty"];
    
    _splitTunnelCell.accessibilityTraits &= ~UIAccessibilityTraitSelected;
    _fullTunnelCell.accessibilityTraits &= ~UIAccessibilityTraitSelected;
    
    switch (tunnelMode) {
        case APVpnManagerTunnelModeFull:
            _fullTunnelCell.imageView.image = [UIImage imageNamed:@"table-checkmark"];
            _fullTunnelCell.accessibilityTraits |= UIAccessibilityTraitSelected;
            break;
            
        case APVpnManagerTunnelModeSplit:
            _splitTunnelCell.imageView.image = [UIImage imageNamed:@"table-checkmark"];
            _splitTunnelCell.accessibilityTraits |= UIAccessibilityTraitSelected;
            break;
            
        default:
            break;
    }
}

#endif

@end
