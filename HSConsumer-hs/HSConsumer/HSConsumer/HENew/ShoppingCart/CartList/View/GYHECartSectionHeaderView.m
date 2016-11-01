//
//  GYHECartSectionHeaderView.m
//  HSConsumer
//
//  Created by admin on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHECartSectionHeaderView.h"

@implementation GYHECartSectionHeaderView

- (void)awakeFromNib {
    // Initialization code
    
    self.couponInfoViewWidth.constant = 0;
    self.couponInfoView.layer.cornerRadius = 8.0f;
    _couponButton.hidden = YES;
}

- (void)setListModel:(GYHECartListModel *)listModel {
    
    if (!listModel) {
        return;
    }
    _listModel = listModel;
    _chooseButton.selected = listModel.isSelect;
    _nameLabel.text = listModel.vshopName;
    //_voucherInfoLabel.text = listModel.couponDesc;
    
//TODO:隐藏消费券
//    if (listModel.couponDesc && listModel.couponDesc.length > 0) {
//        _couponButton.hidden = NO;
//        if (_listModel.isShowMore) {
//            _couponInfoViewWidth.constant = 145.0f;
//        } else {
//            _couponInfoViewWidth.constant = 0;
//        }
//    } else {
//        _couponButton.hidden = YES;
//        _couponInfoViewWidth.constant = 0;
//    }
}

//选择按钮点击事件
- (IBAction)chooseButtonClick:(UIButton *)sender {
    self.listModel.isSelect = !self.listModel.isSelect;
    sender.selected = self.listModel.isSelect;
    if ([self.delegate respondsToSelector:@selector(updateStateWithAction:)]) {
        [self.delegate updateStateWithAction:self.section];
    }
}

//查看营业点信息
- (IBAction)detailButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(pushToShopHomePage:)]) {
        [self.delegate pushToShopHomePage:self.section];
    }
}

//消费券信息展示
- (IBAction)couponInfoButtonClick:(UIButton *)sender {
//    self.listModel.isShowMore = !self.listModel.isShowMore;
//    if (self.listModel.isShowMore) {
//        self.couponInfoViewWidth.constant = 145.0f;
//    } else {
//        self.couponInfoViewWidth.constant = 0;
//    }
//    [UIView animateWithDuration:0.3 animations:^{
//        [self layoutIfNeeded];
//    }];
    
    sender.userInteractionEnabled = NO;
    //自动缩回
    self.couponInfoViewWidth.constant = 145.0f;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.couponInfoViewWidth.constant = 0;
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
        sender.userInteractionEnabled = YES;
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
