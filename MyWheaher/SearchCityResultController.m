//
//  SearchCityResultController.m
//  MyWheaher
//
//  Created by  Leonard on 16/8/6.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "SearchCityResultController.h"
#import "City.h"
#import "SearchCityData.h"
#import "Analysitcs.h"

@interface SearchCityResultController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonnull, nonatomic, readonly)UITableView *tableView;
@property(nonatomic,nonnull, readonly)CityManager *cityManager;
@end

static NSString *const ResultCellID = @"result cell";
@implementation SearchCityResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"Search City Result View Controller"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:@"Search City Result View Controller"];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.cities?self.cities.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResultCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResultCellID];
    }

    City *city = _cities[indexPath.row];
    if (
        ([city.country isEqualToString:@"CN"]
        || [city.country isEqualToString:@"China"])
        && city.ZHCityName
        && ![city.ZHCityName isEqualToString:@""]
        ) {
        cell.textLabel.text = city.ZHCityName;
    }else{
        cell.textLabel.text = city.cityName;
    }


    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.resultDidselectedHandler) {
        self.resultDidselectedHandler(_cities[indexPath.row]);
    }

}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.didRollViewHandler) {
        self.didRollViewHandler();
    }
}
#pragma mark - Poperties
@synthesize tableView = _tableView;
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];


        [self.view insertSubview:_tableView atIndex:0];
    }

    return _tableView;
}

-(void)setCities:(NSArray<City *> *)cities{
    _cities = cities;
    
    [self.tableView reloadData];
}

@dynamic cityManager;
-(CityManager *)cityManager{
    return [CityManager shareManager];
}
@end
