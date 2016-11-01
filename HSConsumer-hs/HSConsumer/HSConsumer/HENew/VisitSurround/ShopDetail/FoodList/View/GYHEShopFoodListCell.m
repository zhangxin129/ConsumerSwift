//
//  GYHEShopFoodListCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopFoodListCell.h"

@interface GYHEShopFoodListCell()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *lessBtn;


@end

@implementation GYHEShopFoodListCell

- (void)awakeFromNib {
    _textField.userInteractionEnabled = NO;
    
    
    
}
- (void)setNum:(NSString *)num {
    _num = num;
//    _num = @"0";
    _textField.text = _num;
    _maxNum = 10;
    if([_num intValue] == 0) {
        _textField.hidden = YES;
        _lessBtn.hidden = YES;
    }else {
        _textField.hidden = NO;
        _lessBtn.hidden = NO;
    }
    
}
- (IBAction)add:(UIButton *)sender {
    
    if([_num intValue] == 0) {
        _textField.hidden = NO;
        _lessBtn.hidden = NO;
    }
    
    if([_num intValue] == _maxNum) {
        [GYUtils showToast:[NSString stringWithFormat:@"%@%ld",kLocalized(@"最大购买数量为"),_maxNum]];
        _num = [NSString stringWithFormat:@"%ld",_maxNum];
        
    }else {
        _num = [NSString stringWithFormat:@"%d", [_num intValue]+1];
    }
    _textField.text = _num;
    
    if(_changeCountBlock) {
        _changeCountBlock(_num);
    }
}

- (IBAction)lass:(UIButton *)sender {
    if ([_num intValue] > 1) {
        
        _num = [NSString stringWithFormat:@"%d", [_num intValue]-1];
        _textField.text = _num;
    }else {
//        [GYUtils showMessage:kLocalized(@"最小购买数量为1")];
        _num = @"0";
        _textField.hidden = YES;
        _lessBtn.hidden = YES;
        
    }
    if(_changeCountBlock) {
        _changeCountBlock(_num);
    }
}


@end
