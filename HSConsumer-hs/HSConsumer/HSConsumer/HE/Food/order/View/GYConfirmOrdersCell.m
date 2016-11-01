//
//  GYConfirmOrdersCell.m
//  HSConsumer
//
//  Created by appleliss on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYConfirmOrdersCell.h"
#import "GYConfirmOrdersController.h"
@implementation GYConfirmOrdersCell

- (void)awakeFromNib
{

    self.titleName.text = kLocalized(@"GYHE_Food_StoreDining");
}

+ (instancetype)cellWithTableView:(UITableView*)tableView andtitleName:(NSString*)titleName andImageName:(NSString*)imageName
{
    GYConfirmOrdersCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYConfirmOrdersCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYConfirmOrdersCell class]) owner:nil options:nil] lastObject];
    }

    cell.titleName.text = titleName;
    cell.iamgesssss.image = [UIImage imageNamed:imageName];
    return cell;
}

- (IBAction)updataImage:(id)sender
{
    if ([_selectedDelegat respondsToSelector:@selector(gYConfirmOrdersCellDelegateSelected:)]) {
        [_selectedDelegat gYConfirmOrdersCellDelegateSelected:self.rows];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
