//
//  GYExpressModel.h
//  HSConsumer
//
//  Created by apple on 16/3/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYExpressModel : JSONModel
@property (nonatomic, copy) NSString* expressId; //物流id
@property (nonatomic, copy) NSString* name; //物流名称
@property (nonatomic, copy) NSString* code; //物流拼音
@property (nonatomic, assign) BOOL isSelect; //判别是否选择
- (void)loadModelDataWithDictionary:(NSDictionary *)dic;
@end
