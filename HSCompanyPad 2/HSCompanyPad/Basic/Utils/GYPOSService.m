//
//  GYPOSService.m
//  company
//
//  Created by liangzm on 15-4-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kScanBluetoothTime 5.0f
#define koperatingDelayTime 0.5f
#define Kbdk @"00000000100000000000000000000001"
#import "DUKPT_2009_CBC.h"
#import "Util.h"
#import "libdes.h"
#import "GYCardReaderModel.h"
// 超时时间
#define KSwipingCardTime 20

typedef NS_ENUM(NSInteger, EMPosoperating) {
    kPosoperating_ok,
    kPosoperating_Connecting, //已经成功连接
};

#import "GYPOSService.h"
#import "GYCardReaderView.h"
#import "BTDeviceFinder.h"
#import <GYKit/CALayer+Transition.h>

@interface GYPOSService () <BluetoothDelegate2Mode, QPOSServiceListener> {
    NSString* posName;
    
}
@property (nonatomic, strong) BTDeviceFinder* btFinder;
@property (nonatomic, strong) QPOSService *service;
@property (nonatomic, assign) int connetPosTimes; //连接设备出现错误重连次数，超过3次提示连接出错
@property (nonatomic, assign) BOOL isBtScanning;
@property (nonatomic, assign) EMPosoperating operating;
@end

@implementation GYPOSService

static id _instace;
+ (id)allocWithZone:(struct _NSZone*)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
        
    });
    return _instace;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone*)zone
{
    return _instace;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setInitValues];
    };
    return self;
}

#pragma mark - 懒加载
- (BTDeviceFinder *)btFinder
{
    if (!_btFinder) {
        _btFinder = [[BTDeviceFinder alloc]init];
    }
    return _btFinder;
}


- (QPOSService *)service
{

    if (!_service) {
        _service = [QPOSService sharedInstance];
        [_service setDelegate:self];
        [_service setPosType:PosType_BLUETOOTH_2mode]; //设置蓝牙模式
    }
    return _service;
}

- (GYCardReaderModel *)posInfo
{

    if (!_posInfo) {
        _posInfo = [[GYCardReaderModel alloc]init];
    }
    return _posInfo;

}

/**
 *  设置类初始化默认值
 */
- (void)setInitValues //
{
    self.connectionPOSBlock = nil;
    self.operating = kPosoperating_ok;
    self.connetPosTimes = 0;
}

/**
 *  scanBluetooth
 */
- (void)scanBluetooth
{
  
    [self.btFinder setBluetoothDelegate2Mode:self];
    
    self.isBtScanning = YES;
    
    self.arrPosDevices = [NSMutableArray array];
    if (self.isConnect && self.posInfo) {
        [self.arrPosDevices addObject:self.posInfo];
        if (self.delegate && [self.delegate respondsToSelector:@selector(getOnePosDevice:isScanning:)]) {
            // 正在扫描并且上一次没有相应代理，则给代理发送方法（应该是检测到设备有变化）
            [self.delegate getOnePosDevice:self.posInfo isScanning:self.isBtScanning];
        }
    }
    
    DDLogInfo(@"蓝牙状态:%d", (int)[self.btFinder getCBCentralManagerState]); //手机蓝牙状态
    
    NSInteger delay = 0;
    if ([self.btFinder getCBCentralManagerState] == CBCentralManagerStateUnknown) {
        while ([self.btFinder getCBCentralManagerState] != CBCentralManagerStatePoweredOn) {
            DDLogInfo(@"Bluetooth state is not power on");
            [self sleepMs:10];
            if (delay++ == 10) {
                return;
            }
        }
    }
    [self.btFinder scanQPos2Mode:kScanBluetoothTime];
}

/**
 *  限制主线程
 *
 *  @param msec 睡眠时间
 */
- (void)sleepMs:(NSInteger)msec
{
    NSTimeInterval sec = (msec / 1000.0f);
    [NSThread sleepForTimeInterval:sec];
}

/**
 *  停止扫描设备
 */
- (void)stopScanBluetooth
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.btFinder stopQPos2Mode];
    });
}

/**
 *  准备链接Pos设备
 *
 *  @param bluetoothName <#bluetoothName description#>
 *  @param block         <#block description#>
 */
- (void)connectionPOS:(NSString*)bluetoothName callbackBlock:(ConnectionPOSBlock)block
{
    self.connectionPOSBlock = [block copy];
    self.connetPosTimes = 0;
    [self connectionPOS:bluetoothName];
    [self performSelector:@selector(connectPOSTimeout) withObject:nil afterDelay:15]; // 超时时间设置
}

/**
 *  正在链接Pos设备
 *
 *  @param bluetoothName <#bluetoothName description#>
 */
- (void)connectionPOS:(NSString*)bluetoothName
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //如果是切换
        if (self.isConnect)
        {
            [self.service setDelegate:nil];//先清除代理
            [self.service disconnectBT];//再断开连接
            self.service = nil;
            self.isConnect = NO;
            // modify by songjk
            [kDefaultNotificationCenter postNotificationName:GYPOSDisconnectNotification object:nil];
        }
        
      
        self.operating = kPosoperating_Connecting;
        
        //        self.posInfo = [[PosDeviceModel alloc] init];
        posName = bluetoothName;
        [self.service setDelegate:self];
        
        [self.service setQueue:nil];
      
        [self.service connectBT:bluetoothName];//连接刷卡器
    });
}

/**
 *  刷卡
 */
- (void)swipingCard
{
    if (!self.isConnect) {
        //刷卡
        GYCardReaderView* view = [[GYCardReaderView alloc] init];
        view.frame =  [UIApplication sharedApplication].keyWindow.bounds;
        view.backgroundColor = kClearColor;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [view.layer bouceAnimation];
        return;
    }

    
    
    // 刷卡
    [self.service doTradeNoPinpad:KSwipingCardTime];
    [kDefaultNotificationCenter postNotificationName:GYPOSOperationStartNotification object:nil];
}

/**
 *  确认互生币金额
 *
 *  @param amount <#amount description#>
 */
- (void)confirkHSpay:(NSString*)amount
{
    [self.service confirmAmount:[NSString stringWithFormat:@"%@%.2f", kLocalized(@"GYBasic_AomuntColon"), amount.doubleValue] delay:KSwipingCardTime withResultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [self inputPwdWithPwdLength:8];
        }
        else
        {
            [kDefaultNotificationCenter postNotificationName:GYPOSOperationErrorNotification object:nil];
            [GYUtils showToast:kLocalized(@"GYBasic_OperationCanceled")];
            
        }
    }];
}

//退货确认
- (void)returnAmount:(NSString*)amount
{
    [self.service confirmAmount:[NSString stringWithFormat:@"%@%.2f", kLocalized(@"GYBasic_AomuntColon"), amount.doubleValue] delay:KSwipingCardTime withResultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [self inputPwdWithPwdLength:6];
        }
        else
        {
            [kDefaultNotificationCenter postNotificationName:GYPOSOperationErrorNotification object:nil];
            [GYUtils showToast:kLocalized(@"GYBasic_OperationCanceled")];
            
        }
    }];
}

/**
 *  发送指令活动密码
 *
 *  @param pwdLength <#pwdLength description#>
 */
- (void)inputPwdWithPwdLength:(NSInteger)pwdLength
{
    if (pwdLength == 6) {
        [self.service getPin:2 keyIndex:0 maxLen:6 typeFace:kLocalized(@"GYBasic_PlaceholderInputLoginPwd") cardNo:@"" data:@"" delay:KSwipingCardTime withResultBlock:^(BOOL isSuccess, NSDictionary* result) {
            if (!isSuccess)
            {
                return;
            }
            else
            {
                //回调
                if (result == nil) {
                    [GYUtils showToast:kLocalized(@"GYBasic_PasswordNotEmpty")];
                    return;
                }
                else
                {
                    NSString *pinksn = result[@"ksn"];
                    NSString *pin = result[@"pin"];
                    if (!pin || pin.length == 0)
                    {
                        [GYUtils showToast:kLocalized(@"GYBasic_PasswordNotEmpty")];
                        return;
                    }
                    else if(!pinksn  || pinksn.length == 0)
                    {
                        [GYUtils showToast:kLocalized(@"GYBasic_TerminalNumberError")];
                        return;
                    }
                }
                NSString * passWorld = [self decodePassWorld:result];
                // 发送登录密码通知
                [kDefaultNotificationCenter postNotificationName:GYPOSShounldInputLoginPasswordNotification object:passWorld];
            }
        }];
    }
    
    if (pwdLength == 8) {
        [self.service getPin:2 keyIndex:0 maxLen:8 typeFace:kLocalized(@"GYBasic_InputEightTradePwd") cardNo:@"" data:@"" delay:KSwipingCardTime withResultBlock:^(BOOL isSuccess, NSDictionary* result) {
            if (!isSuccess)
            {
                return;
            }
            else
            {
                //回调
                if (result == nil) {
                    [GYUtils showToast:kLocalized(@"GYBasic_PasswordNotEmpty")];
                    
                    return;
                }
                else
                {
                    NSString *pinksn = result[@"ksn"];
                    NSString *pin = result[@"pin"];
                    if (!pin || pin.length == 0)
                    {
                        [GYUtils showToast:kLocalized(@"GYBasic_PasswordNotEmpty")];
                        return;
                    }
                    else if(!pinksn  || pinksn.length == 0)
                    {
                        [GYUtils showToast:kLocalized(@"GYBasic_TerminalNumberError")];
                        return;
                    }
                }
                NSString * passWorld = [self decodePassWorld:result];
                // 发送交易密码通知
                [kDefaultNotificationCenter postNotificationName:GYPOSShounldInputTradingPasswordNotification object:passWorld];
            }
        }];
    }
}

/**
 *  解密密码
 *
 *  @param result <#result description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)decodePassWorld:(NSDictionary*)result
{
    NSString* pinksn = result[@"ksn"];
    NSString* pinbdk = Kbdk;
    NSData* byte_pinksn = [Util HexStringToByteArray:pinksn];
    NSData* byte_pinbdk = [Util HexStringToByteArray:pinbdk];
    
    NSData* pinipek = [DUKPT_2009_CBC GenerateIPEK:byte_pinksn bdk:byte_pinbdk];
    DDLogCError(@"pinipek: %@", [Util byteArray2Hex:pinipek]);
    
    NSData* pinKey = [DUKPT_2009_CBC GetPinKeyVariant:byte_pinksn ipek:pinipek];
    DDLogCError(@"pinKey: %@", [Util byteArray2Hex:pinKey]);
    
    NSData* pinDataStr = [Util HexStringToByteArray:result[@"pin"]];
    Byte* pszOut = malloc(8);
    TDes_Decrypt_all((Byte*)[pinKey bytes], (Byte*)[pinDataStr bytes], 8, pszOut);
    
    NSData* pinrs = [NSData dataWithBytes:pszOut length:8];
    
    free(pszOut);
    NSString* strResult = [Util byteArray2Hex:pinrs];
    NSRange range = NSMakeRange(1, 1);
    NSString* strLength = [strResult substringWithRange:range];
    range = NSMakeRange(2, [strLength integerValue]);
    NSString* strPassWard = [strResult substringWithRange:range];
    DDLogCError(@"strResult: %@,length = %@,passWorld = %@", strResult, strLength, strPassWard);
    return strPassWard;
}

#pragma mark - BluetoothDelegate2Mode delegate
// 扫描蓝牙设备 获得设备名称 会多次调用
- (void)onBluetoothName2Mode:(NSString*)bluetoothName
{
    if (!bluetoothName)
        return;
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogInfo(@"onBluetoothName2Mode:%@", bluetoothName);
        GYCardReaderModel *model = [[GYCardReaderModel alloc] init];
        model.posName = bluetoothName;
        [self.arrPosDevices addObject:model];
        for (GYCardReaderModel *m in self.arrPosDevices)
        {
            m.isConnected = NO;
        }
        
        if (self.isConnect && self.posInfo)
        {
            for (GYCardReaderModel *m in self.arrPosDevices)
            {
                if ([m.posName isEqualToString:self.posInfo.posName])
                {
                    m.isConnected = YES;
                    break;
                }
            }
            
        }
        
        if (self)
        {
            if (self.delegate)
            {
                if ([self.delegate respondsToSelector:@selector(getOnePosDevice:isScanning:)])
                {
                    [self.delegate getOnePosDevice:model isScanning:self.isBtScanning];
                }
            }
        }
        
    });
}

- (void)finishScanQPos2Mode
{
    DDLogInfo(@"finishScanQPos2Mode");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isBtScanning = NO;
        if (self && self.delegate)
        {
            if ([self.delegate respondsToSelector:@selector(getOnePosDevice:isScanning:)]) {
                [self.delegate getOnePosDevice:nil isScanning:self.isBtScanning];
            }
        }
    });
}

- (void)bluetoothIsPowerOff2Mode //关闭手机蓝牙
{
    [self stopScanBluetooth];
    [self onRequestQposDisconnected];
}

- (void)bluetoothIsPowerOn2Mode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogInfo(@"bluetoothIsPowerOn2Mode");
    });
}

- (void)bluetoothUnauthorized2Mode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogInfo(@"bluetoothUnauthorized2Mode");
        //        [waitScanBT stopAnimating];
    });
}

#pragma mark - QPOSServiceListener delegate

- (void)onRequestQposConnected
{
    DDLogInfo(@"onRequestQposConnected1");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(koperatingDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.service getQPosId];
    });
}

- (void)onRequestQposDisconnected //连接断开
{
    DDLogInfo(@"onRequestQposDisconnected1");
    self.isConnect = NO;
    if (self.posInfo) {
        self.posInfo.isConnected = self.isConnect;
    }
    if (self.arrPosDevices && self.arrPosDevices.count > 0 && !self.isBtScanning) {
        for (GYCardReaderModel* m in self.arrPosDevices) {
            m.isConnected = NO;
        }
    }
    
    if (_disconnectionPOSBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //只调用一次此方法 by 孙秋明
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self scanBluetooth];//如果断开，不重新搜索，再次连接不能连接，可能配对已失效
            });
            
            self.disconnectionPOSBlock();
        });
    }
    // 发送断开通知
    [kDefaultNotificationCenter postNotificationName:GYPOSDisconnectNotification object:nil];
}

/**
 *  取得pos机器信息
 *
 *  @param info <#info description#>
 */
- (void)onQposIdResult:(NSDictionary*)info //
{
    DDLogCError(@"取得pos机器信息:%@", info);
    self.posInfo.posId = kSaftToNSString(info[@"posId"]);
    self.posInfo.csn = kSaftToNSString(info[@"csn"]);
    self.posInfo.deviceNumber = kSaftToNSString(info[@"deviceNumber"]);
    self.posInfo.merchantId = kSaftToNSString(info[@"merchantId"]);
    self.posInfo.psamId = kSaftToNSString(info[@"psamId"]);
    self.posInfo.psamNo = kSaftToNSString(info[@"psamNo"]);
    self.posInfo.tmk0Status = kSaftToNSString(info[@"tmk0Status"]);
    self.posInfo.tmk1Status = kSaftToNSString(info[@"tmk1Status"]);
    self.posInfo.tmk2Status = kSaftToNSString(info[@"tmk2Status"]);
    self.posInfo.tmk3Status = kSaftToNSString(info[@"tmk3Status"]);
    self.posInfo.tmk4Status = kSaftToNSString(info[@"tmk4Status"]);
    self.posInfo.vendorCode = kSaftToNSString(info[@"vendorCode"]);
    DDLogCError(@"posid = %@", self.posInfo.posId);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(koperatingDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.service getQPosInfo];//获取固件信息
    });
}

/**
 *  获取固件信息结果 ；只有到这一步，才返回连接成功的回调
 *
 *  @param firmwareInfo <#firmwareInfo description#>
 */
- (void)onQposInfoResult:(NSDictionary*)firmwareInfo //
{
    DDLogCError(@"获取固件信息:%@", firmwareInfo);
    self.posInfo.batteryLevel = kSaftToNSString(firmwareInfo[@"batteryLevel"]);
    self.posInfo.bootloaderVersion = kSaftToNSString(firmwareInfo[@"bootloaderVersion"]);
    self.posInfo.firmwareVersion = kSaftToNSString(firmwareInfo[@"firmwareVersion"]);
    self.posInfo.hardwareVersion = kSaftToNSString(firmwareInfo[@"hardwareVersion"]);
    self.posInfo.isCharging = kSaftToNSString(firmwareInfo[@"isCharging"]);
    self.posInfo.isSupportedTrack1 = kSaftToNSString(firmwareInfo[@"isSupportedTrack1"]);
    self.posInfo.isSupportedTrack2 = kSaftToNSString(firmwareInfo[@"isSupportedTrack2"]);
    self.posInfo.isSupportedTrack3 = kSaftToNSString(firmwareInfo[@"isSupportedTrack3"]);
    self.posInfo.isUsbConnected = kSaftToNSString(firmwareInfo[@"isUsbConnected"]);
    self.posInfo.updateWorkKeyFlag = kSaftToNSString(firmwareInfo[@"updateWorkKeyFlag"]);
    
    if (self.operating == kPosoperating_Connecting) {
        self.isConnect = YES;
        self.posInfo.posName = posName;
        self.posInfo.isConnected = self.isConnect;
        self.operating = kPosoperating_ok;
    }
    else {
        self.isConnect = NO;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectPOSTimeout) object:nil];
    if (self.connectionPOSBlock) // 回调block 返回选择连接上的设备
    {
        self.connectionPOSBlock(self.isConnect, self.posInfo);
    }
}

/**
 *  错误列表
 *
 *  @param errorState <#errorState description#>
 */
- (void)onError:(Error)errorState //
{
    NSString* msg = @"";
    if (errorState == Error_CMD_NOT_AVAILABLE) {
        msg = @"Command not available";
    }
    else if (errorState == Error_TIMEOUT) {
        msg = @"Pos no response";
    }
    else if (errorState == Error_DEVICE_RESET) {
        msg = @"Pos reset";
    }
    else if (errorState == Error_UNKNOWN) {
        msg = @"Unknown error";
    }
    else if (errorState == Error_DEVICE_BUSY) {
        msg = @"Pos Busy";
    }
    else if (errorState == Error_INPUT_OUT_OF_RANGE) {
        msg = @"Input out of range.";
    }
    else if (errorState == Error_INPUT_INVALID_FORMAT) {
        msg = @"Input invalid format.";
    }
    else if (errorState == Error_INPUT_ZERO_VALUES) {
        msg = @"Input are zero values.";
    }
    else if (errorState == Error_INPUT_INVALID) {
        msg = @"Input invalid.";
    }
    else if (errorState == Error_CASHBACK_NOT_SUPPORTED) {
        msg = @"Cashback not supported.";
    }
    else if (errorState == Error_CRC_ERROR) {
        msg = @"CRC Error.";
    }
    else if (errorState == Error_COMM_ERROR) {
        msg = @"Communication Error.";
    }
    else if (errorState == Error_MAC_ERROR) {
        msg = @"MAC Error.";
    }
    else if (errorState == Error_CMD_TIMEOUT) {
        msg = @"CMD Timeout.";
    }
    [kDefaultNotificationCenter postNotificationName:GYPOSOperationErrorNotification object:msg];
    //    [GYUtils showMessgeWithTitle:kLocalized(@"GYTrad_FriendlyReminder") message:msg isPopVC:nil];
    DDLogCError(@"onError = %@, self.operating:%d", msg, (int)self.operating);
    if ( //errorState == Error_DEVICE_RESET ||
        errorState == Error_TIMEOUT || errorState == Error_DEVICE_BUSY) {
        if (self.isBtScanning) {
            [self stopScanBluetooth];
        }
        else if (self.operating == kPosoperating_Connecting) {
            self.connetPosTimes++;
            if (self.connetPosTimes <= 3) {
                DDLogCError(@"self.connetPosTimes:%d", self.connetPosTimes);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(koperatingDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self connectionPOS:posName];
                });
            }
            else {
                [self connectPOSTimeout];
            }
        }
    }
}

- (void)connectPOSTimeout
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectPOSTimeout) object:nil];
    if (self.operating == kPosoperating_Connecting) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isConnect = NO;
            self.operating = kPosoperating_ok;
            [self.service disconnectBT];
            if (self.connectionPOSBlock)
            {
                self.connectionPOSBlock(self.isConnect,nil);
            }
            self.connetPosTimes = 0;
            self.connectionPOSBlock = nil;
        });
    }
}

#pragma mark - 输入密码取消时调用一下几个方法

- (void)onRequestDisplay:(Display)displayMsg
{
    DDLogCError(@"displayMsg = %zi", displayMsg);
}


- (void)onRequestTransactionResult:(TransactionResult)transactionResult
{
    NSString* messageTextView = @"";
    if (transactionResult == TransactionResult_APPROVED) {
        messageTextView = @"Approved";
    }
    else if (transactionResult == TransactionResult_TERMINATED) {
        messageTextView = @"Terminated";
    }
    else if (transactionResult == TransactionResult_DECLINED) {
        messageTextView = @"Declined";
    }
    else if (transactionResult == TransactionResult_CANCEL) {
        messageTextView = kLocalized(@"GYBasic_OperationCanceled");
    }
    else if (transactionResult == TransactionResult_CAPK_FAIL) {
        messageTextView = @"Fail (CAPK fail)";
    }
    else if (transactionResult == TransactionResult_NOT_ICC) {
        messageTextView = @"Fail (Not ICC card)";
    }
    else if (transactionResult == TransactionResult_SELECT_APP_FAIL) {
        messageTextView = @"Fail (App fail)";
    }
    else if (transactionResult == TransactionResult_DEVICE_ERROR) {
        messageTextView = @"Pos Error";
    }
    else if (transactionResult == TransactionResult_CARD_NOT_SUPPORTED) {
        messageTextView = @"Card not support";
    }
    else if (transactionResult == TransactionResult_MISSING_MANDATORY_DATA) {
        messageTextView = @"Missing mandatory data";
    }
    else if (transactionResult == TransactionResult_CARD_BLOCKED_OR_NO_EMV_APPS) {
        messageTextView = @"Card blocked or no EMV apps";
    }
    else if (transactionResult == TransactionResult_INVALID_ICC_DATA) {
        messageTextView = @"Invalid ICC data";
    }
    [kDefaultNotificationCenter postNotificationName:GYPOSOperationErrorNotification object:messageTextView];
    //    [GYUtils showMessgeWithTitle:kLocalized(@"GYTrad_FriendlyReminder") message:messageTextView isPopVC:nil];
}



// 发送交易请求时必须实现
- (void)onRequestWaitingUser
{
    // 该方法必须实现
}


- (void)onDoTradeResult:(DoTradeResult)result DecodeData:(NSDictionary*)decodeData
{
    DDLogCError(@"onDoTradeResult?>> result %zi", result);
    DDLogCError(@"%@", decodeData);
    if (result == DoTradeResult_NONE) {
        //        self.textViewLog.text = @"No card detected. Please insert or swipe card again and press check card.";
    }
    else if (result == DoTradeResult_ICC) {
        //        self.textViewLog.text = @"ICC Card Inserted";
        //        [pos doEmvApp:EmvOption_START];
    }
    else if (result == DoTradeResult_NOT_ICC) {
        //        self.textViewLog.text = @"Card Inserted (Not ICC)";
    }
    else if (result == DoTradeResult_MCR) {
        DDLogCError(@"decodeData: %@", decodeData);
        NSString* ksn = [NSString stringWithFormat:@"%@", decodeData[@"trackksn"]];
        NSString* encTracks = [NSString stringWithFormat:@"%@", decodeData[@"encTracks"]];
        NSString* strCardAndCipher = [self decodeCardNumAndCipherWithKsn:ksn encTracks:encTracks];
        if (strCardAndCipher.length == 1) {
            if ([strCardAndCipher isEqualToString:@"0"]) {
//                [GYUtils alertWithContext:kLocalized(@"GYTrad_InvalidCard") buttonTitle:kLocalized(@"GYTrad_Confirm") dismiss:nil];
            }
            else if ([strCardAndCipher isEqualToString:@"1"]) {
//                [GYUtils alertWithContext:kLocalized(@"GYTrad_CardError") buttonTitle:kLocalized(@"GYTrad_Confirm") dismiss:nil];
            }
            else if ([strCardAndCipher isEqualToString:@"2"]) {
//                [GYUtils alertWithContext:@"请重新刷卡" buttonTitle:kLocalized(@"GYTrad_Confirm") dismiss:nil];
            }
        }
        else {
            // 发送得到卡号和暗码通知
            [kDefaultNotificationCenter postNotificationName:GYCardNumAndCipherNotification object:strCardAndCipher];
        }
    }
    else if (result == DoTradeResult_NO_RESPONSE) {
        //        self.textViewLog.text = @"Check card no response";
    }
    else if (result == DoTradeResult_BAD_SWIPE) {
        //        self.textViewLog.text = @"Bad Swipe. \nPlease swipe again and press check card.";
    }
    else if (result == DoTradeResult_NO_UPDATE_WORK_KEY) {
        //        self.textViewLog.text = @"device not update work key";
    }
}

- (void)onRequestFinalConfirm
{
    
    
}

/**解码得出暗码和卡号 格式：卡号,暗码*/
- (NSString*)decodeCardNumAndCipherWithKsn:(NSString*)ksn encTracks:(NSString*)encTracks
{
    Byte pucIv[8];
    memset(pucIv, 0, 8);
    NSData* byte_ksn = [Util HexStringToByteArray:ksn];
    NSData* byte_bdk = [Util HexStringToByteArray:Kbdk];
    NSData* ipek = [DUKPT_2009_CBC GenerateIPEK:byte_ksn bdk:byte_bdk];
    NSData* dataKey = [DUKPT_2009_CBC GetDataKey:byte_ksn ipek:ipek];
    NSData* byte_encTracks = [Util HexStringToByteArray:encTracks];
    Byte* pszOut = malloc([byte_encTracks length]);
    
    TDES_CBCDecrypt((Byte*)[byte_encTracks bytes], pszOut, (int)[byte_encTracks length], (Byte*)[dataKey bytes], 16, pucIv);
    // 06186010026D11561226FFFFFFFFFFFFFFFFFFFFFFFFFFFF
    NSData* resa = [NSData dataWithBytes:pszOut length:[byte_encTracks length]];
    free(pszOut);
    if (!resa || resa.length == 0) {
        return @"0";
    }
    NSString* strCode = [Util byteArray2Hex:resa];
    if (strCode.length < 20)
    {
        return @"1";
    }
    NSString * cardNum = [strCode substringToIndex:11];
    NSRange range = NSMakeRange(12, 8);
    NSString * CipherNum = [strCode substringWithRange:range];
    if (![[CipherNum substringWithRange:NSMakeRange(1, 3)] isEqualToString:globalData.config.currencyCode]) {
        return @"2";
    }
    NSString * strResult = [NSString stringWithFormat:@"%@,%@",cardNum,CipherNum];
    DDLogCError(@"strCode: %@,%@,%@",strCode,cardNum,CipherNum);
    return strResult;
}


-(void) onRequestGetCardNoResult:(NSString *)result
{
    DDLogCError(@"%@",result);
}
- (void)disConnectionPOS
{
    self.isConnect = NO;//断开连接
    if (self.posInfo) {
        self.posInfo.isConnected = NO;
    }
    dispatch_async(dispatch_get_main_queue(),  ^{
        [self.service disconnectBT];
    });
}


@end
