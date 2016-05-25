//
//  weather.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/23.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject
@property(nonnull,nonatomic,copy) NSString *main;
@property(nonnull,nonatomic,copy) NSString *weatherDescription;
@property(nonnull,nonatomic,copy) NSNumber *weatherCode;
@property(nonnull,nonatomic,copy) NSString *iconName;
@end
