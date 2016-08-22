//
//  CityListViewController.m
//  MyWheaher
//
//  Created by  Leonard on 16/5/31.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "CityListViewController.h"
#import "LocatedCityCell.h"
#import "CityCell.h"
#import "AddedFont.h"
#import "ShapeWordView.h"
#import "LineBackgroundView.h"
#import "SearchCityResultController.h"

#import "SearchCityData.h"
#import "GetCurrentData.h"
#import "CurrentWeatherData.h"
#import "GetHeWeatherData.h"
#import "CityDbData.h"


#import "TWMessageBarManager.h"
#import <objc/runtime.h>
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import <FLKAutoLayout.h>


static NSString * const CityCellID = @"City Cell";
static NSString * const LocatedCityID = @"Located City ID";

@interface CityListViewController ()<
UISearchResultsUpdating,
UISearchControllerDelegate,
SearchCityDataDelegate,
GetCurrentDataDelegate,
SWRevealTableViewCellDataSource,
SWRevealTableViewCellDelegate,
GetHeWeatherDataDelegate
>{
    ShapeWordView *_shapeWorldView;
}

@property(nonatomic,readonly)CityManager *cityManger;
@property(nonnull,nonatomic,strong)UISearchController *searchController;
@property(nonatomic,nonnull,strong)SearchCityResultController *searchResultController;

@property(nonatomic,readonly)SearchCityData *searchData;
@property(nonnull,nonatomic,readonly)GetCurrentData *getCurrentData;
@property(nonnull,nonatomic,readonly)GetHeWeatherData *getHeWeatherData;




@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // 初始化
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView.backgroundColor = color(216, 216, 216, 75);

    // 注册cell.
    [self.tableView registerNib:[UINib nibWithNibName:@"CityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CityCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"LocatedCityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:LocatedCityID];

    // 添加上拉刷新view
    _shapeWorldView = [[ShapeWordView alloc]initWithFrame:CGRectMake(0, -60, WIDTH, 60)];
    _shapeWorldView.text = NSLocalizedString(@"SWViewTitle", @"Release To Reflesh") ;
    _shapeWorldView.font = [UIFont fontWithName:LATO_THIN size:20.f];;
    _shapeWorldView.lineWidth = 0.5f;
    _shapeWorldView.lineColor = [UIColor redColor];
    [_shapeWorldView buildView];
    [self.tableView addSubview:_shapeWorldView];

    // 设置footView。
    [self setFootView];

    [self requestAllCityWeatherData];
    [self setSearchResultController];

    // 配置城市数据跟新是处理块
    __weak typeof(self) weakSlef = self;
    [_cityManger addDidChangedCityHandler:^(City * _Nullable city, CityType type, NSUInteger index) {
        if (type == CityTypeNormal) {
            
            [weakSlef.tableView reloadData];
            [weakSlef requestAllCityWeatherData];
        }

    } withIdentifier:ChangedCityHandlerIdentifier];

}

-(void)setSearchResultController{
    _searchResultController = [[SearchCityResultController alloc]init];

    _searchController = [[UISearchController alloc]initWithSearchResultsController:_searchResultController];

    
    _searchController.searchBar.hidden = YES;
    [self.tableView addSubview:_searchController.searchBar];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self;

    __weak typeof(self) weakSlef = self;
    _searchResultController.resultDidselectedHandler = ^(City *city){
        
        [weakSlef.cityManger addCity:city];
        weakSlef.searchController.active = NO;
    };

    _searchResultController.didRollViewHandler = ^(){
        [weakSlef.searchController.searchBar resignFirstResponder];
    };

}

-(void)setFootView{
    UIView *footerView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 71)];
    footerView.backgroundColor = [UIColor colorWithIntRed:240 green:240 blue:240 alpha:100];

    LineBackgroundView *backgroundView = [LineBackgroundView \
                                          createViewWithFrame:footerView.bounds\
                                          LineWidth:4.f \
                                          lineGap:4.f \
                                          lineColor:[[UIColor blackColor]colorWithAlphaComponent:0.015f] ];
    backgroundView.backgroundColor = [UIColor clearColor];
    [footerView insertSubview:backgroundView atIndex:0];

    UIButton *addCityButton = [UIButton buttonWithType:UIButtonTypeCustom ];
    [addCityButton setImage:[UIImage imageNamed:@"add_verify" ] forState:UIControlStateNormal];
    [addCityButton setImage:[UIImage imageNamed:@"add_verify_ translucent"] forState:UIControlStateHighlighted];
    [addCityButton addTarget:self action:@selector(addNewCity:) forControlEvents:UIControlEventTouchUpInside];

    [footerView addSubview:addCityButton];
    [addCityButton alignTop:@"22" bottom:@"-22" toView:footerView];
    [addCityButton alignTrailingEdgeWithView:footerView predicate:@"-33"];

    self.tableView.tableFooterView = footerView;

}

-(void)requestAllCityWeatherData{
    NSMutableArray *cityIDs = [NSMutableArray arrayWithCapacity:5];
    [cityIDs addObject:self.cityManger.locatedCity.cityId];

    for (City *city in self.cityManger.citys) {
        [cityIDs addObject:city.cityId];
    }

    if (isUsingHeWeatherData) {
        [self.getHeWeatherData requestWithCityIds:[cityIDs copy]];

    }else{
        [self.getCurrentData requestWithCityIds:[cityIDs copy]];

    }
}
-(IBAction)addNewCity:(id)sender{
    self.searchController.searchBar.hidden = NO;
    self.searchController.active = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.cityManger removeDidChangedCityHandlerByIdentifier:ChangedCityHandlerIdentifier];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityManger.citys.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return [tableView fd_heightForCellWithIdentifier:LocatedCityID cacheByIndexPath:indexPath configuration:^(id cell) {
            [cell setCity:self.cityManger.locatedCity];
        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:CityCellID cacheByIndexPath:indexPath configuration:^(id cell) {
            [cell setCity:self.cityManger.citys[indexPath.row-1]];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;


    
    if (indexPath.row == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:LocatedCityID forIndexPath:indexPath];

        LocatedCityCell *lCell = (LocatedCityCell*)cell;
        [lCell setCity:self.cityManger.locatedCity];


    }else{
        cell = [self.tableView dequeueReusableCellWithIdentifier:CityCellID forIndexPath:indexPath];

        CityCell *cCell = (CityCell*)cell;
        cCell.dataSource = self;
        cCell.delegate = self;
        cCell.cellRevealMode = SWCellRevealModeNormal;

        [cCell setCity:self.cityManger.citys[indexPath.row-1]];
        
    }
    // Configure the cell...

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        [self.cityManger setCurrentCityType:CityTypelocation index:0];

    }else{
        [self.cityManger setCurrentCityType:CityTypeNormal index:indexPath.row-1];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIScrollViewDelegete
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat YOffset = scrollView.contentOffset.y;

    if (YOffset <= -60) {
        [self requestAllCityWeatherData];

    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat YOffset = scrollView.contentOffset.y;

    if (YOffset <= 0) {
        CGFloat percent = YOffset / -60;
        [_shapeWorldView percent:percent animated:YES];
    }
}
#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchText =  [searchController.searchBar.text
                             stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (isUsingHeWeatherData) {
        if (searchText.length > 0) {

            NSArray <City*>* cities = [[CityDbData shareCityDbData] searchHeCitiesByCondition:searchText];
            self.searchResultController.cities = cities;

        }


    }else{
        [self.searchData searchCityByName:searchText];
    }

    
}

#pragma mark - UISearchControllerDelegate
-(void)didDismissSearchController:(UISearchController *)searchController{
    searchController.searchBar.hidden = YES;
}
#pragma mark - SearchCityDataDelegate
-(void)searchCityData:(SearchCityData *)searchCityData didUpdateSucessWithData:(NSArray<City *> *)cities{
    self.searchResultController.cities = cities;
}

-(void)searchCityData:(SearchCityData *)searchCityData didUpdateFailWithError:(NSError *)error{
    
}

#pragma mark - GetCurrentDataDelegate
-(void)GetCurrentDatas:(GetCurrentData *)getData getDataSuccessWithWeatherDatas:(NSDictionary<NSString *,CurrentWeatherData *> *)weatherDatas{
    // 获取定位城市温度
    NSString *locationID = self.cityManger.locatedCity.cityId;
    self.cityManger.locatedCity.temperature = weatherDatas[locationID].Temperature.temp;

    // 获取其他请求城市天气.
    for (City *city in self.cityManger.citys) {
        NSString *cityId = city.cityId;

        city.temperature = weatherDatas[cityId].Temperature.temp;
    }

    [self.tableView reloadData];
}

-(void)GetCurrentData:(GetCurrentData *)getData getDataSuccessWithWeatherData:(CurrentWeatherData *)weatherData{
    // 获取获取到数据城市位置。
}

-(void)GetCurrentData:(GetCurrentData *)getData getDataFailWithError:(NSError *)error{
    [self showError];

}

#pragma mark - GetHeWeatherDataDelegate
-(void)GetHeWeatherData:(GetHeWeatherData *)getData getDataSuccessWithWeatherDatas:(NSDictionary<NSString *,CurrentWeatherData *> *)weatherDatas{

    // 获取定位城市温度
    NSString *locationID = self.cityManger.locatedCity.cityId;
    self.cityManger.locatedCity.temperature = weatherDatas[locationID].Temperature.temp;

    // 获取其他请求城市天气.
    for (City *city in self.cityManger.citys) {
        NSString *cityId = city.cityId;

        city.temperature = weatherDatas[cityId].Temperature.temp;
    }

    [self.tableView reloadData];
}

-(void)GetHeWeatherData:(GetHeWeatherData *)getData getDataSuccessWithWeatherData:(CurrentWeatherData *)weatherData{

}

-(void)GetHeWeatherData:(GetHeWeatherData *)getData getDataFailWithError:(NSError *)error{
    NSLog(@"获取数据失败.");

    
    [self showError];

}

-(void)showError{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // @"Network Unreachable" ,@"Please try later.", @"Please try later."
        [[TWMessageBarManager sharedInstance]
         showMessageWithTitle:NSLocalizedString(@"NetWorkFTitle1", @"Network Unreachable")
         description: NSLocalizedString(@"NetWorkFMsg1", @"Please try later.")
         type:TWMessageBarMessageTypeError
         callback:nil];
    });
}
#pragma mark - SWRevealTableViewCellDataSource

-(NSArray *)rightButtonItemsInRevealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell{
    __weak typeof(self) weakSlef = self;
    SWCellButtonItem *item = [SWCellButtonItem itemWithTitle:NSLocalizedString(@"SWCellLeftButtonItem1", @"delete") handler:^BOOL(SWCellButtonItem *item, SWRevealTableViewCell *cell) {
        NSIndexPath *indexPath = [weakSlef.tableView indexPathForCell:cell];
        if (indexPath.row > 0) {

            [weakSlef.cityManger removeCity:weakSlef.cityManger.citys[indexPath.row-1]];

            [weakSlef.tableView beginUpdates];
            [weakSlef.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSlef.tableView endUpdates];

        }
        return  YES;
    }];

    item.width = 64;
    item.backgroundColor = [UIColor redColor];
    item.tintColor = [UIColor whiteColor];

    return @[item];
}


#pragma mark - SWRevealTableViewCellDelegate
-(void)revealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell willMoveToPosition:(SWCellRevealPosition)position{
    if (SWCellRevealPositionCenter == position) {
        return;
    }

    for (SWRevealTableViewCell *cell in self.tableView.visibleCells) {

        if (![cell isKindOfClass:[SWRevealTableViewCell class]]) {
            continue;
        }
        if (cell!=revealTableViewCell) {
            [cell setRevealPosition:SWCellRevealPositionCenter animated:YES];
        }
    }
}
#pragma mark - Poperties
NSString *const ChangedCityHandlerIdentifier = @"Changed City Handler";
@synthesize cityManger = _cityManger;
-(CityManager *)cityManger{
    if (!_cityManger) {
        _cityManger = [CityManager shareManager];
                NSLog(@"[%@ CityManager:%@]", NSStringFromClass([self class]), _cityManger);
    }
    return _cityManger;
}

@synthesize searchData = _searchData;
-(SearchCityData *)searchData{
    if (!_searchData) {
        _searchData = [[SearchCityData alloc]init];
        _searchData.delegate = self;

    }
    return _searchData;
}

@synthesize getCurrentData = _getCurrentData;
-(GetCurrentData *)getCurrentData{
    if (!_getCurrentData) {
        _getCurrentData = [[GetCurrentData alloc]initWithDelegate:self];
    }
    return _getCurrentData;
}

@synthesize getHeWeatherData = _getHeWeatherData;

-(GetHeWeatherData *)getHeWeatherData{
    if (!_getHeWeatherData) {
        _getHeWeatherData = [[GetHeWeatherData alloc]initWithDelegate:self];
    }

    return _getHeWeatherData;
}

@end
