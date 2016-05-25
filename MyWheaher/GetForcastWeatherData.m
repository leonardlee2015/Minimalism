//
//  GetForcastWeatherData.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/27.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "GetForcastWeatherData.h"
#import "OpenWeatherClient.h"
#import "ForcastWeatherData.h"
#import "Coordinate.h"

@interface GetForcastWeatherData ()<OpenWeatherClientDelegate>
@property(nonatomic,readonly)OpenWeatherClient *client;
@property(nonatomic,strong) NSMutableArray <NSURLSessionDataTask*>*taskArray;
@end
@implementation GetForcastWeatherData

-(id)initWithDelegate:(id<GetForcastWeatherDataDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}
-(void)requestWithCityId:(NSString *)cityId{
    [self.client getForcastWeatherDataByCityId:cityId];
}
-(void)requestWithCityId{
    [self.client getForcastWeatherDataByCityId:self.cityId];
}

-(void)requestWithCityName:(NSString *)cityName{
    [self.client getForcastWeatherDataByCityName:cityName];
}
-(void)requestWithCityName{
    [self.client getForcastWeatherDataByCityName:self.cityName];
}

-(void)requestWithCoordinate:(Coordinate *)corrdinate{
    [self.client getForcastWeatherDataByCoordinate:corrdinate];
}

-(void)requestWithLocation{
    [self.client getForcastWeatherDataByCoordinate:self.location];
}

@synthesize client = _client;
-(OpenWeatherClient *)client{
    if (!_client) {
        _client = [OpenWeatherClient shareClient];
        _client.delegate  = self;
    }
    return _client;
}

#pragma mark - OpenWeatherClientDelegate
-(void)WeatherClient:(OpenWeatherClient *)client didUpdateSucessWithWeather:(id)weather{
    if (weather) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(GetForcastWeatherData:didUpdateSucessWithData:)]) {
            [self.delegate GetForcastWeatherData:self didUpdateSucessWithData:[ForcastWeatherData ForcastWeatherDataFromWeatherData:weather]];
        }
    }

}

-(void)WeatherClient:(OpenWeatherClient *)client didUpdateSucessFailWithError:(NSError *)error{

    if (self.delegate && [self.delegate respondsToSelector:@selector(GetForcastWeatherData:didUpdateFailWithError:)]) {
        [self.delegate GetForcastWeatherData:self didUpdateFailWithError:error];
    }
}

-(void)dealloc{

}

@end
