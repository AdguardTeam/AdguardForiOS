/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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

#import "AEUIRightDetailTableViewCell.h"

@implementation AEUIRightDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if(self.detailTextLabel.text.length) {
        [self.detailTextLabel sizeToFit];
        
        CGFloat rightMargin = 16;
        CGRect frame = self.detailTextLabel.frame;
        frame.origin.x = self.frame.size.width - frame.size.width - rightMargin;
        
        self.detailTextLabel.frame = frame;
        
        CGRect textFrame = self.textLabel.frame;
        textFrame.size.width = self.detailTextLabel.frame.origin.x - rightMargin - textFrame.origin.x;
        self.textLabel.frame = textFrame;
    }
}

@end
