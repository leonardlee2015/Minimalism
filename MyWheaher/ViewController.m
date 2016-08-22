//
//  RootViewController.m
//  MyWheaher
//
//  Created by  Leonard on 16/7/27.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "ViewController.h"
#import "WeatherViewController.h"
#import "CityListViewController.h"
#import "MWHeWeatherClient.h"
#import <FLKAutoLayout.h>

NSString *const didChangedCityHanderIdentifier = @"weatherView did change handler id";
NSString *const didremoveCityHanderIdentifier = @"weatherView did remove handler id";
NSString *const didselectCityHanderIdentifier = @"weatherView did select handler id";
NSString *const didupdateCityHanderIdentifier = @"weatherView did update handler id";

@interface ViewController ()<UIScrollViewDelegate,WeatherViewControllerDelegate>
@property(nonatomic,nonnull,strong)UIScrollView *contentView;
@property(nonnull,nonatomic,readonly) CityManager *cityManager;
@property(nonnull,nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic)NSUInteger currentWeatherViewIndex;
@property(nonnull,nonatomic,strong)UIButton *requstingMenu;
@property(nonatomic,nonnull,strong)UIButton *failedMenu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self initializeChildViewController];
    [self initializePageControl];
    [self initMenu];
    [self initializeContentView];
    [self initializeCityManagerHandlers];




}

-(void)initializeCityManagerHandlers{
    __weak typeof(self) weakSlef = self;
    [self.cityManager addDidSelectCityHandler:^(City * _Nullable city, CityType type, NSUInteger index) {
        if (type == CityTypelocation) {
            weakSlef.currentWeatherViewIndex = 0;
            [weakSlef.contentView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else{
            weakSlef.currentWeatherViewIndex = index + 1;
            CGPoint offset = CGPointMake((index+1) * weakSlef.contentView.width , 0);

            [weakSlef.contentView setContentOffset:offset animated:YES];

        }
    } withIdentifier:didselectCityHanderIdentifier];

    [self.cityManager addDidChangedCityHandler:^(City * _Nullable city, CityType type, NSUInteger index) {
        if (type == CityTypeNormal) {
            if (index >= self.childViewControllers.count-1) {
                WeatherViewController *weatherVC = [[WeatherViewController alloc]initWithStyle:WeatherViewstyleTargetCity];
                weatherVC.delegate = weakSlef;

                weatherVC.city = city;
                [weakSlef addChildViewController:weatherVC];

                weakSlef.contentView.contentSize = CGSizeMake(weakSlef.contentView.width* (weakSlef.cityManager.citys.count+1), weakSlef.contentView.height);
                weakSlef.pageControl.numberOfPages = weakSlef.childViewControllers.count;
            }else {
                WeatherViewController *weatherVC = weakSlef.childViewControllers[index+1];
                weatherVC.city = city;

            }

            weakSlef.pageControl.numberOfPages = weakSlef.childViewControllers.count;

        }
    } withIdentifier:didChangedCityHanderIdentifier];

    [self.cityManager addDidremoveCityHandler:^(City * _Nullable city, CityType type, NSUInteger index) {
        if (type == CityTypeNormal) {
            if (weakSlef.currentWeatherViewIndex == index+1) {

                UIViewController *vc = weakSlef.childViewControllers[index+1];
                [vc.view removeFromSuperview];

                [vc removeFromParentViewController];


                weakSlef.contentView.contentSize = CGSizeMake(weakSlef.contentView.width* (weakSlef.cityManager.citys.count+1), weakSlef.contentView.height);

                [weakSlef scrollViewDidEndScrollingAnimation:weakSlef.contentView];

            }else{

                UIViewController *vc = weakSlef.childViewControllers[index+1];
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];

                weakSlef.contentView.contentSize = CGSizeMake(weakSlef.contentView.width* (weakSlef.cityManager.citys.count+1), weakSlef.contentView.height);
            }


            weakSlef.pageControl.numberOfPages = weakSlef.childViewControllers.count;
        }
    } withIdentifier:didremoveCityHanderIdentifier];
}
-(void)initializeContentView{
    // 添加contentView.
    _contentView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _contentView.contentSize = CGSizeMake(_contentView.width* (self.cityManager.citys.count+1), _contentView.height);
    _contentView.delegate = self;
    _contentView.pagingEnabled = YES;
    _contentView.backgroundColor = [UIColor whiteColor];

    [self.view insertSubview:_contentView atIndex:0];

    // 设置ContentView初始化视图。
    [self scrollViewDidEndScrollingAnimation:_contentView];
}

-(void)initializeChildViewController{
    WeatherViewController *LocatedVC =[[WeatherViewController alloc]initWithStyle:WeatherViewStyleLocationCity];
    [self addChildViewController:LocatedVC];
    LocatedVC.delegate = self;



    for (City *city in self.cityManager.citys) {
        WeatherViewController *weatherVC = [[WeatherViewController alloc]initWithStyle:WeatherViewstyleTargetCity];
        weatherVC.delegate = self;

        weatherVC.city = city;
        [self addChildViewController:weatherVC];
    }
}

-(void)initializePageControl{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = self.cityManager.citys.count + 1 ;
    _pageControl.alpha = 0;
    _pageControl.currentPageIndicatorTintColor = color(145, 145, 145, 100);
    _pageControl.pageIndicatorTintColor = color(145, 145, 145, 0.5);
    [self.view addSubview:_pageControl];

    [_pageControl alignLeading:@"100" trailing:@"-100" toView:self.view];
    [_pageControl alignBottomEdgeWithView:self.view  predicate:@"-10"];
}

-(void)initMenu{
    /*
     *初始化 WeatherViewStatusReqesting 和 WeatherViewStatusFailed情况下使用的menu.
     */

    _requstingMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [_requstingMenu setImage:[UIImage imageNamed:@"noun_more_white"] forState:UIControlStateNormal];
    [_requstingMenu setImage:[UIImage imageNamed:@"noun_more_black"] forState:UIControlStateHighlighted];
    [_requstingMenu addTarget:self action:@selector(pressMenu:) forControlEvents:UIControlEventTouchUpInside];
    _requstingMenu.alpha = 0.f;

    [self.view addSubview:_requstingMenu];
    [_requstingMenu alignTopEdgeWithView:self.view predicate:@"9"];
    [_requstingMenu alignLeadingEdgeWithView:self.view predicate:@"16"];


    _failedMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [_failedMenu setImage:[UIImage imageNamed:@"noun_more_black"
                           ] forState:UIControlStateNormal];
    [_failedMenu setImage:[UIImage imageNamed:@"noun_more_white"] forState:UIControlStateHighlighted];
    [_failedMenu addTarget:self action:@selector(pressMenu:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_failedMenu];
    [_failedMenu alignTopEdgeWithView:self.view predicate:@"9"];
    [_failedMenu alignLeadingEdgeWithView:self.view predicate:@"16"];
    _failedMenu.alpha = 0.f;
}

-(IBAction)pressMenu:(id)sender{
    CityListViewController *vc = [[CityListViewController alloc]init];
    [self presentViewController:vc animated:YES completion:^{

    }];
}



-(void)dealloc{

    [self.cityManager removeDidremoveCityHandlerByIdentifier:didremoveCityHanderIdentifier];
    [self.cityManager removeDidSelectCityHandlerByIdentifier:didselectCityHanderIdentifier];
    [self.cityManager removeDidChangedCityHandlerByIdentifier:didChangedCityHanderIdentifier];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self scrollViewDidEndScrollingAnimation:self.contentView];
}
- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    NSUInteger index  = _contentView.contentOffset.x / _contentView.width;

    WeatherViewController *vc = self.childViewControllers[index];

    UIView  *view = vc.view;
    view.x = _contentView.width *index;
    view.y = 0;
    view.width = _contentView.width;
    view.height = _contentView.height;

    [_contentView addSubview:view];

    self.currentWeatherViewIndex =index;
    self.pageControl.currentPage = index;

    [self changeButtonvisibleByStatus:vc.status];

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - WeatherViewControllerDelegate
-(void)viewContoller:(WeatherViewController *)vc StatusDidChange:(WeatherViewStatus)status{
    NSUInteger index = [self.childViewControllers indexOfObject:vc];

    if (index == self.currentWeatherViewIndex) {

        [self changeButtonvisibleByStatus:status];
      }

}

-(void)changeButtonvisibleByStatus:(WeatherViewStatus)status{

    if (status == WeatherViewStatusNormal) {
        _pageControl.alpha = 1.f;
        //[self.view bringSubviewToFront:_pageControl];
        _requstingMenu.alpha = 0.f;
        //[self.view bringSubviewToFront:_requstingMenu];
        _failedMenu.alpha = 0.f;


    }else if(status == WeatherViewRequesting){
        _pageControl.alpha = 1.f;
        _requstingMenu.alpha = 1.f;
        _failedMenu.alpha = 0.f;

    }else{
        _pageControl.alpha = 0.f;
        _requstingMenu.alpha = 0.f;
        _failedMenu.alpha = 1.f;
    }


}
#pragma mark - Poperties.
@synthesize cityManager = _cityManager;
-(CityManager *)cityManager{
    if (!_cityManager) {
        _cityManager = [CityManager shareManager];

        NSLog(@"[%@ CityManager:%@]", NSStringFromClass([self class]), _cityManager);
    }
    
    return _cityManager;
}

@end
