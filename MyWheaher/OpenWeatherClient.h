//
//  OpenWeatherClient.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/19.
//  Copyright © 2016年  Leonard. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>

//#import "AFHTTPSessionManager.h"
#import "Coordinate.h"

#if 0
typedef NS_ENUM(NSUInteger,RequestType) {
    requestTypeHTTP,
    requestTYpePropertyList,
    requestTYpeJson,
    requestTYpeXml
};

typedef NS_ENUM(NSUInteger, ResponseType) {
    ResponseTypeHTTP,
    ResponseTypePropertyList,
    ResponseTypeJson,
    ResponseTypeXml
};
#endif

typedef void(^GETCompletedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void(^GETFailBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

@class OpenWeatherClient;
@protocol OpenWeatherClientDelegate <NSObject>

-(void)WeatherClient:(nonnull OpenWeatherClient*)client didUpdateSucessWithWeather:(nullable id)weather;
-(void)WeatherClient:(nonnull OpenWeatherClient *)client didUpdateSucessFailWithError:(nullable NSError*)error;
@end

@interface OpenWeatherClient : AFHTTPSessionManager
@property(nonnull,nonatomic,copy) NSString *country;
@property(nonatomic,weak,nullable) id<OpenWeatherClientDelegate> delegate;
@property(nonatomic,copy,nullable) GETCompletedBlock getCompletedBlock;
@property(nonatomic,copy, nullable) GETFailBlock  getFailBlock;


+(nullable OpenWeatherClient*)shareClient;
+(nullable OpenWeatherClient*)getOpenWeatherClient;
// current weather request.
-(nullable NSURLSessionDataTask*)getCurrentweatherDataByCityName:(nonnull NSString *)cityName;
-(nullable NSURLSessionDataTask*)getCurrentweatherDataByCityId:(nonnull NSString *)cityId;
-(nullable NSURLSessionDataTask*)getCurrentweatherDataByCoordinate:(nonnull Coordinate *)coordinate;

-(nullable NSURLSessionDataTask*)getCurrentweatherDataByCityIDs:(nonnull NSArray<NSString*>*)cityIDs;

// forcast weather request.
-(nullable NSURLSessionDataTask*)getForcastWeatherDataByCityId:(nonnull NSString *)cityId day:(NSInteger) day;
-(nullable NSURLSessionDataTask*)getForcastWeatherDataByCityName:(nonnull NSString *)cityName day:(NSInteger) day;
-(nullable NSURLSessionDataTask*)getForcastWeatherDataByCoordinate:(nonnull Coordinate *)coordinate day:(NSInteger) day;

-(nullable NSURLSessionDataTask*)getForcastWeatherDataByCityId:(nonnull NSString *)cityId;
-(nullable NSURLSessionDataTask*)getForcastWeatherDataByCityName:(nonnull NSString *)cityName;
-(nullable NSURLSessionDataTask*)getForcastWeatherDataByCoordinate:(nonnull Coordinate *)coordinate;
// search  city.
-(nullable NSURLSessionDataTask*)searchSimilarCitiesByName:(nonnull NSString*)cityName;
@end
