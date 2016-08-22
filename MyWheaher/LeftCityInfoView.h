//
//  LeftCityInfoView.h
//  MyWheaher
//
//  Created by  Leonard on 16/8/2.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "BaseWheatherView.h"

@interface LeftCityInfoView : BaseWheatherView
-(void)addButtonItemWithImage:(nonnull UIImage*)image HeightLightImage:(nullable UIImage*)heightLightImage backgroundColor:(nullable UIColor*)color target:(nonnull id)target action:(nonnull SEL)selector;

-(void)hideButtunItems;
@end
