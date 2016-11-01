//
//  GYHDGPSViewController.m
//  HSConsumer
//
//  Created by shiang on 16/7/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDGPSViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDMapCell.h"
#import "GYLoginEn.h"
#import "GYRefreshFooter.h"
#import "GYRefreshHeader.h"

static CGFloat const titleH = 44;/** 文字高度  */

static CGFloat const MaxScale = 1.2;/** 选中文字放大  */

@interface GYHDGPSViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
/**展示图层*/
@property (strong, nonatomic) BMKMapView  *mapView;

@property(nonatomic)CLLocationCoordinate2D currentCoordinate;//记录地理位置
/**定位*/
@property(nonatomic,strong)BMKLocationService*locationService;
@property(nonatomic,assign)BOOL isSearchByFixName;//是否按键是搜索
/**周边搜索*/
@property(nonatomic,strong)BMKNearbySearchOption *nearBySearchOption;

@property(nonatomic, strong)BMKGeoCodeSearch *geocodesearch;//反编码

@property(nonatomic,strong)BMKPoiSearch* poisearch;//检索

@property(nonatomic,strong)BMKPointAnnotation * cencerAnnotation;//大头针显示

@property(nonatomic,strong)  BMKPoiInfo * curPoiInfo;//当前地点信息

@property(nonatomic,assign)CLLocationCoordinate2D coor;
/**
 *  yes: 不重新加载周边信息, no:重新加载周边信息
 *  判断移动地图.还是点击列表 . yes:点击列表. no:移动地图 , 默认为no
 */
@property(nonatomic,assign) BOOL isNotMoveMap;

/**数据数组*/
@property(nonatomic, strong)NSMutableArray *retrievalArray;

@property(nonatomic,strong) NSMutableArray * searchArray;//搜索数组
/**周边tableView*/
@property(nonatomic, strong)UITableView *retrievalTableView;

/** 搜索框 */
@property(nonatomic,strong)UITextField *textField;

/** 文字scrollView  */
@property (nonatomic, strong) UIScrollView *titleScrollView;
/** 标签文字  */
@property (nonatomic ,strong) NSMutableArray * titlesArr;
/** 标签按钮  */
@property (nonatomic, strong) NSMutableArray *buttons;
/** 选中的按钮  */
@property (nonatomic ,strong) UIButton * selectedBtn;

@property (nonatomic,assign)NSInteger fixNameCurentPage;

@property(nonatomic,assign)NSInteger  searchCurentPage;
@end

@implementation GYHDGPSViewController

- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mapView.delegate = self;
    self.locationService.delegate =self;
    self.geocodesearch.delegate = self;
    self.poisearch.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    self.mapView.delegate = nil; // 不用时，置nil
    self.locationService.delegate = nil;
    self.geocodesearch.delegate = nil;
    self.poisearch.delegate = nil;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];

    self.retrievalArray  = [NSMutableArray array];
    
    self.searchArray =[NSMutableArray array];
    self.titlesArr=[NSMutableArray array];
    
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    self.poisearch = [[BMKPoiSearch alloc]init];
    
    self.nearBySearchOption = [[BMKNearbySearchOption alloc]init];
    self.nearBySearchOption.radius = 500; //检索范围 m
    self.nearBySearchOption.sortType = BMK_POI_SORT_BY_DISTANCE;//由近到远

    self.mapView = [[BMKMapView alloc] init];
    
    [self.view addSubview:self.mapView];

    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-350);
    }];
    [self getTitleData];

}

-(void)getTitleData{
    
    [GYNetwork GET:[NSString stringWithFormat:@"%@/shops/v2/getMainInterface",[GYLoginEn sharedInstance].getDefaultRetailDomain] parameter:nil success:^(id returnValue) {
        
        if ([returnValue[@"retCode"]integerValue]==200) {
            
            NSArray*arr=returnValue[@"data"][@"secondCategories"];
            
            for (NSDictionary*dic in arr) {
                
                [self.titlesArr addObject:dic];
            }
            [self configMap];
            [self setUpSearch];
            [self setUpNearbyButton];
        }
        
    } failure:^(NSError *error) {
        
        
    }];

}

-(void)configMap{
    
    if (!self.cencerAnnotation) {
        
        _mapView.maxZoomLevel=19;
        _mapView.zoomLevel=19;
        
        _mapView.mapType=BMKMapTypeStandard;//
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
        
        self.cencerAnnotation = [[BMKPointAnnotation alloc]init];

        self.currentCoordinate =CLLocationCoordinate2DMake(22.54923368170612,114.07752573350844);
        
        CLLocationCoordinate2D cord=self.currentCoordinate;
        
        BMKCoordinateSpan span=BMKCoordinateSpanMake(0.01f , 0.01f);
        
        BMKCoordinateRegion region=BMKCoordinateRegionMake(cord, span);
        
        _mapView.region=region;
        
        [self reverseGeocodeLocation:cord];
        
    }
    
    [self startLoc:nil];
}


-(void)startLoc:(id)sender{
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc]init];
        _locationService.delegate =self;
    }
    [_locationService startUserLocationService];
    
}

#pragma mark - private methods
- (void)initView
{
    
    self.title = kLocalized(@"GYHD_Location_Title");
    //    发送
    UIButton*saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(0, 0, 40, 40);
    [saveBtn setTitle:@"发送" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [saveBtn addTarget:self action:@selector(sendLocation) forControlEvents:UIControlEventTouchUpInside];
   
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.view.backgroundColor=[UIColor blackColor];
    DDLogInfo(@"Load Controller: %@", [self class]);
}
#pragma mark - 地图搜索框
-(void)setUpSearch{

    _textField=[[UITextField alloc]initWithFrame:CGRectMake(30, 100, 350, 40)];
    _textField.backgroundColor=[UIColor whiteColor];
    _textField.borderStyle=UITextBorderStyleRoundedRect;
    _textField.returnKeyType=UIReturnKeySearch;
    _textField.placeholder=kLocalized(@"GYHD_Please_Enter_Search_Content");
    _textField.delegate=self;
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor=[UIColor colorWithRed:0 green:174/255.0 blue:255.0/255.0 alpha:1.0];
    
    btn.frame=CGRectMake(0, 0, 40, 40);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"gyhd_nav_right_search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    _textField.rightView=btn;
    
    _textField.rightViewMode=UITextFieldViewModeAlways;
    
    [_mapView addSubview:_textField];
    
}

-(void)setUpNearbyButton{
    
     /** 添加文字标签  */
    [self setTitleScrollView];
    
    /** 设置标签按钮 文字 背景图  */
    [self setupTitle];
    
    @weakify(self);

    self.retrievalTableView = [[UITableView alloc] init];
    self.retrievalTableView.dataSource = self;
    self.retrievalTableView.delegate = self;
    self.retrievalTableView.tableHeaderView=self.titleScrollView;
    self.retrievalTableView.tableFooterView=[[UIView alloc]init];
    
    GYRefreshFooter*footer=[GYRefreshFooter footerWithRefreshingBlock:^{
         @strongify(self);
        if (self.isSearchByFixName) {
            
            self.fixNameCurentPage++;
            
            [self getShopListData];
            
        }else{
        
            self.searchCurentPage++;
            
            [self getSearchShopListData];
        }
 
        [self.retrievalTableView.mj_footer endRefreshing];
        [self.retrievalTableView reloadData];
        
    }];
    
    self.retrievalTableView.mj_footer=footer;

    [self.view addSubview:self.retrievalTableView];
  
    [self.retrievalTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.mas_equalTo(44);
        make.right.bottom.mas_equalTo(0);
        make.left.equalTo(self.mapView.mas_right).offset(0);
    }];
    
}

#pragma mark - 发送位置
- (void)sendLocation{
    
    if (self.isSearchByFixName) {
        
        if (self.block) {
            

            NSIndexPath * indexPath = [self.retrievalTableView indexPathForSelectedRow];
            
            BMKPoiInfo * aInfo = self.retrievalArray[indexPath.row];
            
            self.block(aInfo);
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }else{
    
        if (self.block) {
            
            NSIndexPath * indexPath = [self.retrievalTableView indexPathForSelectedRow];
            
            BMKPoiInfo * aInfo = self.searchArray[indexPath.row];
            
            self.block(aInfo);
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
   
}

#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    
    for (BMKPointAnnotation *ano in array) {
        
        if (![ano isEqual:self.cencerAnnotation]) {
            [_mapView removeAnnotation:ano];
        }
    }

    if (error == BMK_SEARCH_NO_ERROR) {
        
        
        if (self.isSearchByFixName==YES) {
            
            [self.searchArray removeAllObjects];
            [self.retrievalArray removeAllObjects];
            [self.retrievalArray addObjectsFromArray:result.poiInfoList];

            [self.retrievalTableView reloadData];
            
        }
        else{
            [self.retrievalArray removeAllObjects];
            [self.searchArray removeAllObjects];
            [self.searchArray addObjectsFromArray:result.poiInfoList];
            [self.retrievalTableView reloadData];
        }
        
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        DDLogCInfo(@"起始点有歧义");
    } else {
        
        // 各种情况的判断。。。
    }
}


#pragma mark mapDelegate
/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    CLLocationCoordinate2D coo = [mapView convertPoint:CGPointMake(mapView.width/2.0, mapView.height/2.0) toCoordinateFromView:mapView];
    
    [self reverseGeocodeLocation:coo];
    
}

#pragma mark - 反向检索地理编码
- (void)reverseGeocodeLocation:(CLLocationCoordinate2D)aLocation {
    
    if (!self.isNotMoveMap) {
        if (aLocation.latitude<0 || aLocation.longitude < 0) {
            return;
        }
        
        self.cencerAnnotation.coordinate = aLocation;
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = aLocation;
        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {
            DDLogInfo(@"反geo检索发送成功");
        }
        else
        {
            DDLogInfo(@"反geo检索发送失败");
        }
        
    }
    self.isNotMoveMap = NO;
    
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    
    for (BMKPointAnnotation *ano in array) {
        
        if (![ano isEqual:self.cencerAnnotation]) {
            [_mapView removeAnnotation:ano];
        }
    }
 
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
//   屏蔽百度获取的检索数据
//        [self.retrievalArray removeAllObjects];
//        
//        [self.retrievalArray addObjectsFromArray:result.poiList];
        
        //添加当前位置点
        self.curPoiInfo  = [[BMKPoiInfo alloc]init];
        self.curPoiInfo.name = kLocalized(@"GYHD_Location");
        self.curPoiInfo.address = result.address;
        self.curPoiInfo.pt = result.location;
        self.curPoiInfo.city = result.addressDetail.city;
        [self.retrievalArray insertObject:  self.curPoiInfo atIndex:0];
        if (self.selectedBtn==nil) {
            
             [self click:self.buttons[0]];
        }else{
        
            [self click:self.selectedBtn];
        }
        
//        [self.retrievalTableView reloadData];
//        [self.retrievalTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//        
//        [self.retrievalTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [_mapView addAnnotation:self.cencerAnnotation];
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    if (annotation == self.cencerAnnotation) {
        NSString *AnnotationViewID = @"CencerAnnotation";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            
//            annotationView.pinColor = BMKPinAnnotationColorRed;
            annotationView.image=[UIImage imageNamed:@"gyhd_gps_dingwei"];
            
            
        }
        return annotationView;
    }
    
    return nil;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
#pragma mark- BMKUserLocation Delegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    [_mapView updateLocationData:userLocation];
    [_locationService stopUserLocationService];

    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
}

#pragma mark-tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearchByFixName) {
        
        return self.retrievalArray.count;
    }else {
        
        return self.searchArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYHDMapCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GYHDMapCell"];
    
    if (cell==nil) {
        
        cell=[[GYHDMapCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GYHDMapCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (self.isSearchByFixName && self.retrievalArray.count>0) {
        
        BMKPoiInfo * aInfo = self.retrievalArray[indexPath.row];
        cell.textLabel.text=aInfo.name;
        cell.detailTextLabel.text=aInfo.address;
        
    }else if(!self.isSearchByFixName && self.searchArray.count>0) {
        
        BMKPoiInfo * aInfo = self.searchArray[indexPath.row];
        cell.textLabel.text= aInfo.name;
        cell.detailTextLabel.text= aInfo.address;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    if (self.isSearchByFixName && self.retrievalArray.count>0) {
        
        self.isNotMoveMap = YES;
        
        BMKPoiInfo * aInfo = self.retrievalArray[indexPath.row];
        self.cencerAnnotation.coordinate = aInfo.pt;
        [_mapView setCenterCoordinate:aInfo.pt animated:YES];
    
        
    }else if(!self.isSearchByFixName && self.searchArray.count>0){
        
        self.isNotMoveMap = YES;
        BMKPoiInfo * aInfo = self.searchArray[indexPath.row];
        self.cencerAnnotation.coordinate = aInfo.pt;
        [_mapView setCenterCoordinate:aInfo.pt animated:YES];

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
}

#pragma mark - 选中按钮检索
-(void)click:(UIButton *)sender{
    
    [self selectTitleBtn:sender];
    self.fixNameCurentPage=1;
    NSLog(@"%@%ld",sender.currentTitle,sender.tag);
    [self.searchArray removeAllObjects];
    [self.retrievalArray removeAllObjects];
    
    [self getShopListData];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self searchAction];
    
    return YES;
}
#pragma mark - 输入检索
-(void)searchAction{
    [self.textField resignFirstResponder];
    NSLog(@"搜索%@",self.textField.text);
    
    if (self.textField.text.length<=0) {
        
        return;
    }
    self.searchCurentPage=1;
    [self.searchArray removeAllObjects];
    [self.retrievalArray removeAllObjects];
    self.retrievalTableView.tableHeaderView=[[UIView alloc]init];
    [self getSearchShopListData];
    
}

-(void)getSearchShopListData{
    self.isSearchByFixName=NO;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.textField.text forKey:@"keyword"];
    [dict setValue:@"7" forKey:@"sortType"];
    [dict setValue:@"" forKey:@"specialService"];
    [dict setValue:@"10" forKey:@"count"];
    [dict setValue:@"" forKey:@"hasCoupon"];
    [dict setValue:[NSString stringWithFormat:@"%ld",self.searchCurentPage] forKey:@"currentPage"];
    [dict setValue:[NSString stringWithFormat:@"%f,%f",self.curPoiInfo.pt.latitude,self.curPoiInfo.pt.longitude ] forKey:@"location"];
    
    [GYNetwork GET:[NSString stringWithFormat:@"%@/easybuy/searchShop",[GYLoginEn sharedInstance].getDefaultRetailDomain] parameter:dict success:^(id returnValue) {
        
        if ([returnValue[@"retCode"]integerValue]==200) {
            
            for (NSDictionary *dict in returnValue[@"data"]) {
                BMKPoiInfo *poiInfo = [[BMKPoiInfo alloc] init];
                poiInfo.name = dict[@"vShopName"];
                poiInfo.address = dict[@"addr"];
                _coor.latitude=[dict[@"lat"]floatValue];
                _coor.longitude=[dict[@"longitude"]floatValue];
                poiInfo.pt=_coor;
                [self.searchArray addObject:poiInfo];
            }
            if (self.curPoiInfo!=nil && ![self.searchArray containsObject:self.curPoiInfo] && self.searchCurentPage==1) {
                
                [self.searchArray insertObject: self.curPoiInfo atIndex:0];
            }
            [self.retrievalTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];

}
-(void)getShopListData{
    self.isSearchByFixName =YES;
    if (self.selectedBtn.tag==1004) {
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        dict[@"city"] =kSaftToNSString(self.curPoiInfo.city);
        dict[@"currentPageIndex"] = [NSString stringWithFormat:@"%ld",self.fixNameCurentPage];
        dict[@"everFlag"] = @"2";
        dict[@"key"] = @"";
        dict[@"landmark"] = [NSString stringWithFormat:@"%f,%f",self.curPoiInfo.pt.latitude,self.curPoiInfo.pt.longitude];
        dict[@"pageSize"] = @"10";
        dict[@"type"] = @"1";
        [GYNetwork GET:[NSString stringWithFormat:@"%@/ph/food/mainPage",[GYLoginEn sharedInstance].getFoodConsmerDomain] parameter:dict success:^(id returnValue) {
            
            if ([returnValue[@"retCode"]integerValue]==200) {
                for (NSDictionary *dict in [returnValue[@"data"] firstObject][@"shopList"]) {
                    BMKPoiInfo *poiInfo = [[BMKPoiInfo alloc] init];
                    poiInfo.name = dict[@"shopName"];
                    poiInfo.address = dict[@"shopAddr"];
                    _coor.latitude=[dict[@"lat"]floatValue];
                    _coor.longitude=[dict[@"longitude"]floatValue];
                    poiInfo.pt=_coor;
                    [self.retrievalArray addObject:poiInfo];
                }
                if(self.fixNameCurentPage==1) {
                    
                    [self.retrievalArray insertObject:  self.curPoiInfo atIndex:0];
                }
                
                [self.retrievalTableView reloadData];
            }
           
        } failure:^(NSError *error) {
            
        }];
        
    }else if (self.selectedBtn.tag==1005){
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        dict[@"city"] =kSaftToNSString(self.curPoiInfo.city);
        dict[@"currentPageIndex"] = [NSString stringWithFormat:@"%ld",self.fixNameCurentPage];
        dict[@"everFlag"] = @"2";
        dict[@"key"] = @"";
        dict[@"landmark"] = [NSString stringWithFormat:@"%f,%f",self.curPoiInfo.pt.latitude,self.curPoiInfo.pt.longitude];
        dict[@"pageSize"] = @"10";
        dict[@"type"] = @"2";
        [GYNetwork GET:[NSString stringWithFormat:@"%@/ph/food/mainPage",[GYLoginEn sharedInstance].getFoodConsmerDomain] parameter:dict success:^(id returnValue) {
            
            if ([returnValue[@"retCode"]integerValue]==200) {
                for (NSDictionary *dict in returnValue[@"data"]) {
                    BMKPoiInfo *poiInfo = [[BMKPoiInfo alloc] init];
                    poiInfo.name = dict[@"shopName"];
                    poiInfo.address = dict[@"shopAddr"];
                    _coor.latitude=[dict[@"lat"]floatValue];
                    _coor.longitude=[dict[@"longitude"]floatValue];
                    poiInfo.pt=_coor;
                    [self.retrievalArray addObject:poiInfo];
                }
                if(self.fixNameCurentPage==1) {
                    
                    [self.retrievalArray insertObject:  self.curPoiInfo atIndex:0];
                }
                [self.retrievalTableView reloadData];
            }
           
        } failure:^(NSError *error) {
            
        }];
        
    }else{
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:kSaftToNSString(self.curPoiInfo.city) forKey:@"city"];
        [dict setValue:@"" forKey:@"area"];
        [dict setValue:@"" forKey:@"section"];
        [dict setValue:@"10" forKey:@"count"];
        [dict setValue:[NSString stringWithFormat:@"%ld",self.fixNameCurentPage] forKey:@"currentPage"];
        [dict setValue:[NSString stringWithFormat:@"%ld",self.selectedBtn.tag] forKey:@"categoryId"];
        [dict setValue:@"1" forKey:@"sortType"];
        [dict setValue:[NSString stringWithFormat:@"%f,%f",self.curPoiInfo.pt.latitude,self.curPoiInfo.pt.longitude]forKey:@"location"];
        [dict setValue:@"" forKey:@"supportService"];
        [dict setValue:@"" forKey:@"distance"];
        [dict setValue:@"" forKey:@"hasCoupon"];
        
        [GYNetwork GET:[NSString stringWithFormat:@"%@/shops/v2/getTopicList",[GYLoginEn sharedInstance].getDefaultRetailDomain] parameter:dict success:^(id returnValue) {
            
            if ([returnValue[@"retCode"]integerValue]==200) {
                
                for (NSDictionary *dict in returnValue[@"data"]) {
                    BMKPoiInfo *poiInfo = [[BMKPoiInfo alloc] init];
                    poiInfo.name = dict[@"companyName"];
                    poiInfo.address = dict[@"addr"];
                    _coor.latitude=[dict[@"lat"]floatValue];
                    _coor.longitude=[dict[@"longitude"]floatValue];
                    poiInfo.pt=_coor;
                    [self.retrievalArray addObject:poiInfo];
                }
                if (self.curPoiInfo!=nil && ![self.retrievalArray containsObject:self.curPoiInfo] && self.fixNameCurentPage==1) {
                    
                    [self.retrievalArray insertObject:  self.curPoiInfo atIndex:0];
                }
                [self.retrievalTableView reloadData];
            }
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    if (textField.text.length<=0) {
//        [self.textField resignFirstResponder];
//        [self click:self.selectedBtn];
//        self.retrievalTableView.tableHeaderView=self.titleScrollView;
//    }
    return YES;
}

-(void)textFieldChanged:(UITextField*)textField{

        if (textField.text.length<=0) {
            [self.textField resignFirstResponder];
            [self click:self.selectedBtn];
            self.retrievalTableView.tableHeaderView=self.titleScrollView;
        }

}

#pragma mark -滑动按钮相关
-(void)setTitleScrollView{
    
    CGRect rect  = CGRectMake(0, 0, 350, 50);
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:rect];

}

-(void)setupTitle{
    NSUInteger count = self.titlesArr.count;
    
    CGFloat x = 0;
    CGFloat w = 80;
    CGFloat h = titleH;
    for (int i = 0; i < count; i++)
    {
        NSDictionary*dic=self.titlesArr[i];
        NSString*str=dic[@"categoryName"];
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.tag = [dic[@"id"]integerValue];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];
        
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
}

-(void)selectTitleBtn:(UIButton *)btn{

    [self.selectedBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    self.selectedBtn.transform = CGAffineTransformIdentity;
    
    [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:143/255.0 blue:215/255.0 alpha:1.0] forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(MaxScale, MaxScale);
    self.selectedBtn = btn;
    [self setupTitleCenter:btn];
    
}

-(void)setupTitleCenter:(UIButton *)sender
{
    
    CGFloat offset = sender.center.x - 350 * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    if (self.titleScrollView.contentSize.width>0) {
        
        CGFloat maxOffset  = self.titleScrollView.contentSize.width - 350;
        if (offset > maxOffset) {
            offset = maxOffset;
        }
        [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
  
}
@end

