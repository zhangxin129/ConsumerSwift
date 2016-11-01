//
//  GYSettingSaftSetResetTradePasswordOverruleView.m
//  HSCompanyPad
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingSaftSetResetTradePasswordOverruleView.h"
#import "GYSettingSaftSetLastApplyBeanModel.h"

@interface GYSettingSaftSetResetTradePasswordOverruleView ()
@property (weak, nonatomic) IBOutlet UILabel* dateTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel* resultTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel* remarkTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel* dateLabel;

@property (weak, nonatomic) IBOutlet UILabel* resultLabel;

@property (weak, nonatomic) IBOutlet UILabel* remarkLabel;

@end

@implementation GYSettingSaftSetResetTradePasswordOverruleView

- (void)awakeFromNib
{
    
    [self addTitle:kLocalized(@"重置申请日期") view:self.dateTitleLabel front:NO];
    [self addTitle:kLocalized(@"审批结果") view:self.resultTitleLabel front:NO];
    [self addTitle:kLocalized(@"审批意见") view:self.remarkTitleLabel front:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addLineAll:self.dateTitleLabel];
    [self addLineLeftAndRight:self.resultTitleLabel];
    [self addLineAll:self.remarkTitleLabel];
    [self addLineAll:self.dateLabel];
    [self addLineLeftAndRight:self.resultLabel];
    [self addLineAll:self.remarkLabel];
}

#pragma mark - private methods

- (void)setModel:(GYSettingSaftSetLastApplyBeanModel*)model
{
    _model = model;
    [self addTitle:kSaftToNSString(model.applyDate) view:self.dateLabel front:YES];
    [self addTitle:kLocalized(@"不通过") view:self.resultLabel front:YES];
    //审批意见做换行处理
    self.remarkLabel.attributedText = [[NSAttributedString alloc] initWithString:kSaftToNSString(model.apprRemark) attributes:@{NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGray333333}];
}

- (void)addTitle:(NSString*)str view:(UILabel*)label front:(BOOL)isFront
{
    NSMutableParagraphStyle* style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    style.tailIndent = isFront ? 20 : -20;
    style.alignment = isFront ? NSTextAlignmentLeft : NSTextAlignmentRight;
    
    label.attributedText = [[NSAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGray333333, NSParagraphStyleAttributeName : style }];
}

- (void)addLineAll:(UIView*)view
{
    view.customBorderType = UIViewCustomBorderTypeAll;
    view.customBorderColor = kGrayCCCCCC;
    view.customBorderLineWidth = @1;
}

- (void)addLineLeftAndRight:(UIView*)view
{
    view.customBorderType = UIViewCustomBorderTypeLeft | UIViewCustomBorderTypeRight;
    view.customBorderColor = kGrayCCCCCC;
    view.customBorderLineWidth = @1;
}

@end
