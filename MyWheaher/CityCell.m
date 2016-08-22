//
//  CityCell.m
//  MyWheaher
//
//  Created by  Leonard on 16/7/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "CityCell.h"
#import "LineBackgroundView.h"

@interface CityCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (nonnull,strong,nonatomic) LineBackgroundView *BGView;

@end
@implementation CityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self buildView];
}


-(void)buildView{
/*
    // 设置背景view.
    LineBackgroundView *backgroundView = [LineBackgroundView \
                                          createViewWithFrame:self.bounds\
                                          LineWidth:4.f \
                                          lineGap:4.f \
                                          lineColor:[[UIColor blackColor]colorWithAlphaComponent:0.015f] ];
    backgroundView.backgroundColor = [UIColor clearColor];
    _BGView = backgroundView;
    [self insertSubview:backgroundView atIndex:0];
  */
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_BGView removeFromSuperview];
    LineBackgroundView *backgroundView = [LineBackgroundView \
                                          createViewWithFrame:self.bounds\
                                          LineWidth:4.f \
                                          lineGap:4.f \
                                          lineColor:[[UIColor blackColor]colorWithAlphaComponent:0.015f] ];
    backgroundView.backgroundColor = [UIColor clearColor];
    _BGView = backgroundView;
    [self insertSubview:backgroundView atIndex:0];

}
-(void)setCity:(City *)city{
    // set timeLabel;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"hh:mm";
    formatter.locale = [NSLocale localeWithLocaleIdentifier:city.country];
    self.timeLabel.text = [formatter stringFromDate:[NSDate date]];

    // set city label;
    if (!city.cityName) {
        self.cityLabel.text = @"厦门";

    }else if(
             ([city.country isEqualToString:@"CN"]||[city.country isEqualToString:@"China"])
              && city.ZHCityName && city.ZHCityName.length >0
             ){
        self.cityLabel.text = city.ZHCityName;

    }else{
        self.cityLabel.text = city.cityName;
    }

    if (!city.temperature) {
        _temperatureLabel.text = @"°C";

    }else{
        _temperatureLabel.text = [NSString stringWithFormat:@"%ld°" , [city.temperature integerValue]];
    }

}
@end
