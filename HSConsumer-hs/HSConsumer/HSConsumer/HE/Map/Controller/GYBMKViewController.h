//
//  GYBMKViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h> //引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h> //引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h> //引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h> //引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h> //引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h> //引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h> //只引入所需的单个头文件
#import "GYEasyBuyModel.h"
#import "RoutePlan.h"
@interface GYBMKViewController : GYViewController <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKRouteSearchDelegate, RouteDelegate> {
    BMKRouteSearch* _routesearch;
}
@property (nonatomic, assign) BOOL isSetMapSpan;
@property (nonatomic, strong) NSMutableArray *marr;
@property (nonatomic, assign) CLLocationCoordinate2D coordinateLocation;//接受店铺的经纬度
@property (nonatomic, copy) NSString *strShopId;

@end
