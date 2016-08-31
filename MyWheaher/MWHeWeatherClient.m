//
//  MWHeWeatherClient.m
//  MyWheaher
//
//  Created by  Leonard on 16/8/15.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "MWHeWeatherClient.h"

static NSString *const BaseUrlStr = @"https://api.heweather.com/x3";

// he weather key .
static NSString *const heAPPKey = @"af9a6e1f5567418c8ecf42089749ee6e";

NSString * const weatherHeaderKey = @"HeWeather data service 3.0";

NSString *const CumstomDomain = @"com.heweatherRequest.domain";

@interface MWHeWeatherClient ()
@end
@implementation MWHeWeatherClient

#pragma mark - Initialization
-(instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];

    if (self) {
        // 初始化类属性

        // 初始化http设置
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];

        self.requestSerializer.timeoutInterval = 20.f;

        // 初始化证书设置支持https

        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];

        NSSet *cerSet = [NSSet setWithObject:cerData];

        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

        [policy setAllowInvalidCertificates:YES];
        [policy setPinnedCertificates:cerSet];

        self.securityPolicy = policy;
        self.operationQueue.maxConcurrentOperationCount = 20;

    }

    return self;
}

+(nullable MWHeWeatherClient*)shareClient{
    static MWHeWeatherClient *client;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[MWHeWeatherClient alloc]initWithBaseURL:[NSURL URLWithString:BaseUrlStr]];
    });

    return client;
}

+(MWHeWeatherClient *)client{

    return [[MWHeWeatherClient alloc]initWithBaseURL:[NSURL URLWithString:BaseUrlStr]];
}


#pragma mark - GET request 

-(nullable NSURLSessionDataTask*) _GETURLPath:(NSString*)path withParameters:(NSDictionary*)params questDataType:(MWHeDataType) type {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];

    [dic setObject:heAPPKey forKey:@"key"];


    __weak typeof(self) weakSelf = self;


    NSURLSessionDataTask *task = [self GET:path parameters:[dic copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {



        // 任务完成把task 从_inCurrentTasks 中删除。


        NSString *status;
        if (type == MWHeDataTypeWeatherData) {
            status = responseObject[weatherHeaderKey][0][@"status"];

        }else{
            status = responseObject[@"status"];
        }

        if (![status isEqualToString:@"ok"]) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(MWWeatherClient:didUpdateSucessFailWithError:)]) {

                NSError *error = [NSError errorWithDomain:CumstomDomain code:-204 userInfo:@{NSLocalizedDescriptionKey:status}];

                [weakSelf.delegate MWWeatherClient:weakSelf didUpdateSucessFailWithError:error];

                return ;
            }

        }


        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(MWWeatherClient:didUpdateSucessWithWeatherData:type:)]) {
            [weakSelf.delegate MWWeatherClient:weakSelf didUpdateSucessWithWeatherData:responseObject type:type];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        // 任务完成把task 从_inCurrentTasks 中删除。

        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(MWWeatherClient:didUpdateSucessFailWithError:)]) {
            [weakSelf.delegate MWWeatherClient:weakSelf didUpdateSucessFailWithError:error];
        }

    }];


    return task;
}

-(NSURLSessionDataTask *)getAllChinaCityList{
    NSDictionary *params = @{
                          @"search":@"allchina"
                          };

    return [self _GETURLPath:@"citylist" withParameters:params questDataType: MWHeDataTypeCities];
}

-(NSURLSessionDataTask *)getHotCityList{
    NSDictionary *params = @{
                             @"search":@"hotworld"
                             };

    return [self _GETURLPath:@"citylist" withParameters:params questDataType: MWHeDataTypeCities];
}

-(NSURLSessionDataTask *)getAllWorldCityList{
    NSDictionary *params = @{
                             @"search":@"allworld"
                             };

    return [self _GETURLPath:@"citylist" withParameters:params questDataType: MWHeDataTypeCities];
}

-(NSURLSessionDataTask *)requestCityWeatherdataByID:(NSString *)cityID{
    NSDictionary *params = @{
                             @"cityid":cityID
                             };

    if (cityID.length > 11) {
        return [self _GETURLPath:@"attractions" withParameters:params questDataType: MWHeDataTypeWeatherData];


    }else{
        return [self _GETURLPath:@"weather" withParameters:params questDataType: MWHeDataTypeWeatherData];


    }
    return nil;

}

-(NSURLSessionDataTask *)requestCityWeatherdataByName:(NSString *)name{
    NSDictionary *params = @{
                             @"city":name
                             };

    return [self _GETURLPath:@"weather" withParameters:params questDataType: MWHeDataTypeWeatherData];
}
-(NSURLSessionDataTask *)getAllCondList{
    NSDictionary *params = @{
                             @"search":@"allcond"
                             };

    return [self _GETURLPath:@"condition" withParameters:params questDataType:MWHeDataTypeCouds];
}



@end
