//
//  GYSetingSafeSetInputViewCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSetingSafeSetInputViewCell.h"
#import <GYKit/GYPlaceholderTextView.h>

@interface GYSetingSafeSetInputViewCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet GYPlaceholderTextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation GYSetingSafeSetInputViewCell

- (void)awakeFromNib {
    
    self.titleLabel.textColor = kGray333333;
    
    NSString *str = kLocalized(@"GYSetting_Set_Trade_Password_Reset_Tip");
    NSRange range1 = [str rangeOfString:kLocalized(@"GYSetting_Set_Tip") options:NSCaseInsensitiveSearch];
    NSRange range2 = [str rangeOfString:@"《互生系统平台业务办理申请书》" options:NSBackwardsSearch];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:kFont28,NSForegroundColorAttributeName:kGray333333}];
    [text setAttributes:@{NSFontAttributeName:kFont28,NSForegroundColorAttributeName:kRedE50012} range:range1];
    [text setAttributes:@{NSFontAttributeName:kFont28,NSForegroundColorAttributeName:kRedE50012} range:range2];
    self.tipLabel.attributedText = text;
    
    self.textView.delegate = self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.textView.customBorderLineWidth = @1;
    self.textView.customBorderType = UIViewCustomBorderTypeAll;
    self.textView.customBorderColor = kGrayE3E3EA;
    self.textView.placeholder = kLocalized(@"输入说明，最长不超过300个字");
}

-(NSString *)content {
    return _textView.text;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *textString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (textString.length > 300) {
        textView.text = [textString substringToIndex:300];
        return NO;
    }
    return YES;
}

@end
