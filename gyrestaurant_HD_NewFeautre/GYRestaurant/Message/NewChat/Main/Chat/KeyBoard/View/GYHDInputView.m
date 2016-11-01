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
#import "IQKeyboardManager.h"
#import "GYHDPhotoView.h"
#import "GYHDAudioView.h"
#import "GYHDVideoView.h"
#import "GYHDCameraView.h"
#import "GYHDEmojiView.h"
#import "GYHDMessageTextView.h"
#import "GYHDRecordVideoTool.h"
#import "GYHDPhotoModel.h"
#import "GYHDQucikView.h"
//#import "GYHDPopAudioView.h"
#import "EmojiTextAttachment.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
@interface GYHDInputView()<UITextViewDelegate,GYHDKeyboardSelectBaseViewDelegate,GYHDEmojiViewDelegate,GYHDQucikViewDelegate>
/**消息输入*/
@property(nonatomic, weak)GYHDMessageTextView *messageTextView;
/**发送按钮*/
@property(nonatomic, weak)UIButton *sendBtn;
/**录音按钮*/
@property(nonatomic, weak)UIButton *audioButton;
/**录像按钮*/
@property(nonatomic, weak)UIButton *videoButton;
/**相册按钮*/
@property(nonatomic, weak)UIButton *photoButton;
/**相机按钮*/
@property(nonatomic, weak)UIButton *cameraButton;
/**GPS定位图片按钮*/
@property(nonatomic, weak)UIButton *GPSButton;
/**表情按钮*/
@property(nonatomic, weak)UIButton *emojiButton;
/**快捷回复*/
@property(nonatomic,strong)UIButton*quickButton;
/**选中的按钮*/
@property(nonatomic, weak)UIButton *selectedButton;
/**录音展示*/
@property(nonatomic, weak)UIView *showChildView;
/**录音view*/
@property(nonatomic, weak)UIImageView *startImageView;
/**等待字符串*/
@property(nonatomic, weak)UILabel *placeholderLabel;
/**父View*/
@property(nonatomic, weak)UIView *mySuperView;
@property(nonatomic, assign)BOOL isSendProto;//是否发送图片
@property(nonatomic,strong)NSArray*potoArry;//图片数组
@property(nonatomic,assign)BOOL isoriginalPhoto;//是否发送原图

@end

@implementation GYHDInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    [self.messageTextView removeObserver:self forKeyPath:@"attributedText"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**界面基本布局*/
- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    self.backgroundColor = [UIColor whiteColor];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    // 发送
    WS(weakSelf);
    CGFloat WH =  (kScreenWidth-350) / 15;
    //显示View
    UIView *showView = [[UIView alloc] init];
    [self addSubview:showView];
    _showChildView = showView;
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.mas_equalTo(0);
        make.height.mas_equalTo(211);
    }];
    
    UIView *grayLineView1 = [[UIView alloc] init];
    grayLineView1.backgroundColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
    [self addSubview:grayLineView1];
    [grayLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(showView.mas_top);
    }];
    
    // 音频
    UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [audioButton setBackgroundImage:[UIImage imageNamed:@"hd_audio_btn_normal"] forState:UIControlStateNormal];
    [audioButton setBackgroundImage:[UIImage imageNamed:@"btn-yy_2"] forState:UIControlStateSelected];
    [audioButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:audioButton];
    _audioButton = audioButton;
    [audioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(WH, WH));
        make.bottom.equalTo(showView.mas_top).offset(-10);
        make.left.mas_equalTo(16);
    }];
    
    // 录像
    UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoButton setBackgroundImage:[UIImage imageNamed:@"hd_video_btn_normal"] forState:UIControlStateNormal];
    [videoButton setBackgroundImage:[UIImage imageNamed:@"btn-sp-2"] forState:UIControlStateHighlighted];
    [videoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:videoButton];
    _videoButton = videoButton;
    [videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(audioButton);
        make.left.equalTo(audioButton.mas_right).offset(40);
    }];
    
    // 相册
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"hd_photo_btn_normal"] forState:UIControlStateNormal];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"btn-tp-2"] forState:UIControlStateSelected];
    [photoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:photoButton];
    _photoButton = photoButton;
    [photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(audioButton);
        make.left.equalTo(videoButton.mas_right).offset(40);
    }];
    // 相机
    UIButton *cameraButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"hd_camera_btn_normal"] forState:UIControlStateNormal];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"btn-ps-2"] forState:UIControlStateHighlighted];
    [cameraButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cameraButton];
    _cameraButton = cameraButton;
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(audioButton);
        make.left.equalTo(photoButton.mas_right).offset(40);
    }];
#warning 增加定位功能 暂时屏蔽
//    // 定位
//    UIButton *GPSButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [GPSButton setBackgroundImage:[UIImage imageNamed:@"hd_Gps_btn_normal"] forState:UIControlStateNormal];
//    [GPSButton setBackgroundImage:[UIImage imageNamed:@"btn-wz-2"] forState:UIControlStateSelected];
//    [GPSButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
//    [self addSubview:GPSButton];
//    _GPSButton = GPSButton;
//    [GPSButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.width.height.equalTo(audioButton);
//        make.left.equalTo(cameraButton.mas_right).offset(40);
//    }];
    // 表情
    UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiButton setBackgroundImage:[UIImage imageNamed:@"btn-bq-1"] forState:UIControlStateNormal];
    [emojiButton setBackgroundImage:[UIImage imageNamed:@"btn-bq-2"] forState:UIControlStateSelected];
    [emojiButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:emojiButton];
    _emojiButton = emojiButton;
    [emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(audioButton);
        make.left.equalTo(cameraButton.mas_right).offset(40);
    }];
#warning 增加快捷回复 暂时屏蔽
//    快捷回复
//    _quickButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_quickButton setBackgroundImage:[UIImage imageNamed:@"btn_kjhf_n"] forState:UIControlStateNormal];
//    [_quickButton setBackgroundImage:[UIImage imageNamed:@"btn_kjhf_h"] forState:UIControlStateSelected];
//    [_quickButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
//    [self addSubview:_quickButton];
//    [_quickButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.width.height.equalTo(audioButton);
//        make.left.equalTo(emojiButton.mas_right).offset(40);
//    }];
    
    
    UIView *redLineView = [[UIView alloc] init];
    redLineView.backgroundColor =[UIColor colorWithRed:0/255.0f green:166/255.0f blue:215/255.0f alpha:1];
    [self addSubview:redLineView];
    [redLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(audioButton.mas_top).offset(-10);
    }];
    // 输入条
    GYHDMessageTextView *messageTextView = [[GYHDMessageTextView alloc] init];

    messageTextView.delegate = self;
    [self addSubview:messageTextView];

    [messageTextView addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:nil];
    _messageTextView = messageTextView;
    [messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(redLineView.mas_top).offset(-15);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-60);
        make.top.mas_equalTo(5);
        
    }];

    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = [Utils localizedStringWithKey:@"请输入文字"];
    placeholderLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
    placeholderLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [self addSubview:placeholderLabel];
    _placeholderLabel = placeholderLabel;
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(messageTextView);
        make.left.equalTo(messageTextView);
    }];
    
    UIView *grayLineView = [[UIView alloc] init];
    grayLineView.backgroundColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
    grayLineView.hidden=YES;
    [self addSubview:grayLineView];
    [grayLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(1);
        make.top.equalTo(weakSelf.mas_top);
    }];
    
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"HD_sendBtn"] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];
        sendButton.hidden=YES;
        self.sendBtn=sendButton;
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(redLineView.mas_top).offset(-5);
            make.right.mas_equalTo(-12);
        }];

}

- (void)sendButton
{
    DDLogCInfo(@"发送按钮");
    
    if (!self.isSendProto) {
    
        [self sendMessage];
        
        return;
    }

  
    if (_isSendProto) {
        if (self.isoriginalPhoto) { // 原图发送
            for (GYHDPhotoModel *photo in self.potoArry) {
                        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
                        [assetLibrary assetForURL:photo.photoOriginalImageUrl resultBlock:^(ALAsset *asset)  {
                            
                            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                            
                             [self.delegate GYHDInputView:self sendDict:[self saveImageToBoxWithImage:image] SendType:GYHDInputeViewSendPhoto];
                            self.sendBtn.hidden=YES;
                            [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
                            [self disMiss];
                        }failureBlock:^(NSError *error) {
                            DDLogCInfo(@"error=%@",error);
                        }];
                    }
                }else {    // 缩略图发送
                    for (GYHDPhotoModel *photo in self.potoArry) {

                        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
                        [assetLibrary assetForURL:photo.photoOriginalImageUrl resultBlock:^(ALAsset *asset)  {
                            
                            UIImage *photoImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                            UIImage *image = nil;
                            if (photoImage.size.width >1080 || photoImage.size.height > 1080) {
                                image =  [Utils imageCompressForWidth:photoImage targetWidth:1080];
                            } else {
                                image = photoImage;
                            }
                            [self.delegate GYHDInputView:self sendDict:[self saveImageToBoxWithImage:image] SendType:GYHDInputeViewSendPhoto];
                            self.sendBtn.hidden=YES;
                            [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
                            [self disMiss];
                        }failureBlock:^(NSError *error) {
                            DDLogCInfo(@"error=%@",error);
                        }];
                }
        }
        
    }
    
}

/**保存图片到沙盒*/
- (NSDictionary *)saveImageToBoxWithImage:(UIImage *)image
{
    NSData *imageData = nil;
    if (UIImageJPEGRepresentation(image, 1)) {
        imageData = UIImageJPEGRepresentation(image, 1);
    } else {
        imageData = UIImagePNGRepresentation(image);
    }
    NSInteger timeNumber = arc4random_uniform(1000)+[[NSDate date] timeIntervalSince1970];
    NSString *imageName = [NSString stringWithFormat:@"originalImage%ld.jpg",timeNumber];
    NSString *imagePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] imagefolderNameString],imageName]];
    [imageData writeToFile:imagePath atomically:NO];
    
    UIImage *thumbnailsImage = [Utils imageCompressForWidth:image targetWidth:300];
    NSData *thumbnailsImageData = nil;
    if (UIImageJPEGRepresentation(thumbnailsImage, 1)) {
        thumbnailsImageData = UIImageJPEGRepresentation(thumbnailsImage, 1);
    }else {
        thumbnailsImageData = UIImagePNGRepresentation(thumbnailsImage);
    }
    
    NSString *thumbnailsImageName = [NSString stringWithFormat:@"thumbnailsImage%ld.jpg",timeNumber];
    NSString *thumbnailsImageNamePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] imagefolderNameString],thumbnailsImageName]];
    [thumbnailsImageData writeToFile:thumbnailsImageNamePath atomically:NO];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"originalName"] = imageName;
    dict[@"thumbnailsName"]= thumbnailsImageName;
    return dict;
    
}


- (void)buttonClick:(UIButton *)button
{
    self.sendBtn.hidden=YES;
    if ([self.selectedButton isEqual:button] &&
        ![button isEqual:self.videoButton]   &&
         ![button isEqual:self.cameraButton] ) {
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
    }else {
   
        if (![button isEqual:self.videoButton] &&
            ![button isEqual:self.cameraButton] ) {
            self.selectedButton.selected = NO;
            button.selected = YES;
            self.selectedButton = button;
        }
        if ([button isEqual:self.audioButton]) { // 录音
          __block BOOL audioSelect=YES;
            AVAudioSession *session = [AVAudioSession sharedInstance];
            if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
                [session requestRecordPermission:^(BOOL available) {
                    if (!available)
                    {
                        audioSelect=NO;
                    }
                }];
            }
            
            if (audioSelect) {
                
                for (UIView *childView in self.showChildView.subviews) {
                    [childView removeFromSuperview];
                }
                
                GYHDAudioView *audioView = [[GYHDAudioView alloc] init];
                audioView.delegate = self;
                [self.showChildView addSubview:audioView];
                [audioView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.bottom.right.mas_equalTo(0);
                }];
                [self showBottomView];
                
            }else{
            
                [[[UIAlertView alloc] initWithTitle:nil message:[Utils localizedStringWithKey:@"请在“设置-隐私-麦克风”选项中允许<< 互生系统>>访问你的麦克风"] delegate:nil cancelButtonTitle:[Utils localizedStringWithKey:@"确定"] otherButtonTitles:nil] show];
            
            }
           
        }else if ([button isEqual:self.videoButton]) { // 录像
            
            __block BOOL audioState = YES;
            AVAudioSession *session = [AVAudioSession sharedInstance];
            if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
                [session requestRecordPermission:^(BOOL available) {
                    if (!available) {
                        audioState = NO;
                    }
                }];
            }
            if ([GYHDRecordVideoTool CameraAvailable] && audioState) {
                GYHDVideoView *videoView = [[GYHDVideoView alloc] init];
                videoView.delegate = self;
                [videoView show];
            }else {
                NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                if (appName == nil) {
                    appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
                }
                ;
                [[[UIAlertView alloc] initWithTitle:nil message:[Utils localizedStringWithKey:@"请在“设置-隐私-相机”选项中允许<< 互生系统 >>访问你的相机和麦克风"] delegate:nil cancelButtonTitle:[Utils localizedStringWithKey:@"确定"] otherButtonTitles:nil] show];
            }
        }else if ([button isEqual:self.photoButton]) {

          
            
            if ([GYHDRecordVideoTool CameraAvailable]) {

                for (UIView *childView in self.showChildView.subviews) {
                    [childView removeFromSuperview];
                }
                
                GYHDPhotoView *photoView = [[GYHDPhotoView alloc] init];
                photoView.delegate = self;
                [self.showChildView addSubview:photoView];
                [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.bottom.right.mas_equalTo(0);
                }];
                [self showBottomView];
            }else {
                [[[UIAlertView alloc] initWithTitle:nil message:[Utils localizedStringWithKey:@"请在“设置-隐私-照片”选项中允许<< 互生系统 >>访问你的照片"] delegate:nil cancelButtonTitle:[Utils localizedStringWithKey:@"确定"] otherButtonTitles:nil] show];
            }
            

        }else if ([button isEqual:self.cameraButton]) {
            if ([GYHDRecordVideoTool CameraAvailable]) {
                GYHDCameraView *cameraView = [[GYHDCameraView alloc] init];
                cameraView.delegate = self;
//                 cameraView.transform=CGAffineTransformMakeRotation(M_PI/2);
                [cameraView show];
            }else {
                [[[UIAlertView alloc] initWithTitle:nil message:[Utils localizedStringWithKey:@"请在“设置-隐私-相机”选项中允许<< 互生系统 >>访问你的相机"] delegate:nil cancelButtonTitle:[Utils localizedStringWithKey:@"确定"] otherButtonTitles:nil] show];
            }
            
        }else if ([button isEqual:self.GPSButton]){

            if ([self.delegate respondsToSelector:@selector(GYHDInputView:sendDict:SendType:)]) {
                [self.delegate GYHDInputView:self sendDict:nil SendType:GYHDInputeViewSendGPS];
            }
            
            
        }else if ([button isEqual:self.emojiButton]) {

            for (UIView *childView in self.showChildView.subviews) {
                [childView removeFromSuperview];
            }
            GYHDEmojiView *emojiView = [[GYHDEmojiView alloc] init];
            emojiView.delegate = self;
            [self.showChildView addSubview:emojiView];
            [emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.right.mas_equalTo(0);
            }];
            [self showBottomView];
        }else if ([button isEqual:self.quickButton]) {
            
            for (UIView *childView in self.showChildView.subviews) {
                [childView removeFromSuperview];
            }
//            快捷回复视图
            GYHDQucikView *qucikView = [[GYHDQucikView alloc] init];
            qucikView.delegate = self;
            [self.showChildView addSubview:qucikView];
            [qucikView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.right.mas_equalTo(0);
            }];
            [self showBottomView];
        }

    }
    [self.messageTextView endEditing:YES];
}
- (void)showToSuperView:(UIView *)mySuperView
{
    _mySuperView = mySuperView;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
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
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"attributedText"])
    {
        self.messageTextView.font = [UIFont systemFontOfSize:KFontSizePX(40.0f)];
        if (self.messageTextView.contentSize.height > 100) {
            [self messageTextViewYesEnabled];
        } else {
            [self messageTextViewNoEnabled];
        }
        
        if (self.messageTextView.attributedText.length)
        {
            _placeholderLabel.hidden = YES;
            self.sendBtn.hidden=NO;
        }else {
            _placeholderLabel.hidden = NO;
            self.sendBtn.hidden=YES;
        }
        if (self.messageTextView.text == nil || [self.messageTextView.text isEqualToString:@""]) {
            [self messageTextViewNoEnabled];
        }
        [self.messageTextView scrollRangeToVisible:NSMakeRange(self.messageTextView.text.length, 1)];
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    self.messageTextView.font = [UIFont systemFontOfSize:KFontSizePX(40.0f)];
    if (self.messageTextView.contentSize.height > 100) {
        [self messageTextViewYesEnabled];
    } else {
        [self messageTextViewNoEnabled];
    }
    if (![textView.text isEqualToString:@""])
    {
        _placeholderLabel.hidden = YES;
        self.sendBtn.hidden=NO;
        self.isSendProto=NO;
    }else {
        _placeholderLabel.hidden = NO;
        self.sendBtn.hidden=YES;
        self.isSendProto=NO;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self messageTextViewNoEnabled];
        [self sendMessage];
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    self.sendBtn.hidden=NO;
    self.isSendProto=NO;
    return YES;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
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
            make.bottom.equalTo(weakSelf.audioButton.mas_top).offset(-15);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-60);
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
    [self.messageTextView mas_updateConstraints:^(MASConstraintMaker *make) {
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

    NSString *message = [[GYHDMessageCenter sharedInstance] stringWithAttString:self.messageTextView.attributedText];
    NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
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
- (void)GYHDKeyboardSelectBaseView:(GYHDKeyboardSelectBaseView *)view sendDict:(NSDictionary *)dict SendType:(GYHDKeyboardSelectBaseSendOption)type
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
#pragma mark - 发送图片代理
-(void)GYHDKeyboardSendBtnCount:(NSInteger)count potoArry:(NSArray *)potoArry isoriginalPhoto:(BOOL)isoriginalPhoto{
    
    if (count==0) {
        
        self.sendBtn.hidden=YES;
        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    }else{
        self.isSendProto=YES;
        self.sendBtn.hidden=NO;
        [self.sendBtn setTitle:[NSString stringWithFormat:@"发送(%ld)",count] forState:UIControlStateNormal];
        self.isoriginalPhoto=isoriginalPhoto;
        self.potoArry=potoArry;
    }
}

- (void)GYHDEmojiView:(GYHDEmojiView *)emojiView selectEmojiName:(NSString *)emojiName
{
    UIImage *image = [UIImage imageNamed:emojiName];
    if (!image) return;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.messageTextView.attributedText];
    NSRange selectRange = self.messageTextView.selectedRange;
    if ([emojiName isEqualToString:@"del"]) {
        if (!selectRange.location) return;
        CGFloat location = selectRange.location - 1;
        
        [attr deleteCharactersInRange:NSMakeRange(location, 1)];
        selectRange = NSMakeRange(selectRange.location - 1, selectRange.length);
    
    }
    else {
        // modify by jianglincen
        if (1) {
            selectRange = NSMakeRange(selectRange.location + 1, selectRange.length);
            
            EmojiTextAttachment *imageMent = [[EmojiTextAttachment alloc] init];
            imageMent.image = image;
            //坑爹，emojiName和UIImage imageWithName方法中名称差个中括号
            //            imageMent.emojiName =emojiName;
            
            imageMent.emojiName = [NSString stringWithFormat:@"[%@]", emojiName];
            
//            imageMent.emojiSize=CGSizeMake(40, 40);
            
            NSAttributedString *imageAttr =
            [NSAttributedString attributedStringWithAttachment:imageMent];
            
            [attr insertAttributedString:imageAttr
                                 atIndex:self.messageTextView.selectedRange.location];
        }
        
    }
    self.messageTextView.attributedText = attr;
    self.messageTextView.selectedRange = selectRange;
    self.isSendProto=NO;
}
#pragma mark - GYHDQucikViewDelegate
-(void)GYHDQucikViewSelectQucikString:(NSString *)QucikString{

    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    
    [dict setObject:QucikString forKey:@"string"];
    
    [self.delegate GYHDInputView:self sendDict:dict SendType:GYHDInputeViewSendText];

}
@end