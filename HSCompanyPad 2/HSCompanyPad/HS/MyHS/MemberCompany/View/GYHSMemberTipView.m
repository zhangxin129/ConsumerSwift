//
//  GYHSMemberTipView.m
//
//  Created by apple on 16/8/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMemberTipView.h"
#define kTopHeight kDeviceProportion(45)
#define kLeftWidth kDeviceProportion(80)
#define kheadIndent 25
#define kLineSpace 10
@interface GYHSMemberTipView ()
@property (nonatomic, strong) NSMutableAttributedString* tipMessage;
@property (nonatomic, assign) kMyhsTipType tipType;
@property (nonatomic, strong)  UILabel* label;
@end
@implementation GYHSMemberTipView

- (instancetype)initWithFrame:(CGRect)frame tipType:(kMyhsTipType)tipType
{
    if (self = [super initWithFrame:frame]) {
        self.tipType = tipType;
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scroll];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(kLeftWidth, kTopHeight, scroll.width - kLeftWidth, 30)];
    label.numberOfLines = 0;
//    label.font = kFont36;
    label.attributedText = self.tipMessage;
    CGRect rect = [self.tipMessage boundingRectWithSize:CGSizeMake(label.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    label.size = rect.size;
    [scroll addSubview:label];
    self.label = label;
    scroll.contentSize = CGSizeMake(0, CGRectGetMaxY(label.frame));
}

#pragma mark - load
- (NSMutableAttributedString*)tipMessage
{
    if (_tipMessage == nil) {
        switch (self.tipType) {
        case kMyhsTipMemberCancel:
            [self memberCompanyTip];
            break;
        case kMyhsTipJoinPointActivity:
            [self joinPointActivityTip];
            break;
        case kMyhsTipStopPointActivity:
            [self stopPointActivityTip];
            break;
        default:
            break;
        }
    }
    return _tipMessage;
}

#pragma mark - 成员企业资格注销
- (void)memberCompanyTip
{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:kLineSpace]; //调整行间距
    style.headIndent = kheadIndent;
    NSString* str = kLocalized(@"GYHS_Myhs_Tips_Colon");
    NSString* str1 = kLocalized(@"GYHS_Myhs_Member_Tip1");
    NSString* str2 = kLocalized(@"GYHS_Myhs_Member_Tip2");
    NSString* str3 = kLocalized(@"GYHS_Myhs_Member_Tip3");
    NSString* str4 = kLocalized(@"GYHS_Myhs_Member_Tip4");
    NSString* str5 = kLocalized(@"GYHS_Myhs_Member_Tip5");
    NSString* str6 = kLocalized(@"GYHS_Myhs_Member_Tip6");
    NSString* str7 = kLocalized(@"GYHS_Myhs_Member_Tip7");
    NSString* tipString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@", str, str1, str2, str3, str4, str5, str6, str7];
    self.label.text = tipString;
    _tipMessage = [[NSMutableAttributedString alloc] initWithString:tipString attributes:@{ NSFontAttributeName : kFont36, NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : kGray333333 }];
    [tipString enumerateSubstringsInRange:NSMakeRange(0,tipString.length) options:NSStringEnumerationByParagraphs usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSRange range = [substring rangeOfString:@"＊"];
        if (range.location != NSNotFound ) {
            [_tipMessage setAttributes:@{NSForegroundColorAttributeName:kRedE40011,NSFontAttributeName : kFont32,NSParagraphStyleAttributeName : style} range:NSMakeRange(substringRange.location,range.length)];
        }
        
    }];
}

#pragma mark - 参与积分活动
- (void)joinPointActivityTip
{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:kLineSpace]; //调整行间距
    style.headIndent = kheadIndent;
    NSString* str = kLocalized(@"GYHS_Myhs_Tips_Colon");
    NSString* str1 = kLocalized(@"GYHS_Myhs_Join_Tip1");
    NSString* str2 = kLocalized(@"GYHS_Myhs_Join_Tip2");
    NSString* str3 = kLocalized(@"GYHS_Myhs_Join_Tip3");
    NSString* tipString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", str, str1, str2, str3];
    _tipMessage = [[NSMutableAttributedString alloc] initWithString:tipString attributes:@{ NSFontAttributeName : kFont36, NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : kGray333333 }];
    [tipString enumerateSubstringsInRange:NSMakeRange(0,tipString.length) options:NSStringEnumerationByParagraphs usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSRange range = [substring rangeOfString:@"＊"];
        if (range.location != NSNotFound ) {
            [_tipMessage addAttribute:NSForegroundColorAttributeName value:kRedE40011 range:NSMakeRange(substringRange.location,range.length)];
        }
        
    }];

}

#pragma mark - 停止积分活动
- (void)stopPointActivityTip
{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:kLineSpace]; //调整行间距
    style.headIndent = kheadIndent;
    NSString* str = kLocalized(@"GYHS_Myhs_Tips_Colon");
    NSString * str1 = kLocalized(@"GYHS_Myhs_Stop_Tip1");
    NSString * str2 = kLocalized(@"GYHS_Myhs_Stop_Tip2");
    NSString * str3 = kLocalized(@"GYHS_Myhs_Stop_Tip3");
    NSString * str4 = kLocalized(@"GYHS_Myhs_Stop_Tip4");
    NSString * str5 = kLocalized(@"GYHS_Myhs_Stop_Tip5");
    NSString * tipString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",str,str1,str2,str3,str4,str5];
    _tipMessage = [[NSMutableAttributedString alloc] initWithString:tipString attributes:@{NSFontAttributeName:kFont36, NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:kGray333333}];
    [tipString enumerateSubstringsInRange:NSMakeRange(0,tipString.length) options:NSStringEnumerationByParagraphs usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSRange range = [substring rangeOfString:@"＊"];
        if (range.location != NSNotFound ) {
            [_tipMessage addAttribute:NSForegroundColorAttributeName value:kRedE40011 range:NSMakeRange(substringRange.location,range.length)];
        }
     
    }];

}
- (void)layoutSubviews
{
     [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeAll;
}
@end
