//
//  GYHSPayListCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPayListCell.h"
#import "GYHSPaymentCheckModel.h"
#import "GYHSPublicMethod.h"
@interface GYHSPayListCell ()
@property (weak, nonatomic) IBOutlet UILabel* transDate;
@property (weak, nonatomic) IBOutlet UILabel* transAmount;

@end
@implementation GYHSPayListCell

- (void)awakeFromNib
{
    // Initialization code
    self.transDate.font = kFont24;
    self.transDate.textColor = kGray333333;
    self.transAmount.font = kFont24;
    self.transAmount.textColor = kGray333333;
}

- (void)setModel:(GYHSPaymentCheckModel*)model
{
    _model = model;
    self.transDate.text = [GYHSPublicMethod transDate:model.sourceTransDate];
    self.transAmount.text = [GYHSPublicMethod keepTwoDecimal:model.transAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[GYHSPublicMethod buttonImageStrech:@"gyhs_point_select"]];
        self.transDate.textColor = kRedE50012;
        self.transAmount.textColor = kRedE50012;
    } else {
        self.backgroundView = [[UIImageView alloc] initWithImage:[GYHSPublicMethod buttonImageStrech:@"gyhs_point_noselect"]];
        self.transDate.textColor = kGray333333;
        self.transAmount.textColor = kGray333333;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeBottom;
}

@end
