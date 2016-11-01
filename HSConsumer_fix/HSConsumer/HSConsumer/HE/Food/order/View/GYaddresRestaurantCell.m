//
//  GYaddresRestaurantCell.m
//  HSConsumer
//
//  Created by appleliss on 15/9/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYaddresRestaurantCell.h"
//#import "GYChatViewController.h"
#import "UIActionSheet+Blocks.h"

@interface GYaddresRestaurantCell () <UIActionSheetDelegate>

@end
@implementation GYaddresRestaurantCell

- (void)awakeFromNib
{
    // Initialization code
    self.lbHsTitle.text = [kLocalized(@"GYHE_Food_CardNumber") stringByAppendingString:@":"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnMessage:(UIButton*)sender
{
    if ([_gyGYaddresRestaurantCellDelegate respondsToSelector:@selector(GYaddresRestaurantCell)]) {
        [_gyGYaddresRestaurantCellDelegate GYaddresRestaurantCell];
    }
}

///拨打电话
- (IBAction)btnphone:(id)sender
{
    [GYUtils callPhoneWithPhoneNumber:self.tel showInView:kAppDelegate.window];
}


@end
