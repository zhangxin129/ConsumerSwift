//
//  GYSelectTitleCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSelectTitleCell.h"
#import "GYHSStaffManModel.h"

@interface GYSelectTitleCell()

@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLable;


@end

@implementation GYSelectTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.stateButton setBackgroundImage:[UIImage imageNamed:@"gyhs_check_noselect"] forState:UIControlStateNormal];
    [self.stateButton setBackgroundImage:[UIImage imageNamed:@"gyhs_check_select"] forState:UIControlStateSelected];
    self.shopNameLable.font = kFont32;
    self.shopNameLable.textColor = kGray7D7D7D;
}

-(void)setModel:(GYRelationShopsModel *)model{
    _model = model;
    self.shopNameLable.text = model.shopName;
    if (self.isSelect == YES) {
        self.stateButton.selected = YES;
    }else{
        self.stateButton.selected = NO;
    }
}

- (IBAction)stateBtnAction:(UIButton *)sender {
}

@end
