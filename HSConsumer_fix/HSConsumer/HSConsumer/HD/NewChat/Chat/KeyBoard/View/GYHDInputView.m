//
//  GYHDInputView.m
//  HSConsumer
//
//  Created by shiang on 16/2/2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDInputView.h"
#import "GYHDMessageCenter.h"

#import "GYHDPhotoView.h"
#import "GYHDAudioView.h"
#import "GYHDVideoView.h"
#import "GYHDCameraView.h"
#import "GYHDEmojiView.h"
#import "GYHDMessageTextView.h"
#import "GYHDRecordVideoTool.h"

#import <AVFoundation/AVFoundation.h>

#import "EmojiTextAttachment.h"
//#import "GYHDPopAudioView.h"

@interface GYHDInputView () <UITextViewDelegate, GYHDKeyboardSelectBaseViewDelegate, GYHDEmojiViewDelegate, UIAlertViewDelegate>
/**消息输入*/
@property (nonatomic, weak) GYHDMessageTextView* messageTextView;
/**发送按钮*/
//@property(nonatomic, weak)UIButton *sendButton;
/**录音按钮*/
@property (nonatomic, weak) UIButton* audioButton;
/**录像按钮*/
@property (nonatomic, weak) UIButton* videoButton;
/**相册按钮*/
@property (nonatomic, weak) UIButton* photoButton;
/**相机按钮*/
@property (nonatomic, weak) UIButton* cameraButton;
/**GPS定位图片按钮*/
@property (nonatomic, weak) UIButton* GPSButton;
/**表情按钮*/
@property (nonatomic, weak) UIButton* emojiButton;
/**选中的按钮*/
@property (nonatomic, weak) UIButton* selectedButton;
/**录音展示*/
@property (nonatomic, weak) UIView* showChildView;
/**录音view*/
@property (nonatomic, weak) UIImageView* startImageView;
/**等待字符串*/
@property (nonatomic, weak) UILabel* placeholderLabel;
/**父View*/
@property (nonatomic, weak) UIView* mySuperView;
@end

@implementation GYHDInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc
{

    [self.messageTextView removeObserver:self forKeyPath:@"attributedText"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**界面基本布局*/
- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disMiss) name:UIKeyboardWillHideNotification object:nil];
    self.backgroundColor = [UIColor whiteColor];

    // 发送
    WS(weakSelf);
    CGFloat WH = (kScreenWidth) / 6;
    //显示View
    UIView* showView = [[UIView alloc] init];
    [self addSubview:showView];
    _showChildView = showView;
    [showView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.right.left.mas_equalTo(0);
        make.height.mas_equalTo(211);
    }];

    UIView* grayLineView1 = [[UIView alloc] init];
    grayLineView1.backgroundColor = [UIColor colorWithRed:204 / 255.0f green:204 / 255.0f blue:204 / 255.0f alpha:1];
    [self addSubview:grayLineView1];
    [grayLineView1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(showView.mas_top);
    }];

    // 音频
    UIButton* audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [audioButton setImage:[UIImage imageNamed:@"gyhd_audio_btn_normal"] forState:UIControlStateNormal];
    [audioButton setImage:[UIImage imageNamed:@"gyhd_audio_btn_selected"] forState:UIControlStateSelected];
    [audioButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:audioButton];
    _audioButton = audioButton;
    [audioButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(WH, WH));
        make.bottom.equalTo(showView.mas_top);
    }];

    // 录像
    UIButton* videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoButton setImage:[UIImage imageNamed:@"gyhd_video_btn_normal"] forState:UIControlStateNormal];
    [videoButton setImage:[UIImage imageNamed:@"gyhd_video_btn_selected"] forState:UIControlStateHighlighted];
    [videoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:videoButton];
    _videoButton = videoButton;
    [videoButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.width.height.equalTo(audioButton);
        make.left.equalTo(audioButton.mas_right);
    }];

    // 相册
    UIButton* photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setImage:[UIImage imageNamed:@"gyhd_photo_btn_normal"] forState:UIControlStateNormal];
    [photoButton setImage:[UIImage imageNamed:@"gyhd_photo_btn_selected"] forState:UIControlStateSelected];
    [photoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:photoButton];
    _photoButton = photoButton;
    [photoButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.width.height.equalTo(audioButton);
        make.left.equalTo(videoButton.mas_right);
    }];
    // 相机
    UIButton* cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setImage:[UIImage imageNamed:@"gyhd_camera_btn_normal"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"gyhd_camera_btn_selected"] forState:UIControlStateHighlighted];
    [cameraButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cameraButton];
    _cameraButton = cameraButton;
    [cameraButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.width.height.equalTo(audioButton);
        make.left.equalTo(photoButton.mas_right);
    }];
    // 定位
//        UIButton *GPSButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [GPSButton setImage:[UIImage imageNamed:@"gyhd_Gps_btn_normal"] forState:UIControlStateNormal];
//        [GPSButton setImage:[UIImage imageNamed:@"gyhd_Gps_btn_selected"] forState:UIControlStateSelected];
//        [GPSButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:GPSButton];
//        _GPSButton = GPSButton;
//        [GPSButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.width.height.equalTo(audioButton);
//            make.left.equalTo(cameraButton.mas_right);
//        }];
    // 表情
    UIButton* emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiButton setImage:[UIImage imageNamed:@"gyhd_emoji_btn_normal"] forState:UIControlStateNormal];
    [emojiButton setImage:[UIImage imageNamed:@"gyhd_emoji_btn_selected"] forState:UIControlStateSelected];
    [emojiButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:emojiButton];
    _emojiButton = emojiButton;
    [emojiButton mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.top.width.height.equalTo(audioButton);
//        make.left.equalTo(GPSButton.mas_right);
        make.top.width.height.equalTo(audioButton);
        make.left.equalTo(cameraButton.mas_right);
    }];
    UIView* redLineView = [[UIView alloc] init];
    redLineView.backgroundColor = [UIColor colorWithRed:238 / 255.0f green:100 / 255.0f blue:88 / 255.0f alpha:1];
    [self addSubview:redLineView];
    [redLineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(audioButton.mas_top);
    }];
    // 输入条
    GYHDMessageTextView* messageTextView = [[GYHDMessageTextView alloc] init];

    messageTextView.delegate = self;
    [self addSubview:messageTextView];

    [messageTextView addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:nil];
    _messageTextView = messageTextView;
    [messageTextView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(redLineView.mas_top);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);

    }];

    UILabel* placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = [GYUtils localizedStringWithKey:@"GYHD_please_enter_text"];
    placeholderLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
    placeholderLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
    [self addSubview:placeholderLabel];
    _placeholderLabel = placeholderLabel;
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.bottom.right.equalTo(messageTextView);
        make.left.equalTo(messageTextView).offset(2);
    }];

    UIView* grayLineView = [[UIView alloc] init];
    grayLineView.backgroundColor = [UIColor colorWithRed:204 / 255.0f green:204 / 255.0f blue:204 / 255.0f alpha:1];
    [self addSubview:grayLineView];
    [grayLineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.equalTo(weakSelf.mas_top);
    }];
}

- (void)buttonClick:(UIButton*)button
{

    if ([self.selectedButton isEqual:button] && ![button isEqual:self.videoButton] && ![button isEqual:self.cameraButton] && ![button isEqual:self.GPSButton]) {
        self.selectedButton.selected = NO;
        self.selectedButton = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [UIView animateWithDuration:0.25 animations:^{
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(211);
                }];
                [self.mySuperView layoutIfNeeded];
            }];

        });
    }
    else {

        if (![button isEqual:self.videoButton] && ![button isEqual:self.cameraButton] && ![button isEqual:self.GPSButton]) {
            self.selectedButton.selected = NO;
            button.selected = YES;
            self.selectedButton = button;
        }
        if ([button isEqual:self.audioButton]) { // 录音

            __block BOOL audioState = YES;
            AVAudioSession* session = [AVAudioSession sharedInstance];
            if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
                [session requestRecordPermission:^(BOOL available) {
                    if (!available) {
                        audioState = NO;
                    }
                }];
            }
            if (audioState) {
                for (UIView* childView in self.showChildView.subviews) {
                    [childView removeFromSuperview];
                }
                GYHDAudioView* audioView = [[GYHDAudioView alloc] init];
                audioView.delegate = self;
                [self.showChildView addSubview:audioView];
                [audioView mas_makeConstraints:^(MASConstraintMaker* make) {
                    make.top.left.bottom.right.mas_equalTo(0);
                }];
                [self showBottomView];
            }
            else {
                NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                if (appName == nil) {
                    appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
                }
                [[[UIAlertView alloc] initWithTitle:[GYUtils localizedStringWithKey:@"GYHD_Chat_Not_record"] message:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Chat_Not_record_tips"], appName] delegate:nil cancelButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_confirm"] otherButtonTitles:nil] show];
            }
        }
        else if ([button isEqual:self.videoButton]) { // 录像

            __block BOOL audioState = YES;
            AVAudioSession* session = [AVAudioSession sharedInstance];
            if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
                [session requestRecordPermission:^(BOOL available) {
                    if (!available) {
                        audioState = NO;
                    }
                }];
            }

            if ([GYHDRecordVideoTool CameraAvailable] && audioState) {
                GYHDVideoView* videoView = [[GYHDVideoView alloc] init];
                videoView.delegate = self;
                [videoView show];
            }
            else {
                NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                if (appName == nil) {
                    appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
                };
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message: [GYUtils localizedStringWithKey:@"GYHD_setPrivacyCamera"] delegate:self cancelButtonTitle: [GYUtils localizedStringWithKey:@"GYHD_confirm"] otherButtonTitles:nil];

                [alert show];
            }
        }
        else if ([button isEqual:self.photoButton]) {

            if ([GYHDRecordVideoTool CameraAvailable]) {

                for (UIView* childView in self.showChildView.subviews) {
                    [childView removeFromSuperview];
                }

                GYHDPhotoView* photoView = [[GYHDPhotoView alloc] init];
                photoView.delegate = self;
                [self.showChildView addSubview:photoView];
                [photoView mas_makeConstraints:^(MASConstraintMaker* make) {
                    make.top.left.bottom.right.mas_equalTo(0);
                }];
                [self showBottomView];
            }
            else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message: [GYUtils localizedStringWithKey:@"GYHD_setPrivacyPhoto"] delegate:self cancelButtonTitle: [GYUtils localizedStringWithKey:@"GYHD_confirm"] otherButtonTitles:nil];
                [alert show];
            }
        }
        else if ([button isEqual:self.cameraButton]) {
            if ([GYHDRecordVideoTool CameraAvailable]) {
                GYHDCameraView* cameraView = [[GYHDCameraView alloc] init];
                cameraView.delegate = self;
                [cameraView show];
            }
            else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message: [GYUtils localizedStringWithKey:@"GYHD_setPrivacyCamera"] delegate:nil cancelButtonTitle: [GYUtils localizedStringWithKey:@"GYHD_confirm"] otherButtonTitles:nil];
                alert.delegate = self;
                [alert show];
            }
        }
        else if ([button isEqual:self.GPSButton]) {
//            GYHDGPSView *gpsView = [[GYHDGPSView alloc] init];
//            if ([self.delegate respondsToSelector:@selector(GYHDInputView:sendDict:SendType:)]) {
//                [self.delegate GYHDInputView:self sendDict:nil SendType:GYHDInputeViewSendGPS];
//            }
        }
        else if ([button isEqual:self.emojiButton]) {

            for (UIView* childView in self.showChildView.subviews) {
                [childView removeFromSuperview];
            }
            GYHDEmojiView* emojiView = [[GYHDEmojiView alloc] init];
            emojiView.delegate = self;
            [self.showChildView addSubview:emojiView];
            [emojiView mas_makeConstraints:^(MASConstraintMaker* make) {
                make.top.left.bottom.right.mas_equalTo(0);
            }];
            [self showBottomView];
        }
    }
    [self.messageTextView endEditing:YES];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSURL *url = [NSURL URLWithString:@"prefs:root=privacy"];
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
//    }
//
//}

- (void)showToSuperView:(UIView*)mySuperView
{
    _mySuperView = mySuperView;
    [self mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(mySuperView);
        make.bottom.mas_equalTo(211);
    }];
}

- (void)showBottomView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
            [self.mySuperView layoutIfNeeded];
        }];

    });
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"attributedText"]) {
        self.messageTextView.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
        if (self.messageTextView.contentSize.height > 80) {
            [self messageTextViewYesEnabled];
        }
        else {
            [self messageTextViewNoEnabled];
        }

        if (self.messageTextView.attributedText.length) {
            _placeholderLabel.hidden = YES;
        }
        else {
            _placeholderLabel.hidden = NO;
        }
        if (self.messageTextView.text == nil || [self.messageTextView.text isEqualToString:@""]) {
            [self messageTextViewNoEnabled];
        }
        [self.messageTextView scrollRangeToVisible:NSMakeRange(self.messageTextView.text.length, 1)];
    }
}

- (void)textViewDidChange:(UITextView*)textView
{
    self.messageTextView.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
    if (self.messageTextView.contentSize.height > 80) {
        [self messageTextViewYesEnabled];
    }
    else {
        [self messageTextViewNoEnabled];
    }
    if (![textView.text isEqualToString:@""]) {
        _placeholderLabel.hidden = YES;
    }
    else {
        _placeholderLabel.hidden = NO;
    }
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [self messageTextViewNoEnabled];
        [self sendMessage];
        return NO;
    }
    return YES;
}

- (void)keyboardWillChangeFrame:(NSNotification*)notification
{
    NSDictionary* userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 执行动画
    CGFloat height = 211 - keyboardF.size.height;
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (height > self.mySuperView.frame.size.height) { // 键盘的Y值已经远远超过了控制器view的高度
            // 隐藏键盘
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(211);
            }];
        } else {
            // 显示键盘
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(height);
            }];
        }
        [self.mySuperView layoutIfNeeded];
    }];
}

/**
 * textview禁止滚动
 */
- (void)messageTextViewNoEnabled
{
    self.messageTextView.scrollEnabled = NO;
    WS(weakSelf);
    [UIView animateWithDuration:0.25f animations:^{
        [self.messageTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.audioButton.mas_top);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
        }];
        [self layoutIfNeeded];
    }];
}

/**textView允许滚动*/
- (void)messageTextViewYesEnabled
{
    CGFloat textViewHeight = self.messageTextView.frame.size.height;
    self.messageTextView.scrollEnabled = YES;
    [self.messageTextView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(textViewHeight);
    }];
}

- (void)dismissKeyBoard
{
    self.selectedButton.selected = NO;
    self.selectedButton = nil;
    [self.messageTextView resignFirstResponder];
}

- (void)keyboardDidShow
{
    if (self.selectedButton) {
        self.selectedButton.selected = NO;
        self.selectedButton = nil;
    }
}

- (void)disMiss
{
    [self dismissKeyBoard];
    self.selectedButton.selected = NO;
    self.selectedButton = nil;
    [self.messageTextView resignFirstResponder];

    [UIView animateWithDuration:0.25f animations:^{

        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(211);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)sendMessage
{

    NSString* message = [[GYHDMessageCenter sharedInstance] stringWithAttString:self.messageTextView.attributedText];
    NSMutableDictionary* imageDict = [NSMutableDictionary dictionary];
    if ([message isEqualToString:@""] || message == nil) {
        return;
    }
    imageDict[@"string"] = message;
    if ([self.delegate respondsToSelector:@selector(GYHDInputView:sendDict:SendType:)]) {
        [self.delegate GYHDInputView:self sendDict:imageDict SendType:GYHDInputeViewSendText];
    }
    self.messageTextView.text = nil;
}

#pragma mark Delegate;
- (void)GYHDKeyboardSelectBaseView:(GYHDKeyboardSelectBaseView*)view sendDict:(NSDictionary*)dict SendType:(GYHDKeyboardSelectBaseSendOption)type
{
    if ([self.delegate respondsToSelector:@selector(GYHDInputView:sendDict:SendType:)]) {
        switch (type) {
        case GYHDKeyboardSelectBaseSendText:

            break;
        case GYHDKeyboardSelectBaseSendAudio:
            [self.delegate GYHDInputView:self sendDict:dict SendType:GYHDInputeViewSendAudio];

            break;
        case GYHDKeyboardSelectBaseSendVideo:
            [self.delegate GYHDInputView:self sendDict:dict SendType:GYHDInputeViewSendVideo];

            break;
        case GYHDKeyboardSelectBaseSendPhoto:
            [self.delegate GYHDInputView:self sendDict:dict SendType:GYHDInputeViewSendPhoto];

            break;
        default:
            break;
        }
    }
}

- (void)GYHDEmojiView:(GYHDEmojiView*)emojiView selectEmojiName:(NSString*)emojiName
{
    UIImage* image = [UIImage imageNamed:emojiName];
    if (!image)
        return;
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.messageTextView.attributedText];
    NSRange selectRange = self.messageTextView.selectedRange;
    if ([emojiName isEqualToString:@"del"]) {
        if (!selectRange.location)
            return;
        CGFloat location = selectRange.location - 1;

        [attr deleteCharactersInRange:NSMakeRange(location, 1)];
        selectRange = NSMakeRange(selectRange.location - 1, selectRange.length);
    }
    else {
    
            selectRange = NSMakeRange(selectRange.location + 1, selectRange.length);
    
            EmojiTextAttachment *imageMent = [[EmojiTextAttachment alloc] init];
            imageMent.image = image;
            //坑爹，emojiName和UIImage imageWithName方法中名称差个中括号
            //            imageMent.emojiName =emojiName;
    
            imageMent.emojiName = [NSString stringWithFormat:@"[%@]", emojiName];
    
            //    imageMent.emojiSize=CGSizeMake(25, 25);
    
            NSAttributedString *imageAttr =
            [NSAttributedString attributedStringWithAttachment:imageMent];
    
            [attr insertAttributedString:imageAttr
                                 atIndex:self.messageTextView.selectedRange.location];

//        selectRange = NSMakeRange(selectRange.location + 1, selectRange.length);
//        NSTextAttachment* imageMent = [[NSTextAttachment alloc] init];
//        imageMent.image = image;
//        imageMent.bounds = CGRectMake(0, -1, KFontSizePX(32.0f), KFontSizePX(32.0f));
//        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:imageMent];
//        [attr insertAttributedString:imageAttr atIndex:self.messageTextView.selectedRange.location];
    }
    self.messageTextView.attributedText = attr;
    self.messageTextView.selectedRange = selectRange;
}

- (void)GYHDemojiVIewSendMessage {
    [self sendMessage];
}

@end