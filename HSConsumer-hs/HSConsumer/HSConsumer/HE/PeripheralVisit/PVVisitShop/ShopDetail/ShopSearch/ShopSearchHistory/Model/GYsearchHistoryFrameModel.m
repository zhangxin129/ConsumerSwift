//
//  GYsearchHistoryFrameModel.m
//  HSConsumer
//
//  Created by Apple03 on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYsearchHistoryFrameModel.h"
#import "GYseachhistoryModel.h"
@implementation GYsearchHistoryFrameModel
- (void)setModel:(GYseachhistoryModel*)model
{
    _model = model;
    self.height = [GYUtils heightForString:model.name fontSize:16 andWidth:kScreenWidth -16] +10;
}

@end
