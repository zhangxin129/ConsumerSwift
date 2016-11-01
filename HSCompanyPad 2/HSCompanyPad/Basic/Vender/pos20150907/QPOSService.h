//
//  QPOSService.h
//  qpos-ios-demo
//
//  Created by Robin on 11/19/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PosType) {
    PosType_AUDIO,
    PosType_BLUETOOTH,
    PosType_BLUETOOTH_new, //new bluetooth mode
    PosType_BLUETOOTH_2mode //bluetooth 2 mode
};

typedef NS_ENUM(NSInteger, UpdateInformationResult) {
    UpdateInformationResult_UPDATE_SUCCESS,
    UpdateInformationResult_UPDATE_FAIL,
    UpdateInformationResult_UPDATE_PACKET_VEFIRY_ERROR,
    UpdateInformationResult_UPDATE_PACKET_LEN_ERROR,
};

typedef NS_ENUM(NSInteger, DoTradeResult)
{
    DoTradeResult_NONE,
    DoTradeResult_MCR,
    DoTradeResult_ICC,
    DoTradeResult_BAD_SWIPE,
    DoTradeResult_NO_RESPONSE,
    DoTradeResult_NOT_ICC,
    DoTradeResult_NO_UPDATE_WORK_KEY,
    DoTradeResult_NFC_ONLINE,   // add 20150802
    DoTradeResult_NFC_OFFLINE,
    DoTradeResult_NFC_DECLINED,
};

typedef NS_ENUM(NSInteger, EmvOption)
{
    EmvOption_START, EmvOption_START_WITH_FORCE_ONLINE
};

typedef NS_ENUM(NSInteger, Error)
{
    Error_TIMEOUT,
    Error_MAC_ERROR,
    Error_CMD_NOT_AVAILABLE,
    Error_DEVICE_RESET,
    Error_UNKNOWN,
    Error_DEVICE_BUSY,
    Error_INPUT_OUT_OF_RANGE,
    Error_INPUT_INVALID_FORMAT,
    Error_INPUT_ZERO_VALUES,
    Error_INPUT_INVALID,
    Error_CASHBACK_NOT_SUPPORTED,
    Error_CRC_ERROR,
    Error_COMM_ERROR,
    Error_CMD_TIMEOUT,
    Error_WR_DATA_ERROR,
    Error_EMV_APP_CFG_ERROR,
    Error_EMV_CAPK_CFG_ERROR,
    Error_APDU_ERROR,
    Error_ICC_ONLINE_TIMEOUT
};

typedef NS_ENUM(NSInteger, Display)
{
    Display_TRY_ANOTHER_INTERFACE,
    Display_PLEASE_WAIT,
    Display_REMOVE_CARD,
    Display_CLEAR_DISPLAY_MSG,
    Display_PROCESSING,
    Display_TRANSACTION_TERMINATED,
    Display_PIN_OK,
    Display_INPUT_PIN_ING,
    Display_MAG_TO_ICC_TRADE,
    Display_INPUT_OFFLINE_PIN_ONLY,
};

typedef NS_ENUM(NSInteger, TransactionResult) {
    TransactionResult_APPROVED,
    TransactionResult_TERMINATED,
    TransactionResult_DECLINED,
    TransactionResult_CANCEL,
    TransactionResult_CAPK_FAIL,
    TransactionResult_NOT_ICC,
    TransactionResult_SELECT_APP_FAIL,
    TransactionResult_DEVICE_ERROR,
    TransactionResult_CARD_NOT_SUPPORTED,
    TransactionResult_MISSING_MANDATORY_DATA,
    TransactionResult_CARD_BLOCKED_OR_NO_EMV_APPS,
    TransactionResult_INVALID_ICC_DATA,
    TransactionResult_FALLBACK,
    TransactionResult_NFC_TERMINATED
};

typedef NS_ENUM(NSInteger, TransactionType) {
    TransactionType_GOODS, // 货物
    TransactionType_SERVICES, // 服务
    TransactionType_CASH,//现金
    TransactionType_CASHBACK, // 退货 返现
    TransactionType_INQUIRY, // 查询
    TransactionType_TRANSFER, // 转账
    TransactionType_ADMIN,//管理
    TransactionType_CASHDEPOSIT,//存款
    TransactionType_PAYMENT,// 付款 支付
    
    //add 2014-04-02
    TransactionType_PBOCLOG,//        0x0A			/*PBOC日志(电子现金日志)*/
    TransactionType_SALE,//           0x0B			/*消费*/
    TransactionType_PREAUTH,//        0x0C			/*预授权*/
    TransactionType_ECQ_DESIGNATED_LOAD,//		0x10				/*电子现金Q指定账户圈存*/
    TransactionType_ECQ_UNDESIGNATED_LOAD,//	0x11				/*电子现金费非指定账户圈存*/
    TransactionType_ECQ_CASH_LOAD,//	0x12	/*电子现金费现金圈存*/
    TransactionType_ECQ_CASH_LOAD_VOID,//			0x13				/*电子现金圈存撤销*/
    TransactionType_ECQ_INQUIRE_LOG,//	0x0A	/*电子现金日志(和PBOC日志一样)*/
};

typedef NS_ENUM(NSInteger, LcdModeAlign) {
    LCD_MODE_ALIGNLEFT,
    LCD_MODE_ALIGNRIGHT,
    LCD_MODE_ALIGNCENTER
};

typedef NS_ENUM(NSInteger, AmountType) {
    AmountType_NONE,
    AmountType_RMB,
    AmountType_DOLLAR,
    AmountType_CUSTOM_STR
};

typedef NS_ENUM(NSInteger, CardTradeMode) {
    CardTradeMode_ONLY_INSERT_CARD,
    CardTradeMode_ONLY_SWIPE_CARD,
    CardTradeMode_SWIPE_INSERT_CARD,
    CardTradeMode_UNALLOWED_LOW_TRADE,
    CardTradeMode_SWIPE_TAP_INSERT_CARD,// add 20150802
    CardTradeMode_SWIPE_TAP_INSERT_CARD_UNALLOWED_LOW_TRADE,
    CardTradeMode_ONLY_TAP_CARD
};

@protocol QPOSServiceListener<NSObject>

@optional
-(void) onRequestWaitingUser;
-(void) onQposIdResult: (NSDictionary*)posId;
-(void) onQposInfoResult: (NSDictionary*)posInfoData;
-(void) onDoTradeResult: (DoTradeResult)result DecodeData:(NSDictionary*)decodeData;
-(void) onRequestSetAmount;
-(void) onRequestSelectEmvApp: (NSArray*)appList;
-(void) onRequestIsServerConnected;
-(void) onRequestFinalConfirm;
-(void) onRequestOnlineProcess: (NSString*) tlv;
-(void) onRequestTime;
-(void) onRequestTransactionResult: (TransactionResult)transactionResult;
-(void) onRequestTransactionLog: (NSString*)tlv;
-(void) onRequestBatchData: (NSString*)tlv;
-(void) onRequestQposConnected;
-(void) onRequestQposDisconnected;
-(void) onRequestNoQposDetected;
-(void) onError: (Error)errorState;
-(void) onRequestDisplay: (Display)displayMsg;
-(void) onRequestUpdateWorkKeyResult:(UpdateInformationResult)updateInformationResult;
-(void) onRequestGetCardNoResult:(NSString *)result;
-(void) onRequestSignatureResult:(NSData *)result;
-(void) onReturnReversalData: (NSString*)tlv;
-(void) onReturnGetPinResult:(NSDictionary*)decodeData;

//add icc apdu 2014-03-11
-(void) onReturnPowerOnIccResult:(BOOL) isSuccess  KSN:(NSString *) ksn ATR:(NSString *)atr ATRLen:(NSInteger)atrLen;
-(void) onReturnPowerOffIccResult:(BOOL) isSuccess;
-(void) onReturnApduResult:(BOOL)isSuccess APDU:(NSString *)apdu APDU_Len:(NSInteger) apduLen;

//add set the sleep time 2014-03-25
-(void)onReturnSetSleepTimeResult:(BOOL)isSuccess;
//add  2014-04-02
-(void)onRequestCalculateMac:(NSString *)calMacString;
//add 2014-04-11
-(void)onReturnCustomConfigResult:(BOOL)isSuccess config:(NSString*)resutl;

-(void) onRequestPinEntry;
-(void) onReturnSetMasterKeyResult: (BOOL)isSuccess;

//add 2014-05-24
-(void) onReturnBatchSendAPDUResult:(NSDictionary *)apduResponses;

-(void) onReturniccCashBack: (NSDictionary*)result;

-(void) onLcdShowCustomDisplay: (BOOL)isSuccess;

-(void) onUpdatePosFirmwareResult:(UpdateInformationResult)result;

-(void) onDownloadRsaPublicKeyResult:(NSDictionary *)result;
-(void) onPinKeyTDESResult:(NSString *)encPin;
-(void) onGetPosComm:(NSInteger)mode amount:(NSString *)amt posId:(NSString*)aPosId;

-(void) onUpdateMasterKeyResult:(BOOL)isSuccess aDic:(NSDictionary *)resultDic;
-(void) onEmvICCExceptionData: (NSString*)tlv;
@end

@interface QPOSService : NSObject

@property (nonatomic, assign) EmvOption emvOption;
@property (nonatomic, assign) BOOL isPosExistFlag;
@property (nonatomic, assign) BOOL isTradeFlag;
@property (nonatomic, assign) NSInteger SelectEmvAppIndex;

@property (nonatomic, readonly) id <QPOSServiceListener> CallBackDelegate;

+(QPOSService *)sharedInstance;
-(void)setDelegate:(id<QPOSServiceListener>)aDelegate;
-(void)setQueue:(dispatch_queue_t)queue;
-(void)setPosType:(PosType) aPosType;

-(BOOL) resetPos;
-(BOOL) connectBT: (NSString *)bluetoothName;
-(void) disconnectBT;

-(void) doTradeNoPinpad:(NSInteger)timeout;
-(void) doTrade;
-(void) doTrade:(NSInteger) timeout;
-(void) doCheckCard;
-(void) doCheckCard:(NSInteger) timeout;
-(void) doTrade_QF:(NSInteger)tradeMode TradeRandomString:(NSString *)randomString TradeExtraString:(NSString *)extraString;
-(void) doTrade_QF:(NSInteger)tradeMode TradeRandomString:(NSString *)randomString TradeExtraString:(NSString *)extraString timeout:(NSInteger) delay;
-(void) doEmvApp: (EmvOption)aemvOption;
-(void) cancelSetAmount;
-(void) setAmount: (NSString *)aAmount aAmountDescribe:(NSString *)aAmountDescribe currency:(NSString *)currency transactionType:(TransactionType)transactionType;
-(void) selectEmvApp: (NSInteger)index;
-(void) cancelSelectEmvApp;
-(void) finalConfirm: (BOOL)isConfirmed;
-(void) sendOnlineProcessResult: (NSString *)tlv;
-(void) isServerConnected: (BOOL)isConnected;
-(void) sendTime: (NSString *)aterminalTime;
-(NSString *) getSdkVersion;
-(void) getQPosInfo;
-(void) getQPosId;

-(void)setAmountIcon:(NSString *)aAmountIcon;
-(void)setAmountIcon:(AmountType) amtType amtIcon:(NSString *)aAmountIcon;
-(void)getPin:(NSString *)aTransactionData;


//add icc apdu 2014-03-11
-(void)powerOffIcc;
-(void)powerOnIcc;
-(void)sendApdu:(NSString *)apduStr;

//add set the sleep time 2014-03-25
-(void)setPosSleepTime:(NSInteger)sleepTime;

//add 2014-04-11
-(void)updateEmvConfig:(NSString *)emvAppCfg emvCapk:(NSString*)emvCapkCfg;
-(void)readEmvAppConfig;
-(void)readEmvCapkConfig;

////////////////////////////////////////////
-(void)udpateWorkKey:(NSString *)pik pinKeyCheck:(NSString *)pikCheck trackKey:(NSString *)trk trackKeyCheck:(NSString *)trkCheck macKey:(NSString *)mak macKeyCheck:(NSString *)makCheck;
-(void)MacKeyEncrypt:(NSString *)macStr;

/////////////////////////////////////////////
-(void)udpateWorkKey:(NSString *)workKey workKeyCheckValue:(NSString *)workKeyCheck;

///////////////////////////////////////////

-(void)startAudio;
-(void)stopAudio;
-(BOOL)isQposPresent;
- (NSString *)getApiVersion ;
- (NSString *)getApiBuildNumber;

- (void)sendPinEntryResult:(NSString *)pin;
- (void)cancelPinEntry;

-(void)udpateWorkKey:(NSString *)updateKey;
- (void) getCardNo;
- (void) setDesKey:(NSString *)key;
-(void) lcdShowCustomDisplay:(LcdModeAlign) alcdModeAlign lcdFont:(NSString *)alcdFont;
-(void)signature;

-(void) getIccCardNo: (NSString *)aterminalTime;
-(void) inquireECQAmount: (NSString *)aterminalTime;

-(void) setMasterKey:(NSString *)key  checkValue:(NSString *)chkValue;

//add 2014-04-30
-(void)calcMacSingle:(NSString *)macStr;
-(void)calcMacDouble:(NSString *)macStr;

-(BOOL)isIdle;

//add 2014-05-24
-(void) doTrade:(NSString *)subTime delay:(NSInteger) timeout;
-(NSDictionary *)anlysEmvIccData:(NSString *)tlv;
-(void)VIPOSBatchSendAPDU:(NSDictionary *) batchAPDU;
-(NSDictionary *)synVIPOSBatchSendAPDU:(NSDictionary *) batchAPDU;

-(void)saveUserData:(NSInteger)offset userData:(NSString *)aStr;
-(void)readUserData:(NSInteger)offset userDataSize:(NSInteger) size;

-(NSDictionary *)anlysEmvIccData_qf:(NSString *)tlv;
-(BOOL)isIsIssScriptRes;
-(void)iccCashBack:(NSString *)transactionTime random:(NSString *)aRandom;

-(void)lcdShowCustomDisplay:(LcdModeAlign) alcdModeAlign lcdFont:(NSString *)alcdFont delay:(NSInteger)timeout;

-(void) setPosPresent:(BOOL) flag;


-(void) doTrade:(NSInteger)keyIndex delays:(NSInteger)timeout;
-(void) doTrade:(NSString *)subTime randomStr:(NSString *)random TradeExtraString:(NSString *)extraStr keyIndex:(NSInteger)mKeyIndex delay:(NSInteger) timeout;

-(void)udpateWorkKey:(NSString *)pik pinKeyCheck:(NSString *)pikCheck trackKey:(NSString *)trk trackKeyCheck:(NSString *)trkCheck macKey:(NSString *)mak macKeyCheck:(NSString *)makCheck keyIndex:(NSInteger) mKeyIndex;

-(void) setMasterKey:(NSString *)key  checkValue:(NSString *)chkValue keyIndex:(NSInteger) mKeyIndex;

-(void)setCardTradeMode:(CardTradeMode) aCardTMode;
-(void)setPinPadFlag:(BOOL)flag;

-(NSDictionary *)synVIPOSBatchSendAPDU:(BOOL)isOpen  batchAPDUData:(NSDictionary *) batchAPDU;
-(BOOL)qposStatus;

-(void)closeDevice;

-(void)calcMacDouble:(NSString *)macStr keyIndex:(NSInteger) mKeyIndex;

-(void) doTrade:(NSString *)random TradeExtraString:(NSString *)extraStr delay:(NSInteger) timeout;

-(void)calcMacSingleNoCheck:(NSString *)macStr delay:(NSInteger)timeout;
-(void)MacKeyEncryptNoCheck:(NSString *)macStr delay:(NSInteger)timeout;

-(void) getQPosId:(NSInteger)timeout;
-(void) setMasterKey:(NSString *)key  checkValue:(NSString *)chkValue keyIndex:(NSInteger) mKeyIndex delay:(NSInteger)timeout;

-(void)udpateWorkKey:(NSString *)pik pinKeyCheck:(NSString *)pikCheck trackKey:(NSString *)trk trackKeyCheck:(NSString *)trkCheck macKey:(NSString *)mak macKeyCheck:(NSString *)makCheck keyIndex:(NSInteger) mKeyIndex delay:(NSInteger)timeout;

-(void)calcMacDouble:(NSString *)macStr keyIndex:(NSInteger) mKeyIndex delay:(NSInteger)timeout;

-(void)calcMacDoubleNoCheck:(NSString *)macStr keyIndex:(NSInteger) mKeyIndex delay:(NSInteger)timeout;

-(void)downloadRsaPublicKey:(NSString*)rid keyIndex:(NSString *)index keyModule:(NSString *)module keyExponent:(NSString *)exponent delay:(NSInteger)timeout;

-(void)pinKey_TDES:(NSInteger) keyIndex  pin:(NSString *)inStr delay:(NSInteger)timeout;

-(void)updateMasterKey:(NSInteger)step RN1:(NSString *)RN1Str RN2:(NSString *)RN2Str masterKey:(NSString *)mKey masterKeyCheck:(NSString *)mKeyCheck delay:(NSInteger)timeout;
-(void)udpateWorkKey:(NSString *)pik pinKeyCheck:(NSString *)pikCheck trackKey:(NSString *)trk trackKeyCheck:(NSString *)trkCheck macKey:(NSString *)mak macKeyCheck:(NSString *)makCheck transKey:(NSString *)tnsk transKeyCheck:(NSString *)tnskCheck keyIndex:(NSInteger) mKeyIndex delay:(NSInteger)timeout;
-(void)updateMasterKeyRandom:(NSInteger)step keyIndex:(NSString *)index masterKey:(NSString *)mKey masterKeyCheck:(NSString *)mKeyCheck delay:(NSInteger)timeout;

-(void)pinKey_TDESNoCheck:(NSInteger) keyIndex  pin:(NSString *)inStr delay:(NSInteger)timeout;

-(NSInteger)getUpdateProgress;
-(void)updatePosFirmware:(NSData*)aData address:(NSString*)devAddress;

//获取输入金额
- (void)getInputAmountWithSymbol:(NSString *)currencySymbol
                             len: (NSInteger) amountMaxLen
                           delay:(NSInteger)timeout
                           block:(void (^)(BOOL isSuccess, NSString *amountStr))inputAmountBlock;
//设置系统时间
- (void)setSystemDateTime:(NSString *)dateTimeStr
                    delay:(NSInteger)timeout
                    block:(void (^)(BOOL isSuccess, NSDictionary *resultDic))dateTimeBlock;

- (void)powerOffNFC:(NSInteger) timeout withBlock:(void (^)(BOOL isSuccess))onPowerOffNFCResultBlock;
- (void)sendApduByNFC:(NSString *)apduString delay:(NSInteger)timeout withBlock:(void (^)(BOOL isSuccess, NSString *apdu, NSInteger apduLen))onNFCApduResultBlock;
- (void)powerOnNFC:(NSInteger) isEncrypt delay:(NSInteger) timeout withBlock:(void (^)(BOOL isSuccess, NSString *ksn, NSString *atr, NSInteger atrLen))onPowerOnNFCResultBlock;

//设置商户号
- (void)setMerchantID:(NSString *)merchantID
                delay:(NSInteger)timeout
                block:(void (^)(BOOL isSuccess, NSDictionary *resultDic))merchantIDBlock;
//设置终端号
- (void)setTerminalID:(NSString *)TerminalID
                delay:(NSInteger)timeout
                block:(void (^)(BOOL isSuccess, NSDictionary *resultDic))terminalIDBlock;

//获取磁道明文数据
- (void)getMagneticTrackPlaintext:(NSInteger)timeout;

//更新蓝牙参数
- (void)updateBluetoothConfig:(NSString *)paras delay:(NSInteger) timeout;

//cbc-mac
- (void)cbc_mac:(NSInteger)keyLen atype:(NSInteger)algorithmType otype:(NSInteger)operatorType data:(NSString *)dataStr delay:(NSInteger)timeout withResultBlock:(void (^)(NSString *))cbcmacBlock;
//cbc-mac-NoCheck
- (void)cbc_macNoCheck:(NSInteger)keyLen atype:(NSInteger)algorithmType otype:(NSInteger)operatorType data:(NSString *)dataStr delay:(NSInteger)timeout withResultBlock:(void (^)(NSString *))cbcmacBlock;

- (void)readBusinessCard:(NSString *)cardType businessID:(NSInteger)businessID pin:(NSString *)pinStr address:(NSString *)addr readLen:(NSInteger)len delay:(NSInteger)timeout withResultBlock:(void (^)(BOOL isSuccess, NSString * result))readBusinessCardResultBlock;

//
- (void)writeBusinessCard:(NSString *)cardType businessID:(NSInteger)businessID address:(NSString *)addr writeData:(NSString *)data cardPin:(NSString *)pin isUpdatePin:(BOOL)updateFlag delay:(NSInteger)timeout withResultBlock:(void (^)(BOOL isSuccess, NSString * result))writeBusinessCardResultBlock;

- (NSData *)syncReadBusinessCard:(NSString *)cardType businessID:(NSInteger)businessID pin:(NSString *)pinStr address:(NSString *)addr readLen:(NSInteger)len delay:(NSInteger)timeout;

//
- (NSInteger)syncWriteBusinessCard:(NSString *)cardType businessID:(NSInteger)businessID address:(NSString *)addr writeData:(NSString *)data cardPin:(NSString *)pin isUpdatePin:(BOOL)updateFlag delay:(NSInteger)timeout;

- (void)getPin:(NSInteger)encryptType keyIndex:(NSInteger)keyIndex maxLen:(NSInteger)maxLen typeFace:(NSString *)typeFace cardNo:(NSString *)cardNo data:(NSString *)data delay:(NSInteger)timeout withResultBlock:(void (^)(BOOL isSuccess, NSDictionary * result))getPinBlock;

- (void)confirmAmount:(NSString *)wKey delay:(NSInteger)timeout withResultBlock:(void (^)(BOOL isSuccess))confirmAmountBlock;

-(void) setAmount: (NSString *)aAmount aAmountDescribe:(NSString *)aAmountDescribe currency:(NSString *)currency transactionType:(TransactionType)transactionType posDisplayAmount:(BOOL)flag;

- (void)bypassPinEntry;
-(BOOL) resetPosStatus;
-(BOOL) syncGenerateQRCode:(NSString *)data amount:(NSString *)amt delay:(NSInteger)timeout;

//cbc-mac
- (void)cbc_mac_cn:(NSInteger)keyLen atype:(NSInteger)algorithmType otype:(NSInteger)operatorType data:(NSString *)dataStr delay:(NSInteger)timeout withResultBlock:(void (^)(NSString *))cbcmacBlock;
//cbc-mac-NoCheck
- (void)cbc_macNoCheck_cn:(NSInteger)keyLen atype:(NSInteger)algorithmType otype:(NSInteger)operatorType data:(NSString *)dataStr delay:(NSInteger)timeout withResultBlock:(void (^)(NSString *))cbcmacBlock;

//add 20150802
-(void)calcMacSingle_all:(NSString *)macStr delay:(NSInteger)timeout;
-(void)MacKeyEncrypt_all:(NSString *)macStr delay:(NSInteger)timeout;
-(void)calcMacDouble_all:(NSString *)macStr keyIndex:(NSInteger) mKeyIndex delay:(NSInteger)timeout;
-(void)pinKey_TDES_all:(NSInteger) keyIndex  pin:(NSString *)inStr delay:(NSInteger)timeout;
- (void)cbc_mac_all:(NSInteger)keyLen atype:(NSInteger)algorithmType otype:(NSInteger)operatorType data:(NSString *)dataStr delay:(NSInteger)timeout withResultBlock:(void (^)(NSString *))cbcmacBlock;
- (void)cbc_mac_cn_all:(NSInteger)keyLen atype:(NSInteger)algorithmType otype:(NSInteger)operatorType data:(NSString *)dataStr delay:(NSInteger)timeout withResultBlock:(void (^)(NSString *))cbcmacBlock;

-(NSDictionary *)getICCTag:(NSInteger) cardType tagCount:(NSInteger) mTagCount tagArrStr:(NSString*) mTagArrStr;
-(NSDictionary *)getNFCBatchData;
-(void)doTradeAll:(NSDictionary *)mDic;
-(void)doCheckCardAll:(NSDictionary*)mDic;
@end

