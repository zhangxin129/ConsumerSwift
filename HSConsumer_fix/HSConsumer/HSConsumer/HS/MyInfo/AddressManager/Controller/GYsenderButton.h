//
//  GYsenderButton.h
//  HSConsumer
//
//  Created by apple on 14-10-28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYAddressModel.h"
@protocol GYsenderButton <NSObject>
- (void)senderBtn:(id)sender WithCellModel:(GYAddressModel*)mod;
@end
