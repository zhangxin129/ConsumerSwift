//
//  GYHSPointPassInputView.m
//
//  Created by apple on 16/8/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointPassInputView.h"
#define kPassFeildHeigt 35
#define kImageSize 26
@interface GYHSPointPassInputView ()
@property (nonatomic, assign) kPasswordType type;
@end
@implementation GYHSPointPassInputView
- (instancetype)initWithFrame:(CGRect)frame type:(kPasswordType)type
{
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        [self setUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    UITextField* passField = [[UITextField alloc] initWithFrame:self.bounds];
    passField.keyboardType = UIKeyboardTypeNumberPad;
    passField.secureTextEntry = YES;
    passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passField.textAlignment = NSTextAlignmentCenter;
    passField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    NSString* string;
    switch (self.type) {
    case kPasswordTrade:
        string = kLocalized(@"GYHS_Point_Consume_Input_Trade_Passwd");
        break;
    case kPasswordLogin:
        string = kLocalized(@"GYHS_Point_Consume_Input_Login_Password");
        break;
    default:
        break;
    }
    NSMutableAttributedString* placeholder = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kRedE40011 }];
    UIImage* image = [UIImage imageNamed:@"comman_inputPasswordsIcon"];
    NSTextAttachment* imageMent = [[NSTextAttachment alloc] init];
    imageMent.image = image;
    imageMent.bounds = CGRectMake(10, -8, image.size.width, image.size.height);
    NSAttributedString* imageAttr =
        [NSAttributedString attributedStringWithAttachment:imageMent];
    [placeholder appendAttributedString:imageAttr];
    passField.attributedPlaceholder = placeholder;
    [self addSubview:passField];
    self.passField = passField;
}

@end
