//
//  APUIDnsStatusTableViewCell.m
//  Adguard
//
//  Created by Roman Sokolov on 06.10.16.
//  Copyright © 2016 Performiks. All rights reserved.
//

#import "APUIDnsStatusTableViewCell.h"

@implementation APUIDnsStatusTableViewCell {
    
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
    
    return [NSString string];
}

- (NSString *)accessibilityLabel {
    
    NSString *label = [super accessibilityLabel];
    
    return label;
}
- (UIAccessibilityTraits)accessibilityTraits {
    
    UIAccessibilityTraits traits = [super accessibilityTraits];
    traits &= ~UIAccessibilityTraitSelected;
//    traits |= UIAccessibilityTraitButton;
    
    traits |= _statusSwitch.accessibilityTraits;
    return traits;
}

- (BOOL)accessibilityActivate {
    
    if (_statusSwitch.enabled) {
        _statusSwitch.on = ! _statusSwitch.on;
        [_statusSwitch sendActionsForControlEvents:UIControlEventValueChanged];
//        return YES;
    }
    
    return NO;
}


@end
