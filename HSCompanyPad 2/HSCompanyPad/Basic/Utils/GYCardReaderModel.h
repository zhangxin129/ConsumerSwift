//
//  GYCardReaderModel.h
//  HSCompanyPad
//
//  Created by sqm on 16/9/7.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYCardReaderModel : NSObject

@property (nonatomic, copy) NSString* posName; //pos显示的名字
@property (nonatomic, assign) BOOL isConnected; //是否已经接连,用于判断连接状态

//以下是机器自带
@property (nonatomic, copy) NSString* posId;
@property (nonatomic, copy) NSString* csn;
@property (nonatomic, copy) NSString* deviceNumber;
@property (nonatomic, copy) NSString* merchantId;
@property (nonatomic, copy) NSString* psamId;
@property (nonatomic, copy) NSString* psamNo;
@property (nonatomic, copy) NSString* tmk0Status;
@property (nonatomic, copy) NSString* tmk1Status;
@property (nonatomic, copy) NSString* tmk2Status;
@property (nonatomic, copy) NSString* tmk3Status;
@property (nonatomic, copy) NSString* tmk4Status;
@property (nonatomic, copy) NSString* vendorCode;

//===========================固件信息===========================
@property (nonatomic, copy) NSString* batteryLevel;
@property (nonatomic, copy) NSString* bootloaderVersion;
@property (nonatomic, copy) NSString* firmwareVersion;
@property (nonatomic, copy) NSString* hardwareVersion;
@property (nonatomic, copy) NSString* isCharging;
@property (nonatomic, copy) NSString* isSupportedTrack1;
@property (nonatomic, copy) NSString* isSupportedTrack2;
@property (nonatomic, copy) NSString* isSupportedTrack3;
@property (nonatomic, copy) NSString *isUsbConnected;
@property (nonatomic, copy) NSString *updateWorkKeyFlag;
@end
