//
//  CALayer+MaskLayer.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//


#import "CALayer+MaskLayer.h"

@implementation CALayer (MaskLayer)

+ (CALayer *)createMaskLayerWithSize:(CGSize)size maskPNGImage:(UIImage *)image {
    
    CALayer *layer    = [CALayer layer];
    layer.anchorPoint = CGPointMake(0, 0);                          // 重置锚点
    layer.bounds      = CGRectMake(0, 0, size.width, size.height);  // 设置尺寸
    
    if (image) {
        
        layer.contents = (__bridge id)(image.CGImage);
    }

    return layer;
}

@end
