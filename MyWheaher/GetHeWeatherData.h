//
//  GetHeWeatherData.h
//  MyWheaher
//
//  Created by  Leonard on 16/8/15.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ENABLE_HEWEATHER

@class CurrentWeatherData;
@class GetHeWeatherData;
@class Coordinate;
@protocol GetHeWeatherDataDelegate <NSObject>
-(void)GetHeWeatherData:(nonnull GetHeWeatherData*)getData getDataFailWithError:(nonnull NSError*)error;

@optional
-(void)GetHeWeatherData:(nonnull GetHeWeatherData*)getData  getDataSuccessWithWeatherData:(nonnull CurrentWeatherData*)weatherData;
-(void)GetHeWeatherData:(nonnull  GetHeWeatherData*)getData  getDataSuccessWithWeatherDatas:(nonnull NSDictionary<NSString*,CurrentWeatherData*> *)weatherDatas;



@end
@interface GetHeWeatherData : NSObject
@property(nonatomic,weak,nullable)  id<GetHeWeatherDataDelegate> delegate;


-(nullable instancetype)initWithDelegate:(nullable id<GetHeWeatherDataDelegate>)delegate;

@property(nonatomic,copy,nonnull) NSString *cityId;
@property(nonatomic,copy,nonnull) NSString *cityName;

-(void)requestWithCityId;
-(void)requestWithCityName;

-(void)requestWithCityId:(nonnull NSString*)cityId;
-(void)requestWithCityName:(nonnull NSString*)cityName;
-(void)requestWithCityIds:(nonnull NSArray<NSString*>*)cityIds;


@end
