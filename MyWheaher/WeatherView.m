//
//  WheatherView.m
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/17.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "WeatherView.h"
#import "CityTitleView.h"
#import "MinMaxTempView.h"
#import "SunInfoView.h"
#import "WindSpeedView.h"
#import "TemperatureView.h"
#import "HumidityView.h"
#import "WeatherIconView.h"
#import "HSeparatorLine.h"
#import "VSeparatorLine.h"
#import "Categories.h"
#import "ShapeWordView.h"
#import "AddedFont.h"
#import "CurrentWeatherData.h"
#import "ShowDownView.h"

@interface WeatherView ()<UIScrollViewDelegate>{


    WeatherIconView *_iconView;
    TemperatureView  * _temperatureView;
    HumidityView * _humidityView;
    SunInfoView * _sunInfoView;
    WindSpeedView * _windSpeedView;
    MinMaxTempView *_minMaxTempView;
    CityTitleView *_cityTitleView;
    ShowDownView  *_showDownView;


    CGFloat _width;
    CGFloat _subViewWidth;
    CGFloat _cityTitleHeight;

    HSeparatorLine *_HSeparator1;
    HSeparatorLine *_HSeparator2;
    HSeparatorLine *_HSeparator3;
    HSeparatorLine *_HSeparator4;

    VSeparatorLine *_VSeparator;

    ShapeWordView *_shapeWorldView;

    __weak id<WeatherViewDelegate> _delegate;
}

@property(nonnull,nonatomic,strong) UIScrollView * baseView;
@end
@implementation WeatherView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];

    if (self) {
        // 初始化背景ScrollView.
        _baseView = [[UIScrollView alloc]initWithFrame:frame];
        _baseView.delegate = self;
        _baseView.restorationIdentifier = @"baseView";
        
        _baseView.alwaysBounceVertical = YES;
        [self addSubview:_baseView];

        // 初始化 子视图的框架元素.
        _width = self.width;
        _subViewWidth = self.width/2;

        _baseView.contentSize = self.size;

        if (iPhone4_4s) {
            _cityTitleHeight = self.height - 2.4 * _subViewWidth;

        }else{
            _cityTitleHeight = self.height - 3 * _subViewWidth;

        }

        _baseView.contentSize = CGSizeMake(self.width, _cityTitleHeight + 3* _subViewWidth);



        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];

    }
    return self;
}
-(void)buildView{
    // 初始化子视图

    _cityTitleView = [[CityTitleView alloc]initWithFrame:CGRectMake(0, 0, _width, _cityTitleHeight  )];
    _cityTitleView.restorationIdentifier = @"city title view";
    [_baseView addSubview:_cityTitleView];
    
    [_cityTitleView buildView];

    __weak typeof(self) weakSlef = self;

    _cityTitleView.moreItemHandler = ^(){
        if (weakSlef.delegate && [weakSlef.delegate respondsToSelector:@selector(weatherViewDidPressMoreItem:)]) {
            [weakSlef.delegate weatherViewDidPressMoreItem:weakSlef];
        }
    };

    _cityTitleView.shareItemHandler = ^{
        if (weakSlef.delegate && [weakSlef.delegate respondsToSelector:@selector(weatherViewDidPressShareItem:)]) {
            [weakSlef.delegate weatherViewDidPressShareItem:weakSlef];
        }
    };
    _cityTitleView.rightButtonHandler = ^{
        
        if (weakSlef.delegate && [weakSlef.delegate respondsToSelector:@selector(weatherViewDidPressRightButton:)]) {
            [weakSlef.delegate weatherViewDidPressRightButton:weakSlef];
        }
    };
    [_cityTitleView addHideLeftButtonGestruerToView:self];
    
    _iconView = [[WeatherIconView alloc]initWithFrame:CGRectMake(0, _cityTitleHeight, _subViewWidth, _subViewWidth)];
    [_baseView addSubview:_iconView];
    [_iconView buildView];

    _temperatureView = [[TemperatureView alloc]initWithFrame:CGRectMake(_subViewWidth, _cityTitleHeight, _subViewWidth, _subViewWidth)];
    [_baseView addSubview:_temperatureView];
    [_temperatureView buildView];

    _humidityView = [[HumidityView alloc]initWithFrame:CGRectMake(0, _cityTitleHeight+_subViewWidth, _subViewWidth, _subViewWidth)];
    [_baseView addSubview:_humidityView];
    [_humidityView buildView];

    _sunInfoView = [[SunInfoView alloc]initWithFrame:CGRectMake(_subViewWidth, _cityTitleHeight+_subViewWidth, _subViewWidth, _subViewWidth)];
    [_baseView addSubview:_sunInfoView];
    [_sunInfoView buildView];

#ifdef OLD
    if (!iPhone4_4s){
        _minMaxTempView = [[MinMaxTempView alloc]initWithFrame:CGRectMake(0, _cityTitleHeight+2*_subViewWidth, _subViewWidth, _subViewWidth)];
        [_baseView addSubview:_minMaxTempView];
        [_minMaxTempView buildView];

        _windSpeedView = [[WindSpeedView alloc]initWithFrame:CGRectMake(_subViewWidth, _cityTitleHeight+2*_subViewWidth, _subViewWidth, _subViewWidth)];
        [_baseView addSubview:_windSpeedView];
        [_windSpeedView buildView];

    }
#else
    _minMaxTempView = [[MinMaxTempView alloc]initWithFrame:CGRectMake(0, _cityTitleHeight+2*_subViewWidth, _subViewWidth, _subViewWidth)];
    [_baseView addSubview:_minMaxTempView];
    [_minMaxTempView buildView];

    _windSpeedView = [[WindSpeedView alloc]initWithFrame:CGRectMake(_subViewWidth, _cityTitleHeight+2*_subViewWidth, _subViewWidth, _subViewWidth)];
    [_baseView addSubview:_windSpeedView];
    [_windSpeedView buildView];

#endif

    // 初始化子视图间分割线

    _HSeparator1 = [[HSeparatorLine alloc]initWithFrame:CGRectMake(0, _cityTitleHeight, _width, 0.5)];
    [_baseView addSubview:_HSeparator1];
    [_baseView bringSubviewToFront:_HSeparator1];

    _HSeparator2 = [[HSeparatorLine alloc]initWithFrame:CGRectMake(0, _cityTitleHeight+_subViewWidth, _width, 0.5)];
    [_baseView addSubview:_HSeparator2];
    [_baseView bringSubviewToFront:_HSeparator2];

    _HSeparator3 = [[HSeparatorLine alloc]initWithFrame:CGRectMake(0, _cityTitleHeight+2*_subViewWidth, _width, 0.5)];
    [_baseView addSubview:_HSeparator3];
    [_baseView bringSubviewToFront:_HSeparator3];
#ifdef OLD
    if (!iPhone4_4s) {
        _HSeparator4 = [[HSeparatorLine alloc]initWithFrame:CGRectMake(0, _cityTitleHeight+3*_subViewWidth, _width, 0.5)];
        [_baseView addSubview:_HSeparator4];
        [_baseView bringSubviewToFront:_HSeparator4];

        _VSeparator = [[VSeparatorLine alloc]initWithFrame:CGRectMake(_subViewWidth, _cityTitleHeight, 0.5, 3 * _subViewWidth)];


    }else{

        _VSeparator = [[VSeparatorLine alloc]initWithFrame:CGRectMake(_subViewWidth, _cityTitleHeight, 0.5, 2 * _subViewWidth)];
    }
#else
    _HSeparator4 = [[HSeparatorLine alloc]initWithFrame:CGRectMake(0, _cityTitleHeight+3*_subViewWidth, _width, 0.5)];
    [_baseView addSubview:_HSeparator4];
    [_baseView bringSubviewToFront:_HSeparator4];

    _VSeparator = [[VSeparatorLine alloc]initWithFrame:CGRectMake(_subViewWidth, _cityTitleHeight, 0.5, 3 * _subViewWidth)];

#endif
    [_baseView addSubview:_VSeparator];
    [_baseView bringSubviewToFront:_VSeparator];

    // 添加上拉刷新view
    _shapeWorldView = [[ShapeWordView alloc]initWithFrame:CGRectMake(0, -60, WIDTH, 60)];
    _shapeWorldView.text = NSLocalizedString(@"SWViewTitle", @"Release To Reflesh") ;
    _shapeWorldView.font = [UIFont fontWithName:LATO_THIN size:20.f];;
    _shapeWorldView.lineWidth = 0.5f;
    _shapeWorldView.lineColor = [UIColor redColor];
    [_shapeWorldView buildView];
    [_baseView addSubview:_shapeWorldView];

    // 添加上拉 show down view.
    _showDownView = [[ShowDownView  alloc]initWithFrame:CGRectMake(0, 0, 30, 10)];
    _showDownView.center = CGPointMake(self.width/2, self.baseView.contentSize.height+20.f);
    [_baseView addSubview:_showDownView];


    // 添加 tab 取消按钮弹窗手势。


}

-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    if (!self.weatherData) {
        return;
    }

    [self resetContentInset];
    //为各子视图赋值
    _cityTitleView.city = _weatherData.city;
    _cityTitleView.station = _weatherData.station;
    _cityTitleView.updateTime = _weatherData.updateTime;
    _cityTitleView.wheather = _weatherData.weather.weatherDescription;

    _iconView.wheatherCode = _weatherData.weather.weatherCode;

    _temperatureView.temperature = _weatherData.Temperature.temp;

    _humidityView.Humidity = [_weatherData.humidity floatValue];

    _sunInfoView.sunrizeAndSunset = _weatherData.sunrizeSunset;

    _minMaxTempView.minTemp = [_weatherData.Temperature.minTemp floatValue];
    _minMaxTempView.maxTemp = [_weatherData.Temperature.maxTemp floatValue];

    _windSpeedView.windSpeed = [_weatherData.windSpeed floatValue];
    _windSpeedView.circleByOneSecond = [_weatherData.windSpeed floatValue] / 10.f;

    
    // 子视图动画
    [_cityTitleView showByDuration:duration delay:delay];
    [_iconView showByDuration:duration delay:delay];
    [_temperatureView showByDuration:duration delay:delay];
    [_humidityView showByDuration:duration delay:delay];
    [_sunInfoView showByDuration:duration delay:delay];
    [_minMaxTempView showByDuration: duration delay:delay];
    [_windSpeedView showByDuration:duration delay:delay];

    [_HSeparator1 showByDuration:duration delay:delay];
    [_HSeparator2 showByDuration:duration delay:delay];
    [_HSeparator3 showByDuration:duration delay:delay];
    [_HSeparator4 showByDuration:duration delay:delay];

    [_VSeparator showByDuration:duration delay:delay];


}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{

    [self resetContentInset];
    // 子视图动画
    [_cityTitleView hideByDuration:duration delay:delay];
    [_iconView hideByDuration:duration delay:delay];
    [_temperatureView hideByDuration:duration  delay:delay];
    [_humidityView hideByDuration:duration delay:delay];
    [_sunInfoView hideByDuration:duration delay:delay];
    [_minMaxTempView hideByDuration:duration delay:delay];
    [_windSpeedView hideByDuration:duration delay:delay];

    [_HSeparator1 hideByDuration:duration delay:delay];
    [_HSeparator2 hideByDuration:duration delay:delay];
    [_HSeparator3 hideByDuration:duration delay:delay];
    [_HSeparator4 hideByDuration:duration delay:delay];

    [_VSeparator hideByDuration:duration delay:delay];

    
}
-(CGFloat)scaleConst{
    return 1;
}

@dynamic delegate;

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSValue *rectValue = change[NSKeyValueChangeNewKey];
    CGRect newFrame = [rectValue CGRectValue];

    _baseView.frame = newFrame;
    _width = newFrame.size.width;
    _subViewWidth = _width/2;


    [self buildView];
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"frame"];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat moreHeight = scrollView.contentSize.height - self.height;

    CGFloat percent = (scrollView.contentOffset.y - fabs(moreHeight))/60.f;
    [_showDownView showPercent:percent];

    CGFloat offsetY = -scrollView.contentOffset.y;

    if (offsetY >= 0) {
        CGFloat percent  = offsetY / 60.f;
        [_shapeWorldView percent:percent animated:YES];
    }


}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= - 60.f) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(weatherViewPullUp:)]) {
            [self.delegate weatherViewPullUp:self];

        }

        _baseView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);

    }

    CGFloat moreHeight = scrollView.contentSize.height - self.height;

    if (offsetY > fabs(moreHeight) + 60.f) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(weatherViewPullDown:)]){
            [self.delegate weatherViewPullDown:self];
        }
    }

}

-(void)resetContentInset{
    _baseView.contentInset = UIEdgeInsetsZero;
}

/*
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


}
*/

@end
