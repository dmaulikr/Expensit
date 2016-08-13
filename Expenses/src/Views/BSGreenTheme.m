//
//  BSGreenTheme.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSGreenTheme.h"

@implementation BSGreenTheme

- (UIColor *)tintColor {
    return [self greenColor];
}

- (UIColor *)selectedTintColor {
    return [UIColor colorWithRed:218.0/256.0 green:104.0/256.0 blue:44.0/256.0 alpha:1.0];
}

- (UIColor *)navigationBarBackgroundColor
{
    return [UIColor colorWithRed:12.0/256.0 green:34.0/256.0 blue:11.0/256.0 alpha:1.0];
}

- (UIColor *)navigationBarTextColor
{
    return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

- (UIColor *)redColor
{
    return [UIColor colorWithRed:199.0/255.0 green:43.0/255.0 blue:49.0/255.0 alpha:1.0];
}

- (UIColor *)greenColor
{
    return [UIColor colorWithRed:86.0/255.0 green:130.0/255.0 blue:61.0/255.0 alpha:1.0];
}

- (UIColor *)blueColor
{
    return [UIColor colorWithRed:75.0/256.0 green:132.0/256.0 blue:197.0/256.0 alpha:1.0];
}

- (UIColor *)brownColor
{
    return [UIColor colorWithRed:100.0/255.0 green:50.0/255.0 blue:25.0/255.0 alpha:1.0];
}

- (UIColor *)orangeColor
{
    return [UIColor colorWithRed:250.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
}

- (UIColor *)purpleColor
{
    return [UIColor colorWithRed:200.0/255.0 green:10.0/255.0 blue:255.0/255.0 alpha:1.0];
}

- (UIColor *)grayColor
{
    return [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
}

- (UIColor *)selectedCellColor
{
    return [UIColor colorWithRed:0.624 green:0.816 blue:0.902 alpha:1.00];
}

- (UIColor *)unselectedCellColor
{
    return [UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1];
}

- (UIImage *)stretchableImageForNavBarDecisionButtonsWithStrokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor
{
    CGSize newSize = CGSizeMake(11.0f, 30.0f);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(imageContext, YES);
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5, 0.5, newSize.width-1, newSize.height-1) cornerRadius:5];
    
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5, 0.5, newSize.width-1, newSize.height-1) cornerRadius:5];

    
    CGContextSetStrokeColorWithColor(imageContext, strokeColor.CGColor);
    CGContextSetFillColorWithColor(imageContext, fillColor.CGColor);

    CGContextSetLineWidth(imageContext, 1.0);
    
    if (fillColor) {
        CGContextAddPath(imageContext, fillPath.CGPath);
        CGContextFillPath(imageContext);
    }

    CGContextAddPath(imageContext, borderPath.CGPath);
    CGContextStrokePath(imageContext);

    
    

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
}

@end
