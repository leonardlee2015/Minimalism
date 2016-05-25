//
//  City.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/24.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Coordinate;
@interface City : NSObject
@property(nonatomic,copy) NSString *cityName;
@property(nonatomic,copy) NSString *ZHCityName;
@property(nonatomic,copy) NSString *cityId;
@property(nonatomic,strong) Coordinate * coordinate;
@property(nonatomic,copy) NSString *country;
@end
