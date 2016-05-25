//
//  NumberAnimation.m
//  WheatherAppTest
//
//  Created by 李南 on 15/9/25.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "NumberAnimation.h"

@implementation NumberAnimation
-(instancetype)init{
    self = [super init];
    if (self) {
        self.animation = [POPBasicAnimation animation];
    }
    return self;
}

-(void)startAnimation{
    self.animation.duration = self.duration>0? self.duration:1.0f;
    self.animation.fromValue = self.fromValue;
    self.animation.toValue = self.toValue;
    self.animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.69 :0.11 :0.32 :0.88];

    // 如果 有委托并且 实现 anmimate:byCurrentNumber:方法执行动画
    if (self.delegate && [self.delegate respondsToSelector:@selector(animation:ByCurrentNumber:)]) {
        self.animation.property = [POPAnimatableProperty  propertyWithName:@"PopUIViewNumber"
                                                               initializer:^(POPMutableAnimatableProperty *prop) {
                                                                   prop.writeBlock = ^(id view ,const CGFloat value[]){
                                                                       
                                                                       [self.delegate animation:self ByCurrentNumber:value[0]];
                                                                       
                                                                   };
                                                               }];
        [self pop_addAnimation:self.animation forKey:@"NumberAnimation"];
    }

}
@end
