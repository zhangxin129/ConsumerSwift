//
//  GYHSConfirmTransferInfoVC.h
//  HSConsumer
//
//  Created by wangfd on 16/6/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

@class GYHSCardBandModel;
@interface GYHSConfirmTransferInfoVC : GYViewController

@property (nonatomic, assign) double inputValue; //传过来的值（转账金额）
@property (nonatomic, assign) double cashAccountValue; //传过来的值（货币账户余额）
@property (nonatomic, strong) NSMutableArray* arrStrings;
@property (nonatomic, strong) GYHSCardBandModel* bandCardModel;

@end
