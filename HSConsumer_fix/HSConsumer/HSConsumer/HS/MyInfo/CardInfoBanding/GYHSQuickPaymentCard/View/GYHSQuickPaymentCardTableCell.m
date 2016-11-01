//
//  GYHSQuickPaymentCardTableCell.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSQuickPaymentCardTableCell.h"

@interface GYHSQuickPaymentCardTableCell()

@property (weak, nonatomic) IBOutlet UILabel *bankNumberLable;
@property (weak, nonatomic) IBOutlet UILabel *bankAdressLable;

@end

@implementation GYHSQuickPaymentCardTableCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setCellValue:(GYHSQuickPayModel *)model {
    
    self.bankNumberLable.text = [NSString stringWithFormat:@"**** %@",model.bankCardNo];
    self.bankAdressLable.text = model.bankName;
}

@end
