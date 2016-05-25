//
//  ForcastViewController.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/26.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "ForcastViewController.h"
#import "ForecastCell.h"
#import "ShowDownView.h"
#import "ForecastWeatherView.h"
#import "Categories.h"
#import "GetForcastWeatherData.h"
#import "ForcastWeatherData.h"
#import "CityDbData.h"

NSString *const DismissForcastViewCNotification = @"Dismiss Forcast View Controller Notification";

@interface ForcastViewController ()<UITableViewDataSource, UITableViewDelegate,GetForcastWeatherDataDelegate>
@property(nonnull,nonatomic,strong)ForcastWeatherData *forcastWeatherData;
@property(nonnull,nonatomic,strong)GetForcastWeatherData *getForcastData;

@property (nonatomic, strong) UIButton            *button;

@property (nonatomic, strong) UITableView         *tableView;
@property (nonatomic)         CGFloat              cellHeight;

@property (nonatomic, strong) NSMutableArray      *weatherDataArray;
@property (nonatomic, strong) ShowDownView        *showDownView;

@property (nonatomic, strong) ForecastWeatherView *forecastView;

@end

@implementation ForcastViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initTableView];

    //


    /*
    [GCDQueue executeInMainQueue:^{

        self.weatherDataArray = [NSMutableArray arrayWithArray:self.weatherCondition.list];

        NSMutableArray *indexPathArray = [NSMutableArray array];

        for (int count = 0; count < self.weatherDataArray.count; count++) {

            NSIndexPath *path = [NSIndexPath indexPathForRow:count inSection:0];
            [indexPathArray addObject:path];
        }

        [self.tableView insertRowsAtIndexPaths:indexPathArray
                              withRowAnimation:UITableViewRowAnimationFade];

    } afterDelaySecs:0.30f];
*/
    // 显示进入更多天气的view的提示信息
    self.showDownView        = [[ShowDownView alloc] initWithFrame:CGRectMake(0, 0, 30.f, 30.f / 3.f)];
    self.showDownView.center = self.view.center;
    self.showDownView.y      = -30.f;
    [self.tableView addSubview:self.showDownView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

    _getForcastData = [[GetForcastWeatherData alloc]initWithDelegate:self];

    switch (self.requestType) {
        case ForcastRequestTypeCityID:{
            _getForcastData.cityId = self.requstParam;
            [_getForcastData requestWithCityId];

            break;

        }
        case ForcastRequestTypeCityName:{
            _getForcastData.cityName = self.requstParam;
            [_getForcastData requestWithCityName];
            break;
        }
        case ForcastRequestTypeCoordinate:{
            _getForcastData.location = self.requstParam;
            [_getForcastData requestWithLocation];
            break;
        }


        default:
            break;
    }
}
- (void)initTableView {

    // cell高度
    self.cellHeight           =  WIDTH / 4.f;
    self.tableView            = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator   = NO;
    self.tableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ForecastCell class] forCellReuseIdentifier:@"ForecastCell"];

    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.weatherDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ForecastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForecastCell"];
    [cell acccessData:self.weatherDataArray[indexPath.row] indexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return self.cellHeight;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView.contentOffset.y <= -60) {

        [UIView animateWithDuration:0.5 animations:^{

            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:DismissForcastViewCNotification object:nil];
            }];
        });

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat percent = (-scrollView.contentOffset.y) / 60.f;
    [self.showDownView showPercent:percent];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    ForecastCell *forecastCell = (ForecastCell *)cell;
    [forecastCell show];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {

    ForecastCell *forecastCell = (ForecastCell *)cell;
    [forecastCell hide];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) {

        ForecastWeatherView *titleView = [[ForecastWeatherView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - WIDTH * 1.5)];
        [titleView buildView];



        titleView.countryCode = self.forcastWeatherData.city.country;

        if ([titleView.countryCode isEqualToString:@"CN"]) {
            NSString *temp = self.forcastWeatherData.city.cityName;

            temp = [[CityDbData shareCityDbData] requestZhCityNameByCityName:temp];
            temp = [temp stringByAppendingString:@"市"];
            if (temp) {

                titleView.cityName = [self addSpaceForZHStr:temp];


            }else{
                titleView.cityName    = self.forcastWeatherData.city.cityName;
            }
        }else{
            titleView.cityName    = self.forcastWeatherData.city.cityName;
        }

        UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - WIDTH * 1.5 - 1, WIDTH, 0.5)];
        line.backgroundColor = [UIColor blackColor];
        line.alpha           = 0.1f;
        [titleView addSubview:line];

        return titleView;

    } else {

        return nil;
    }
}

-(nonnull NSString *)addSpaceForZHStr:(nonnull NSString*) zhStr{
    NSString *str ;

    if (zhStr.length < 5) {
        NSMutableArray *strArray = [NSMutableArray arrayWithCapacity:4];

        for (int i = 0; i< zhStr.length; i++) {
            NSString *obj =  [zhStr substringWithRange:NSMakeRange(i, 1)];
            [strArray addObject:obj];
        }

        switch (zhStr.length) {
            case 1:{
                str = [NSString stringWithFormat:@"    %@",zhStr];
                break;
            }
            case 2:{
                str = [NSString stringWithFormat:@"  %@   %@",strArray[0],strArray[1] ];
                break;
            }
            case 3:{
                str = [NSString stringWithFormat:@"%@  %@  %@",strArray[0],strArray[1],strArray[2]];
                break;

            };
            case 4:{
                str = [NSString stringWithFormat:@"%@%@%@%@",strArray[0], strArray[1],strArray[2],strArray[3]];
                break;
            }
            default:
                break;
        }


    }else{
        str = zhStr;
    }

    return str;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return HEIGHT - WIDTH * 1.5;
}

#pragma mark - GetForcastWeatherDataDelegate
-(void)GetForcastWeatherData:(GetForcastWeatherData *)getData didUpdateSucessWithData:(ForcastWeatherData *)weatherData{
    self.forcastWeatherData = weatherData;

    self.weatherDataArray = weatherData.forcastWeatherList.mutableCopy;

    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[weatherData.cnt integerValue]];
    for (int i=0; i<_weatherDataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    if (indexPaths.count > 0) {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }

}
-(void)GetForcastWeatherData:(GetForcastWeatherData *)getData didUpdateFailWithError:(NSError *)error{
    
}

@end
