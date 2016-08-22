//
//  GetHeForcastWeatherData.h
//  MyWheaher
//
//  Created by  Leonard on 16/8/16.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GetHeForcastWeatherData;
@class Coordinate;
@class ForcastWeatherData;

@protocol  GetHeForcastWeatherDataDelegate<NSObject>
-(void)GetHeForcastWeather:(nonnull GetHeForcastWeatherData*) getData didUpdateSucessWithData:(nonnull ForcastWeatherData*)weatherData;
-(void)GetHeForcastWeather:(nonnull GetHeForcastWeatherData*) getData didUpdateFailWithError:(nonnull NSError*)error;
@end

@interface GetHeForcastWeatherData : NSObject
@property(nonatomic,weak,nullable)id<GetHeForcastWeatherDataDelegate> delegate;
-initWithDelegate:(nullable id<GetHeForcastWeatherDataDelegate>)delegate;


@property(nonatomic,strong,nonnull) NSString *cityId;
@property(nonatomic,strong,nonnull) NSString *cityName;

-(void)requestWithCityId;
-(void)requestWithCityName;

-(void)requestWithCityId:(nonnull NSString*)cityId;
-(void)requestWithCityName:(nonnull NSString*)cityName;
@end
