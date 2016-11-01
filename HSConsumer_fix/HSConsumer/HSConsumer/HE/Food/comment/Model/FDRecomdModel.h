//
//  FDRecomdModel.h
//  HSConsumer
//
//  Created by apple on 15/12/30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FDRecomdModel : JSONModel
@property (nonatomic, copy) NSString* pics;
@property (nonatomic, copy) NSString* recomFood;
@property (nonatomic, assign) NSInteger cont;
@property(nonatomic, copy) NSString *recomId;
@end
