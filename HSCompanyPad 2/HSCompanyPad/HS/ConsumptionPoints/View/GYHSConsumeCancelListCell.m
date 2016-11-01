//
//  GYHSConsumeCancelListCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSConsumeCancelListCell.h"
#import "GYHSPointCancelModel.h"
#import "GYHSPublicMethod.h"
@interface GYHSConsumeCancelListCell ()
@property (weak, nonatomic) IBOutlet UILabel* transNoLab;
@property (weak, nonatomic) IBOutlet UILabel* transAmountLab;
@property (weak, nonatomic) IBOutlet UILabel* pointLab;
@property (weak, nonatomic) IBOutlet UILabel* transAmountValue;
@property (weak, nonatomic) IBOutlet UILabel* pointValue;
@property (weak, nonatomic) IBOutlet UILabel* TransDateValue;
@property (weak, nonatomic) IBOutlet UILabel* transNoValue;

@end
@implementation GYHSConsumeCancelListCell

- (void)awakeFromNib
{
    // Initialization code
    self.transNoLab.font = kFont24;
    self.transNoLab.textColor = kGray777777;
    self.transAmountLab.font = kFont24;
    self.transAmountLab.textColor = kGray777777;
    self.pointLab.font = kFont24;
    self.pointLab.textColor = kGray777777;
    self.TransDateValue.font = kFont24;
    self.TransDateValue.textColor = kGray777777;
    
    self.transAmountValue.font = kFont24;
    self.transAmountValue.textColor = kGray333333;
    self.pointValue.font = kFont24;
    self.pointValue.textColor = kGray333333;
    self.transNoValue.font = kFont24;
    self.transNoValue.textColor = kGray333333;
}

- (void)setModel:(GYHSPointCancelModel*)model
{
    _model = model;
    self.transNoValue.text = model.sourceTransNo;
    self.transAmountValue.text = [GYHSPublicMethod keepTwoDecimal:model.transAmount];
    self.pointValue.text = [GYHSPublicMethod keepTwoDecimal:model.perPoint];
    self.TransDateValue.text = model.sourceTransDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.backgroundView = [[UIImageView alloc] initWithImage:[GYHSPublicMethod buttonImageStrech:self.isSelected ? @"gyhs_point_select" : @"gyhs_point_noselect"]];
    self.layer.borderWidth = 1;
    self.layer.borderColor = self.isSelected ? kRedE40011.CGColor : [UIColor clearColor].CGColor;
}

@end
