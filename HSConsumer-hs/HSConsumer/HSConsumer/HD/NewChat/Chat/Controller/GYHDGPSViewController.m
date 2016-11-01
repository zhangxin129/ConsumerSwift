//
//  GYHDGPSViewController.m
//  HSConsumer
//
//  Created by shiang on 16/7/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDGPSViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDGPSCell.h"
#import "GYHDMessageCenter.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>


//,,,,BMKPoiSearchDelegate
@interface GYHDGPSViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (strong, nonatomic) UISearchDisplayController *searchDisplay;
/**根据关键字获取企业名称返回的数组*/
@property(nonatomic, strong) NSArray *searchStringCompanyArray;
/**展示图层*/
@property (strong, nonatomic) BMKMapView  *mapView;
/**搜索周边企业*/
@property(nonatomic, strong)NSArray *companyArray;
@property(nonatomic, strong)UIScrollView *searchTypeCompanyScrollView;
/**选中按钮*/
@property(nonatomic, weak)UIButton *selectButton;
/**企业*/
@property(nonatomic, strong)UITableView *companyTableView;

/**定位*/
@property(nonatomic, strong)BMKLocationService *locService;
/**选中数据*/
@property(nonatomic, strong)GYHDGPSModel *selectModel;
@property(nonatomic, strong)UISearchBar *mySearchBar;
/**按钮数组*/
@property(nonatomic, strong)NSArray *buttonArray;
@property(nonatomic, assign)BOOL reloadRetrievalData;
/**定位imageview*/
@property(nonatomic, strong)UIImageView *GPSimageView;
@property(nonatomic, strong)BMKGeoCodeSearch *geocodesearch;

@end

@implementation GYHDGPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_map_position"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mySearchBar = [[UISearchBar alloc] init];
    self.mySearchBar.delegate = self;
    self.mySearchBar.placeholder  = [GYUtils localizedStringWithKey:@"GYHD_search"];
    self.mySearchBar.tintColor  = [UIColor blackColor];
    [self.view addSubview:self.mySearchBar];
    self.searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:self.mySearchBar contentsController:self];
    
    self.mapView = [[BMKMapView alloc] init];
    [self.view addSubview:self.mapView];
    self.locService = [[BMKLocationService alloc]init];
    
    self.GPSimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_gps_dingwei"]];
    [self.mapView addSubview:self.GPSimageView];
    
    self.geocodesearch = [[BMKGeoCodeSearch alloc] init];
    
    self.searchTypeCompanyScrollView = [[UIScrollView alloc] init];
    self.searchTypeCompanyScrollView.showsHorizontalScrollIndicator = NO;
    self.searchTypeCompanyScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.searchTypeCompanyScrollView];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    self.companyTableView = [[UITableView alloc] init];
    self.companyTableView.dataSource = self;
    self.companyTableView.delegate = self;
    [self.companyTableView registerClass:[GYHDGPSCell class] forCellReuseIdentifier:@"GYHDGPSCellID"];
    [self.view addSubview:self.companyTableView];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:[GYUtils localizedStringWithKey:@"GYHD_Send"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 44);
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    WS(weakSelf);
    [self.mySearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mySearchBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    
    [self.GPSimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.mapView);
    }];
    
    [self.searchTypeCompanyScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mapView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.searchTypeCompanyScrollView);
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(0);
    }];
    [self.companyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.searchTypeCompanyScrollView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
//    self.searchTypeCompanyScrollView.backgroundColor = [UIColor redColor];
    [self loadCompanyType];

    
}
- (void)rightBtnClick:(UIButton *)btn {

    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[@"map_name"] = self.selectModel.title;
    sendDict[@"map_address"] = self.selectModel.address;
    sendDict[@"map_lng"] = self.selectModel.longitude;
    sendDict[@"map_lat"] = self.selectModel.latitude;;
    sendDict[@"map_poi"] = @"";
    sendDict[@"map_level"] = @"19";
    if (self.block) {
        self.block(sendDict);
    }
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)loadCompanyType {
    WS(weakSelf);
    [[GYHDMessageCenter sharedInstance] searchCompanyTypeRequetResult:^(NSDictionary *resultDict) {
        if ([[resultDict[@"retCode"] stringValue] isEqualToString:@"200"]) {
            NSArray *array = resultDict[@"data"][@"secondCategories"];
            NSMutableArray *typeArray = [NSMutableArray array];
            int i = 0;
            for (NSDictionary *dict in array) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:weakSelf action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = [dict[@"id"] integerValue];
                NSMutableDictionary *NormalDict = [NSMutableDictionary dictionary];
                NormalDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
                NormalDict[NSFontAttributeName] = [UIFont systemFontOfSize:KFontSizePX(28)];
                NSAttributedString *NormalAtt = [[NSAttributedString alloc] initWithString:dict[@"categoryName"] attributes:NormalDict];
 
                
                NSMutableDictionary *SelectedDict = [NSMutableDictionary dictionary];
                SelectedDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:250/255.0f green:60/255.0f blue:40/255.0f alpha:1];
                SelectedDict[NSFontAttributeName] = [UIFont systemFontOfSize:KFontSizePX(32)];
                NSAttributedString *SelectedAtt = [[NSAttributedString alloc] initWithString:dict[@"categoryName"] attributes:SelectedDict];
    
                [button setAttributedTitle:NormalAtt forState:UIControlStateNormal];
                [button setAttributedTitle:SelectedAtt forState:UIControlStateSelected];
                [weakSelf.searchTypeCompanyScrollView addSubview:button];
                button.frame = CGRectMake(80 * i, 0, 60, 44);
                if (!i) {
                    self.selectButton.selected = YES;
                    self.selectButton = button;
                
                }
                i++;
                [typeArray addObject:button];
            }
            self.buttonArray = typeArray;
            [self.searchTypeCompanyScrollView setContentSize:CGSizeMake(88*i, 44)];

          
        }
    }];
}
- (void)buttonClick:(UIButton *)button {
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
    if (self.searchTypeCompanyScrollView.contentSize.width > 0) {
        CGFloat offset = button.center.x - kScreenWidth * 0.5;
        if (offset < 0) {
            offset = 0;
        }
        CGFloat maxOffset  = self.searchTypeCompanyScrollView.contentSize.width - 350;
        if (offset > maxOffset) {
            offset = maxOffset;
        }
        [self.searchTypeCompanyScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];

    }

    WS(weakSelf);
    if (button.tag == 1004) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        dict[@"city"] =@"";
        dict[@"currentPageIndex"] = @"1";
        dict[@"everFlag"] = @"2";
        dict[@"key"] = @"";
        dict[@"landmark"] = [NSString stringWithFormat:@"%@,%@",self.selectModel.latitude,self.selectModel.longitude ];
        dict[@"pageSize"] = @"60";
        dict[@"type"] = @"1";
        
        [[GYHDMessageCenter sharedInstance] GetFoodMainPageUrlWithDict:dict RequetResult:^(NSDictionary *resultDict) {
            NSMutableArray *array = [NSMutableArray array];
            if ( [[resultDict[@"retCode"] stringValue]isEqualToString:@"200"]) {
                
                if ([resultDict[@"data"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in [resultDict[@"data"] firstObject][@"shopList"]) {
                        GYHDGPSModel *model = [[GYHDGPSModel alloc] init];
                        model.title = dict[@"shopName"];
                        model.address = dict[@"shopAddr"];
                        model.latitude = dict[@"lat"];
                        model.longitude = dict[@"longitude"];
                        model.city = self.selectModel.city;
                        model.pt = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
                        if ([model.title isEqualToString:self.selectModel.title] && [model.address isEqualToString:self.selectModel.address]) {
                            model = self.selectModel;
                        }
                        [array addObject:model];
                    }
                }
            }
            weakSelf.companyArray = array;
            [weakSelf.companyTableView reloadData];
        }];
        
    }else if (button.tag ==1005) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        dict[@"city"] = @"";
        dict[@"currentPageIndex"] = @"1";
        dict[@"everFlag"] = @"2";
        dict[@"key"] = @"";
        dict[@"landmark"] = [NSString stringWithFormat:@"%@,%@",self.selectModel.latitude,self.selectModel.longitude ];
        dict[@"pageSize"] = @"60";
        dict[@"type"] = @"2";
        [[GYHDMessageCenter sharedInstance] GetFoodMainPageUrlWithDict:dict RequetResult:^(NSDictionary *resultDict) {
            NSMutableArray *array = [NSMutableArray array];
            if ( [[resultDict[@"retCode"] stringValue]isEqualToString:@"200"]) {
                if ([resultDict[@"data"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in resultDict[@"data"]) {
                        GYHDGPSModel *model = [[GYHDGPSModel alloc] init];
                        model.title = dict[@"shopName"];
                        model.address = dict[@"shopAddr"];
                        model.latitude = dict[@"lat"];
                        model.longitude = dict[@"longitude"];
                        model.city = self.selectModel.city;
                        model.pt = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
                        if ([model.title isEqualToString:self.selectModel.title] && [model.address isEqualToString:self.selectModel.address]) {
                            model = self.selectModel;
                        }
                        [array addObject:model];
                    }
                }

            }
            weakSelf.companyArray = array;
            [weakSelf.companyTableView reloadData];
        }];
        
    } else {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@"" forKey:@"city"];
        [dict setValue:@"" forKey:@"area"];
        [dict setValue:@"" forKey:@"section"];
        [dict setValue:@"60" forKey:@"count"];
        [dict setValue:@"1" forKey:@"currentPage"];
        [dict setValue:[NSString stringWithFormat:@"%ld",(long)button.tag] forKey:@"categoryId"];
        [dict setValue:@"1" forKey:@"sortType"];
        [dict setValue:[NSString stringWithFormat:@"%@,%@",self.selectModel.latitude,self.selectModel.longitude ] forKey:@"location"];
        [dict setValue:@"" forKey:@"supportService"];
        [dict setValue:@"" forKey:@"distance"];
        [dict setValue:@"" forKey:@"hasCoupon"];
        [[GYHDMessageCenter sharedInstance] getTopicListWithDict:dict RequetResult:^(NSDictionary *resultDict) {
            NSMutableArray *array = [NSMutableArray array];
            BOOL sele = YES;
            if ( [[resultDict[@"retCode"] stringValue]isEqualToString:@"200"]) {
                if ([resultDict[@"data"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in resultDict[@"data"]) {
                        GYHDGPSModel *model = [[GYHDGPSModel alloc] init];
                        model.title = dict[@"companyName"];
                        model.address = dict[@"addr"];
                        model.latitude = dict[@"lat"];
                        model.longitude = dict[@"longitude"];
                        model.city = self.selectModel.city;
                        model.pt = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
                        if ([model.title isEqualToString:self.selectModel.title] && [model.address isEqualToString:self.selectModel.address]) {
                            model = self.selectModel;
                            sele = NO;
                        }
                        [array addObject:model];
                    }
                }
     
            }
            if (button.tag ==1002 && sele && array.count) {
                [array insertObject:self.selectModel atIndex:0];
            }
            weakSelf.companyArray = array;
            [weakSelf.companyTableView reloadData];
        }];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchTypeCompanyScrollView.contentOffset = CGPointMake(0, 0);
    self.searchDisplay.delegate = self;
    self.searchDisplay.searchResultsDataSource = self;
    self.searchDisplay.searchResultsDelegate =self;
    self.geocodesearch.delegate = self;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_locService startUserLocationService];
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
    });
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.companyTableView) {
        return self.companyArray.count;
    }else {
        return self.searchStringCompanyArray.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView==self.companyTableView) {
        GYHDGPSCell *baseCell = [[GYHDGPSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GYHDGPSCellID"];
        baseCell.model = self.companyArray[indexPath.row];
        cell = baseCell;
    }else {
        GYHDGPSCell *baseCell = [[GYHDGPSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GYHDGPSCellID"];
        baseCell.model = self.searchStringCompanyArray[indexPath.row];
        cell = baseCell;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==self.companyTableView) {
        self.selectModel.selectState = NO;
        self.selectModel = self.companyArray[indexPath.row];
        self.selectModel.selectState = YES;
    }else {
        self.selectModel.selectState = NO;
        self.selectModel = self.searchStringCompanyArray[indexPath.row];
        self.selectModel.selectState = YES;
        [self.mySearchBar resignFirstResponder];
        [self.searchDisplay setActive:NO animated:YES];
        
        self.selectButton.selected = NO;
        self.selectButton = [self.buttonArray firstObject];
        self.selectButton.selected = YES;
        [self buttonClick:self.selectButton];
      
    }
    [_mapView setCenterCoordinate:self.selectModel.pt animated:YES];
    self.reloadRetrievalData = NO;
    [self.companyTableView reloadData];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString {

    return  YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchCompanyWithString:searchBar.text];
}


- (void)searchCompanyWithString:(NSString *)searchString {

    NSString* hasCoupon = @"0";
    NSString* SortType = @"7";
    NSString* strSpecialServiceType = @"";
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:searchString forKey:@"keyword"];
    [dict setValue:SortType forKey:@"sortType"];
    [dict setValue:strSpecialServiceType forKey:@"specialService"];
    [dict setValue:@"10" forKey:@"count"];
    
    [dict setValue:hasCoupon forKey:@"hasCoupon"];
    [dict setValue:[NSString stringWithFormat:@"%@,%@",self.selectModel.latitude,self.selectModel.longitude ] forKey:@"location"];
    [dict setValue:@"1" forKey:@"currentPage"];
    
    [[GYHDMessageCenter sharedInstance] EasyBuySearchShopUrlWithDict:dict RequetResult:^(NSDictionary *resultDict) {
        NSMutableArray *array = [NSMutableArray array];
        if ([resultDict[@"retCode"] integerValue] == 200) {
            for (NSDictionary *dict in resultDict[@"data"]) {
                GYHDGPSModel *model = [[GYHDGPSModel alloc] init];
                model.title = dict[@"vShopName"];
                model.address = dict[@"addr"];
                model.latitude = dict[@"lat"];
                model.longitude = dict[@"longitude"];
//                model.city = dict[@"city"];
                model.pt = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
                if ([model.title isEqualToString:self.selectModel.title] && [model.address isEqualToString:self.selectModel.address]) {
                    model = self.selectModel;
                }
                [array addObject:model];
            }
            self.searchStringCompanyArray = array;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
//    [[GYHDMessageCenter sharedInstance] searchCompanyWithString:searchString currentPage:@"1" RequetResult:^(NSDictionary *resultDict) {
//        NSMutableArray *array = [NSMutableArray array];
//        if ([resultDict[@"retCode"] integerValue] == 200) {
//            for (NSDictionary *dict in resultDict[@"data"]) {
//                GYHDGPSModel *model = [[GYHDGPSModel alloc] init];
//                model.title = dict[@"vShopName"];
//                model.address =  dict[@"addr"];
//                model.latitude = dict[@"lat"];
//                model.longitude = dict[@"longitude"];
//                [array addObject:model];
//            }
//            self.searchStringCompanyArray = array;
//            [self.searchDisplayController.searchResultsTableView reloadData];
//        }
//    }];
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
//    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(0.02f,0.02f));
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    
    [_locService stopUserLocationService];
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D pt= [mapView convertPoint:CGPointMake( self.mapView.frame.size.width / 2, self.mapView.frame.size.height/2) toCoordinateFromView:self.mapView];
    if (self.reloadRetrievalData) {
        NSLog(@"重新刷新数据");
            BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
            reverseGeocodeSearchOption.reverseGeoPoint = pt;
            [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    }
    self.reloadRetrievalData = YES;
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    GYHDGPSModel *model = [[GYHDGPSModel alloc] init];
    model.title = [GYUtils localizedStringWithKey:@"GYHD_GPS_position"];
    model.address = result.address;
    model.pt = result.location;
    model.latitude =  [NSString stringWithFormat:@"%f",model.pt.latitude];
    model.longitude = [NSString stringWithFormat:@"%f",model.pt.longitude];
    model.selectState = YES;
    model.city = result.addressDetail.city;
    self.selectModel.selectState = NO;
    self.selectModel = model;
    
//    NSMutableArray *array =[NSMutableArray arrayWithArray:self.companyArray];
//    [array insertObject:model atIndex:0];
//    self.companyArray = array;
//    [self.companyTableView reloadData];
    self.selectButton.selected =NO;
    self.selectButton = [self.buttonArray firstObject];
    [self buttonClick:self.selectButton];
}

@end
