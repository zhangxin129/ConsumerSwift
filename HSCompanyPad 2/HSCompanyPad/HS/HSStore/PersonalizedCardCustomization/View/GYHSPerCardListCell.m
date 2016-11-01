//
//  GYHSPerCardListCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPerCardListCell.h"
#import "GYHSListSpecCardStyleModel.h"

@interface GYHSPerCardListCell()


@property (weak, nonatomic) IBOutlet UILabel *cardNameLable;
@property (weak, nonatomic) IBOutlet UILabel *feeTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *cardFeeLable;
@property (weak, nonatomic) IBOutlet UILabel *cusTimeTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *cusTimelable;
@property (weak, nonatomic) IBOutlet UILabel *cusStaLable;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;


@end

@implementation GYHSPerCardListCell
/**
 *  给控件添加各种属性
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    self.numLable.textColor = kBlue59A0FF;
    self.numLable.font = kFont100;
    self.cardNameLable.textColor = kGray333333;
    self.cardNameLable.font = kFont42;
    self.feeTitleLable.textColor = kGray666666;
    self.feeTitleLable.font = kFont32;
    self.cardFeeLable.textColor = kRedE50012;
    self.cardFeeLable.font = kFont32;
    self.cusTimeTitleLable.textColor = kGray666666;
    self.cusTimeTitleLable.font = kFont32;
    self.cusTimelable.textColor = kGray666666;
    self.cusTimelable.font = kFont32;
    self.cusStaLable.textColor = kRedE50012;
    self.cusStaLable.font = kFont32;
    
    [self.lookButton setBackgroundColor:kBlue0A59C2];
    [self.lookButton setTitleColor:kWhiteFFFFFF forState:UIControlStateNormal];
    self.lookButton.layer.cornerRadius = 5;
}
/**
 *  给控件赋值
 */
- (void)setModel:(GYHSListSpecCardStyleModel *)model{
    _model = model;
    self.cardNameLable.text = model.cardStyleName;
    self.cardFeeLable.text = [GYUtils formatCurrencyStyle: model.cardStyleFee.doubleValue];
    self.cusTimelable.text = model.reqTime;
    if (model.isConfirm.boolValue) {
        self.cusStaLable.text = kLocalized(@"GYHS_HSStore_PerCardCustomization_AlreadyComfirm");
    }else{
       self.cusStaLable.text = kLocalized(@"GYHS_HSStore_PerCardCustomization_ToBeConfirmed");
    }
    
    self.lookButton.hidden = NO;
    if (model.sourceFile.length ==0 && !model.isConfirm.boolValue && model.confirmFile.length == 0 && model.microPic.length == 0) {
        self.cusStaLable.text = kLocalized(@"GYHS_HSStore_PerCardCustomization_CardModelBeMaking");
                                                                                                                        
        self.lookButton.hidden = YES;
    }
}
/**
 *  给列表上的按钮添加代理传值
 */
- (IBAction)buttonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lookSelectCell:)]) {
        [self.delegate lookSelectCell:_model];
    }
}

@end
