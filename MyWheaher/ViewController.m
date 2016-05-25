//
//  ViewController.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/17.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "ViewController.h"
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

@interface ViewController ()<CLLocationManagerDelegate,GetCurrentDataDelegate,WeatherViewDelegate,FailedLongPressViewDelegate>{
    FadeBlackView *_fadeBlackView;
    UpdatingView *_updatingView;
    FailedLongPressView *_failLongPressView;



}
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) GetCurrentData *getCurrentdata;
@property(nonatomic,strong) WeatherView *weatherView;
@end

@implementation ViewController

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

    


    // 开始获取地址坐标。
    [self getLocationAndFadeView];
    

    // 隐藏status bar.
   // [self setNeedsStatusBarAppearanceUpdate];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];


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
-(void)getLocationAndFadeView{
    // 显示失败显示画面。
    [_fadeBlackView show];
    [_updatingView show];

    // 开始定位。
    if (_getCurrentdata.cityName) {
        [_getCurrentdata requestWithCityName];

    }else{
        [_locationManager startUpdatingLocation];
    }
}



#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{


    CLLocation *location = [locations lastObject];

    NSLog(@"定位成功:%@",location);

    // 延时执行取数据程序, 并取消上一项请求以排除干扰
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [self performSelector:@selector(delayRequstDataByCoordinate:) withObject:location afterDelay:0.8f];




}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([CLLocationManager locationServicesEnabled] == NO) {

        NSLog(@"定位失败，定位服务关闭！");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_fadeBlackView hide];
            [_updatingView hide];

            [_failLongPressView show];
        });

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[TWMessageBarManager sharedInstance]showMessageWithTitle:@"Failed to locate" description:@"Please turn on your Locations Service." type:TWMessageBarMessageTypeError];
        });

    }else{

        NSLog(@"定位失败，未能定位当前位置！");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_fadeBlackView hide];
            [_updatingView hide];

            [_failLongPressView show];
        });

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[TWMessageBarManager sharedInstance]showMessageWithTitle:@"Failed to locate" description:@"Sorry, temporarily unable to locate your position." type:TWMessageBarMessageTypeError];
        });

    }


}

-(void)delayRequstDataByCoordinate:(CLLocation*)location{


    CLGeocoder *coder = [CLGeocoder new];


    // 强制是系统语言环境设置为英文，获取英文城市名称。
    NSMutableArray *userDefultLanguage = [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"];

    [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithObjects:@"en-US", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"]);


        [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            //NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"]);
            if (error) {
#pragma Warning - 错误处理逻辑未设置，日后需设置处理逻辑。
                NSLog(@"获取城市名称失败.[%@]", [error description]);
            }else{

                CLPlacemark *mark  = placemarks.firstObject;

                NSString *cityName = mark.addressDictionary[@"City"];


                // 获取英文城市名成功，根据城市名查询天气信息，如果城市名为中文，从数据库获取中文城市名。
                if (![cityName isEqualToString:@""]) {
                    NSLog(@"当前城市是: %@",cityName);

                    if([mark.country isEqualToString:@"China"]){
                        _getCurrentdata.ZNCithName = [[CityDbData shareCityDbData] requestZhCityNameByCityName:cityName];
                        _getCurrentdata.ZNCithName = [_getCurrentdata.ZNCithName stringByAppendingString:@"市"];

                    }
                    _getCurrentdata.cityName = cityName;

                    [_getCurrentdata requestWithCityName];

                }
                
            }
            // 还原中文城市名。
            [[NSUserDefaults standardUserDefaults]setObject:userDefultLanguage forKey:@"AppleLanguages"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];









}
#pragma mark - GetCurrentDataDelegate
-(void)GetCurrentData:(GetCurrentData *)getData getDataSuccessWithWeatherData:(CurrentWeatherData *)weatherData{
    if (weatherData) {
        // 先隐藏再显示。

        dispatch_async(dispatch_get_main_queue(), ^{
            [_weatherView hide];
        });


        // 1.75秒后显示weather view.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7501f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _weatherView.weatherData = weatherData;
            [_weatherView show];

            [_fadeBlackView hide];
            [_updatingView hide];

        });

        // 隐藏fail view.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7501f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_failLongPressView remove];
        });


    }
}

-(void)GetCurrentData:(GetCurrentData *)getData getDataFailWithError:(NSError *)error{
    NSLog(@"获取数据失败.");

    [_updatingView showFailed];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.51f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_updatingView hide];
        [_fadeBlackView hide];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.51f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_failLongPressView show];
    });

    [self showError];

}
-(void)showError{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Network Unreachable"
                                                       description:@"Please try later."
                                                              type:TWMessageBarMessageTypeError
                                                          callback:^{}];
    });
}
 #pragma mark - WeatherViewDelegate;
-(void)weatherViewPullUp:(WeatherView *)weatherView{

    [self getLocationAndFadeView];
    //[_locationManager requestLocation];
    //[self getLocationAndFadeView];



}
-(void)weatherViewPullDown:(WeatherView *)weatherView{

    ForcastViewController *vc = [[ForcastViewController alloc]init];
    vc.requestType = ForcastRequestTypeCityName;
    vc.requstParam = _getCurrentdata.cityName;

    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FailedLongPressViewDelegate
- (void)pressEvent:(FailedLongPressView *)view {

    [_failLongPressView hide];
    [self getLocationAndFadeView];
}


@end
