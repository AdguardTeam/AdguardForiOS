//
//  AEUILabelWithCopy.m
//  Adguard
//
//  Created by Roman Sokolov on 18.08.16.
//  Copyright © 2016 Performiks. All rights reserved.
//

#import "AEUILabelWithCopy.h"

@implementation AEUILabelWithCopy

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    return (action == @selector(copy:));
}

- (void)copy:(id)sender {

    [[UIPasteboard generalPasteboard] setString: self.text];
}

@end
