//
//  GYHSConsumeReturnListCell.m
//  HSCompanyPad
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSConsumeReturnListCell.h"
#import "GYHSPublicMethod.h"
#import "GYHSPointReturnModel.h"

@interface GYHSConsumeReturnListCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNumTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLable;
@property (weak, nonatomic) IBOutlet UILabel *conMonTitlteLable;
@property (weak, nonatomic) IBOutlet UILabel *conMonLable;
@property (weak, nonatomic) IBOutlet UILabel *actMonTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *actMonLable;
@property (weak, nonatomic) IBOutlet UILabel *pointRateTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *pointRateLable;
@property (weak, nonatomic) IBOutlet UILabel *disPointTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *disPointLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;


@end

@implementation GYHSConsumeReturnListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.orderNumTitleLable.textColor = kGray666666;
    self.conMonTitlteLable.textColor = kGray666666;
    self.actMonTitleLable.textColor = kGray666666;
    self.pointRateTitleLable.textColor = kGray666666;
    self.disPointTitleLable.textColor = kGray666666;
    self.timeLable.textColor = kGray666666;
    self.orderNumLable.textColor = kGray333333;
    self.conMonLable.textColor = kGray333333;
    self.actMonLable.textColor = kGray333333;
    self.pointRateLable.textColor = kGray333333;
    self.disPointLable.textColor = kGray333333;
}

- (void)setModel:(GYHSPointReturnModel *)model{
    _model = model;
    self.orderNumLable.text = model.sourceTransNo;
    self.conMonLable.text = [GYHSPublicMethod keepTwoDecimal:model.transAmount];
    self.actMonLable.text = [GYHSPublicMethod keepTwoDecimal:model.orderAmount];
    self.pointRateLable.text = model.pointRate;
    self.disPointLable.text = [GYHSPublicMethod keepTwoDecimal:model.perPoint];
    self.timeLable.text = model.sourceTransDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.backgroundView = [[UIImageView alloc] initWithImage:[GYHSPublicMethod buttonImageStrech:self.isSelected ? @"gyhs_point_select" : @"gyhs_point_noselect"]];
    self.layer.borderWidth = 1;
    self.layer.borderColor = self.isSelected ? kRedE40011.CGColor : [UIColor clearColor].CGColor;
}

@end
