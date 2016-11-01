//
//  GYEPSaleAfterApplyForOnlyReturnMoneyViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GYUploadImage.h"
@interface GYEPSaleAfterApplyForOnlyReturnMoneyViewController : GYViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GYUploadPicDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSDictionary* dicDataSource;

@property (nonatomic, copy) NSString* commentSting;
@end
