//
//  OpenWeatherClient.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/19.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "OpenWeatherClient.h"

static NSString *baseUrl = @"http://api.openweathermap.org/data/2.5/";
static NSString *forcastUrl = @"forecast/daily";
static NSString *appIdKey = @"8781e4ef1c73ff20a180d3d7a42a8c04";

@interface OpenWeatherClient ()
-(NSURLSessionDataTask*) _GET:(nonnull NSString *)URLString Parameters:(nullable NSDictionary*)parameters;
@end

@implementation OpenWeatherClient
+(OpenWeatherClient *)shareClient{
    static OpenWeatherClient*shareclient = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareclient = [[OpenWeatherClient alloc]initWithBaseURL:[NSURL URLWithString:baseUrl]];
    });
    return shareclient;
}

-(instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        // 
        self.requestSerializer.timeoutInterval = 10.f;

    }

    return self;
}

-(NSURLSessionDataTask*) _GET:(nonnull NSString *)URLString Parameters:(NSDictionary*)parameters{
    __weak typeof(self) weakSelf = self;

    // 为参数添加 appid ;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [params setObject:appIdKey forKey:@"APPID"];
    [params setObject: @"metric" forKey:@"units"];
    if (self.country && ![self.country isEqualToString:@""]) {
        [params setObject:self.country forKey:@"lang"];;
    }

    return [self GET:URLString parameters:[params copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(WeatherClient:didUpdateSucessWithWeather:)]) {
            [weakSelf.delegate WeatherClient:weakSelf didUpdateSucessWithWeather:responseObject];
        }


        if (weakSelf.getCompletedBlock) {
            weakSelf.getCompletedBlock(task, responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(WeatherClient:didUpdateSucessFailWithError:)]) {
            [weakSelf.delegate WeatherClient:weakSelf didUpdateSucessFailWithError:error];
        }

        if (weakSelf.getFailBlock) {
            weakSelf.getFailBlock(task,error);
        }
    }];
}
-(NSURLSessionDataTask*)getCurrentweatherDataByCityId:(NSString *)cityId{


    NSDictionary *parameters = @{@"q":cityId};

    return  [self _GET:@"weather" Parameters:parameters];

}
-(NSURLSessionDataTask*)getCurrentweatherDataByCityName:(NSString *)cityName{
    NSDictionary *parameters = @{@"q":cityName,@"lang":@"zh"};

    return  [self _GET:@"weather" Parameters:parameters];
}

-(NSURLSessionDataTask*)getCurrentweatherDataByCoordinate:(Coordinate *)coordinate{

    NSDictionary *parameters = @{@"lat":coordinate.lat, @"lon":coordinate.lon};

    return  [self _GET:@"weather" Parameters:parameters];
}

-(NSURLSessionDataTask*)getCurrentweatherDataByCityIDs:(nonnull NSArray<NSString *> *)cityIDs{
    NSMutableString *requestCityIDs = [NSMutableString string];

    [cityIDs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (cityIDs.count > 1) {
            if (idx < (cityIDs.count - 1)) {
                [requestCityIDs appendFormat:@"%@,",obj];
            }else{
                [requestCityIDs appendString:obj];
            }
        }else{
            [requestCityIDs appendString:obj];
        }

    }];

    NSDictionary *parameters = @{@"id":[requestCityIDs copy],
                                 @"lang":@"zh"
                                };

    return  [self _GET:@"group" Parameters:parameters];
}

-(NSURLSessionDataTask*)getForcastWeatherDataByCityId:(NSString *)cityId day:(NSInteger)day{
    if(day < 1 || day > 16){
        return nil;
    }

    NSDictionary *params = @{
                            @"id":cityId,
                            @"cnt":@(day)
                            };

    return  [self _GET:forcastUrl Parameters:params];
}

-(NSURLSessionDataTask*)getForcastWeatherDataByCityName:(NSString *)cityName day:(NSInteger)day{
    if(day < 1 || day > 16){
        return nil;
    }

    NSDictionary *params = @{
                            @"q":cityName,
                             @"cnt":@(day)
                             };
    return  [self _GET:forcastUrl Parameters:params];

}

-(NSURLSessionDataTask*)getForcastWeatherDataByCoordinate:(Coordinate *)coordinate day:(NSInteger)day{
    if(day < 1 || day > 16){
        return nil;
    }

    NSDictionary *params = @{
                             @"lat":coordinate.lat,
                             @"lon":coordinate.lon,
                             @"cnt":@(day)
                             };

    return  [self _GET:forcastUrl Parameters:params];

}

-(NSURLSessionDataTask*)getForcastWeatherDataByCityId:(NSString *)cityId{
    return  [self getForcastWeatherDataByCityId:cityId day:10];
}

-(NSURLSessionDataTask*)getForcastWeatherDataByCityName:(NSString *)cityName{
    return  [self getForcastWeatherDataByCityName:cityName day:10];
}

-(NSURLSessionDataTask*)getForcastWeatherDataByCoordinate:(Coordinate *)coordinate{
    return  [self getForcastWeatherDataByCoordinate:coordinate day:10];
}
@end
