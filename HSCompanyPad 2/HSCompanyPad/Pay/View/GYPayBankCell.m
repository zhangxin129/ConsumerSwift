//
//  GYBankCell.m
//  HSCompanyPad
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSBankCradModel.h"
#import "GYHSPublicMethod.h"
#import "GYPayBankCell.h"

@interface GYPayBankCell ()

@property (weak, nonatomic) IBOutlet UILabel* bankNameLable;
@property (weak, nonatomic) IBOutlet UILabel* bankAccountLable;
@property (weak, nonatomic) IBOutlet UILabel* cardTypeLable;
@property (weak, nonatomic) IBOutlet UILabel* quickLable;
@property (weak, nonatomic) IBOutlet UIButton* deleteButton;

@end

@implementation GYPayBankCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bankAccountLable.textColor = kGray333333;
    self.bankAccountLable.font = kFont36;
    self.cardTypeLable.textColor = kWhiteFFFFFF;
    self.cardTypeLable.font = kFont32;
    self.cardTypeLable.backgroundColor = kGrayCCCCCC;
    self.quickLable.textColor = kWhiteFFFFFF;
    self.quickLable.font = kFont32;
    self.quickLable.backgroundColor = kGreen008C23;
    self.backgroundView = [[UIImageView alloc] initWithImage:[GYHSPublicMethod buttonImageStrech:@"gyhs_point_noselect"]];
    self.layer.borderWidth = 1;
    self.layer.borderColor = kGrayCCCCCC.CGColor;
    [self.deleteButton setTitleColor:kWhiteFFFFFF forState:UIControlStateNormal];
    [self.deleteButton setBackgroundColor:kRedE50012];
    self.deleteButton.hidden = YES;
    
    UISwipeGestureRecognizer* leftTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapAction)];
    leftTap.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftTap];
    
    UISwipeGestureRecognizer* rightTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightAction)];
    rightTap.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightTap];
}

- (void)leftTapAction
{

    self.deleteButton.hidden = NO;
    self.quickLable.hidden = YES;
}

- (void)rightAction
{
    self.deleteButton.hidden = YES;
    self.quickLable.hidden = NO;
}

- (void)setModel:(GYHSBankCradModel*)model
{
    _model = model;
    self.bankNameLable.text = model.bankName;
    self.bankAccountLable.text = [NSString stringWithFormat:@"****%@", [model.bankCardNo substringFromIndex:model.bankCardNo.length - 4]];
    if ([model.bankCardType isEqualToString:@"1"]) {
        self.cardTypeLable.text = kLocalized(@"GYHSPay_DebitCard");
    } else {
        self.cardTypeLable.text = kLocalized(@"GYHSPay_CreditCard");
    }
}

//- (void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//    self.backgroundView = [[UIImageView alloc] initWithImage:[GYHSPublicMethod buttonImageStrech:self.isSelected ? @"gyhs_point_select" : @"gyhs_point_noselect"]];
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = self.isSelected ? kRedE40011.CGColor : kGrayCCCCCC.CGColor;
//
//}

- (UIImage*)buttonImageStrech:(NSString*)imagename
{
    UIImage* btnImage = [UIImage imageNamed:imagename];
    CGFloat btnImageW = btnImage.size.width * 0.5;
    CGFloat btnImageH = btnImage.size.height * 0.5;
    UIImage* newBtnImage = [btnImage resizableImageWithCapInsets:UIEdgeInsetsMake(btnImageH, btnImageW, btnImageH, btnImageW) resizingMode:UIImageResizingModeStretch];
    return newBtnImage;
}
- (IBAction)deleteBtnAction:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteActionModel:)]) {
        [self.delegate deleteActionModel:_model];
    }
}
@end
