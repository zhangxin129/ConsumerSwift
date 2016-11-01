//
//  GYHSQuickPamentCollectCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSQuickPamentCollectCell.h"
#import "GYHSEdgeLabel.h"
#import "GYHSQuickListModel.h"
@interface GYHSQuickPamentCollectCell ()
@property (weak, nonatomic) IBOutlet UILabel* bankName;
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel* bankAccountNumber;
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel* bankType;

@end
@implementation GYHSQuickPamentCollectCell

- (void)awakeFromNib
{
    // Initialization code
    self.bankAccountNumber.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.bankType.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.bankAccountNumber.backgroundColor = kRedfa5a48;
    self.bankAccountNumber.font = [UIFont boldSystemFontOfSize:21.0f];
    self.bankType.backgroundColor = kRedff3a24;
    self.bankType.font = [UIFont boldSystemFontOfSize:15.0f];
}

- (void)setModel:(GYHSQuickListModel*)model
{
    _model = model;
    self.bankName.text = model.bankName;
    self.bankAccountNumber.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_Myhs_Tailno"), [self subBankNumber:model.bankCardNo]]];
    if (model.bankCardType.integerValue == 1) {
        self.bankType.text = kLocalized(@"GYHS_Myhs_Debit_card");
    } else if (model.bankCardType.integerValue == 2) {
        self.bankType.text = kLocalized(@"GYHS_Myhs_Credit_Card");
    }
}

- (NSString*)subBankNumber:(NSString*)bankNumber
{
    if (bankNumber.length > 4) {
    
        return [bankNumber substringFromIndex:bankNumber.length - 4];
        
    } else {
        return bankNumber;
    }
}
- (IBAction)deleteClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteQuickBankWithModel:)]) {
        [_delegate deleteQuickBankWithModel:self.model];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeAll;
}
@end
