//
//  GetHeForcastWeatherData.m
//  MyWheaher
//
//  Created by  Leonard on 16/8/16.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "GetHeForcastWeatherData.h"
#import "MWHeWeatherClient.h"
#import "ForcastWeatherData.h"

@interface GetHeForcastWeatherData ()<MWHeWeatherClientDelegate>
@property(nonatomic,readonly) MWHeWeatherClient *client;
@property(nonatomic,strong) NSMutableArray <NSURLSessionDataTask*>*taskArray;
@end


@implementation GetHeForcastWeatherData

-(id)initWithDelegate:(id<GetHeForcastWeatherDataDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}
-(void)requestWithCityId:(NSString *)cityId{
    [self.client requestCityWeatherdataByID:cityId];
}
-(void)requestWithCityId{
    [self requestWithCityId:self.cityId];
}

-(void)requestWithCityName:(NSString *)cityName{
    [self.client requestCityWeatherdataByName:cityName];
}
-(void)requestWithCityName{
    [self.client requestCityWeatherdataByName:self.cityName];
}




#pragma mark - MWHeWeatherClient
@synthesize client = _client;
-(MWHeWeatherClient *)client{
    if (!_client) {
        _client = [MWHeWeatherClient client];
        _client.delegate  = self;
    }

    return _client;
}


-(void)MWWeatherClient:(MWHeWeatherClient *)client didUpdateSucessFailWithError:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(GetHeForcastWeather:didUpdateFailWithError:)]) {
        [self.delegate GetHeForcastWeather:self didUpdateFailWithError:error];
    }


}
-(void)MWWeatherClient:(MWHeWeatherClient *)client didUpdateSucessWithWeatherData:(id)weather type:(MWHeDataType)type{
    if (self.delegate && [self.delegate respondsToSelector:@selector(GetHeForcastWeather:didUpdateSucessWithData:)]) {
        [self.delegate GetHeForcastWeather:self didUpdateSucessWithData:[ForcastWeatherData ForcastWeatherDataFromHeWeatherData:weather]];
    }
}

@end
