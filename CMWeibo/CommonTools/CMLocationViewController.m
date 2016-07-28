//
//  CMLocationViewController.m
//  CMWeibo
//
//  Created by jiachenmu on 16/7/26.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "CMLocationViewController.h"

#import "CMLocationModel.h"

#import "SelectPlaceCell.h"

@interface CMLocationViewController ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UITableView *showTableView;

@property (strong, nonatomic) CMLocationModel *locationModel;

@end

@implementation CMLocationViewController {
    double latitude;   //纬度
    double longitude;  //经度
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildLocationManager];
    
    [self buildUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [SVProgressHUD showWithStatus:@"正在努力的获取周边信息，请耐心等待"];
}

- (void)barCancel {
    if (_selectPlaceBlock) {
        _selectPlaceBlock(@"");
    }
    [super barCancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildUI {
    _showTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT) style:UITableViewStylePlain];
    _showTableView.delegate = self;
    _showTableView.dataSource = self;
    [_showTableView registerNib:[UINib nibWithNibName:@"SelectPlaceCell" bundle:nil] forCellReuseIdentifier:@"SelectPlaceCell_"];
    [self.view addSubview:_showTableView];
}

- (void)buildLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    // 请求授权
    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    
    // 设置 定位忽略更新的距离
    _locationManager.distanceFilter = 100;
    
    // 设置定位精度  设置的精度比较高，所以耗时
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    
    [_locationManager requestLocation];
    
    
}

- (void)requestBaiduMapApiData {
    NSString *requestLocation = [NSString stringWithFormat:@"%.6f,%.6f",latitude,longitude];
    
    Weakself;
    [CMNetwork spec_GET:@"http://api.map.baidu.com/geocoder/v2/?" parameters:@{@"ak" : BaiduMapKey,@"location" : requestLocation, @"pois" : @(1), @"output" : @"json", @"coordtype" : @"wgs84ll"} success:^(NSString * _Nonnull jsonString) {

        [SVProgressHUD showSuccessWithStatus:@"获取周边数据成功"];
        
        weakself.locationModel = [CMLocationModel initWithJSONString:jsonString];

        [weakself.showTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取周边信息失败"];
    }];
}

#pragma mark - delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%@",locations);
    if (latitude == 0.00 || longitude == 0.00) {
        latitude = locations[0].coordinate.latitude;
        longitude = locations[0].coordinate.longitude;
        //请求百度Api数据
        [self requestBaiduMapApiData];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *errorMsg = nil;
    if ([error code] == kCLErrorDenied) {
        errorMsg = @"不给我权限想搞定位啊~";
    }
    if ([error code] == kCLErrorLocationUnknown) {
        errorMsg = @"定位失败啊，再试试~";
    }
    [SVProgressHUD showErrorWithStatus:errorMsg];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_locationModel) {
        return 1 + _locationModel.pois.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectPlaceCell_"];
    if (indexPath.row == 0) {
        cell.model = _locationModel;
    }else {
        PoistionNearByModel *nearbyInfo =  [PoistionNearByModel nearbyInfolWithObject:[_locationModel.pois objectAtIndex:indexPath.row - 1]];
        cell.poisInfo = nearbyInfo;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectPlaceBlock) {
        NSString *place = indexPath.row == 0 ? _locationModel.business : [PoistionNearByModel nearbyInfolWithObject:[_locationModel.pois objectAtIndex:indexPath.row - 1]].name;
        _selectPlaceBlock(place);
        [self.navigationController popViewControllerAnimated:true];
    }
}

@end
