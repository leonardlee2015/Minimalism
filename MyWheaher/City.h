//
//  City.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/24.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Coordinate;
@interface City : NSObject<NSCopying,NSCoding>
@property(nonnull,nonatomic,copy) NSString *cityName;
@property(nonnull,nonatomic,copy) NSString *ZHCityName;
@property(nonnull,nonatomic,copy) NSString *cityId;
@property(nullable,nonatomic,strong) Coordinate * coordinate;
@property(nonnull,nonatomic,copy) NSString *country;
@property(nullable,nonatomic,copy) NSNumber *temperature;
@property(nonnull,nonatomic)NSDate *upateTime;
@end
