//
//  GYOrderQuickPayConfirmVC.h
//  HSConsumer
//
//  Created by sqm on 16/5/3.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYQRPayModel;
@interface GYOrderQuickPayConfirmVC : GYViewController
@property (nonatomic, strong) GYQRPayModel* model;
@property (nonatomic, copy) NSString* transNo;
@property (nonatomic, strong) NSMutableArray* quickBankListArrM;
@end