//
//  CALayer+MaskLayer.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (MaskLayer)

/**
 *  根据PNG图片创建出用于mask的layer
 *
 *  @param size  mask的尺寸
 *  @param image 用于mask的图片
 *
 *  @return 创建好的mask的layer
 */
+ (CALayer *)createMaskLayerWithSize:(CGSize)size maskPNGImage:(UIImage *)image;

@end
