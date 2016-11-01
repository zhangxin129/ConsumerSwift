
//  HSConsumer
//
//  Created by apple on 15-1-15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
//选择国家
#import "GYCountrySelectionViewController.h"
@interface GYImportantChangeViewController : GYViewController <UITextFieldDelegate, UITextViewDelegate, selectNationalityDelegate>
@property (nonatomic, copy) NSString* strRealName;
@property (nonatomic, copy) NSString* strSex;
@property (nonatomic, copy) NSString* strNationality;
@property (nonatomic, copy) NSString* strCerType;
@property (nonatomic, copy) NSString* strCerNumber;
@property (nonatomic, copy) NSString* strCerduration;
@property (nonatomic, copy) NSString *strRegAddress;

@end
