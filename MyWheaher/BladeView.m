//
//  BladeView.m
//  WheatherAppTest
//
//  Created by 李南 on 16/3/16.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "BladeView.h"

@interface BladeView (){
    UIImageView *bladeView;
    CGFloat offsetY;
}
@end
@implementation BladeView
-(void)buildView{
    UIImage *bladeImage = [UIImage imageNamed:@"WindSpeed"];
    // 获取扇叶rect.
    CGRect bladeFrame = CGRectMake(0, 0, self.width, self.height/2);
    // 获取扇叶动画偏移
    offsetY = -(self.height / 2.0f);
    

    // 添加blade view.
    bladeView =  [[UIImageView alloc]initWithImage:bladeImage];
    bladeView.frame = bladeFrame;
    bladeView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:bladeView];
#ifdef test
    self.layer.borderColor  = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2;
#endif
    // 初始化动画位移
    bladeView.y = offsetY;

    
}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [UIView animateWithDuration:duration animations:^{
        bladeView.y = offsetY;

    }];
    [super hideByDuration:duration delay:delay];
}

-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [UIView animateWithDuration:duration animations:^{
        bladeView.y = 0;

    }];
    [super showByDuration:duration delay:delay];
}
@end
