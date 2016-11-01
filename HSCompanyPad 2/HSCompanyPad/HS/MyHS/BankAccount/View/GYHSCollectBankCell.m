//
//  GYHSCollectBankCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCollectBankCell.h"
#import "GYHSBankListModel.h"
#import "GYHSEdgeLabel.h"
@interface GYHSCollectBankCell ()
@property (weak, nonatomic) IBOutlet UILabel* bankName;
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel* bankNumber;
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel* bankCurrencyCode;
@property (weak, nonatomic) IBOutlet UIButton* defaultButton;

@end
@implementation GYHSCollectBankCell

- (void)awakeFromNib
{
    // Initialization code
    self.bankNumber.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.bankCurrencyCode.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.bankNumber.font = [UIFont boldSystemFontOfSize:21.0f];
    self.bankCurrencyCode.font = [UIFont boldSystemFontOfSize:15.0f];
}

- (void)setModel:(GYHSBankListModel*)model
{
    _model = model;
    self.bankName.text = model.bankName;
    self.bankNumber.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_Myhs_Tailno"), [self subBankNumber:model.bankAccNo]]];
    self.bankCurrencyCode.text = [NSString stringWithFormat:@"%@ %@", kLocalized(@"GYHS_Myhs_Settle_Kind"), globalData.config.currencyName];
    self.bankNumber.backgroundColor = model.isDefault.boolValue ? kGreen48d78c : kRedfa5a48;
    self.bankCurrencyCode.backgroundColor = model.isDefault.boolValue ? kGreen42c781 : kRedff3a24;
    self.defaultButton.hidden = model.isDefault.boolValue ? NO : YES;
}

- (NSString*)subBankNumber:(NSString*)bankNumber
{
    if (bankNumber.length > 4) {
    
        return [bankNumber substringFromIndex:bankNumber.length - 4];
        
    } else {
        return bankNumber;
    }
}

- (IBAction)bankClick:(UIButton*)sender
{
    //tag = 1 详情，2 删除
    if (_delegate && [_delegate respondsToSelector:@selector(collectBankClick:model:)]) {
        [_delegate collectBankClick:sender.tag model:self.model];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeAll;
}

@end
