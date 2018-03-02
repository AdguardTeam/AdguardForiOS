/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2016 Performix LLC. All rights reserved.
 
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

#import "APUIProSectionFooter.h"
#import "AEUICommons.h"

@implementation APUIProSectionFooter{
    
    UITextView *_textView;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _textView = [UITextView new];
        _textView.isAccessibilityElement = NO;
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.layoutMargins = _textView.textContainerInset = _textView.contentInset = UIEdgeInsetsZero;
        _textView.layoutManager.usesFontLeading = NO;
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.preservesSuperviewLayoutMargins = self.preservesSuperviewLayoutMargins = NO;
        _textView.delegate = self;
        
        self.layoutMargins = UIEdgeInsetsMake(7, 15, 7, 15);
        
        [self.contentView addSubview:_textView];
        
//        UILayoutGuide *margin = self.layoutMarginsGuide;
        id _v = self.layoutMarginsGuide;
        [_textView.leadingAnchor constraintEqualToAnchor:[_v leadingAnchor]].active = YES;
        [_textView.topAnchor constraintEqualToAnchor:[_v topAnchor]].active = YES;
        [_textView.trailingAnchor constraintEqualToAnchor:[_v trailingAnchor]].active = YES;
        [_textView.bottomAnchor constraintEqualToAnchor:[_v bottomAnchor]].active = YES;
        
    }
    
    return self;
}

- (CGFloat)heightForWidth:(CGFloat)width{
    @synchronized (self) {
        CGSize size = CGSizeZero;
        size.width = width - self.layoutMargins.left - self.layoutMargins.right;
        size = [_textView sizeThatFits:CGSizeMake(size.width, CGFLOAT_MAX)];
        return size.height + self.layoutMargins.top + self.layoutMargins.bottom;
    }
}

- (NSAttributedString *)text{

    @synchronized (self) {
        return _textView.attributedText;
    }
}
- (void)setText:(NSAttributedString *)text{
    
    @synchronized (self) {
        
//        CGFloat fontSize = [UIFont buttonFontSize];
        UIFont *font = [UIFont systemFontOfSize:13];
        UIColor *color = SUBTITLE_TEXT_COLOR;

//        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//        style.alignment = NSTextAlignmentJustified;
        
        NSMutableAttributedString *textString = [text mutableCopy];
        [textString addAttributes:@{
                                    NSForegroundColorAttributeName: color,
                                    NSFontAttributeName: font
                                    } range:NSMakeRange(0, textString.length)];
        
        //we convert arrtibuted string through NSTextStorage
        //for preventing of error of the calculating of size.
        _textView.attributedText = [[NSTextStorage alloc] initWithAttributedString:textString];
    }
}

- (BOOL)isAccessibilityElement {
    return NO;
}

- (NSString *)accessibilityLabel {
    
    return _textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    if(self.urlClickBlock && self.urlClickBlock(URL)) {
        return NO;
    }
    
    return YES;
}

@end
