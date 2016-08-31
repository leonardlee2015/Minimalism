//
//  ViewController.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/17.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "WeatherViewController.h"
#import "GetCurrentData.h"
#import "CurrentWeatherData.h"
#import "WeatherView.h"
#import "ForcastViewController.h"
#import "FadeBlackView.h"
#import <CoreLocation/CoreLocation.h>
#import "UpdatingView.h"
#import "FailedLongPressView.h"
#import "TWMessageBarManager.h"
#import "CityDBData.h"
#import "CityListViewController.h"
#import "GetHeWeatherData.h"


#import "AppDelegate.h"
#import "Analysitcs.h"
#ifdef UM_OPEN

#import <UMSocialControllerService.h>
#import <UMSocialSnsService.h>

#endif

@interface  WeatherViewController()<
CLLocationManagerDelegate,
GetCurrentDataDelegate,
WeatherViewDelegate,
FailedLongPressViewDelegate,
#ifdef UM_OPEN
    UMSocialUIDelegate,
#endif
GetCurrentDataDelegate
>{
    FadeBlackView *_fadeBlackView;
    UpdatingView *_updatingView;
    FailedLongPressView *_failLongPressView;
    WeatherViewStyle  _style;
    BOOL _didSetLocationCity;



}
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) GetCurrentData *getCurrentdata;
@property(nonnull,strong,nonatomic)GetHeWeatherData* getHeWeatherData;
@property(nonatomic,strong) WeatherView *weatherView;
@property(nonnull,nonatomic,strong) UIScrollView *contentView;
@end

@implementation WeatherViewController
-(instancetype)initWithStyle:(WeatherViewStyle)style{
    self = [super init];
    if (self) {
        _style = style;
    }
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.



    // 初始化地址管理器。
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100;

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){

            [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        }


    }

    _getCurrentdata = [GetCurrentData new];
    _getCurrentdata.delegate = self;

    _getHeWeatherData = [[GetHeWeatherData alloc]initWithDelegate:self];

    // 添加 weather view
    _weatherView = [[WeatherView alloc]initWithFrame:self.view.bounds];
    _weatherView.delegate = self;
    [_weatherView buildView];
    [self.view addSubview:_weatherView];

    // 添加刷新背景 view。
    _fadeBlackView = [[FadeBlackView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_fadeBlackView];

    // 添加 update View.
    _updatingView = [[UpdatingView alloc]initWithFrame:CGRectZero];
    _updatingView.center = self.view.center;
    [self.view addSubview:_updatingView];

    // 添加fail long press view.
    _failLongPressView = [[FailedLongPressView alloc]initWithFrame:self.view.bounds];
    _failLongPressView.delegate = self;
    [_failLongPressView buildView];
    [self.view addSubview:_failLongPressView];

    // 添加获取

    // 添加content view。
    _contentView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _contentView.pagingEnabled = YES;
    _contentView.contentSize = _contentView.size;


    //  开始获取天气数据。
    [self requestWeatheData];


    // 隐藏status bar.
    // [self setNeedsStatusBarAppearanceUpdate];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"Weather View Controller"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [MobClick endLogPageView: @"Weather View Controller"];
}
// 隐藏status bar.
/*
 -(UIStatusBarStyle)preferredStatusBarStyle{
 return UIStatusBarStyleLightContent;
 }

 -(BOOL)prefersStatusBarHidden{
 return YES;
 }
 */

#pragma mark - View Animation.

-(void)requestWeatheData{

    /*
     *  WeatherViewStyleLocationCity类型，根据定位获取天气数据
     *  WeatherViewstyleTargetCity类型，根据设定城市获取天气数据
     */
    switch (_style) {
        case WeatherViewStyleLocationCity:{
            [self getLocationAndFadeView];
            break;
        }
        case WeatherViewstyleTargetCity:{
            if (!isUsingHeWeatherData) {
                // 显示请求中画面。
                [self showRequstingView];
                _getCurrentdata.cityName  = _city.cityName;
                _getCurrentdata.cityId = _city.cityId;
                [_getCurrentdata requestWithCityId];



            }else{
                // 显示请求中画面。
                [self showRequstingView];

                _getHeWeatherData.cityName = _city.cityName;
                _getHeWeatherData.cityId = _city.cityId;
                [_getHeWeatherData requestWithCityId];
            }
        }
        default:
            break;
    }
}


-(void)getLocationAndFadeView{
    // 显示请求中画面。
    [self showRequstingView];


    [_locationManager startUpdatingLocation];
    // 开始定位。

}
-(void)showRequstingView{
    [_weatherView hide];
    [_fadeBlackView show];
    [_updatingView show];

    self.status = WeatherViewRequesting;
}
-(void)showFailedView{
    [_weatherView hide];
    [_fadeBlackView hide];
    [_updatingView hide];

    [self.view addSubview:_failLongPressView];
    [_failLongPressView show];

    self.status = WeatherViewfailed;
}

-(void)showNormailWeatherView{
    [_weatherView show];

    [_fadeBlackView hide];
    [_updatingView hide];

    [_failLongPressView remove];


    self.status = WeatherViewStatusNormal;

}
#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{


    CLLocation *location = [locations lastObject];


    DLog(@"定位成功:%@",location);

    [CityManager shareManager].locatedCity.coordinate.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    [CityManager shareManager].locatedCity.coordinate.lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];

    // 延时执行取数据程序, 并取消上一项请求以排除干扰
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [self performSelector:@selector(delayRequstDataByCoordinate:) withObject:location afterDelay:0.8f];




}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([CLLocationManager locationServicesEnabled] == NO) {

        DLog(@"定位失败，定位服务关闭！");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showFailedView];
        });


        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // @"Failed to locate!" ,@"Please turn on your Locations Service."
            [[TWMessageBarManager sharedInstance]showMessageWithTitle:NSLocalizedString(@"LCErrTitle1", @"Failed to locate")description:NSLocalizedString(@"LCErrMsg1", @"Please turn on your Locations Service.")  type:TWMessageBarMessageTypeError];
        });

        // 发送统计信息。
        NSString *errMsg = [error localizedDescription];

        if (errMsg) {
            NSDictionary *attributes = @{@"ErrMsg": errMsg };
            [MobClick event:LocationDidNotOpenID attributes:attributes];
        }else{
            [MobClick endEvent:LocationDidNotOpenID];
        }



    }else{

        DLog(@"定位失败，未能定位当前位置！");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showFailedView];
        });

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //
            [[TWMessageBarManager sharedInstance]
             showMessageWithTitle:NSLocalizedString(@"LCErrTitle1", @"Failed to locate")
             description:NSLocalizedString(@"LCErrMsg2", @"Sorry, temporarily unable to locate your position.")
             type:TWMessageBarMessageTypeError];
        });


        // 发送统计信息。
        NSString *errMsg = [error localizedDescription];

        if (errMsg) {
            NSDictionary *attributes = @{@"ErrMsg": errMsg };
            [MobClick event:LocationFailedID attributes:attributes];
        }else{
            [MobClick endEvent:LocationFailedID];
        }

    }


}

-(void)reflesh{
    [self requestWeatheData];
}
-(void)delayRequstDataByCoordinate:(CLLocation*)location{


    CLGeocoder *coder = [CLGeocoder new];

    static BOOL enableRequstWeather = YES;


    // 强制是系统语言环境设置为英文，获取英文城市名称。
    //#define test
#ifndef test
#if 0
    NSMutableArray *userDefultLanguage = [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"];

    [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithObjects:@"en-US", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"]);

#endif
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"]);
        if (error) {

            DLog(@"reverseGeocodeLocation:%@",[error localizedDescription]);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [self showFailedView];

            });

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                // @"Sorry, temporarily unable to locate your position."
                [[TWMessageBarManager sharedInstance]
                 showMessageWithTitle:NSLocalizedString(@"LCErrTitle1", @"Failed to locate")
                 description:NSLocalizedString(@"LCErrMsg3",@"Sorry, temporarily unable to get your position information.")
                 type:TWMessageBarMessageTypeError];
            });



            // 发送统计信息。
            NSString *errMsg = [error localizedDescription];

            if (errMsg) {
                NSDictionary *attributes = @{@"ErrMsg": errMsg };
                [MobClick event:DecoderLocationFailedID attributes:attributes];
            }else{
                [MobClick endEvent:DecoderLocationFailedID];
            }


        }else{

            CLPlacemark *mark  = placemarks.firstObject;

            NSString *cityName = mark.addressDictionary[@"City"];
            NSString *province = mark.addressDictionary[@"State"];
            NSString *CtyCode = mark.addressDictionary[@"CountryCode"];


            // 获取英文城市名成功，根据城市名查询天气信息，如果城市名为中文，从数据库获取中文城市名。
            CityDbData *DB = [CityDbData shareCityDbData];

            City *city;

            if ([cityName isEqualToString:@""]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    [self showFailedView];


                });

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    [[TWMessageBarManager sharedInstance]
                     showMessageWithTitle:NSLocalizedString(@"LCErrTitle1", @"Failed to locate")
                     description:NSLocalizedString(@"LCErrMsg3",@"Sorry, temporarily unable to get your position information.")
                     type:TWMessageBarMessageTypeError];
                });

                // 发送统计信息。
                NSString *errMsg = [error localizedDescription];
                if (errMsg) {

                    NSDictionary *attributes = @{@"ErrMsg": errMsg };
                    [MobClick event:DecoderLocationFailedID attributes:attributes];
                }else{

                    [MobClick endEvent:DecoderLocationFailedID];
                }

            }else if (isUsingHeWeatherData) {

                if([self isZHLanguageenvironment]){

                    if ([CtyCode isEqualToString:@"CN"]) {
                        if (
                            [cityName containsString:@"香港"]||
                            [cityName containsString:@"澳门"]||
                            [cityName containsString:@"澳門"]
                             ) {

                            cityName = [cityName substringWithRange:NSMakeRange(0, 2)];
                            province = [province substringWithRange:NSMakeRange(0, province.length-1)];


                        }else{
                            cityName = [cityName substringWithRange:NSMakeRange(0, cityName.length-1)];
                            province = [province substringWithRange:NSMakeRange(0, province.length-1)];

                        }


                        city = [DB requestHeWeatherCityByZHName:cityName province:province];
                    }

                }else{

                    if ([CtyCode isEqualToString:@"CN"]) {

                        city = [DB requestHeWeatherCNCityByPinyin:cityName];

                    }else{

                        city = [DB requestHeWeatherCityByName:cityName];
                    }
                }


                if (city) {
                    // 更新定位城市数据
                    City *locationCity = [CityManager shareManager].locatedCity;
                    locationCity.cityId = city.cityId;
                    locationCity.cityName = city.cityName;
                    locationCity.ZHCityName = city.ZHCityName;
                    locationCity.country = city.country;

                    // 发送定位城市数据更新通知
                    [self pushDidUpdateLocationCityInfoNotification];
                    //
                    _getHeWeatherData.cityName = city.cityName;
                    _getHeWeatherData.cityId = city.cityId;

                }else{

                    _getHeWeatherData.cityName = cityName;

                }



                if (enableRequstWeather ) {

                    enableRequstWeather = NO;
                    if (_getHeWeatherData.cityId) {
                        [_getHeWeatherData requestWithCityId];

                    }else if(_getHeWeatherData.cityName){

                        [_getHeWeatherData requestWithCityName];

                    }else{

                        [self showFailedView];
                    }

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        enableRequstWeather = YES;
                    });
                }



            }else{
                if ([self isZHLanguageenvironment]) {
                    
                    city = [DB requestCityByZHCityName:cityName provinceName:province];

                }else{
                    city = [DB requestCityByCityName:cityName];
                }

                if (city) {
                    [CityManager shareManager].locatedCity = [city copy];
                }

                _getCurrentdata.cityName = cityName;
                _getCurrentdata.cityId = city.cityId;
                _getCurrentdata.ZNCithName = city.ZHCityName;

                if (enableRequstWeather ) {

                    enableRequstWeather = NO;
                    [_getCurrentdata requestWithCityName];

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        enableRequstWeather = YES;
                    });
                }
                
            }




        }
        // 还原中文城市名。
#if 0
        [[NSUserDefaults standardUserDefaults]setObject:userDefultLanguage forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
#endif
    }];
#endif
}

-(void)pushDidUpdateLocationCityInfoNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:DidUpdateLocationCityInfoNotification object:self ];
    _didSetLocationCity = YES;
}

-(BOOL)isZHLanguageenvironment{

    // 从NSUserDefaults中取语言环境信息。
    NSArray *appleLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];

    // 判断是否包含中文语言ID。若包含返回YES ,否则返回NO.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"zh-"];

    NSString *firstObject = appleLanguages.firstObject;


    return [predicate evaluateWithObject:firstObject];

}
#pragma mark - GetCurrentDataDelegate
-(void)GetCurrentData:(GetCurrentData *)getData getDataSuccessWithWeatherData:(CurrentWeatherData *)weatherData{

    if (weatherData) {

        if (_style == WeatherViewStyleLocationCity) {
            [CityManager shareManager].locatedCity.cityId = weatherData.city.cityId;
        }
        // 先隐藏再显示。
        [_weatherView hide];


        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.751f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _weatherView.weatherData = weatherData;
            [self showNormailWeatherView];
        });
        // 1.75秒后显示weather view.




    }
}

-(void)GetCurrentData:(GetCurrentData *)getData getDataFailWithError:(NSError *)error{
    NSLog(@"获取数据失败.");

    [_updatingView showFailed];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.51f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showFailedView];
    });


    [self showError];

    // 发送统计信息。
    NSString *errMsg = [error localizedDescription];

    if (errMsg) {
        NSDictionary *attributes = @{@"ErrMsg": errMsg };
        [MobClick event:RequestWeatherDataFailedID attributes:attributes];
    }else{
        [MobClick endEvent:RequestWeatherDataFailedID];
    }


}
-(void)showError{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // @"Network Unreachable" ,@"Please try later.", @"Please try later."
        [[TWMessageBarManager sharedInstance]
         showMessageWithTitle:NSLocalizedString(@"NetWorkFTitle1", @"Network Unreachable")
         description: NSLocalizedString(@"NetWorkFMsg1", @"Please try later.")
         type:TWMessageBarMessageTypeError
         callback:nil];
    });
}

#pragma mark - GetHeWeatherDataDelegate
-(void)GetHeWeatherData:(nonnull GetHeWeatherData*)getData getDataFailWithError:(nonnull NSError*)error{
    NSLog(@"获取数据失败.");

    [_updatingView showFailed];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.51f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showFailedView];
    });


    [self showError];

    // 发送统计信息。
    NSString *errMsg = [error localizedDescription];

    if (errMsg) {
        NSDictionary *attributes = @{@"ErrMsg": errMsg };
        [MobClick event:RequestWeatherDataFailedID attributes:attributes];
    }else{
        [MobClick endEvent:RequestWeatherDataFailedID];
    }
}

-(void)GetHeWeatherData:(nonnull GetHeWeatherData*)getData getDataSuccessWithWeatherData:(nonnull CurrentWeatherData *)weatherData{

    if (weatherData) {

        if (_style == WeatherViewStyleLocationCity) {
            City *locationCity = [CityManager shareManager].locatedCity;
            locationCity.cityId = weatherData.city.cityId;
            locationCity.cityName = weatherData.city.cityName;
            locationCity.ZHCityName = weatherData.city.ZHCityName;
            locationCity.country = weatherData.city.country;

            // 如果未设置定位城市，发送定位城市信息更新数据。
            if (!_didSetLocationCity) {
                [self pushDidUpdateLocationCityInfoNotification];

            }
        }
        // 先隐藏再显示。
        [_weatherView hide];


        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.751f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _weatherView.weatherData = weatherData;
            [self showNormailWeatherView];
        });
        // 1.75秒后显示weather view.
        
        
        
        
    }
}

#pragma mark - WeatherViewDelegate;
-(void)weatherViewPullUp:(WeatherView *)weatherView{

    [self requestWeatheData];

    // 发送统计信息。
    [MobClick event:DragDownRequestWeatherDataID];

    //[_locationManager requestLocation];
    //[self getLocationAndFadeView];



}
-(void)weatherViewPullDown:(WeatherView *)weatherView{

    ForcastViewController *vc = [[ForcastViewController alloc]init];
    vc.requestType = ForcastRequestTypeCityName;
    if (isUsingHeWeatherData) {
        vc.requstParam = _getHeWeatherData.cityName;

    }else{
        vc.requstParam = _getCurrentdata.cityName;
    }

    [self presentViewController:vc animated:YES completion:nil];

    
}

-(void)weatherViewDidPressMoreItem:(WeatherView *)weatherView{
    CityListViewController *vc = [[CityListViewController alloc]init];
    [self presentViewController:vc animated:YES completion:^{
        [MobClick event:NormalEnterCityMangerID];
    }];
}

-(void)weatherViewDidPressShareItem:(WeatherView *)weatherView{

    // 把当前天气时图转换为图片复制进粘贴板。
    UIImage *snsImage = [[UIImage imageFromView:self.weatherView]imageBysize:CGSizeMake(self.view.width/2, self.view.height/2)];

    [UIPasteboard generalPasteboard].image = snsImage;

    // 弹出提醒窗口。
    NSString *alertTitle = NSLocalizedString(@"WVVCShareTitle1", @"Current weather share haven been generated."); // @"当前天气分享已生成！";
    NSString *alertMsg = NSLocalizedString(@"WVVCShareMsg1", @"Current weather share haven been generated. Please prase to APP what your wanted.");//@"当前天气分享已生成，请手动粘贴到需要分享的通讯应用中。";
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:alertTitle message:alertMsg preferredStyle:UIAlertControllerStyleAlert];

    // 去粘贴 按钮
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"WVVCShareGoPraseButton1", @"Go Prase") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIPasteboard generalPasteboard].image = snsImage;

    }];
    [alertC addAction:doneAction];

    //
    UIAlertAction *canncelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"WVVCSharecanncelButton1", @"Canncel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertC addAction:canncelAction];

    [self presentViewController:alertC animated:YES completion:nil];

#ifdef UM_OPEN
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAPPKey
                                      shareText:nil//shareText
                                     shareImage:snsImage
                                shareToSnsNames:nil
                                       delegate:self];
#endif

}

-(void)weatherViewDidPressRightButton:(WeatherView *)weatherView{
    [self requestWeatheData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UMSocialUIDelegate
#ifdef UM_OPEN

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
   // NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
#endif
#pragma mark - FailedLongPressViewDelegate
- (void)pressEvent:(FailedLongPressView *)view {
    
    [_failLongPressView hide];
    [self requestWeatheData];

    // 发送统计信息。
    [MobClick event:LongPressRequestWeatherDataID];
}

#pragma mark - Properties
-(void)setStatus:(WeatherViewStatus)status{
    _status = status;

    if (self.delegate && [self.delegate respondsToSelector:@selector(viewContoller:StatusDidChange:)]) {
        [self.delegate viewContoller:self StatusDidChange:_status];
    }

}

-(void)setCity:(City *)city{
    _city = city;
    
    [self requestWeatheData];
}
@end
