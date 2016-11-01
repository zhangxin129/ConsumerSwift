//
//  GYHEGoodsQueryCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHEGoodsQueryCell.h"

@interface GYHEGoodsQueryCell()

@property (weak, nonatomic) IBOutlet UILabel *goodsClassLable;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLable;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLable;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *goodsPointLable;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLable;
@property (weak, nonatomic) IBOutlet UILabel *goodsStaLable;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@end

@implementation GYHEGoodsQueryCell

-(void)layoutSubviews{
    [super layoutSubviews];
    _goodsClassLable.textColor = kGray333333;
    _goodsNameLable.textColor = kGray333333;
    _goodsNumLable.textColor = kGray333333;
    _goodsPriceLable.textColor = kGray333333;
    _goodsPointLable.textColor = kGray333333;
    _shopNameLable.textColor = kGray333333;
    _goodsStaLable.textColor = kGray333333;
    [_changeButton setTitleColor:kBlue0A59C1 forState:UIControlStateNormal];
    [_deleteButton setTitleColor:kBlue0A59C1 forState:UIControlStateNormal];
    [_stateButton setTitleColor:kBlue0A59C1 forState:UIControlStateNormal];

}
- (IBAction)stateBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(stateAction)]) {
        [self.delegate stateAction];
    }
}

- (IBAction)changeBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(changeAction)]) {
        [self.delegate changeAction];
        sender.enabled = YES;
    }
}
- (IBAction)deleteBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteAction)]) {
        [self.delegate deleteAction];
        sender.enabled = YES;
    }
}
@end
