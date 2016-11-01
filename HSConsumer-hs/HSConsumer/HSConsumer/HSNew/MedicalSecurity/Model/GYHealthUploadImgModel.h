//
//  GYHealthUploadImgModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/7/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KtitleFont [UIFont systemFontOfSize:12]
#define KshowFont [UIFont systemFontOfSize:10]

@interface GYHealthUploadImgModel : NSObject
@property (nonatomic, copy) NSString* strTitle;
@property (nonatomic, assign) BOOL isNeed;

@property (nonatomic, assign) CGRect picFrame;
@property (nonatomic, assign) CGRect needFrame;
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGRect showTempFrame;
@property (nonatomic, assign) CGRect mainFrame;
// 是否显示事例图片
@property (nonatomic, assign) BOOL isShow;
@end
