//
//  GYBankListModel.h
//  HSConsumer
//
//  Created by apple on 15-1-27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GYHSBankListModel : JSONModel <NSCoding>
/**银行编号*/
@property (nonatomic, copy) NSString* bankName;

/**银行名称*/
@property (nonatomic, copy) NSString* bankNo;

/**删除标识*/
@property (nonatomic,copy)NSString * delFlag;

@end
