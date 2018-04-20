//##implementation

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

#import <UIKit/UIKit.h>
#import "AEUIStarsLayer.h"


/**
 UIColor category for bleng colors
 */
@implementation UIColor(blend)
- (UIColor*) blendedColorWithFraction: (CGFloat) fraction ofColor:(UIColor*) color{
    
    CGFloat r1 = 1.0;
    CGFloat g1 = 1.0;
    CGFloat b1 = 1.0;
    CGFloat a1 = 1.0;
    
    CGFloat r2 = 1.0;
    CGFloat g2 = 1.0;
    CGFloat b2 = 1.0;
    CGFloat a2 = 1.0;
    
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    return [UIColor colorWithRed:r1 * (1 - fraction) + r2 * fraction
                           green:g1 * (1 - fraction) + g2 * fraction
                            blue:b1 * (1 - fraction) + b2 * fraction
                           alpha:a1 * (1 - fraction) + a2 * fraction];
    
    
}

@end

@implementation AEUIStarsLayer

#pragma mark init

-(instancetype)initWithSize:(CGSize)size {
    
    self = [super init];
    self.position = CGPointMake(
                                       -size.width * 2, 0);
    self.emitterSize = CGSizeMake(0, size.height * 2);
    self.emitterShape=kCAEmitterLayerRectangle;
    self.velocity = 10;
    
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.lifetime = 1000;
    cell.velocity = 400;
    cell.velocityRange = 30;
    cell.scale = 0.3;
    cell.scaleRange = 0.5;
    
    cell.emissionRange = 0;
    cell.contents = (id)[self cometImageWithWidth:size.width * 2];
    
    CAEmitterCell *cell2 = [CAEmitterCell emitterCell];
    cell2.lifetime = 1000;
    cell2.velocity = 400;
    cell2.velocityRange = 30;
    cell2.scale = 0.7;
    cell2.scaleRange = 1.0;
    
    cell2.emissionRange = 0;
    cell2.contents = (id)[self cometImageWithWidth:size.width * 2];
    
    self.emitterCells = @[cell, cell2];
    
    self.fast = NO;
    
    return self;
}

#pragma mark privatemethods

- (CGImageRef) cometImageWithWidth:(CGFloat) width {
    
    UIGraphicsBeginImageContext(CGSizeMake(width, 30));
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Gradient Declarations
    CGFloat gradientLocations[] = {0, 0.49, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(NULL,
        (__bridge CFArrayRef)@[(id)UIColor.clearColor.CGColor,
                               (id)[UIColor.clearColor blendedColorWithFraction: 0.3 ofColor: UIColor.whiteColor].CGColor,
                               (id)[UIColor.clearColor blendedColorWithFraction: 0.8 ofColor: UIColor.whiteColor].CGColor],
        gradientLocations);
    
    CGFloat gradient2Locations[] = {0, 1};
    CGGradientRef gradient2 = CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)@[(id)UIColor.whiteColor.CGColor, (id)UIColor.clearColor.CGColor], gradient2Locations);
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = UIColor.whiteColor;
    shadow.shadowOffset = CGSizeMake(0, 0);
    shadow.shadowBlurRadius = 12;
    
    if(self.fast) {
        
        //// Draw tail
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 14, 1524, 4)];
        CGContextSaveGState(context);
        [rectanglePath addClip];
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 16), CGPointMake(width - 15, 16), kNilOptions);
        CGContextRestoreGState(context);
    }
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(width - 30, 1, 30, 30)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
    CGContextBeginTransparencyLayer(context, NULL);
    [ovalPath addClip];
    CGContextDrawRadialGradient(context, gradient2,
                                CGPointMake(width - 15, 16), 3,
                                CGPointMake(width - 15, 16), 6,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGGradientRelease(gradient2);
    
    
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    return cgImage;
}

- (void)setFast:(BOOL)fast {
    
//    if(_fast == fast)
//        return;
    
    _fast = fast;
    
    CAEmitterCell *cell = self.emitterCells.firstObject;
    CAEmitterCell *cell2 = self.emitterCells[1];
    
    if(fast) {
        
        self.velocity = 3.0;

        cell.contents = (id)[self cometImageWithWidth:1000];
        cell.birthRate = 5;
        cell.lifetime = 30;
        cell.velocity = 40;
        
        cell2.contents = (id)[self cometImageWithWidth:500];
        cell2.birthRate = 0.5;
        cell2.lifetime = 30;
        cell2.velocity = 40;
        
    }
    else {
        
        self.velocity = 1;

        cell.contents = (id)[self cometImageWithWidth:50];
        cell.birthRate = 1;
        cell.lifetime = 300;
        cell.velocity = 4;
        
        cell2.contents = (id)[self cometImageWithWidth:50];
        cell2.birthRate = 0.1;
        cell2.lifetime = 30;
        cell2.velocity = 40;
    }
}

@end
