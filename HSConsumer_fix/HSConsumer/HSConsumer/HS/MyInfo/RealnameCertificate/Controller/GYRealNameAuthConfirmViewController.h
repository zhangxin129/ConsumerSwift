//
//  GYRealNameAuthConfirmViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYUploadImage.h"
typedef enum {
    useForAuth = 0,
    useForImportantChange,

} KuseType;

@interface GYRealNameAuthConfirmViewController : GYViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GYUploadPicDelegate>

@property (nonatomic, strong) NSMutableDictionary* dictInside; //所有变更的新值
@property (nonatomic, strong) NSMutableDictionary* olddictInside; //所有变更的旧值
@property (nonatomic, strong) NSMutableArray* changeItem; //变更项数组（全中文）
@property (nonatomic, copy) NSString* strCreFaceUrl;
@property (nonatomic, copy) NSString* strCreBackUrl;
@property (nonatomic, copy) NSString* strCreHoldUrl;
@property (nonatomic, copy) NSString* strCreOtherFileUrl; //户籍地址变更
@property (nonatomic, assign) KuseType useType;

@end
