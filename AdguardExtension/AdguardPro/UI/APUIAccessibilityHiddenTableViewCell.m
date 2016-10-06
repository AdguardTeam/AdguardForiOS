//
//  APUIAccessibilityHiddenTableViewCell.m
//  Adguard
//
//  Created by Roman Sokolov on 06.10.16.
//  Copyright © 2016 Performiks. All rights reserved.
//

#import "APUIAccessibilityHiddenTableViewCell.h"

@implementation APUIAccessibilityHiddenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textLabel.isAccessibilityElement = NO;
    self.detailTextLabel.isAccessibilityElement = NO;
    self.accessoryView.isAccessibilityElement = NO;
    
    self.textLabel.accessibilityLabel = @"";
    self.detailTextLabel.accessibilityLabel = @"";
    self.accessoryView.accessibilityLabel = @"";
    
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
