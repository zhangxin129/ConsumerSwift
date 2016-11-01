//
//  GYTwoPictureViewController.h
//  HSConsumer
//
//  Created by apple on 15-3-11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYRealNameAuthConfirmViewController.h"

@interface GYTwoPictureViewController : GYViewController <UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary* mdictParams;
@property (nonatomic, strong) NSMutableDictionary* oldmdictParams;
@property (nonatomic, strong) NSMutableArray* changeItem;
@property (nonatomic, copy) NSString* strCreFaceUrl;
@property (nonatomic, copy) NSString* strcreHoldPic;

@property (nonatomic, assign) KuseType useType;
@end
