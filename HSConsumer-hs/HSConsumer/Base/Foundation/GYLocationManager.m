//
//  GYLocationManager.m
//  HSConsumer
//
//  Created by wangfd on 16/6/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYLocationManager.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface GYLocationManager () <CLLocationManagerDelegate, BMKGeneralDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) BMKMapManager* bmkMapManager;
@property (nonatomic, strong) BMKGeoCodeSearch* geocodesearch;

@property (nonatomic, strong) GYLocationManagerCityNameBlock cityBlock;
@property (nonatomic, strong) GYLocationManagerLocalCoordinate localCoordBlock;

@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, assign) BOOL isFirstRun;

@end

@implementation GYLocationManager

+ (instancetype)sharedInstance
{
    static GYLocationManager* locationMgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationMgr = [[GYLocationManager alloc] init];
    });

    return locationMgr;
}

- (void)startMapService
{
    NSString* mapKey = kBaiduMapReleaseKey;
    if ([kBundleId isEqualToString:@"com.hsxt.hsxt.test"]) {
        mapKey = kBaiduMapTestKey;
    }
    else if ([kBundleId isEqualToString:@"com.hsxt.hsxt.demo"]) {
        mapKey = kBaiduMapDemoKey;
    }

    if ([self.bmkMapManager start:mapKey generalDelegate:self]) {
        DDLogDebug(@"Succesed to run: BMKMapManager start.");
    }
}

- (void)reverseAdress:(GYLocationManagerCityNameBlock)cityBlock
{
    if (cityBlock == nil) {
        return;
    }
    self.cityBlock = cityBlock;
    if ([self checkLocationStatus]) {
        [self restartLocation];
    }
    else {
        DDLogDebug(@"The local service is not available.");
        self.cityBlock(nil, nil);
        self.cityBlock = nil;
    }
}

- (BOOL)checkLocationStatus
{
    BOOL result = NO;
    BOOL serviceEnable = [self locationServiceEnabled];
    GYLocationManagerLocationServiceStatus authorizationStatus = [self locationServiceStatus];

    if (authorizationStatus == GYLocationManagerLocationServiceStatusOK && serviceEnable) {
        result = YES;
    }
    else if (authorizationStatus == GYLocationManagerLocationServiceStatusNotDetermined) {
        result = YES;
    }
    else {
        result = NO;
    }

    if (serviceEnable && result) {
        result = YES;
    }
    else {
        result = NO;
    }

    DDLogDebug(@"serviceEnable:%d, authorizationStatus:%lu", serviceEnable, (unsigned long)authorizationStatus);
    return result;
}

- (GYLocationManagerLocationServiceStatus)locationServiceStatus
{
    BOOL serviceEnable = [CLLocationManager locationServicesEnabled];
    if (!serviceEnable) {
        return GYLocationManagerLocationServiceStatusUnAvailable;
    }

    GYLocationManagerLocationServiceStatus locationStatus = GYLocationManagerLocationServiceStatusUnknownError;
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];

    switch (authorizationStatus) {
    case kCLAuthorizationStatusNotDetermined:
        locationStatus = GYLocationManagerLocationServiceStatusNotDetermined;
        break;

    case kCLAuthorizationStatusAuthorizedAlways:
    case kCLAuthorizationStatusAuthorizedWhenInUse:
        locationStatus = GYLocationManagerLocationServiceStatusOK;
        break;

    case kCLAuthorizationStatusDenied:
        locationStatus = GYLocationManagerLocationServiceStatusNoAuthorization;
        break;

    default:
        break;
    }

    return locationStatus;
}

- (void)localCoordinate:(BOOL)relocation block:(GYLocationManagerLocalCoordinate)localCoordinateBlock
{
    if (localCoordinateBlock == nil) {
        DDLogDebug(@"The localCoordinateBlock is nil.");
        return;
    }

    self.localCoordBlock = localCoordinateBlock;

    // 不需要定位使用本地缓存数据
    if ((!relocation) && (self.currentCoordinate.latitude != 0) && (self.currentCoordinate.longitude != 0)) {
        self.localCoordBlock([self changeGPSToBaiduCoordinate:self.currentCoordinate]);
        self.localCoordBlock = nil;
        return;
    }

    if ([self checkLocationStatus]) {
        [self restartLocation];
    }
    else {
        DDLogDebug(@"The local service is not available.");
        self.localCoordBlock([self changeGPSToBaiduCoordinate:self.currentCoordinate]);
        self.localCoordBlock = nil;
    }
}

#pragma mark - BMKGeneralDelegate
- (void)onGetPermissionState:(int)iError
{
    if (iError == 0) {
        DDLogDebug(@"Succesed to start BaiduMap service.");
    }
    else {
        DDLogDebug(@"Failed to start BaiduMap service, iError:%d", iError);
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    CLLocation* location = [locations objectAtIndex:0];
    CLLocationCoordinate2D coord = location.coordinate;
    self.currentCoordinate = coord;

    if ((coord.latitude != 0) && (coord.longitude != 0)) {
        [self stopLocation];
    }

    if (self.localCoordBlock) {
        if ((coord.latitude == 0) && (coord.longitude == 0)) {
            DDLogDebug(@"Lat and lon is zero.");
            return;
        }

        self.localCoordBlock([self changeGPSToBaiduCoordinate:coord]);
        self.localCoordBlock = nil;
    }

    if (self.cityBlock) {
        if (self.isFirstRun) {
            return;
        }

        self.isFirstRun = YES;
        [self parseAdress:[self changeGPSToBaiduCoordinate:coord]];
    }
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    DDLogInfo(@"locationManager, Error:%@, ErrorCode:%ld", [error localizedDescription], (long)[error code]);
    if (self.localCoordBlock) {
        self.localCoordBlock([self changeGPSToBaiduCoordinate:self.currentCoordinate]);
        self.localCoordBlock = nil;
    }

    if (self.cityBlock) {
        self.cityBlock(nil, nil);
        self.cityBlock = nil;
    }
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    GYLocationManagerLocationServiceStatus authorizationStatus = [self locationServiceStatus];

    if (authorizationStatus == GYLocationManagerLocationServiceStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }

        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch*)searcher result:(BMKReverseGeoCodeResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (self.cityBlock) {
        NSString* city = nil;
        NSString* address = nil;

        if (error == BMK_SEARCH_NO_ERROR) {
            city = result.addressDetail.city;
            address = result.address;
        }

        self.cityBlock(city, address);
        self.cityBlock = nil;

        // 使用完释放掉
        self.geocodesearch.delegate = nil;
        self.geocodesearch = nil;
    }
}

#pragma mark - private methods
- (void)startLocation
{
    if ([self checkLocationStatus]) {
        [self.locationManager startUpdatingLocation];
    }
    else {
        DDLogDebug(@"Failed to run checkLocationStatus.");
    }
}

- (void)stopLocation
{
    if ([self checkLocationStatus]) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)restartLocation
{
    self.isFirstRun = NO;
    [self stopLocation];
    [self startLocation];
}

- (BOOL)locationServiceEnabled
{
    if ([CLLocationManager locationServicesEnabled]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)parseAdress:(CLLocationCoordinate2D)pt
{
    BMKReverseGeoCodeOption* reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];

    if (flag) {
        DDLogDebug(@"Sucessed to reverse address");
    }
    else {
        DDLogDebug(@"Failed to reverse address");

        if (self.cityBlock) {
            self.cityBlock(nil, nil);
            self.cityBlock = nil;

            // 使用完释放掉
            self.geocodesearch.delegate = nil;
            self.geocodesearch = nil;
        }
    }
}

- (CLLocationCoordinate2D)changeGPSToBaiduCoordinate:(CLLocationCoordinate2D)coord
{
    return BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(coord, BMK_COORDTYPE_GPS));
}

#pragma mark - getters and setters
- (CLLocationManager*)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 5.0;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {

            //由于IOS8中定位的授权机制改变 需要进行手动授权 获取授权认证
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
    }

    return _locationManager;
}

- (BMKMapManager*)bmkMapManager
{
    if (_bmkMapManager == nil) {
        _bmkMapManager = [[BMKMapManager alloc] init];
    }

    return _bmkMapManager;
}

- (BMKGeoCodeSearch*)geocodesearch
{
    if (_geocodesearch == nil) {
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        _geocodesearch.delegate = self;
    }
    
    return _geocodesearch;
}

@end
