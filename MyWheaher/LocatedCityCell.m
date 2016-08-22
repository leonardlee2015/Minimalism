//
//  LocatedCityCell.m
//  MyWheaher
//
//  Created by  Leonard on 16/7/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "LocatedCityCell.h"
#import "LineBackgroundView.h"

@interface LocatedCityCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *CityLabel;
@property (weak, nonatomic) IBOutlet UILabel *TemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imdicateImageView;
@property (nonnull,strong,nonatomic) LineBackgroundView *BGView;


@end
@implementation LocatedCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self buildView];

}

-(void)buildView{
    
    // 设置位置指视View。
    CGSize size = _imdicateImageView.size;
    _imdicateImageView.image = [UIImage imageNamed:@"Location" size:size];




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
        self.CityLabel.text = city.cityName;
        self.CityLabel.text = @"厦门";

    }else if([city.country isEqualToString:@"CN"]   ){
        self.CityLabel.text = city.ZHCityName;

    }else{
        self.CityLabel.text = city.cityName;
    }

    if (!city.temperature) {
        _TemperatureLabel.text = @"°C";

    }else{
        _TemperatureLabel.text = [NSString stringWithFormat:@"%ld°" , [city.temperature integerValue]];
    }


    
}
@end
