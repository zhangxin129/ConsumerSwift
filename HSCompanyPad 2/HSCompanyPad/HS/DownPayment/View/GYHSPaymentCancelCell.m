//
//  GYHSPaymentCancelCell.m
//  HSCompanyPad
//
//  Created by 梁晓辉 on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPaymentCancelCell.h"
#import "GYHSPaymentCheckModel.h"
#import "GYHSPublicMethod.h"
@interface GYHSPaymentCancelCell ()
@property (weak, nonatomic) IBOutlet UILabel* transDate;
@property (weak, nonatomic) IBOutlet UILabel* transAmount;

@end
@implementation GYHSPaymentCancelCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.transDate.textColor = kGray333333;
    self.transDate.font = kFont24;
    self.transAmount.textColor = kGray333333;
    self.transAmount.font = kFont24;
}

- (void)setModel:(GYHSPaymentCheckModel*)model
{
    _model = model;
    self.transDate.text = [GYHSPublicMethod transDate:model.sourceTransDate];
    self.transAmount.text = [GYHSPublicMethod keepTwoDecimal:model.transAmount];
}
- (IBAction)clcik:(UIButton*)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cancelWithPayment:)]) {
        [_delegate cancelWithPayment:self.model];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeBottom;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
