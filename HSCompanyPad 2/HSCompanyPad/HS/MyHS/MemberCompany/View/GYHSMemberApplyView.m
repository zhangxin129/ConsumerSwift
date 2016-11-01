//
//  GYHSMemberApplyView.m
//
//  Created by apple on 16/8/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMemberApplyView.h"
#import "GYHSPublicMethod.h"
#import <GYKit/GYPlaceholderTextView.h>

#define kImageWidth kDeviceProportion(220)
#define kImageHeight kDeviceProportion(160)
#define kTopHeight kDeviceProportion(40)
#define kDistance kDeviceProportion(10)
#define kMidDistance 48

@interface GYHSMemberApplyView () <UIActionSheetDelegate>
@property (nonatomic, weak) UIImageView* imageView;
@end
@implementation GYHSMemberApplyView
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
    label.text = kLocalized(@"GYHS_Myhs_Bussiness_Apply");
    label.font = kFont32;
    label.textColor = kGray333333;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    CGFloat buttonWidth = 90;
    CGFloat buttonHeight = 25;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + kDistance, buttonWidth, buttonHeight);
    button.centerX = self.width / 2;
    [button setBackgroundImage:[UIImage imageNamed:@"gyhs_download"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(upLoadPicture:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:kWhiteFFFFFF forState:UIControlStateNormal];
    [self addSubview:button];
    
    CGFloat textWidth = 450;
    CGFloat textHeith = 90;
    GYPlaceholderTextView* textView = [[GYPlaceholderTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + kMidDistance, textWidth, textHeith)];
    textView.placeholder = kLocalized(@"GYHS_Myhs_Input_Reason_Max_Tip");
    textView.layer.borderColor = UIColor.grayColor.CGColor;
    textView.layer.borderWidth = 1;
    textView.centerX = self.width / 2;
    [self addSubview:textView];
    self.textView = textView;
    
    CGFloat reasonWidth = 120;
    CGFloat reasonHeight = 30;
    UILabel* reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(textView.frame) - 14 - reasonWidth, CGRectGetMinY(textView.frame) + kDistance, reasonWidth, reasonHeight)];
    reasonLabel.text = kLocalized(@"GYHS_Myhs_Apply_Reason_Colon");
    reasonLabel.font = kFont32;
    reasonLabel.textColor = kGray333333;
    reasonLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:reasonLabel];
}

#pragma mark - 下载模板
- (void)upLoadPicture:(UIButton *)btn {

    if ([self.delegate respondsToSelector:@selector(applyViewDidClickDownLoadButton:)]) {
        [self.delegate applyViewDidClickDownLoadButton:btn];
    }


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
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheetWithIndex:)]) {
        [_delegate actionSheetWithIndex:buttonIndex];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeAll;
}

@end
