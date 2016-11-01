//
//  GYLocationManager.h
//  HSConsumer
//
//  Created by wangfd on 16/6/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GYLocationManagerLocationServiceStatus) {
    GYLocationManagerLocationServiceStatusDefault, //默认状态
    GYLocationManagerLocationServiceStatusOK, //定位功能正常
    GYLocationManagerLocationServiceStatusUnknownError, //未知错误
    GYLocationManagerLocationServiceStatusUnAvailable, //定位功能关掉了
    GYLocationManagerLocationServiceStatusNoAuthorization, //定位功能打开，但是用户不允许使用定位
    GYLocationManagerLocationServiceStatusNoNetwork, //没有网络
    GYLocationManagerLocationServiceStatusNotDetermined //用户还没做出是否要允许应用使用定位功能的决定，第一次安装应用的时候会提示用户做出是否允许使用定位功能的决定
};

typedef void (^GYLocationManagerCityNameBlock)(NSString* cityName, NSString* address);
typedef void (^GYLocationManagerLocalCoordinate)(CLLocationCoordinate2D coord);

@interface GYLocationManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  启动地图服务
 *  说明：使用地图前需要先启动地图的服务，否则地图无法使用
 */
- (void)startMapService;

/**
 *  获取城市名称
 *
 *  @param tCityBlock 回调返回城市名
 */
- (void)reverseAdress:(GYLocationManagerCityNameBlock)cityBlock;

/**
 *   检查定位服务是否打开
 *
 *  @param YES 可用，NO不可用
 */
- (BOOL)checkLocationStatus;

/**
 *    获取服务的状态
 *
 *    @return 状态结果
 */
- (GYLocationManagerLocationServiceStatus)locationServiceStatus;

/**
 *  获取当前位置的坐标, relocation 为是否需要重新定位，如果为NO 如果有数据了则直接返回数据
 *
 *  @param relocation YES 为重新定位，NO 如果已经定位过则不再定位
 *  @param block 回调返回定位的坐标
 */
- (void) localCoordinate:(BOOL)relocation block:(GYLocationManagerLocalCoordinate)localCoordinateBlock;

@end
