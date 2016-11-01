//
//  GYHSRealApplyView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSRealApplyView.h"
#import "GYHSCustomedDraw.h"
#import "GYHSIdentifyCode.h"
#import <GYKit/GYPlaceholderTextView.h>
#import "GYHSCunsumeTextField.h"
#define kImageWidth kDeviceProportion(220)
#define kImageHeight kDeviceProportion(160)
#define kTopHeight kDeviceProportion(40)
#define kDistance kDeviceProportion(10)
#define kCodeWith kDeviceProportion(80)
#define kMidDistance 48
#define kCommonHeight 30

@interface GYHSRealApplyView () <UIActionSheetDelegate>
@property (nonatomic, weak) UIImageView* imageView;

@end
@implementation GYHSRealApplyView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kTopHeight, kImageWidth, kImageHeight)];
    imageView.centerX = self.width / 2;
    imageView.image = [UIImage imageNamed:@"gyhs_image_upload"];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [imageView addGestureRecognizer:tap];
    self.imageView = imageView;
    
    CGFloat labelWidth = 180;
    CGFloat labelHeight = 50;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), labelWidth, labelHeight)];
    label.centerX = self.width / 2;
    label.text = kLocalized(@"GYHS_Myhs_Business_License_Scan");
    label.font = kFont32;
    label.textColor = kGray333333;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    CGFloat buttonWidth = 90;
    CGFloat buttonHeight = 25;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + kDistance, buttonWidth, buttonHeight);
    button.centerX = self.width / 2;
    [button setBackgroundImage:[UIImage imageNamed:@"gyhs_example_icon"] forState:UIControlStateNormal];
    [button setTitleColor:kWhiteFFFFFF forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showBigPic:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    CGFloat textWidth = 450;
    CGFloat textHeith = 90;
    GYPlaceholderTextView* textView = [[GYPlaceholderTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + kMidDistance, textWidth, textHeith)];
    textView.placeholder = kLocalized(@"GYHS_Myhs_Input_Authen_Max_Tip");
    textView.layer.borderColor = UIColor.grayColor.CGColor;
    textView.layer.borderWidth = 1;
    textView.centerX = self.width / 2;
    [self addSubview:textView];
    self.textView = textView;
    
    CGFloat reasonWidth = 120;
    UILabel* reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(textView.frame) - 14 - reasonWidth, CGRectGetMinY(textView.frame) + kDistance, reasonWidth, kCommonHeight)];
    reasonLabel.text = kLocalized(@"GYHS_Myhs_Certifice_Comments_Colon");
    reasonLabel.font = kFont32;
    reasonLabel.textColor = kGray333333;
    reasonLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:reasonLabel];
    
    //输入验证码
    CGFloat inputWidth = 150;
    CGFloat inputHeith = 50;
    GYHSCunsumeTextField* inputCodeField = [[GYHSCunsumeTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textView.frame), CGRectGetMaxY(self.textView.frame) + 20, inputWidth, inputHeith)];
    inputCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputCodeField.layer.borderColor = UIColor.grayColor.CGColor;
    inputCodeField.layer.borderWidth = 1;
    inputCodeField.placeholder = kLocalized(@"GYHS_Myhs_Input_Code");
    [self addSubview:inputCodeField];
    self.inputCodeField = inputCodeField;
    
    CGFloat verWidth = 120;
    UILabel* verLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(inputCodeField.frame) - 14 - verWidth, CGRectGetMinY(inputCodeField.frame) + kDistance, verWidth, kCommonHeight)];
    verLabel.text = kLocalized(@"GYHS_Myhs_Code_Colon");
    verLabel.font = kFont32;
    verLabel.textColor = kGray333333;
    verLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:verLabel];
    
    GYHSIdentifyCode* codeView = [[GYHSIdentifyCode alloc] initWithFrame:CGRectMake(CGRectGetMaxX(inputCodeField.frame) + 14, CGRectGetMinY(inputCodeField.frame) + kDistance, kCodeWith, kCommonHeight)];
    self.codeString = codeView.authCodeStr;
    [self addSubview:codeView];
    self.codeView = codeView;
    
    UIButton* refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(CGRectGetMaxX(self.codeView.frame) + kDistance, CGRectGetMinY(self.codeView.frame), 28, kCommonHeight);
    [refreshBtn setImage:[UIImage imageNamed:@"gyhs_refresh_code"] forState:UIControlStateNormal];
    refreshBtn.adjustsImageWhenHighlighted = NO;
    [refreshBtn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refreshBtn];
}

- (void)showBigPic:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(showBigPicture:)]) {
        [self.delegate showBigPicture:sender];
    }

}
- (void)refresh:(UIButton*)button
{
    [GYHSCustomedDraw setRoateWithhLayer:button];
    [self.codeView getAuthcode];
    self.codeString = self.codeView.authCodeStr;
}
- (void)showImage:(UIImage*)image
{
    if (image) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.image = image;
    }
}

- (void)touch
{
//    UIActionSheet* acUpLoad = [[UIActionSheet alloc] initWithTitle:kLocalized(@"GYHS_Myhs_Select_Photo")
//                                                          delegate:self
//                                                 cancelButtonTitle:kLocalized(@"GYHS_Myhs_Cancel")
//                                            destructiveButtonTitle:nil
//                                                 otherButtonTitles:kLocalized(@"GYHS_Myhs_Select_Album"),
//                                                 kLocalized(@"GYHS_Myhs_Take_Photo"), nil];
//    [acUpLoad showInView:self];
    if (_delegate && [_delegate respondsToSelector:@selector(viewControllerWithPictureAndCamera)]) {
        [_delegate viewControllerWithPictureAndCamera];
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_delegate && [_delegate respondsToSelector:@selector(actionPictureWithIndex:)]) {
        [_delegate actionPictureWithIndex:buttonIndex];
    }
}

- (void)layoutSubviews
{
     [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeAll;
}


@end
