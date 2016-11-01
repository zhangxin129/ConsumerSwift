//
//  GYHSAccountShowDetailCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAccountShowDetailCell.h"
#import "GYHSTools.h"

@interface GYHSAccountShowDetailCell()

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation GYHSAccountShowDetailCell

- (void)awakeFromNib {
    _searchBtn.titleLabel.font = kCellOtherTextFont;
    _searchBtn.titleLabel.textColor = kBtnBlue;
    [_searchBtn setTitle:kLocalized(@"GYHS_HSAccount_showDetail") forState:UIControlStateNormal];
    [_searchBtn setImage:[UIImage imageNamed:@"gyhs_account_search"] forState:UIControlStateNormal];
}

- (IBAction)searchAction:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(searchAccountDetail:)]) {
        [self.delegate searchAccountDetail:self];
    }
}

@end
