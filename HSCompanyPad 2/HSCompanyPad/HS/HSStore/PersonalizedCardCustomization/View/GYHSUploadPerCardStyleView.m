//
//  GYHSUploadPerCardStyleView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSUploadPerCardStyleView.h"
#import <GYKit/GYPlaceholderTextView.h>
#import "UILabel+Category.h"

#define kViewWidth self.frame.size.width

@interface GYHSUploadPerCardStyleView()<UITextViewDelegate>

@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, strong) UIView *cardNameView;
@property (nonatomic, strong) UIView *remarkView;
@property (nonatomic, strong) GYPlaceholderTextView *cardTypeTextView;
@property (nonatomic, strong) GYPlaceholderTextView *remarkTextView;

@end

@implementation GYHSUploadPerCardStyleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [self setTipsUI];
    [self createInputCardNameView];
    [self createRemarkView];
}
- (void)setTipsUI{
    
    _tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 16, kDeviceProportion(kViewWidth) , kDeviceProportion(204))];
    [self addSubview:_tipsView];
    self.tipsView.layer.borderColor = kGrayCCCCCC.CGColor;
    self.tipsView.layer.borderWidth = 1.0f;
    
    UILabel *tipsLable = [[UILabel alloc] init];
    tipsLable.numberOfLines = 0;
    NSString *tipsStr = [NSString stringWithFormat:@"%@\n%@\n%@",kLocalized(@"GYHS_HSStore_PerCardCustomization_Tips"),kLocalized(@"GYHS_HSStore_PerCardCustomization_OtherTypesOfApplicationTrustCompanyOnlyNeed 1000 YuanCanEnjoyPersonalizedHSCardCustomizationService"),kLocalized(@"GYHS_HSStore_PerCardCustomization_EverytimesApplyForPermanentUse")];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.lineSpacing = 10;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tipsStr attributes:@{NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGray666666 ,NSParagraphStyleAttributeName:paragraphStyle}];
    NSRange range = [tipsStr rangeOfString:kLocalized(@"GYHS_HSStore_PerCardCustomization_Tips")];
    [text addAttributes:@{ NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kRedE50012 } range:range];
    tipsLable.attributedText = text;
    [_tipsView addSubview:tipsLable];
    [tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipsView.mas_top).offset(30);
        make.left.equalTo(_tipsView.mas_left).offset(80);
        make.width.equalTo(@(kDeviceProportion(kViewWidth - 80)));
        make.height.equalTo(@(kDeviceProportion(90)));
    }];
    
    
    UILabel *promptLable = [[UILabel alloc] init];
    promptLable.numberOfLines = 0;
    NSString *promptStr = [NSString stringWithFormat:@"%@\n%@",kLocalized(@"GYHS_HSStore_PerCardCustomization_SpecialNote"),kLocalized(@"GYHS_HSStore_PerCardCustomization_VisitTheWeb-likeUploadPersonalizedCardStyleFile")];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    style.lineSpacing = 10;
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc] initWithString:promptStr attributes:@{NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGray666666 ,NSParagraphStyleAttributeName:style}];
    NSRange ran = [promptStr rangeOfString:kLocalized(@"GYHS_HSStore_PerCardCustomization_SpecialNote")];
    [textStr addAttributes:@{ NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kBlue0A59C2 } range:ran];
    promptLable.attributedText = textStr;
    [_tipsView addSubview:promptLable];
    [promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLable.mas_top).offset(30 + 70);
        make.left.equalTo(_tipsView.mas_left).offset(80);
        make.width.equalTo(@(kDeviceProportion(kViewWidth - 80)));
        make.height.equalTo(@(kDeviceProportion(60)));
    }];
}

- (void)createInputCardNameView{
    
    _cardNameView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tipsView.frame) + 16, kDeviceProportion(kViewWidth) , kDeviceProportion(76))];
    [self addSubview:_cardNameView];
    
    UILabel *cardTypeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(150), kDeviceProportion(16))];
    [cardTypeLable initWithText:kLocalized(@"GYHS_HSStore_PerCardCustomization_PersonalizedCardName") TextColor:kGray333333 Font:kFont32 TextAlignment:0];
    [_cardNameView addSubview:cardTypeLable];
    
    _cardTypeTextView = [[GYPlaceholderTextView alloc] init];
    _cardTypeTextView.layer.borderColor = kGrayCCCCCC.CGColor;
    _cardTypeTextView.layer.borderWidth = 1.0f;
    _cardTypeTextView.delegate = self;
    _cardTypeTextView.maxTextLength = 20;
    _cardTypeTextView.keyboardType = UIKeyboardTypeDefault;
    _cardTypeTextView.placeholder = kLocalized(@"GYHS_HSStore_PerCardCustomization_EnterThePersonalizedCardName,NoMoreThan 20 Words");
    [_cardNameView addSubview:_cardTypeTextView];
    [_cardTypeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardTypeLable.mas_top).offset(16 + 10);
        make.left.equalTo(_cardNameView.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(kViewWidth)));
        make.height.equalTo(@(kDeviceProportion(50)));
    }];

}
- (void)createRemarkView{
    _remarkView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cardNameView.frame) + 16, kDeviceProportion(kViewWidth) , kDeviceProportion(204))];
    [self addSubview:_remarkView];
    
    UILabel *remarkLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(150), kDeviceProportion(16))];
    [remarkLable initWithText:kLocalized(@"GYHS_HSStore_PerCardCustomization_DesignRequirementsNote") TextColor:kGray333333 Font:kFont32 TextAlignment:0];
    [_remarkView addSubview:remarkLable];
    
    _remarkTextView = [[GYPlaceholderTextView alloc] init];
    _remarkTextView.layer.borderColor = kGrayCCCCCC.CGColor;
    _remarkTextView.layer.borderWidth = 1.0f;
    _remarkTextView.delegate = self;
    _remarkTextView.keyboardType = UIKeyboardTypeDefault;
    _remarkTextView.maxTextLength = 300;
    _remarkTextView.placeholder = kLocalized(@"GYHS_HSStore_PerCardCustomization_EnterTheDesignRequirementsNote,NoMoreThan 300 Words");
    [_remarkView addSubview:_remarkTextView];
    [_remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkLable.mas_top).offset(16 + 10);
        make.left.equalTo(_remarkView.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(kViewWidth)));
        make.height.equalTo(@(kDeviceProportion(180)));
    }];
    
}

#pragma  mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([self.delegate respondsToSelector:@selector(transCardName:Remark:)]) {
        [self.delegate transCardName:_cardTypeTextView.text Remark:_remarkTextView.text];
    }
    
}
- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    NSString* toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (textView == self.cardTypeTextView) {
        if (toBeString.length > 20) {
            [textView resignFirstResponder];
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_PerCardCustomization_PersonalizedCardNameCannotBeMoreThan 20 Characters")];
            return NO;
        }
 
    }
    if (textView == self.remarkTextView) {
        if (toBeString.length > 300) {
            [textView resignFirstResponder];
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_PerCardCustomization_DesignRequirementsDescriptionCannotExceed 300 Words")];
            return NO;
        }
    }
    
    return YES;
    
}


@end
