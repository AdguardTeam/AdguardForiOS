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
#import "AEUISubscriptionTableViewCell.h"
#import "ACommons/ACLang.h"

#define CHECKMARK_EDIT_DISABLE      @"table-circle"
#define CHECKMARK_EDIT_ENABLE       @"table-circle-checkmark"
#define CHECKMARK_NORMAL_DISABLE    @"table-empty"
#define CHECKMARK_NORMAL_ENABLE     @"table-checkmark"

#define ANIMATION_DELAY              0.2f

@implementation AEUISubscriptionTableViewCell{
    
    BOOL _on;
}

- (void)awakeFromNib {
    // Initialization code
    
    _on = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOn:(BOOL)on{
    
    if (_on != on) {
        
        _on = on;
        
        [self setImageAnimated:NO];
    }
}

- (BOOL)on{

    return _on;
}

- (void)setImageAnimated:(BOOL)animated{
    
    
        NSString *imageName = (_on ? (self.editing ? CHECKMARK_EDIT_ENABLE : CHECKMARK_NORMAL_ENABLE) : (self.editing ?  CHECKMARK_EDIT_DISABLE : CHECKMARK_NORMAL_DISABLE));
        
        UIImage * toImage = [UIImage imageNamed:imageName];
        
        if (animated) {
            [UIView transitionWithView:self.imageView
                              duration:ANIMATION_DELAY
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.imageView.image = toImage;
                            } completion:nil];
        }
        else{
            
            self.imageView.image = toImage;
        }
}


- (void)didTransitionToState:(UITableViewCellStateMask)state{
    
    [self setImageAnimated:YES];
    
    [super didTransitionToState:state];
}
@end
