//
//  GYVApplyTableViewCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/7/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYVApplyTableViewCell.h"
#import "GYHSTools.h"

@implementation GYVApplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.accidentHarmlb.font = kQualificationlbFont;
    self.dielb.font = kQualificationlbFont;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnDie:(id)sender {
    [self.btnDie setImage:[UIImage imageNamed:@"gyhs_select_circle"] forState:UIControlStateNormal];
    [self.btnMedical setImage:[UIImage imageNamed:@"gyhs_select_circle_no"] forState:UIControlStateNormal];
    if ([_btnDieDeletage respondsToSelector:@selector(btnDie)]) {
        [self.btnDieDeletage btnDie];
        
    }
}
- (IBAction)btnMedical:(id)sender {
    [self.btnMedical setImage:[UIImage imageNamed:@"gyhs_select_circle"] forState:UIControlStateNormal];
    [self.btnDie setImage:[UIImage imageNamed:@"gyhs_select_circle_no"] forState:UIControlStateNormal];
    if ([_btnMedicalDeletage respondsToSelector:@selector(btnMedical)]) {
        [self.btnMedicalDeletage btnMedical];
        
    }
}

@end
