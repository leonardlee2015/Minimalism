//
//  GetForcastWeatherData.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/27.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  GetForcastWeatherData;
@class Coordinate;
@class ForcastWeatherData;

@protocol GetForcastWeatherDataDelegate <NSObject>
-(void)GetForcastWeatherData:(nonnull GetForcastWeatherData*) getData didUpdateSucessWithData:(nonnull ForcastWeatherData*)weatherData;
-(void)GetForcastWeatherData:(nonnull GetForcastWeatherData*) getData didUpdateFailWithError:(nonnull NSError*)error;

@end
@interface GetForcastWeatherData : NSObject
@property(nonatomic,weak,nullable)id<GetForcastWeatherDataDelegate> delegate;
-initWithDelegate:(nullable id<GetForcastWeatherDataDelegate>)delegate;


@property(nonatomic,strong,nonnull) Coordinate *location;
@property(nonatomic,strong,nonnull) NSString *cityId;
@property(nonatomic,strong,nonnull) NSString *cityName;

-(void)requestWithLocation;
-(void)requestWithCityId;
-(void)requestWithCityName;

-(void)requestWithCoordinate:(nonnull Coordinate*)corrdinate;
-(void)requestWithCityId:(nonnull NSString*)cityId;
-(void)requestWithCityName:(nonnull NSString*)cityName;

@end
