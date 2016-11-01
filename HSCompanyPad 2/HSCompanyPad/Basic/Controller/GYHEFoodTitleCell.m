//
//  GYHEFoodTitleCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHEFoodTitleCell.h"
#import "GYHSStaffManModel.h"
#import "KxMenu.h"

@interface GYHEFoodTitleCell()

@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UILabel *roleNameLable;


@end

@implementation GYHEFoodTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.stateButton setBackgroundImage:[UIImage imageNamed:@"gyhs_check_noselect"] forState:UIControlStateNormal];
    [self.stateButton setBackgroundImage:[UIImage imageNamed:@"gyhs_check_select"] forState:UIControlStateSelected];
    self.roleNameLable.font = kFont32;
    self.roleNameLable.textColor = kGray333333;
}

- (void)setModel:(GYRoleListModel *)model{
    _model = model;
    self.roleNameLable.text = model.roleName;
    if (self.isSelect == YES) {
        self.stateButton.selected = YES;
    }else{
        self.stateButton.selected = NO;
    }
    if (model.isSelected == YES) {
        self.stateButton.selected = YES;
    }else{
        self.stateButton.selected = NO;
    }
}

- (IBAction)satateButtonAction:(UIButton *)sender {
}
- (IBAction)questionButtonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(pullDownRoleDesc:)]) {
        [self.delegate pullDownRoleDesc:_model];
    }
}

@end
