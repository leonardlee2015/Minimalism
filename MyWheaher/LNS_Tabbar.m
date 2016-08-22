//
//  LNS_Tabbar.m
//  DynamicTabBar
//
//  Created by  Leonard on 16/5/18.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "LNS_Tabbar.h"
#import "UIView+SetRect.h"
#import "UIImage+BitMap.h"
#import <FLKAutoLayout.h>

@interface LNS_Tabbar ()
//@property(nonatomic,nonnull,strong)UIButton *leftButton;
@property(nonnull,nonatomic,strong)UIButton *rightButton;
@property(nonnull,nonatomic,strong)UIPageControl *pageControl;

@end
@implementation LNS_Tabbar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if (self.width==0 && self.height==0) {
            self.width = [UIScreen mainScreen].bounds.size.width;
            self.height = 41 + 64 + 4;
        }
        [self setup];

    }

    return self;
}

-(void)setup{
    //  关闭comstom tabbar content view 交互使能,使事件能传送到后面的视图。
    self.userInteractionEnabled = NO;

    // 设置背景为透明
    self.backgroundColor = [UIColor clearColor];

    

    // 添加顶部分割线
    UIView *view = [[UIView alloc]init];
    [self addSubview:view];
    view.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.75];


    [view alignTopEdgeWithView:self predicate:@"0"];
    [view alignLeading:@"0" trailing:@"0" toView:self];
    [view constrainHeight:@"0.5"];
#if 0
    // 添加左边按钮
    UIImage *image
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];


    //添加左填视图
    UIView *leftView = [[UIView alloc]init];
    [self addSubview:leftView];
    leftView.backgroundColor = [UIColor clearColor];

    [leftView constrainAspectRatio:@"1"];
    [leftView constrainHeight:@"37"];
#endif
    // 添加右视图

    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setBackgroundColor:[UIColor yellowColor]];

    UIImage *menuImage = [UIImage imageNamed:@"menu2" size:CGSizeMake(64, 64)];
    UIImage *renderImage = [menuImage imageWithGradientTintColor:[UIColor colorWithWhite:0.95 alpha:0.75]];
    [_rightButton setImage:renderImage forState:UIControlStateNormal];
    [_rightButton setImage:menuImage forState:UIControlStateHighlighted];
    [_rightButton setTintColor:[UIColor clearColor]];
    _rightButton.backgroundColor = [UIColor clearColor];

    [_rightButton addTarget:self action:@selector(clickRightBarItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: _rightButton];

    [_rightButton constrainHeight:@"64"];
    [_rightButton constrainAspectRatio:@"1"];
    [_rightButton alignTrailingEdgeWithView:self predicate:@"-8"];
    [_rightButton alignTopEdgeWithView:self predicate:@"4"];





    //[_rightButton constrainHeight:@"37"];
    //[_rightButton constrainAspectRatio:@"1"];

    // 中间 pageControl
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.enabled  = YES;
    _pageControl.numberOfPages = 0;
    _pageControl.currentPage = 0;

    [_pageControl addTarget:self action:@selector(pageValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];

    [_pageControl alignLeading:@"8" trailing:@"-8" toView:self];
    [_pageControl constrainTopSpaceToView:_rightButton predicate:@"0"];
    [_pageControl alignBottomEdgeWithView:self predicate:@"-4"];
    [_pageControl constrainHeight:@"37"];
}



#pragma mark - Actions
-(IBAction)clickRightBarItem:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbarRightBarItemDidClick:)]) {
        [self.delegate  tabbarRightBarItemDidClick:self];
    }
}

-(IBAction)clickLeftBarItem:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbarLeftBarItemDidClick:)]) {
        [self.delegate  tabbarLeftBarItemDidClick:self];
    }
}
-(IBAction)pageValueDidChange:(id)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbar:pageValueDidChange:)]) {
        [self.delegate tabbar:self pageValueDidChange:_pageControl.currentPage];
    }
}

#pragma mark - Properties
@dynamic numOfPages;
@dynamic currentPage;
-(void)setNumOfPages:(NSUInteger)numOfPages{
    _pageControl.numberOfPages = numOfPages;
}
-(NSUInteger)numOfPages{
    return  _pageControl.numberOfPages;
}
-(NSUInteger)currentPage{
    return _pageControl.currentPage;
}
-(void)setCurrentPage:(NSUInteger)currentPage{
    _pageControl.currentPage = currentPage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
