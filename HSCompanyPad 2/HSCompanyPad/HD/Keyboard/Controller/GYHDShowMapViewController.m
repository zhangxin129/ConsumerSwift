//
//  GYHDShowMapViewController.m
//  HSConsumer
//
//  Created by shiang on 16/7/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDShowMapViewController.h"
#import "UIImage+GYExtension.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
//#import "GYHDNavView.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface GYHDRouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation GYHDRouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface GYHDShowMapViewController ()<BMKMapViewDelegate,BMKRouteSearchDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property(nonatomic, strong)BMKRouteSearch *routesearch;
@property(nonatomic, strong)BMKMapView *mapView;
@property(nonatomic, strong)BMKLocationService *locService;
//@property(nonatomic, strong)BMKPointAnnotation *annotation;//标注
@property(nonatomic, strong)BMKGeoCodeSearch* geocodesearch;
/**起始位置*/
@property(nonatomic, assign)CLLocationCoordinate2D startCoordinate;
/**结束位置*/
@property(nonatomic, assign)CLLocationCoordinate2D endCoordinate;
@property(nonatomic, copy)NSString *cityName;
@end

@implementation GYHDShowMapViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    _routesearch = [[BMKRouteSearch alloc]init];
    _locService = [[BMKLocationService alloc]init];
    self.mapView =[[BMKMapView  alloc] init];
    
    [self.view addSubview:self.mapView];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
    }];
    
	_geocodesearch = [[BMKGeoCodeSearch alloc]init];
    UIButton *busButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [busButton setBackgroundImage:[UIImage imageNamed:@"gyhd_bus_normal"] forState:UIControlStateNormal];
//    [busButton setBackgroundImage:[UIImage imageNamed:@"hd_bus_select"] forState:UIControlStateHighlighted];
    [busButton addTarget:self action:@selector(onClickBusSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:busButton];
    
    UIButton *driverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [driverButton setBackgroundImage:[UIImage imageNamed:@"gyhd_drive_normal"] forState:UIControlStateNormal];
//    [driverButton setBackgroundImage:[UIImage imageNamed:@"hd_drive_select"] forState:UIControlStateHighlighted];
    [driverButton addTarget:self action:@selector(onClickDriveSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:driverButton];
    
    UIButton *walkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [walkButton setBackgroundImage:[UIImage imageNamed:@"gyhd_walk_normal"] forState:UIControlStateNormal];
//    [walkButton setBackgroundImage:[UIImage imageNamed:@"hd_walk_select"] forState:UIControlStateHighlighted];
    [walkButton addTarget:self action:@selector(onClickWalkSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:walkButton];
  
    [busButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [driverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(busButton);
        make.left.equalTo(busButton.mas_right).offset(20);
        make.width.height.equalTo(busButton);
    }];
    
    [walkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(busButton);
        make.left.equalTo(driverButton.mas_right).offset(20);
        make.width.height.equalTo(busButton);
    }];

}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHD_Location_Title");

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]init]];
    self.view.backgroundColor=[UIColor blackColor];
    DDLogInfo(@"Load Controller: %@", [self class]);
}

-(void)viewWillAppear:(BOOL)animated {
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层

    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = self.endCoordinate;
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _routesearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    if (_routesearch != nil) {
        _routesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)setLocationDict:(NSDictionary *)locationDict {
    _locationDict = locationDict;
    CLLocationDegrees latitude = [locationDict[@"map_lat"] doubleValue];
    CLLocationDegrees longitude= [locationDict[@"map_lng"] doubleValue];
    
    self.endCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
}


-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        self.cityName = result.addressDetail.city;

        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(result.location, BMKCoordinateSpanMake(0.02f,0.02f));
        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
    }
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[GYHDRouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(GYHDRouteAnnotation*)annotation];
    }else{
    
        BMKPinAnnotationView* annotationView = (BMKPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"gyhd_gps_dingwei"];
//            [annotationView setSelected:YES animated:YES];
            NSString *titleString = self.locationDict[@"map_name"];
            CGSize titleSize = [GYHDUtils sizeForString:titleString font:[UIFont systemFontOfSize:12] width:340];
            
            NSString *addressString = self.locationDict[@"map_address"];
            CGSize addressSize = [GYHDUtils sizeForString:addressString font:[UIFont systemFontOfSize:12] width:340];
            UIImageView *paoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_pao"]];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.numberOfLines = 0;
            titleLabel.text = titleString;
            titleLabel.frame = CGRectMake(10, 15, titleSize.width, titleSize.height);
            [paoImageView addSubview:titleLabel];
            
            
            UILabel *addressLabel  = [[UILabel alloc] init];
            addressLabel.font = [UIFont systemFontOfSize:12];
            addressLabel.textColor = [UIColor whiteColor];
            addressLabel.numberOfLines = 0;
            addressLabel.textAlignment=NSTextAlignmentCenter;
            addressLabel.text = addressString;
            addressLabel.frame = CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+10, addressSize.width, addressSize.height);
            [paoImageView addSubview:addressLabel];
            
            
            CGFloat popH = CGRectGetMaxY(addressLabel.frame)+30;
            
            paoImageView.frame = CGRectMake(0, 0, 360, popH);
            annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paoImageView];
            
        }
        
        return annotationView;
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
#pragma mark - BMKLocationServiceDelegate
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
       NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.startCoordinate = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
}


#pragma mark - BMKRouteSearchDelegate

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = kLocalized(@"GYHD_Starting_Point");
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = kLocalized(@"GYHD_End_Point");
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
//        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        BMKMapPoint * temppoints= malloc(planPointCounts * sizeof(BMKMapPoint));
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        free(temppoints);
        [self mapViewFitPolyLine:polyLine];
    }
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = kLocalized(@"GYHD_Starting_Point");
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = kLocalized(@"GYHD_End_Point");
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
                item = [[GYHDRouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
//        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        BMKMapPoint * temppoints= malloc(planPointCounts * sizeof(BMKMapPoint));
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        free(temppoints);
        [self mapViewFitPolyLine:polyLine];
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = kLocalized(@"GYHD_Starting_Point");
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = kLocalized(@"GYHD_End_Point");
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
//        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        BMKMapPoint * temppoints= malloc(planPointCounts * sizeof(BMKMapPoint));
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        free(temppoints);
        [self mapViewFitPolyLine:polyLine];
    }
}

/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetRidingRouteResult error:%d", (int)error);
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKRidingRouteLine* plan = (BMKRidingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:i];
            if (i == 0) {
                GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = kLocalized(@"GYHD_Starting_Point");
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
            } else if(i==size-1){
                GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = kLocalized(@"GYHD_End_Point");
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            GYHDRouteAnnotation* item = [[GYHDRouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.degree = (int)transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
     //   BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
//        BMKMapPoint  temppoints[planPointCounts]={0};
     BMKMapPoint * temppoints= malloc(planPointCounts * sizeof(BMKMapPoint));
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
//        delete []temppoints;
        free(temppoints);
        [self mapViewFitPolyLine:polyLine];
    }
}

#pragma mark - action

-(void)onClickBusSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = self.startCoordinate;

    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = self.endCoordinate;
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= self.cityName;
    
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

-(void)onClickDriveSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = self.startCoordinate;
 
//    start.cityName = @"北京市";
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = self.endCoordinate;
//    end.cityName = @"北京市";
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}

-(void)onClickWalkSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = self.startCoordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = self.endCoordinate;

    
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
    
}

- (IBAction)onClickRidingSearch:(id)sender {
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = self.startCoordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = self.endCoordinate;

    
    BMKRidingRoutePlanOption *option = [[BMKRidingRoutePlanOption alloc]init];
    option.from = start;
    option.to = end;
    BOOL flag = [_routesearch ridingSearch:option];
    if (flag)
    {
        NSLog(@"骑行规划检索发送成功");
    }
    else
    {
        NSLog(@"骑行规划检索发送失败");
    }
}

#pragma mark - 私有

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(GYHDRouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

@end


