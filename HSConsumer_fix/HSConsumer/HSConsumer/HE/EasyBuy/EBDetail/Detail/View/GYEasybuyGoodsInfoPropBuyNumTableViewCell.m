//
//  GYEasybuyGoodsInfoPropBuyNumTableViewCell.m
//  HSConsumer
//
//  Created by zhangqy on 15/11/17.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import "GYEasybuyGoodsInfoPropBuyNumTableViewCell.h"
#import "UIView+CustomBorder.h"


@interface GYEasybuyGoodsInfoPropBuyNumTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *numFeild;

@property (weak, nonatomic) IBOutlet UIButton *lessBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *lessImgV;
@property (weak, nonatomic) IBOutlet UIImageView *addImgView;


@end
@implementation GYEasybuyGoodsInfoPropBuyNumTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _lessImgV.image = [UIImage imageNamed:@"gyhe_btn_min"];
    _addImgView.image = [UIImage imageNamed:@"gyhe_btn_add"];
    
    self.backgroundColor = kDefaultVCBackgroundColor;
    self.numFeild.keyboardType = UIKeyboardTypeNumberPad;
    self.numFeild.delegate = self;
    [self.numFeild addTopBorder];
    [self.numFeild addBottomBorder];
    [self addBottomBorder];
    self.titleLabel.text = kLocalized(@"GYHE_Easybuy_buyCount");
    _num = @"1";
    _numFeild.text = _num;
}

- (IBAction)add:(UIButton *)sender {
    
    if([_num intValue] == _maxNum) {
        [GYUtils showToast:[NSString stringWithFormat:@"%@%ld",kLocalized(@"GYHE_Easybuy_maxnum"),_maxNum]];
        _num = [NSString stringWithFormat:@"%ld",_maxNum];
        
    }else {
        _num = [NSString stringWithFormat:@"%d", [_num intValue]+1];
    }
    _numFeild.text = _num;
}

- (IBAction)less:(UIButton *)sender {
    if ([_num intValue] > 1) {
        
        _num = [NSString stringWithFormat:@"%d", [_num intValue]-1];
        _numFeild.text = _num;
    }else {
        [GYUtils showMessage:kLocalized(@"GYHE_Easybuy_less_buy")];
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if([text integerValue] > _maxNum) {
        [self.contentView endEditing:YES];
        [GYUtils showToast:[NSString stringWithFormat:@"%@%ld",kLocalized(@"GYHE_Easybuy_maxnum"),_maxNum]];
        _num = [NSString stringWithFormat:@"%ld",_maxNum];
        textField.text = _num;
    }else {
        _num = text;
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField*)textField {
    if([textField.text integerValue] < 1) {//当输入数字为0 或者 空的时候
        [self.contentView endEditing:YES];
        [GYUtils showMessage:kLocalized(@"GYHE_Easybuy_less_buy")];
        _num = @"1";
        textField.text = _num;
    }
}

@end
