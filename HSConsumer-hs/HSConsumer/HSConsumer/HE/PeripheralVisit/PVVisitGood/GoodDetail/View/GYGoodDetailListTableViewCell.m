//
//  GYGoodDetailListTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYGoodDetailListTableViewCell.h"

@implementation GYGoodDetailListTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor = kDefaultVCBackgroundColor;
}

- (void)refreshUIWith:(NSString*)title WithDetail:(NSString*)detail
{
    self.lbDetailTitle.text = [NSString stringWithFormat:@"%@:", title];

    self.lbDetailInfo.text = detail;


}

@end
