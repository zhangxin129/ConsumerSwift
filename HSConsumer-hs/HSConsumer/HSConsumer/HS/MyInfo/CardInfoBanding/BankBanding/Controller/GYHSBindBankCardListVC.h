//
//  GYHSBandingBankCardVC.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/28.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSCardBandModel.h"

typedef NS_ENUM(NSInteger, GYHSBindBankCardListVCType) {
    GYHSBindBankCardListVCTypeNoPerfect = 0, //未完善资料
    GYHSBindBankCardListVCTypePerfect = 1 //完善资料
};

@protocol GYHSBindBankCardListVCDelegate <NSObject>

- (void)chooseBank:(GYHSCardBandModel*)model isAdd:(BOOL)isAdd;

@end

@interface GYHSBindBankCardListVC : GYViewController
@property (nonatomic, weak) id<GYHSBindBankCardListVCDelegate> bankcardDelegate;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, assign) GYHSBindBankCardListVCType isPerfect;

@end
