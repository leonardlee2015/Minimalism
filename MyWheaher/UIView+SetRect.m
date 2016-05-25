//
//  UIView+SetRect.m
//  WheatherAppTest
//
//  Created by 李南 on 15/9/1.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import "UIView+SetRect.h"

@implementation UIView (SetRect)
-(CGPoint)origin{
    return self.frame.origin;
}
-(void)setOrigin:(CGPoint)origin{
    
    self.frame = CGRectMake(origin.x, origin.y,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

-(CGSize)size{
    return self.frame.size;
}
-(void)setSize:(CGSize)size{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), size.width, size.height);
}

-(CGFloat)x{
    return self.frame.origin.x;

}
-(void)setX:(CGFloat)x{
    
    self.frame = CGRectMake(x, self.y, self.width, self.height  );
}

-(CGFloat)y{
    return self.frame.origin.y;
}
-(void)setY:(CGFloat)y{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
    
}

-(CGFloat)width{
    return self.frame.size.width;
}
-(void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

-(CGFloat)height{
    return self.frame.size.height;
}
-(void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.x, self.y, self.width
                            , height);
}
-(CGFloat)centerX{
    return self.center.x;
}
-(void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.centerY);
}
-(CGFloat)centerY{
    return self.center.y;
}
-(void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.centerX, centerY);
}
-(CGFloat)midX{
    return CGRectGetMidX(self.bounds);
}
-(CGFloat)midY{
    return CGRectGetMidY(self.bounds);
}
-(CGPoint)boundsCenter{
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

@end
