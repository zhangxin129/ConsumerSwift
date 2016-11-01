//
//  GYNewMapViewController.m
//  HSConsumer
//
//  Created by appleliss on 15/12/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMapLocationViewController.h"
#import "UIView+Extension.h"

@interface GYMapLocationViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    BMKPointAnnotation* _annotation;
    BMKPoiSearch* _poisearch;
    BMKGeoCodeSearch* _geocodesearch;

    BMKSearchBase* _search;
    BMKReverseGeoCodeOption* reverseGeocodeSearchOption;
    IBOutlet UIView* goodPaopao;
    __weak IBOutlet NSLayoutConstraint* addressHeight;
    __weak IBOutlet NSLayoutConstraint* shopNameHeight;
    __weak IBOutlet UILabel* addressLable;
    __weak IBOutlet UILabel* shopNameLabel;
    __weak IBOutlet NSLayoutConstraint* topLayoutConstraint;
    __weak IBOutlet UITableView* seachTable;
    __weak IBOutlet NSLayoutConstraint* leftLayoutConstraint;
    __weak IBOutlet NSLayoutConstraint* tableHeightLayoutConstraint;
    __weak IBOutlet NSLayoutConstraint* rightLayoutConstraint;
    bool isGeoSearch;
    __weak IBOutlet UIView* seachView;
}

@property (weak, nonatomic) IBOutlet UITextField* myTextFiled;
@property (weak, nonatomic) IBOutlet UIButton* seachBtn;
@property (nonatomic, strong) CALayer* myLayer;
@property (nonatomic, assign) CGRect tableFrame;
@property (nonatomic, strong) NSMutableArray* mapdataArry;
@property (nonatomic, assign) BOOL btnClick;
@property (nonatomic, assign) BOOL didCell;
@property (nonatomic, strong) NSString* stext;
@end

@implementation GYMapLocationViewController
////返回
- (IBAction)backView:(UITapGestureRecognizer*)sender
{
    NSString *location = [NSString stringWithFormat:@"%f,%f", _annotation.coordinate.latitude, _annotation.coordinate.longitude];
    globalData.selectedCityCoordinate = location;
    if ([self.delegate respondsToSelector:@selector(getCity:getIsLocation:)]) {
        [self.delegate getCity:self.city getIsLocation:location];
    }
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)seachBtn:(UIButton*)sender
{
    [_myTextFiled resignFirstResponder];
    _btnClick = YES;
    _didCell = NO;
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });

    tableHeightLayoutConstraint.constant = 0;
    [_mapdataArry removeAllObjects];
    [seachTable reloadData];

    [self seach:_btnClick andDidCell:NO];
}

///搜索
- (void)seach:(BOOL)click andDidCell:(BOOL)cell
{
    [_myTextFiled resignFirstResponder];
    if (_stext == nil && self.myTextFiled.text == nil) {
        return;
    }
    BMKCitySearchOption* citySearchOption = [[BMKCitySearchOption alloc] init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 5;
    citySearchOption.city = self.city;

    if ([self.myTextFiled.text isEqualToString:@""]) {
        if ([self.city isEqualToString:kLocalized(@"GYHE_SurroundVisit_HongKong")] || [self.city isEqualToString:kLocalized(@"GYHE_SurroundVisit_MaCao")]) {
            citySearchOption.keyword = [NSString stringWithFormat:@"%@%@", self.city, kLocalized(@"GYHE_SurroundVisit_SARGovernment")];
        }
        else if ([self.city isEqualToString:kLocalized(@"GYHE_SurroundVisit_BeijingCity")]) {
            citySearchOption.keyword = kLocalized(@"GYHE_SurroundVisit_Beijing_Dongcheng_DistrictCity_JusticeRoad_No. 2");
        }
        else {
            citySearchOption.keyword = [NSString stringWithFormat:@"%@%@", self.city, _stext];
        }
        _stext = @"";
    }
    else {
        citySearchOption.keyword = self.myTextFiled.text;
    }

    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if (flag) {
        _seachBtn.enabled = true;
        DDLogDebug(@"城市内检索发送成功");
    }
    else {
        _seachBtn.enabled = false;
        DDLogDebug(@"城市内检索发送失败");
    }
}

////修改过表格的高度
- (void)updateTableHeight:(BOOL)btnClick:(BOOL)didCell
{
    if (btnClick == YES) {
        [UIView animateWithDuration:0.2 animations:^{
            if (tableHeightLayoutConstraint.constant == 0) {
                tableHeightLayoutConstraint.constant = 150;
            } else {
                tableHeightLayoutConstraint.constant = 0;
            }
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                if (didCell == YES) {
                    tableHeightLayoutConstraint.constant = 0;
                } else {
                    tableHeightLayoutConstraint.constant = 150;
                }
                //            tableHeightLayoutConstraint.constant=150;
                [self.view layoutIfNeeded];
            }];
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    _btnClick = YES;
    _didCell = NO;
    [self seach:_btnClick andDidCell:_didCell];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    _geocodesearch.delegate = self;
    _annotation = [[BMKPointAnnotation alloc] init];
    _mapdataArry = [NSMutableArray array];
    seachTable.layer.bounds = seachTable.frame;
    seachTable.layer.position = CGPointMake(50, 50);
    seachTable.layer.cornerRadius = 10;
    tableHeightLayoutConstraint.constant = 0;
    _stext = kLocalized(@"GYHE_SurroundVisit_Government");
    [self.seachBtn setTitle:kLocalized(@"GYHE_SurroundVisit_Search") forState:UIControlStateNormal];

    //适配ios7
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    _poisearch = [[BMKPoiSearch alloc] init];
    // 设置地图级别
    [_mapView setZoomLevel:13];
    _seachBtn.enabled = false;
    _mapView.isSelectedAnnotationViewFront = YES;
    [self.view bringSubviewToFront:seachView];
    [seachView setHidden:YES];
    [self.view bringSubviewToFront:seachTable];
    seachTable.delegate = self;
    seachTable.dataSource = self;
    _btnClick = NO;
    _didCell = NO;
    [self seach:_btnClick andDidCell:_didCell];
    
    [self setNav];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self;
    _geocodesearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil;
    _geocodesearch.delegate = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)setNav
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIImageView* leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 24, 24, 24)];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    leftImage.image = [UIImage imageNamed:@"gy_he_map_back"];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushBack)];
    [leftImage addGestureRecognizer:tapSetting];
    [view addSubview:leftImage];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 30, 24, 60, 21)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"位置";
    label.font = [UIFont systemFontOfSize:17];
    label.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 50, 25, 40, 21)];
    [confirmBtn setTitle:[GYUtils localizedStringWithKey:@"确定"] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    confirmBtn.titleLabel.textColor = [UIColor blackColor];
    [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmBtn];
}

-(void)pushBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)confirmClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tableDelegt
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mapdataArry.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* idcell = @"GYNewMapViewController";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:idcell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idcell];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (_mapdataArry.count > indexPath.row) {
        _annotation = _mapdataArry[indexPath.row];
        cell.textLabel.text = _annotation.title;
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
    if (_mapdataArry.count > indexPath.row) {
        _annotation = _mapdataArry[indexPath.row];
        self.myTextFiled.text = _annotation.title;
    }
    _didCell = YES;
    _btnClick = YES;
    [self seach:_btnClick andDidCell:_didCell];
    //    [self updateTableHeight:nil];
}

- (void)dealloc
{
    if (_poisearch != nil) {
        _poisearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
}

#pragma mark 底图手势操作
/**
 *点中底图标注后会回调此接口
 *@param mapview 地图View
 *@param mapPoi 标注点信息
 */
- (void)mapView:(BMKMapView*)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    CLLocationCoordinate2D coords = mapPoi.pt;
    _annotation.coordinate = coords;
    _annotation.title = mapPoi.text;
    [_mapView addAnnotation:_annotation];
    self.isCao = YES;
    [self updateTableHeight:NO:NO];

    reverseGeocodeSearchOption.reverseGeoPoint = coords;
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}

/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView*)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    _annotation.coordinate = coordinate;
    _annotation.title = @"";
    [_mapView addAnnotation:_annotation];
    self.isCao = YES;
    [self updateTableHeight:NO:NO];

    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}

/**
 *双击地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回双击处坐标点的经纬度
 */
- (void)mapview:(BMKMapView*)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate
{
    DDLogDebug(@"onDoubleClick-latitude==%f,longitude==%f", coordinate.latitude, coordinate.longitude);
}

/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
- (void)mapview:(BMKMapView*)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    DDLogDebug(@"onLongClick-latitude==%f,longitude==%f", coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(BMKMapView*)mapView regionDidChangeAnimated:(BOOL)animated
{
    //        NSString* showmeg = [NSString stringWithFormat:@"地图区域发生了变化(x=%d,y=%d,\r\nwidth=%d,height=%d).\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d",(int)_mapView.visibleMapRect.origin.x,(int)_mapView.visibleMapRect.origin.y,(int)_mapView.visibleMapRect.size.width,(int)_mapView.visibleMapRect.size.height,(int)_mapView.zoomLevel,_mapView.rotation,_mapView.overlooking];
    //    DDLogDebug(@"%@",showmeg);
}

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];

    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray* annotations = [NSMutableArray array];

        BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:0];
        if (poi == nil) {
            [GYUtils showToast:kLocalized(@"GYHE_SurroundVisit_NOSearchResult") ];
            return;
        }

        _annotation = [[BMKPointAnnotation alloc] init];
        _annotation.coordinate = poi.pt;
        _annotation.title = poi.name;
        _mapView.centerCoordinate = poi.pt;
        [_mapdataArry addObject:_annotation];

        [annotations addObject:_annotation];
        reverseGeocodeSearchOption.reverseGeoPoint = _annotation.coordinate;
        [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];

        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
        [seachTable reloadData];
        [self updateTableHeight:_btnClick:_didCell];
    }
    else {
        [GYUtils showToast:kLocalized(@"GYHE_SurroundVisit_NOSearchResult")];
    }
}

//根据anntation生成对应的View
- (BMKAnnotationView*)mapView:(BMKMapView*)view viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString* AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
        ((BMKPinAnnotationView*)annotationView).image = [UIImage imageNamed:@"gyhe_location_red"];
    }
    //    UIView *goodPaopaoBezier = [[UIView alloc]init];
    //    CGRect gf = goodPaopao.frame;
    //    gf.size.height = goodPaopao.frame.size.height+25;
    //    goodPaopaoBezier.frame=gf;
    //    GYBezier  *bezier = [[GYBezier alloc]init];
    //    bezier.backgroundColor = [UIColor clearColor];
    //    bezier.frame = CGRectMake(goodPaopao.center.x-10, goodPaopao.frame.size.height, 20, 30);
    //    [goodPaopaoBezier addSubview:goodPaopao];
    //    [goodPaopaoBezier addSubview:bezier];
    //    [goodPaopao.layer setBorderWidth:1.0];
    //    [goodPaopao.layer setBorderColor:[UIColor whiteColor].CGColor];
    //    [goodPaopao.lay er setCornerRadius:15.0];

    BMKActionPaopaoView* pView = [[BMKActionPaopaoView alloc] initWithCustomView:goodPaopao];
    pView.frame = goodPaopao.frame;
    annotationView.paopaoView = nil;
    annotationView.paopaoView = pView;
    annotationView.selected = YES;
    annotationView.size = CGSizeMake(20, 30);
    return annotationView;
}

////点击地图上的小红点方法
- (void)mapView:(BMKMapView*)mapView didSelectAnnotationView:(BMKAnnotationView*)view
{

    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}

////回调方法 保存 显示详细地址和名称
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch*)searcher result:(BMKReverseGeoCodeResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc] init];
        item.coordinate = result.location;
        item.title = result.address;
        //        item.title =[NSString stringWithFormat:@"%@%@%@",result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = item.coordinate;
        if (_annotation.title) {
            shopNameLabel.text = _annotation.title;
        
//            CGFloat heg = [GYUtils heightForString:shopNameLabel.text font:[UIFont systemFontOfSize:15] width:150.f];
            CGFloat heg = [GYUtils heightForString:shopNameLabel.text fontSize:15 andWidth:150.0f];
            shopNameHeight.constant = heg;
        }
        else {
            shopNameHeight.constant = 0;
        }

//        CGFloat heg = [GYUtils heightForString:item.title font:[UIFont systemFontOfSize:12] width:150];
        
        CGFloat heg = [GYUtils heightForString:item.title fontSize:12 andWidth:150];
        addressHeight.constant = heg;
        addressLable.text = item.title;
        [self changePopViewFrame:item.title];

        globalData.selectedCityAddress = item.title;
        if (self.isCao == YES) {
            globalData.selectedCityName = result.addressDetail.city;
        }
    }
}

- (void)mapView:(BMKMapView*)mapView didAddAnnotationViews:(NSArray*)views
{
    DDLogDebug(@"didAddAnnotationViews");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changePopViewFrame:(NSString*)title
{
    if ([GYUtils checkStringInvalid:title]) {
        return;
    }
    
    CGFloat popViewWidth = [GYUtils sizeForString:title font:[UIFont systemFontOfSize:12] width:kScreenWidth - 30].width;
    popViewWidth += 30;
    popViewWidth = (popViewWidth > 165) ? popViewWidth : 165;
    popViewWidth = (popViewWidth > kScreenWidth - 30) ? kScreenWidth - 30 : popViewWidth;
    
    CGRect popFrame = goodPaopao.frame;
    popFrame.size.width = popViewWidth;
    goodPaopao.frame = popFrame;
}

@end
