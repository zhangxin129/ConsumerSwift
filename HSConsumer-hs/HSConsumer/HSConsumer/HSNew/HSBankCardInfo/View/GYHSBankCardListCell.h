//
//  GYHSBankCardListCell.h
//  HSConsumer
//
//  Created by lizp on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSBankCardListCellIdentifier @"GYHSBankCardListCell"

#import <UIKit/UIKit.h>
#import "GYHSCardBandModel.h"

@interface GYHSBankCardListCell : UITableViewCell

@property (nonatomic,strong) UIButton *deleteBtn;//删除银行卡
@property (nonatomic,strong) UISwitch *defaultSwitch;//设置默认开关
@property (nonatomic,strong) GYHSCardBandModel *model;

@end
