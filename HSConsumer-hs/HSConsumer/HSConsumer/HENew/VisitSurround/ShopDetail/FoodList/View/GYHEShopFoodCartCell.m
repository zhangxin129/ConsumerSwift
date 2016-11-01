//
//  GYHEShopFoodCartCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopFoodCartCell.h"

@interface  GYHEShopFoodCartCell()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation GYHEShopFoodCartCell

- (void)awakeFromNib {
    // Initialization code
    _maxNum = 10;
    _textField.userInteractionEnabled = NO;
}
- (void)setNum:(NSString *)num {
    _num = num;
    _textField.text = _num;    
}
- (IBAction)add:(UIButton *)sender {
    
    if([_num intValue] == _maxNum) {
        [GYUtils showToast:[NSString stringWithFormat:@"%@%ld",kLocalized(@"最大购买数量为"),_maxNum]];
        _num = [NSString stringWithFormat:@"%ld",_maxNum];
        
    }else {
        _num = [NSString stringWithFormat:@"%d", [_num intValue]+1];
    }
    _textField.text = _num;
}

- (IBAction)less:(UIButton *)sender {
    if ([_num intValue] > 1) {
        
        _num = [NSString stringWithFormat:@"%d", [_num intValue]-1];
        _textField.text = _num;
    }else {
       
        //删除行
        if(_deleteRowBlock) {
            _deleteRowBlock();
        }
    }
}

@end
