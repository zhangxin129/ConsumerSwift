//
//  GYHSPurchaseAddressCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPurchaseAddressCell.h"
#import "GYHSAddressListModel.h"

@interface GYHSPurchaseAddressCell()

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *addTypeLable;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLable;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLable;
@property (weak, nonatomic) IBOutlet UILabel *contactAddLable;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) NSDictionary *addDict;

@end

@implementation GYHSPurchaseAddressCell
/**
 *  给各个控件设置属性
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.selectButton setImage:[UIImage imageNamed:@"gyhs_check_noselect"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"gyhs_check_select"] forState:UIControlStateSelected];
    self.addTypeLable.textColor = kGray333333;
    self.contactNameLable.textColor = kGray333333;
    self.contactPhoneLable.textColor = kGray333333;
    self.contactAddLable.textColor = kGray333333;
    [self.changeButton setTitleColor:kBlue0A59C2 forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:kBlue0A59C2 forState:UIControlStateNormal];

}
/**
 *  给各个控件赋值
 */
- (void)setModel:(GYHSAddressListModel *)model{
    _model = model;
    self.contactNameLable.text = model.contactName;
    self.contactPhoneLable.text = model.contactPhone;
    if (model.addressId.length > 2) {
        @weakify(self);
        [model getDetailArressWithBlock:^(NSString* address) {
            @strongify(self);
            self.contactAddLable.text = address;
            [self setNeedsLayout];
        }];
    }else {
        self.contactAddLable.text = model.contactAddr;
    }
    
    if (model.addressId.length > 0) {
        self.addTypeLable.text = kLocalized(@"GYHS_HSStore_PurchaseTools_CustomAddress");
        self.changeButton.hidden = NO;
        self.deleteButton.hidden = NO;
    }else{
        self.addTypeLable.text = kLocalized(@"GYHS_HSStore_PurchaseTools_ContactAddress");
        self.changeButton.hidden = YES;
        self.deleteButton.hidden = YES;
    }
    
    self.selectButton.selected =   model.isSelected;
    

}

/**
 *  修改和删除按钮的触发时间
 */
- (IBAction)selectBtnAction:(UIButton *)sender {
    if (sender == self.deleteButton) {
        if ([self.delegate respondsToSelector:@selector(deleteAction:)]) {
            [self.delegate deleteAction:_model];
        }
    }else if (sender == self.changeButton){
        if ([self.delegate respondsToSelector:@selector(changeAction:)]) {
            [self.delegate changeAction:_model];
        }
    }
}

@end
