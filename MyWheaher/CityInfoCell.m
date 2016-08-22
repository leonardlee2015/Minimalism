//
//  CityInfoCell.m
//  MyWheaher
//
//  Created by  Leonard on 16/5/31.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "CityInfoCell.h"

@interface CityInfoCell (){
    UILabel *_cityLabel;
}
@end

@implementation CityInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self setTitleLabels];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setTitleLabels];
    }

    return  self;
}

-(void)setTitleLabels{
    

    
}

@end
