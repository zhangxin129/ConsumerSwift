//
//  GYHSBankCardListViewController.h
//
//  Created by lizp on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSCardBandModel;
@protocol GYHSBankCardListViewControllerDelegate<NSObject>

@optional

-(void)selectBankCard:(GYHSCardBandModel *)model;

//当银行卡添加或者删除或者设置默认后 货币转银行界面获取默认银行卡接口应重新获取
-(void)bankCardChange;

@end


@interface GYHSBankCardListViewController: GYViewController

@property (nonatomic,weak) id<GYHSBankCardListViewControllerDelegate>delegate;

@end
