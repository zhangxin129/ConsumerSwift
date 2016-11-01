//
//  GYHSBankAccountCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSBankAccountCell.h"
#define kLineHeight 0.5
#define kBorderColor [UIColor colorWithRed:200 / 255.0f green:200 / 255.0f blue:200 / 255.0f alpha:1]

@interface GYHSBankAccountCell()

@end
@implementation GYHSBankAccountCell

- (void)awakeFromNib
{
    self.bankLeftLabel.edgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    self.bankRightLabel.edgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    self.bankLeftLabel.textColor = kGray666666;
    self.bankRightLabel.textColor = kGray333333;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft | UIViewCustomBorderTypeBottom;
}

#pragma mark - 分割线
- (UIView*)bindingWithView:(UIView*)view frame:(CGRect)frame
{
    UIView* vPass = [[UIView alloc] initWithFrame:frame];
    vPass.backgroundColor = [UIColor whiteColor];
    for (NSInteger i = 0; i < frame.size.width; i += 2) {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(i, frame.size.height / 2, 1, 0.5)];
        v.backgroundColor = kBorderColor;
        [vPass addSubview:v];
    }
    [view addSubview:vPass];
    
    return vPass;
}

@end
