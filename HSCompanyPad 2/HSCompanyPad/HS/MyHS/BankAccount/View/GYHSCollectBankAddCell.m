//
//  GYHSCollectBankAddCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCollectBankAddCell.h"

@interface GYHSCollectBankAddCell ()
@property (weak, nonatomic) IBOutlet UILabel* tipLabel;

@end
@implementation GYHSCollectBankAddCell



#pragma mark - setter
- (void)setAddNumber:(NSInteger)addNumber
{
    if (_addNumber != addNumber) {
        _addNumber = addNumber;
        NSString* string = [NSString stringWithFormat:@"%@%ld%@",kLocalized(@"GYHS_Myhs_Can_Add1"),addNumber,kLocalized(@"GYHS_Myhs_Can_Add2")];
        NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range = [[attribute string] rangeOfString:[NSString stringWithFormat:@"%ld", addNumber] options:NSBackwardsSearch];
        [attribute addAttribute:NSForegroundColorAttributeName value:kRedE50012 range:range];
        self.tipLabel.attributedText = attribute;
    }
}

- (IBAction)click:(UIButton*)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(bankAddClick)]) {
        [_delegate bankAddClick];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeAll;
}
@end
