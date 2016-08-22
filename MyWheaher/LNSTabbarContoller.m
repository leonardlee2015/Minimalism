//
//  LNSTabbarContoller.m
//  DynamicTabBar
//
//  Created by  Leonard on 16/5/16.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "LNSTabbarContoller.h"
//#import "LNSTabbar.h"
#import "LNS_Tabbar.h"
#import "UIView+SetRect.h"
#import <FLKAutoLayout.h>
#ifdef LSNTabbar
@interface LNSTabbarContoller ()<LNSTabbarDelegate,UIToolbarDelegate>

@end
#else

@interface LNSTabbarContoller ()<LNS_TabbarDelegate,UIToolbarDelegate>

@end
#endif


@implementation LNSTabbarContoller
@dynamic delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self setTabbar];


    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    


}

-(void)setTabbar{
#ifdef LSNTabbar
    _constomTabbar = [[LNSTabbar alloc]init];
    _constomTabbar.delegate = self;
    _constomTabbar.frame = CGRectMake(self.tabBar.x, self.tabBar.y, self.tabBar.width, 41);
    [self.view addSubview:_constomTabbar];
#else
    _constomTabbar = [[LNS_Tabbar alloc]init];
    _constomTabbar.delegate = self;
    _constomTabbar.origin = CGPointMake(self.tabBar.x, self.view.height-_constomTabbar.height);
    [self.view addSubview:_constomTabbar];

#endif
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //删除系统自动生成 tabbar
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:[UIControl class]]) {
            [view removeFromSuperview];

        }
    }
    self.tabBar.alpha = 0.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildViewController:(UIViewController *)childController{

    [super addChildViewController:childController];
    _constomTabbar.numOfPages = self.viewControllers.count;

}

-(void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [super setViewControllers:viewControllers];
    _constomTabbar.numOfPages = self.viewControllers.count;
}

-(void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    [super setViewControllers:viewControllers animated:animated];
    _constomTabbar.numOfPages = self.viewControllers.count;

}

#pragma mark - LNSTabbarDelegate
-(void)tabbar:(LNS_Tabbar *)tabbar pageValueDidChange:(NSInteger)changeValue{
    self.selectedIndex = _constomTabbar.currentPage;

}

-(void)tabbarLeftBarItemDidClick:(LNS_Tabbar *)tabbar{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarControllerDidClickLeftBarItem:)]) {

        [self.delegate tabBarControllerDidClickLeftBarItem:self];

    }

}

-(void)tabbarRightBarItemDidClick:(LNS_Tabbar *)tabbar{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbarControllerDidClickRightBarItem:)]) {
        [self.delegate tabbarControllerDidClickRightBarItem:self];
    }
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selectedIndex"]) {

        //id value = change[NSKeyValueChangeNewKey];

        self.constomTabbar.currentPage = self.selectedIndex;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
