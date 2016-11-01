//
//  GYQuitPhoneBandingModel.h
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYQuitPhoneBandingModel : NSObject
@property (nonatomic, copy) NSString* strPhoneNo; //电话号码
@property (nonatomic, copy) NSString* strIconUrl; //银行图片 URL
@property (nonatomic, copy) NSString* strBandingSuccess; //是否成功绑定
@property (nonatomic, copy) NSString *strBtnTitle;//BTN的title
@end
