//
//  GYExpressListCell.m
//  HSConsumer
//
//  Created by apple on 16/3/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYExpressListCell.h"

@implementation GYExpressListCell

- (void)awakeFromNib
{

    self.expressLabel.textColor = kCellItemTitleColor;
    self.expressLabel.font = kCellTitleFont;
}

- (void)refreshUIWithModel:(GYExpressModel*)model
{

    if (model.isSelect) {

        self.isSelectImageView.hidden = NO;
    }

    self.expressLabel.text = model.name;

}

@end
