//
//  GYPOSService.h
//  company
//
//  Created by liangzm on 15-4-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYPOSService.h"
#import "QPOSService.h"



@class GYCardReaderModel;
typedef void (^ConnectionPOSBlock)(BOOL connected, id posDevice);
typedef void (^DisconnectionPOSBlock)();

@protocol GYPOSServiceDelegate <NSObject>
@optional
- (void)getOnePosDevice:(GYCardReaderModel*)posModel isScanning:(BOOL)isScanning; //搜索到一个蓝牙设备

@end

@interface GYPOSService : NSObject
@property (nonatomic, assign, getter=canSwipeCard) BOOL swipeCard;//刷卡是否有效
@property (nonatomic, assign) BOOL isConnect; //是否已经连接上pos刷卡器
@property (nonatomic, strong) GYCardReaderModel* posInfo; //当前连接上的pos信息
@property (nonatomic, strong) NSMutableArray* arrPosDevices; //搜索到的所有蓝牙列表
@property (nonatomic, copy) DisconnectionPOSBlock disconnectionPOSBlock;
@property (nonatomic, copy) ConnectionPOSBlock connectionPOSBlock;
@property (nonatomic, weak) id<GYPOSServiceDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)scanBluetooth;
- (void)stopScanBluetooth;

//连接刷卡器
- (void)connectionPOS:(NSString*)bluetoothName callbackBlock:(ConnectionPOSBlock)block;
- (void)disConnectionPOS;
// 刷卡
- (void)swipingCard;
// 确认互生币金额
-(void)confirkHSpay:(NSString *)amount;
//退货确认
- (void)returnAmount:(NSString *)amount;
//发送指令活动密码
-(void)inputPwdWithPwdLength:(NSInteger)pwdLength;

#pragma mark - 配置参数
@property (nonatomic, copy) NSString *couponMax;
@property (nonatomic, copy) NSString *couponAmount;
@property (nonatomic, copy) NSString *couponRate;
@end
