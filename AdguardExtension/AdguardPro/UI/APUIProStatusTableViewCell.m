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

#import "APUIProStatusTableViewCell.h"

@implementation APUIProStatusTableViewCell {
    
    UISwitch *_statusSwitch;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _statusSwitch = self.accessoryView.subviews[0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (BOOL)isAccessibilityElement {
    
    return YES;
}

- (NSString *)accessibilityValue {
    
    return _statusSwitch.accessibilityValue;
}

- (NSString *)accessibilityLabel {
    
    NSString *label = [super accessibilityLabel];
    
    return label;
}
- (UIAccessibilityTraits)accessibilityTraits {
    
    UIAccessibilityTraits traits = [super accessibilityTraits];
    traits &= ~UIAccessibilityTraitSelected;
    
    traits |= _statusSwitch.accessibilityTraits;
    return traits;
}

- (BOOL)accessibilityActivate {
    
    if (_statusSwitch.enabled) {
        _statusSwitch.on = ! _statusSwitch.on;
        [_statusSwitch sendActionsForControlEvents:UIControlEventValueChanged];
        return YES;
    }
    
    return NO;
}


@end
