//
//  GYHDMoreChooseView.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDMoreChooseView.h"
#import "GYHDRecordVideoTool.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface GYHDMoreChooseView ()
@property(nonatomic, strong)UIButton *photoButton;
@property(nonatomic, strong)UILabel  *photoLabel;
@property(nonatomic, strong)UIButton *cameraButton;
@property(nonatomic, strong)UILabel  *cameraLabel;
@property(nonatomic, strong)UIButton *videoButton;
@property(nonatomic, strong)UILabel  *videoLabel;
@property(nonatomic, strong)UIButton *mapButton;
@property(nonatomic, strong)UILabel  *mapLabel;
@end

@implementation GYHDMoreChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self setupAuto];
    }
    return self;
}
- (void)setup {
    self.photoButton = [[UIButton alloc] init];
    [self.photoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_photo_btn_normal"] forState:UIControlStateNormal];
    [self.photoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_photo_btn_select"] forState:UIControlStateHighlighted];
    [self.photoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.photoButton];
    
    self.cameraButton = [[UIButton alloc] init];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_camera_btn_normal"] forState:UIControlStateNormal];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_camera_btn_select"] forState:UIControlStateHighlighted];
    [self.cameraButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cameraButton];
    
    self.videoButton = [[UIButton alloc] init];
    [self.videoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_video_btn_normal"] forState:UIControlStateNormal];
    [self.videoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_video_btn_select"] forState:UIControlStateHighlighted];
    [self.videoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.videoButton];
    
    self.mapButton = [[UIButton alloc] init];
    [self.mapButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_map_btn_normal"] forState:UIControlStateNormal];
    [self.mapButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_map_btn_select"] forState:UIControlStateHighlighted];
    [self.mapButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.mapButton];
    
    self.photoLabel = [[UILabel alloc] init];
    self.photoLabel.font = [UIFont systemFontOfSize:14.0f];
    self.photoLabel.textColor = [UIColor colorWithHex:0x999999];
    [self addSubview:self.photoLabel];
    
    self.cameraLabel = [[UILabel alloc] init];
    self.cameraLabel.font = [UIFont systemFontOfSize:14.0f];
    self.cameraLabel.textColor = [UIColor colorWithHex:0x999999];
    [self addSubview:self.cameraLabel];
    
    self.videoLabel = [[UILabel alloc] init];
    self.videoLabel.font = [UIFont systemFontOfSize:14.0f];
    self.videoLabel.textColor = [UIColor colorWithHex:0x999999];
    [self addSubview:self.videoLabel];
    
    self.mapLabel = [[UILabel alloc] init];
    self.mapLabel.font = [UIFont systemFontOfSize:14.0f];
    self.mapLabel.textColor = [UIColor colorWithHex:0x999999];
    [self addSubview:self.mapLabel];
    
    self.photoLabel.text = kLocalized(@"GYHD_Input_Photo");
    self.cameraLabel.text = kLocalized(@"GYHD_Photograph");
    self.videoLabel.text = kLocalized(@"GYHD_Videotape");
    self.mapLabel.text = kLocalized(@"GYHD_Input_Map");
}
- (void)setupAuto {
    @weakify(self);
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(79, 79));
    }];
    
    [self.photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.photoButton);
        make.top.equalTo(self.photoButton.mas_bottom).offset(6);
    }];
    
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.photoButton.mas_right).offset(50);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(79, 79));
    }];

    [self.cameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.cameraButton);
        make.top.equalTo(self.cameraButton.mas_bottom).offset(6);
    }];
    
    [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.cameraButton.mas_right).offset(50);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(79, 79));
    }];
    
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.videoButton);
        make.top.equalTo(self.videoButton.mas_bottom).offset(6);
    }];

    [self.mapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.videoButton.mas_right).offset(50);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(79, 79));
    }];
    
    [self.mapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.mapButton);
        make.top.equalTo(self.mapButton.mas_bottom).offset(6);
    }];
}

-(void)buttonClick:(UIButton*)button{

    
    if (button==self.photoButton) {//照片
        
        if (self.delegage && [self.delegage respondsToSelector:@selector(GYHDMoreChooseViewSendMessageWith:)]) {
            
            [self.delegage GYHDMoreChooseViewSendMessageWith:GYHDInputeViewSendPhoto];
        }
        
    }else if (button==self.cameraButton){//照相
        
        if ([GYHDRecordVideoTool CameraAvailable]) {

            if (self.delegage && [self.delegage respondsToSelector:@selector(GYHDMoreChooseViewSendMessageWith:)]) {
                
                [self.delegage GYHDMoreChooseViewSendMessageWith:GYHDInputeViewSendCamara];
            }
            
        }else {
      
            [[[UIAlertView alloc] initWithTitle:nil message:kLocalized(@"GYHD_Please_Settings_Privacy_Camera_Option_Allows_The_Alternate_System_To_Access_Your_Camera")  delegate:nil cancelButtonTitle:kLocalized(@"GYHD_Comfirm") otherButtonTitles:nil] show];
        }

    }else if (button==self.videoButton){//视频
        
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
        
            if (self.delegage && [self.delegage respondsToSelector:@selector(GYHDMoreChooseViewSendMessageWith:)]) {
                
                [self.delegage GYHDMoreChooseViewSendMessageWith:GYHDInputeViewSendVideo];
            }
            
        }else {
            NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            if (appName == nil) {
                appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
            }
            ;
            [[[UIAlertView alloc] initWithTitle:nil message:kLocalized(@"GYHD_Please_Settings_Privacy_Camera_Option_Allows_The_Alternate_System_To_Access_Your_Camera_And_Microphone") delegate:nil cancelButtonTitle:kLocalized(@"GYHD_Comfirm") otherButtonTitles:nil] show];
        }

    
    }else if (button==self.mapButton){//地图
    
        if (self.delegage && [self.delegage respondsToSelector:@selector(GYHDMoreChooseViewSendMessageWith:)]) {
            
            [self.delegage GYHDMoreChooseViewSendMessageWith:GYHDInputeViewSendLocation];
        }

    }


}




@end
