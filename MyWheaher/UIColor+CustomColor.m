//
//  UIColor+CustomColor.m
//  WheatherAppTest
//
//  Created by 李南 on 15/9/10.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import "UIColor+CustomColor.h"

UIColor * color(int red, int green, int blue,CGFloat alpha)
{
    return  [UIColor colorWithIntRed:red green:green blue:blue alpha:alpha];
}

@implementation UIColor (CustomColor)

+(UIColor *)CustomBlueColor{
    return [self colorWithIntRed:52 green:152 blue:219 alpha:1.0f];
}
+(UIColor *)colorWithIntRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (UIColor *)customGrayColor
{
    return [self colorWithRed:84 green:84 blue:84];
}

+ (UIColor *)customRedColor
{
    return [self colorWithRed:231 green:76 blue:60];
}

+ (UIColor *)customYellowColor
{
    return [self colorWithRed:241 green:196 blue:15];
}

+ (UIColor *)customGreenColor
{
    return [self colorWithRed:46 green:204 blue:113];
}


+ (UIColor *)customRandomColor{
    NSUInteger red = arc4random() % 255;
    NSUInteger green = arc4random() % 255;
    NSUInteger blue = arc4random() % 255;
    return [self colorWithRed:red green:green blue:blue];
}

-(BOOL)isEqualColor:(UIColor *)color{
    CGFloat sGreen;
    CGFloat sRed;
    CGFloat sBlue;
    CGFloat sAlpha;
    
    CGFloat oGreen;
    CGFloat oRed;
    CGFloat oBlue;
    CGFloat oAlpha;
    
    [self getRed:&sRed green:&sGreen blue:&sBlue alpha:&sAlpha];
    
    [color getRed:&oRed green:&oGreen blue:&oBlue alpha:&oAlpha];
    
    if ((sRed==oRed) &&
        (sGreen==oGreen)&&
        (sBlue==oBlue)&&
        (sAlpha==oAlpha)) {
        
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - Private class methods

+ (UIColor *)colorWithRed:(NSUInteger)red
                    green:(NSUInteger)green
                     blue:(NSUInteger)blue
{
    return [UIColor colorWithRed:(float)(red/255.f)
                           green:(float)(green/255.f)
                            blue:(float)(blue/255.f)
                           alpha:1.f];
}

@end
