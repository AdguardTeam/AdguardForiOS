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

#import "AEUIAccessibilityHiddenTableViewCell.h"

@implementation AEUIAccessibilityHiddenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textLabel.isAccessibilityElement = NO;
    self.detailTextLabel.isAccessibilityElement = NO;
    self.accessoryView.isAccessibilityElement = NO;
    
    self.textLabel.accessibilityTraits = UIAccessibilityTraitNotEnabled;
    self.detailTextLabel.accessibilityTraits = UIAccessibilityTraitNotEnabled;
    self.accessoryView.accessibilityTraits = UIAccessibilityTraitNotEnabled;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)isAccessibilityElement {
    return NO;
}

- (UIAccessibilityTraits)accessibilityTraits {
    
    UIAccessibilityTraits traits = UIAccessibilityTraitNone | UIAccessibilityTraitNotEnabled;
    return traits;
}

- (NSString *)accessibilityLabel {
    return [NSString string];
}

- (NSString *)accessibilityValue {
    
    return [NSString string];
}

@end
