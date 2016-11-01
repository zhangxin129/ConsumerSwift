//
//  GYCardBandTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

typedef void (^BtnBlock)(id model);

#import <UIKit/UIKit.h>
#import "GYHSCardBandModel.h"
#import "GYQuickPayModel.h"
#import "SWTableViewCell.h"

@interface GYCardBandTableViewCell : SWTableViewCell

/**银行卡*/
@property (nonatomic, strong) GYHSCardBandModel* modol;
/**快捷支付卡*/
@property (nonatomic, strong) GYQuickPayModel* quickModel;

@property (nonatomic, copy) BtnBlock btnBlock;

@end
