//
//  GYNewMapViewController.h
//  HSConsumer
//
//  Created by appleliss on 15/12/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@protocol GYMapLocationViewControllerDelegate <NSObject>
@optional
- (void)getCity:(NSString*)CityTitle getIsLocation:(NSString*)location;
@end
@interface GYMapLocationViewController : GYViewController <BMKGeneralDelegate, BMKMapViewDelegate, BMKPoiSearchDelegate, BMKGeoCodeSearchDelegate> {
    IBOutlet BMKMapView* _mapView;
}
@property (nonatomic, strong) NSString* city;
@property (nonatomic, assign) BOOL isLocagtion; ///是否调用手动定位地址
@property (nonatomic, strong) NSString* mylocagtion; ///经纬度
@property (nonatomic, assign) BOOL isCao;
@property (nonatomic, weak) id<GYMapLocationViewControllerDelegate> delegate;
@end
