//
//  GYHSCashToBankConfirmViewController.h
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSCardBandModel.h"

@protocol GYHSCashToBankConfirmViewControllerDelegate<NSObject>

@optional
-(void)cashToCashSuccess;

@end

@interface GYHSCashToBankConfirmViewController: GYViewController

@property (nonatomic,copy) NSString *cashStr;//货币转银行数
@property (nonatomic,copy) GYHSCardBandModel *model;
@property (nonatomic,weak) id<GYHSCashToBankConfirmViewControllerDelegate>delegate;

@end
