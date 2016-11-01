//
//  GYPurchaseToolsCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYPurchaseToolsCell.h"
#import <YYKit/UIImageView+YYWebImage.h>

@interface GYPurchaseToolsCell()

@property (weak, nonatomic) IBOutlet UIImageView *toolImageView;
@property (weak, nonatomic) IBOutlet UILabel *toolNameLable;
@property (weak, nonatomic) IBOutlet UILabel *toolPrice;

@property (weak, nonatomic) IBOutlet UIButton *reduceButton;

@property (weak, nonatomic) IBOutlet UIView *operateView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, assign) NSInteger valueCount;

@end

@implementation GYPurchaseToolsCell
/**
 *  给各个控件设置属性
 */
-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderColor = kGrayDDDDDD.CGColor;
    self.layer.borderWidth = 1.0f;
    self.toolNumTF.layer.borderColor = kGrayDDDDDD.CGColor;
    self.toolNumTF.layer.borderWidth = 1.0f;
    self.toolNumTF.text = @"0";
    self.toolNumTF.textColor = kGray666666;
    self.toolNumTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.toolNumTF addTarget:self action:@selector(tfCountChange) forControlEvents:UIControlEventEditingChanged];
    self.operateView.userInteractionEnabled = NO;
    
    [self.stateButton setBackgroundImage:[UIImage imageNamed:@"gyhs_sta_normal"] forState:UIControlStateNormal];
    [self.stateButton setBackgroundImage:[UIImage imageNamed:@"gyhs_sta_select"] forState:UIControlStateSelected];
    self.stateButton.userInteractionEnabled = NO;
}

/**
 *  申购工具数量的输入框的事件
 */
- (void)tfCountChange
{
    if (self.toolNumTF.text.intValue < [_model.mayBuyquantity intValue]) {
        self.model.quanilty = [@(self.toolNumTF.text.integerValue) stringValue];
        self.toolNumTF.text = [@(self.toolNumTF.text.integerValue) stringValue];
    }else{
        self.toolNumTF.text =  _model.mayBuyquantity;
        self.model.quanilty = _model.mayBuyquantity ;
        [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_PurchaseQuantityExceedsTheQuantityPurchased")];
        [self.toolNumTF resignFirstResponder];
    }
}

/**
 *  给各个控件赋值
 */
-(void)setModel:(GYHSToolPurchaseModel *)model
{
    _model = model;
    self.toolNameLable.text = model.productName;
    self.toolPrice.text = [GYUtils formatCurrencyStyle: model.price.doubleValue];
    
    NSString *url = GY_PICTUREAPPENDING(model.microPic);
    
    [self.toolImageView setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionProgressiveBlur completion:nil];
    
    self.stateButton.selected = model.selected;
    if (self.isSelect == YES) {
        self.stateButton.selected = YES;
        self.operateView.userInteractionEnabled = YES;
        if (model.marrStyles > 0) {
            self.toolImageView.userInteractionEnabled = YES;
        }
    }else{
        self.stateButton.selected = NO;
        self.operateView.userInteractionEnabled = NO;
        self.toolImageView.userInteractionEnabled = NO;
    }
}
/**
 *  申购数量加和减按钮的事件
 */
- (IBAction)btnAction:(UIButton *)sender {
    NSInteger add = 0;
    if (sender == self.reduceButton) {
        if (self.toolNumTF.text.intValue > 0) {
            add = 1;
            self.toolNumTF.text = [NSString stringWithFormat:@"%zi",[self.toolNumTF.text integerValue] - add];
            self.model.quanilty = self.toolNumTF.text;
        }
    }else if(sender == self.addButton)
    {
        if (self.toolNumTF.text.intValue < 10) {
            add = 1;
            self.toolNumTF.text = [NSString stringWithFormat:@"%zi",[self.toolNumTF.text integerValue] + add];
            self.model.quanilty = self.toolNumTF.text;
        }else{
            
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_PurchaseQuantityMayNotExceedTheQuantityPurchased")];

            [self.toolNumTF resignFirstResponder];
        }
    }

}

@end
