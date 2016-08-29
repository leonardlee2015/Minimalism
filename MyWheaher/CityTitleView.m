//
//  CityTitleView.m
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/15.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "CityTitleView.h"
#import "WheatherViewAnimationState.h"
#import "AddedFont.h"
#import "Categories.h"
#import "City.h"
#import "LeftCityInfoView.h"



@interface CityTitleView (){
    UILabel *_stationLabel;
    WheatherViewAnimationState *_stationLabelAnimationState;
    
    UILabel *_cityLabel;
    WheatherViewAnimationState *_cityLabelAnimationState;
    
    UILabel *_wheatherLabel;
    WheatherViewAnimationState *_wheatherLabelAnimationState;
    
    UILabel *_updateDateLabel;
    WheatherViewAnimationState *_updateDateLabelAnimationState;
    
    UILabel *_updateTimeLabel;
    WheatherViewAnimationState *_updateTimeLabelAnimationState;
    
    UIView *_wheatherView;
    WheatherViewAnimationState *_wheatherViewAnimationState;
    
    UIButton *_rightView;
    WheatherViewAnimationState *_rightViewAnimationState;

    LeftCityInfoView *_leftView;
    
    
}

@property (nonatomic,copy) NSString *updatedDate;
@property (nonatomic,copy) NSString *updatedTime;

@end

@implementation CityTitleView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _stationLabelAnimationState = [WheatherViewAnimationState new];
        _cityLabelAnimationState = [WheatherViewAnimationState new];
        _wheatherLabelAnimationState = [WheatherViewAnimationState new];
        _wheatherViewAnimationState = [WheatherViewAnimationState new];
        _updateDateLabelAnimationState = [WheatherViewAnimationState new];
        _updateTimeLabelAnimationState = [WheatherViewAnimationState new];
        _rightViewAnimationState = [WheatherViewAnimationState new];

        
    }
    return self;
}
-(void)buildView{
    // 创建 state lalel
    _stationLabel = [[UILabel alloc]initWithFrame:ScaleRectMake(0, 5, WIDTH-8, 12.f)];
    _stationLabel.textAlignment = NSTextAlignmentRight;
    _stationLabel.text = self.station;
    _stationLabel.font = [UIFont fontWithName:LATO_BOLD size:MOD(10.f)];
    _stationLabel.alpha = 0.f;
    
    [self MoveWithMidRect:_stationLabel.frame startOffsetP:ScalePointMake(10, 0) endOffsetP:ScalePointMake(-10, 0) WithAnimationState:_stationLabelAnimationState];
    _stationLabel.frame = [_stationLabelAnimationState CGRectStartState];
    [self addSubview:_stationLabel];
    
    //创建City Label
    _cityLabel = [[UILabel alloc]initWithFrame:ScaleRectMake(12, 17, WIDTH - 10, 40)];
    _cityLabel.textAlignment = NSTextAlignmentLeft;
    _cityLabel.text = self.city.cityName;
    _cityLabel.font = [UIFont fontWithName:LATO_REGULAR size:MOD(30)];
    _cityLabel.alpha = 0.f;
    
    [self MoveWithMidRect:_cityLabel.frame startOffsetP:ScalePointMake(-5, 0) endOffsetP:ScalePointMake(5.f, 0.f) WithAnimationState:_cityLabelAnimationState];
    _cityLabel.frame = [_cityLabelAnimationState CGRectStartState];
    [self addSubview:_cityLabel];
    
    //创建 wheather Label
    _wheatherLabel = [[UILabel alloc]initWithFrame:ScaleRectMake(15, 62, WIDTH - 10, 20)];
    _wheatherLabel.textAlignment = NSTextAlignmentLeft;
    _wheatherLabel.text = self.wheather;
    _wheatherLabel.font = [UIFont fontWithName:LATO_THIN size:MOD(16)];
    _wheatherLabel.alpha = 0.f;
    
    [self MoveWithMidRect:_wheatherLabel.frame startOffsetP:ScalePointMake(-8, 0) endOffsetP:ScalePointMake(8.f, 0.f) WithAnimationState:_wheatherLabelAnimationState];
    _wheatherLabel.frame = [_wheatherLabelAnimationState CGRectStartState];
    [self addSubview:_wheatherLabel];
    
    //创建 Update Date Label
    _updateDateLabel = [[UILabel alloc]initWithFrame:ScaleRectMake(0, 30, WIDTH - 40, 17)];
    _updateDateLabel.textAlignment = NSTextAlignmentRight;
    _updateDateLabel.text = self.updatedDate;
    _updateDateLabel.font = [UIFont fontWithName:LATO_LIGHT size:MOD(16)];
    _updateDateLabel.textColor = [UIColor blackColor];
    //_updateDateLabel.textColor = [UIColor whiteColor];

    _updateDateLabel.alpha = 0.f;
    
    [self MoveWithMidRect:_updateDateLabel.frame startOffsetP:ScalePointMake(20.f, 0) endOffsetP:ScalePointMake(-20.f, 0.f) WithAnimationState:_updateDateLabelAnimationState];
    _updateDateLabel.frame = [_updateDateLabelAnimationState CGRectStartState];
    [self addSubview:_updateDateLabel];
    
    
    //创建 Update Time Label
    _updateTimeLabel = [[UILabel alloc]initWithFrame:ScaleRectMake(0, 55, WIDTH - 8, 20)];
    _updateTimeLabel.textAlignment = NSTextAlignmentRight;
    _updateTimeLabel.text = self.updatedTime;
    _updateTimeLabel.font = [UIFont fontWithName:LATO_REGULAR size:MOD(16)];
    _updateTimeLabel.textColor = [UIColor blackColor];
    //_updateTimeLabel.textColor = [UIColor whiteColor];

    _updateTimeLabel.alpha = 0.f;
    
    [self MoveWithMidRect:_updateTimeLabel.frame startOffsetP:ScalePointMake(15.f, 0) endOffsetP:ScalePointMake(-15.f, 0.f) WithAnimationState:_updateTimeLabelAnimationState];
    _updateTimeLabel.frame = [_updateTimeLabelAnimationState CGRectStartState];
    [self addSubview:_updateTimeLabel];
    
    // 创建  left black view.
    _leftView  = [[LeftCityInfoView alloc]initWithFrame:ScaleRectMake(0, 22, 138, 60)];
    [_leftView buildView];
    [_leftView addButtonItemWithImage:[UIImage imageNamed:@"main_weahter_view_menu"]
                     HeightLightImage:[UIImage imageNamed:@"main_weahter_view_menu_black"]
                      backgroundColor:color(74, 144, 226, 1)
                               target:self action:@selector(callMoreItem:)];
    [_leftView addButtonItemWithImage:[UIImage imageNamed:@"share"]
                     HeightLightImage:[UIImage imageNamed:@"share_black"]
                      backgroundColor:color(211, 0, 0, 1)
                               target:self
                               action:@selector(callShareItem:)];


    [self addSubview:_leftView];
    [self bringSubviewToFront:_leftView];
    

    
    
    // 创建  Right red view.
    _rightView = [UIButton buttonWithType:UIButtonTypeSystem];
    [_rightView  setFrame:ScaleRectMake(WIDTH -135, 22, 135+100, 60)];
    //_rightView.backgroundColor = [UIColor  redColor];
    _rightView.backgroundColor = [UIColor orangeColor];
    _rightView.alpha = 0.f;

    [_rightView addTarget:self action:@selector(pressRightButton:) forControlEvents:UIControlEventTouchUpInside];

    [self MoveWithMidRect:_rightView.frame startOffsetP:ScalePointMake(30, 0) endOffsetP:ScalePointMake(-30, 0) WithAnimationState:_rightViewAnimationState];
    _rightView.frame = [_rightViewAnimationState CGRectStartState];
    [self addSubview:_rightView];
    [self sendSubviewToBack:_rightView];

    
    
}

-(IBAction)callMoreItem:(id)sender{
    [_leftView hideButtunItems];
    if (self.moreItemHandler) {
        self.moreItemHandler();
    }
}
-(IBAction)callShareItem:(id)sender{
    [_leftView hideButtunItems];
    if (self.shareItemHandler) {
        self.shareItemHandler();
    }
}

-(void)pressRightButton:(UIButton*) button{
    if (self.rightButtonHandler) {
        self.rightButtonHandler();
    }
}
-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    
    [self ToAnimationStartState];
    [_leftView showByDuration:duration delay:delay];

    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [self ToAnimationMidState];

    } completion:^(BOOL finished) {
        if (!finished) {
            [self ToAnimationMidState];
        }
    }];
    
    [super showByDuration:duration delay:delay];
}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [_leftView hideByDuration:duration delay:delay];

    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [self ToAnimationEndState];
    } completion:^(BOOL finished) {
        if (!finished) {
            [self ToAnimationEndState];
        }
    }];
    
    [super hideByDuration:duration delay:delay];
    
}
-(void)ToAnimationStartState{
    _cityLabel.frame = [_cityLabelAnimationState CGRectStartState];
    _cityLabel.alpha = 0.f;
    
    _wheatherLabel.frame = [_wheatherLabelAnimationState CGRectStartState];
    _wheatherLabel.alpha = 0.f;
    
    _updateDateLabel.frame = [_updateDateLabelAnimationState CGRectStartState];
    _updateDateLabel.alpha = 0.f;
    
    _updateTimeLabel.frame = [_updateTimeLabelAnimationState CGRectStartState];
    _updateTimeLabel.alpha = 0.f;
    
    _stationLabel.frame = [_stationLabelAnimationState CGRectStartState];
    _stationLabel.alpha = 0.f;

    _rightView.frame = [_rightViewAnimationState  CGRectStartState];
    _rightView.alpha = 0.f;
    
}

-(void)ToAnimationMidState{
    _cityLabel.frame = [_cityLabelAnimationState CGRectMidState];
    _cityLabel.alpha = 1.f;
    
    _wheatherLabel.frame = [_wheatherLabelAnimationState CGRectMidState];
    _wheatherLabel.alpha = 1.f;
    
    _updateDateLabel.frame = [_updateDateLabelAnimationState CGRectMidState];
    _updateDateLabel.alpha = 1.f;
    
    _updateTimeLabel.frame = [_updateTimeLabelAnimationState CGRectMidState];
    _updateTimeLabel.alpha = 1.f;
    
    _stationLabel.frame = [_stationLabelAnimationState CGRectMidState];
    _stationLabel.alpha = 1.f;
    

    _rightView.frame = [_rightViewAnimationState  CGRectMidState];
    _rightView.alpha = 1.f;
}

-(void)ToAnimationEndState{

    _cityLabel.frame = [_cityLabelAnimationState CGRectEndState];
    _cityLabel.alpha = 0.f;
    
    _wheatherLabel.frame = [_wheatherLabelAnimationState CGRectEndState];
    _wheatherLabel.alpha = 0.f;
    
    _updateDateLabel.frame = [_updateDateLabelAnimationState CGRectEndState];
    _updateDateLabel.alpha = 0.f;
    
    _updateTimeLabel.frame = [_updateTimeLabelAnimationState CGRectEndState];
    _updateTimeLabel.alpha = 0.f;
    
    _stationLabel.frame = [_stationLabelAnimationState CGRectEndState];
    _stationLabel.alpha = 0.f;

    
    _rightView.frame = [_rightViewAnimationState  CGRectEndState];
    _rightView.alpha = 0.f;

}

#pragma mark - Properties
-(void)setCity:( City*)city{
    _city = city;
    
    if (_city) {
        if ([city.country isEqualToString:@"CN"] && ![_city.ZHCityName isEqualToString:@""]) {
            _cityLabel.text = city.ZHCityName;
        }else{
            _cityLabel.text = _city.cityName;

        }
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
                str = [NSString stringWithFormat:@"  %@  %@",strArray[0],strArray[1] ];
                break;
            }
            case 3:{
                str = [NSString stringWithFormat:@"%@ %@ %@",strArray[0],strArray[1],strArray[2]];
                break;

            };
            case 4:{
                str = [NSString stringWithFormat:@"%@ %@ %@ %@",strArray[0], strArray[1],strArray[2],strArray[3]];
                break;
            }
            default:{
                str = zhStr;
            }
                
        }


    }else{
        str = zhStr;
    }
    
    return str;
}

-(void)setStation:(NSString *)station{
    _station = [station copy];
    if (_station) {
        _stationLabel.text = _station;
        
    }
}

-(void)setWheather:(NSString *)wheather{
    _wheather = [wheather copy];
    if (_wheather) {
        _wheatherLabel.text = _wheather;
    }
}

-(void)setUpdateTime:(NSDate *)updateTime{
    _updateTime = updateTime;
    
    if (_updateTime) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.locale = [NSLocale currentLocale];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
        self.updatedDate = [[dateFormatter stringFromDate:_updateTime]stringByAppendingString:@""];
        
        NSDateFormatter *timeFormatter = [NSDateFormatter new];
        timeFormatter.locale = [NSLocale currentLocale];
        timeFormatter.dateFormat = @"hh:mm";
        
        self.updatedTime = [[timeFormatter stringFromDate:_updateTime]stringByAppendingString:NSLocalizedString(@"CityInfoViewUpdateTimeLabel1", @" update")];
        
        
        
    }
}

-(void)setUpdatedDate:(NSString *)updatedDate{
    _updatedDate = updatedDate;
    
    if (_updatedDate) {
        _updateDateLabel.text = _updatedDate;
    }
}

-(void)setUpdatedTime:(NSString *)updatedTime{
    _updatedTime = updatedTime;
    if (_updatedTime) {
        _updateTimeLabel.text = _updatedTime;
    }
}
-(void)show{
    [self showByDuration:0.75f delay:0];
}
-(CGFloat)scaleConst{
    return (self.width/2)/207;
}
@end
