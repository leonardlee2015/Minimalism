//
//  SearchCityData.m
//  MyWheaher
//
//  Created by  Leonard on 16/7/24.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "SearchCityData.h"
#import "CityDbData.h"
#import "City.h"
#import "OpenWeatherClient.h"

@interface SearchCityData ()<OpenWeatherClientDelegate>
@property(nonnull,readonly)OpenWeatherClient *client;
@property(nonnull,strong,nonatomic) NSURLSessionDataTask *lastTask;
@end
@implementation SearchCityData

@synthesize client = _client;

-(OpenWeatherClient *)client{

    if (!_client) {
        _client = [OpenWeatherClient getOpenWeatherClient];
        _client.delegate = self;
    }
    return _client;

}

-(instancetype)init{
    self = [super init];
    if (self) {
        OpenWeatherClient *client = [OpenWeatherClient shareClient];
        client.delegate = self;

    }
    return self;
}
-(void)searchCityByName:(NSString *)cityName{
    [_lastTask cancel];
    
    _lastTask = [self.client searchSimilarCitiesByName:cityName];
}

-(void)WeatherClient:(nonnull OpenWeatherClient*)client didUpdateSucessWithWeather:(nullable id)weather{
    if (weather) {

        NSString *cod = weather[@"cod"];
        if (![cod isEqualToString:@"200"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchCityData:didUpdateFailWithError:)]) {
                [self.delegate searchCityData:self didUpdateFailWithError:nil];
            }
            return;

        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchCityData:didUpdateSucessWithData:)]) {
            NSInteger count = [weather[@"count"] integerValue];

            NSMutableArray *cities = [NSMutableArray arrayWithCapacity:count];

            for (int i=0; i< count; i++) {
                City *city = [City new];
                city.cityName = weather[@"list"][i][@"name"];
                city.cityId = weather[@"list"][i][@"id"];
                city.country = weather[@"list"][i][@"sys"][@"country"];
                city.coordinate.lat = weather[@"list"][i][@"coord"][@"lat"];
                city.coordinate.lon = weather[@"list"][i][@"coord"][@"lat"];

                if ([city.country isEqualToString:@"CN"]
                    || [city.country isEqualToString:@"China"]) {
                    NSString *zhName = [[CityDbData shareCityDbData] requestZhCityNameByCityName:city.cityName];
                    city.ZHCityName = [zhName stringByAppendingString:@"市"];

                }
                [cities addObject:city];
            }

            [self.delegate searchCityData:self didUpdateSucessWithData:cities];
            
        }
    }else{
        [self WeatherClient:client didUpdateSucessFailWithError:nil];
    }
}
-(void)WeatherClient:(nonnull OpenWeatherClient *)client didUpdateSucessFailWithError:(nullable NSError*)error{

    if (self.delegate && [self.delegate respondsToSelector:@selector(searchCityData:didUpdateFailWithError:)]) {
        [self.delegate searchCityData:self didUpdateFailWithError:error];
    }
}



@end
