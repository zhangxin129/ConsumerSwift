//
//  GYHEOrderQuickPayInfoCell.m
//  HSConsumer
//
//  Created by wangfd on 16/5/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEOrderQuickPayInfoCell.h"

@interface GYHEOrderQuickPayInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel* titleLable;
@property (weak, nonatomic) IBOutlet UILabel* orderNameLable;
@property (weak, nonatomic) IBOutlet UILabel* orderValueLable;
@property (weak, nonatomic) IBOutlet UILabel* moneyNameLable;
@property (weak, nonatomic) IBOutlet UILabel* moneyValueLable;

@end

@implementation GYHEOrderQuickPayInfoCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellValue:(NSString*)title
            orderNum:(NSString*)orderNum
               money:(NSString*)money
{
    self.titleLable.text = title;
    self.orderValueLable.text = orderNum;
    self.moneyValueLable.text = [GYUtils formatCurrencyStyle:kSaftToNSString(money).doubleValue];
}

@end
