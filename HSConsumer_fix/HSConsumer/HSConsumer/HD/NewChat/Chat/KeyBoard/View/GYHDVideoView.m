//
//  GYHDVideoView.m
//  HSConsumer
//
//  Created by shiang on 16/2/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDVideoView.h"
#import "GYHDMessageCenter.h"
#import "GYHDRecordVideoTool.h"
#import "GYHDPlayVideoView.h"

@interface GYHDVideoView () <GYHDRecordVideoDelegate, GYHDPlayVideoViewDelegate>
/**相机展示图层*/
@property (nonatomic, weak) UIView* showVideoView;
/**录制界面*/
@property (nonatomic, weak) UIView* startRecordVideoView;
/**试看按钮*/
@property (nonatomic, weak) UIButton* startPlayRecordButton;
/**开始录制*/
@property (nonatomic, weak) UIImageView* startImageView;
/**删除按钮*/
@property (nonatomic, weak) UIButton* deleteRecordButton;
/**录制视频工具*/
@property (nonatomic, strong) GYHDRecordVideoTool* recordViewTool;
/**录音提示*/
@property (nonatomic, weak) UILabel* recordNoticeLabel;
/**录音时长提示*/
@property (nonatomic, weak) UIButton* recordTimeCountButton;
/**进度条白色View*/
@property (nonatomic, weak) UIView* progressWhiteView;
/**进度条背景View*/
@property (nonatomic, weak) UIView* progressBackgroundView;
/**进度条蓝色View*/
@property (nonatomic, weak) UIView* progressBlueView;
/**是否为发送*/
@property (nonatomic, assign) BOOL sendVideo;
/**是否为播放*/
@property (nonatomic, assign) BOOL playeVideo;
@property (nonatomic, strong) NSDictionary* sendDict;
@property (nonatomic, assign) NSTimeInterval recordSelectTimeInterval;
@end

@implementation GYHDVideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return self;
    self.backgroundColor = [UIColor blackColor];

    [self setuptUp];
    [self setupCenter];
    [self setupDown];

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.recordViewTool = [[GYHDRecordVideoTool alloc] initWithView:self.showVideoView];
    self.recordViewTool.delegate = self;
}

/**顶部*/
- (void)setuptUp
{
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_cancel_camera_btn_normal"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_cancel_camera_btn_highlighted"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];

    [cancelButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];

    UIButton* changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeCameraButton setBackgroundImage:[UIImage imageNamed:@"gyhd_change_camera_btn_normal"] forState:UIControlStateNormal];
    [changeCameraButton setBackgroundImage:[UIImage imageNamed:@"gyhd_change_camera_btn_highlighted"] forState:UIControlStateHighlighted];
    [changeCameraButton addTarget:self action:@selector(changeCameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changeCameraButton];
    [changeCameraButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
}

- (void)cancelButtonClick
{
    [self disMiss];
}

/**中间*/
- (void)setupCenter
{
    UIView* showVideoView = [[UIView alloc] init];
    [self addSubview:showVideoView];
    _showVideoView = showVideoView;

    WS(weakSelf);
    [showVideoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenWidth * 2 / 3));
    }];
}

/**底部*/
- (void)setupDown
{
    //1. 录制界面
    UIView* startRecordVideoView = [[UIView alloc] init];
    [self addSubview:startRecordVideoView];
    _startRecordVideoView = startRecordVideoView;
    WS(weakSelf);
    [startRecordVideoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(weakSelf.showVideoView.mas_bottom);
    }];
    startRecordVideoView.backgroundColor = [UIColor blackColor];

    // 开始按钮
    UIImageView* startImageView = [[UIImageView alloc] init];
    startImageView.userInteractionEnabled = YES;
    [startImageView setImage:[UIImage imageNamed:@"gyhd_video_record_btn_normal"]];
    _startImageView = startImageView;
    [startRecordVideoView addSubview:startImageView];
    [startImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(105, 105));
        make.centerX.equalTo(startRecordVideoView);
        make.centerY.equalTo(startRecordVideoView).offset(10);
    }];
    UILongPressGestureRecognizer* tapPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    tapPress.minimumPressDuration = 0;
    [startImageView addGestureRecognizer:tapPress];

    // 试看按钮
    UIButton* startPlayRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startPlayRecordButton setImage:[UIImage imageNamed:@"gyhd_video_start_btn_normal"] forState:UIControlStateNormal];
    [startPlayRecordButton setImage:[UIImage imageNamed:@"gyhd_video_start_btn_select"] forState:UIControlStateSelected];
    [startRecordVideoView addSubview:startPlayRecordButton];
    _startPlayRecordButton = startPlayRecordButton;

    [startPlayRecordButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(45);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    startPlayRecordButton.hidden = YES;
    /**删除录像*/
    UIButton* deleteRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteRecordButton setImage:[UIImage imageNamed:@"gyhd_video_delete_btn_normal"] forState:UIControlStateNormal];
    [deleteRecordButton setImage:[UIImage imageNamed:@"gyhd_video_delete_btn_highlighted"] forState:UIControlStateSelected];
    [startRecordVideoView addSubview:deleteRecordButton];
    _deleteRecordButton = deleteRecordButton;

    [deleteRecordButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(45);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    deleteRecordButton.hidden = YES;

    // 标题
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(34)];
    titleLabel.textColor = [UIColor colorWithRed:132.0 / 255.0f green:141.0f / 255.0f blue:153.0f / 255.0f alpha:1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Chat_TouchDown_Video"];
    [startRecordVideoView addSubview:titleLabel];
    _recordNoticeLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(5);
        make.right.left.equalTo(startRecordVideoView);
    }];
    // 录音提示
    UIButton* recordTimeCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordTimeCountButton setBackgroundImage:[UIImage imageNamed:@"gyhd_timeCount_btn_normal"] forState:UIControlStateNormal];
    [recordTimeCountButton setImage:[UIImage imageNamed:@"gyhd_timtCount_show_icon"] forState:UIControlStateNormal];
    [recordTimeCountButton setTitle:@" 1\"" forState:UIControlStateNormal];
    recordTimeCountButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    [self addSubview:recordTimeCountButton];
    _recordTimeCountButton = recordTimeCountButton;
    [recordTimeCountButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.showVideoView).offset(12);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(35, 16));
    }];
    recordTimeCountButton.hidden = YES;

    // 录像进入条
    UIView* progressBackgroundView = [[UIView alloc] init];
    progressBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:progressBackgroundView];
    [progressBackgroundView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.startRecordVideoView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 5));
    }];

    UIView* progressBlueView = [[UIView alloc] init];
    progressBlueView.backgroundColor = [UIColor colorWithRed:97.0f / 255.0f green:208.0f / 255.0f blue:224.0f / 255.0f alpha:1];
    [progressBackgroundView addSubview:progressBlueView];
    _progressBlueView = progressBlueView;
    [progressBlueView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(0, 5));

    }];

    UIView* progressWhiteView = [[UIView alloc] init];
    progressWhiteView.backgroundColor = [UIColor whiteColor];
    [progressBackgroundView addSubview:progressWhiteView];
    _progressWhiteView = progressWhiteView;
    [progressWhiteView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(progressBlueView.mas_right);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(5);
    }];
}

/**录音*/
- (void)tapPress:(UILongPressGestureRecognizer*)tapPress
{
    switch (tapPress.state) {
    case UIGestureRecognizerStateBegan: {

        if ([NSDate timeIntervalSinceReferenceDate] - self.recordSelectTimeInterval <= 2) {
            [GYUtils showToast:[GYUtils localizedStringWithKey:@"GYHD_Chat_Recording_less_than_1_seconds"] duration:1.0f position:CSToastPositionCenter];
        }
        else {

            self.recordSelectTimeInterval = [NSDate timeIntervalSinceReferenceDate];
            self.sendVideo = NO;
            self.playeVideo = NO;
            // 开始录制视频
            [self.recordViewTool startRecordVideoForDuration:15.0f];

            [self.startImageView setImage:[UIImage imageNamed:@"gyhd_video_record_btn_Highlighte"]];
            self.startPlayRecordButton.hidden = NO;
            self.deleteRecordButton.hidden = NO;
            self.recordTimeCountButton.hidden = NO;

            [UIView animateWithDuration:15.0f animations:^{
                [self.progressBlueView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.left.mas_equalTo(0);
                    make.height.mas_equalTo(5);
                    make.width.mas_equalTo(kScreenWidth-5);
                }];
                [self layoutIfNeeded];
            }];
        }

        break;
    }
    case UIGestureRecognizerStateChanged: {
        CGPoint point = [tapPress locationInView:self];
        CGFloat pad = [UIScreen mainScreen].bounds.size.width / 3.0f;
        if (point.x < pad) { // 左滑

            self.startPlayRecordButton.selected = YES;
            self.deleteRecordButton.selected = NO;
            self.recordNoticeLabel.hidden = NO;
            self.recordNoticeLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Chat_TouchUp_Preview"];
        }
        else if (point.x > pad * 2) { // 右滑
            self.startPlayRecordButton.selected = NO;
            self.deleteRecordButton.selected = YES;
            self.recordNoticeLabel.hidden = NO;
        }
        else {
            self.startPlayRecordButton.selected = NO;
            self.deleteRecordButton.selected = NO;
            self.recordNoticeLabel.hidden = YES;
            self.recordNoticeLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Chat_TouchUp_delete"];
        }

        break;
    }
    case UIGestureRecognizerStateEnded: {

        [self.progressBlueView mas_remakeConstraints:^(MASConstraintMaker* make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(5);
                make.width.mas_equalTo(0);
        }];
        if (self.startPlayRecordButton.selected || self.deleteRecordButton.selected) {
            if (self.startPlayRecordButton.selected) {
                self.playeVideo = YES;
            }
            self.sendVideo = NO;
        }
        else {
            self.sendVideo = YES;
        }

        // 结束录制
        [self.recordViewTool stopRecordVideo];

        break;
    }

    default:
        break;
    }
}

- (void)changeCameraButtonClick
{
    [self.recordViewTool changeCamera];
}

#pragma mark-- 录音代理
/**录音中*/
- (void)recordViewTimeInterval:(NSTimeInterval)timelen
{
    NSInteger time = timelen + 1;
    [self.recordTimeCountButton setTitle:[NSString stringWithFormat:@" %ld\"", (long)time] forState:UIControlStateNormal];
}

/**结束录音*/
#pragma mark--GYHDPlayVideoViewDelegate
- (void)GYHDPlayVideoView:(GYHDPlayVideoView*)playVideoView DidSendData:(NSData*)data
{
    if (!(self.startPlayRecordButton.selected && self.deleteRecordButton.selected)) {
        [self disMiss];
        if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
            [self.delegate GYHDKeyboardSelectBaseView:self sendDict:self.sendDict SendType:GYHDKeyboardSelectBaseSendVideo];
        }
    }
}

- (void)GYHDRecordVideoTool:(GYHDRecordVideoTool*)recordView sendDict:(NSDictionary*)dict
{
    self.sendDict = dict;
    if (self.sendVideo || self.recordTimeCountButton.currentTitle.integerValue > 14) {
        [self disMiss];
        if (dict.allKeys.count > 1) {
            if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
                [self.delegate GYHDKeyboardSelectBaseView:self sendDict:self.sendDict SendType:GYHDKeyboardSelectBaseSendVideo];
            }
        }
        else {
            [GYUtils showToast:[GYUtils localizedStringWithKey:@"GYHD_Chat_Video_failed"] duration:1.0f position:CSToastPositionCenter];
        }
    }
    else if (self.playeVideo) {
        GYHDPlayVideoView* playeView = [[GYHDPlayVideoView alloc] initWithPlayMp4Data:[self.recordViewTool mp4Data]];
        playeView.delegate = self;
        [playeView show];
    }
    self.recordNoticeLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Chat_TouchDown_Video"];
    self.recordNoticeLabel.hidden = NO;

    [self.startImageView setImage:[UIImage imageNamed:@"gyhd_video_record_btn_normal"]];
    self.startPlayRecordButton.hidden = YES;
    self.deleteRecordButton.hidden = YES;
    self.recordTimeCountButton.hidden = YES;
    [self.recordTimeCountButton setTitle:@" 1\"" forState:UIControlStateNormal];
    self.deleteRecordButton.selected = NO;
    self.startPlayRecordButton.selected = NO;
}

@end
//    if (!(self.startPlayRecordButton.selected &&  self.deleteRecordButton.selected)) {
//        [self disMiss];
//        if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
//            [self.delegate GYHDKeyboardSelectBaseView:self sendDict:self.sendDict SendType:GYHDKeyboardSelectBaseSendVideo];
//        }
//    }else  if (self.startPlayRecordButton.selected) {
//            GYHDPlayVideoView *playeView = [[GYHDPlayVideoView alloc] initWithPlayMp4Data:[self.recordViewTool mp4Data]];
//            playeView.delegate = self;
//            [playeView show];
//        }
//            if (self.startPlayRecordButton.selected) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    GYHDPlayVideoView *playeView = [[GYHDPlayVideoView alloc] initWithPlayMp4Data:[self.recordViewTool mp4Data]];
//                    playeView.delegate = self;
//                    [playeView show];
//                });
//            }
//            if (self.startPlayRecordButton.selected || self.deleteRecordButton.selected) {
//                  self.sendVideo = YES;
//            }else {
//                self.sendVideo = YES;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
//                        [self.delegate GYHDKeyboardSelectBaseView:self sendDict:self.sendDict SendType:GYHDKeyboardSelectBaseSendVideo];
//                    }
//                    [self disMiss];
//                });
//            }
//    if (!self.isSendVideo) return;
//        [self disMiss];
//        if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
//            [self.delegate GYHDKeyboardSelectBaseView:self sendDict:self.sendDict SendType:GYHDKeyboardSelectBaseSendVideo];
//        }
//        self.sendVideo = YES;
//- (void)GYHDRecordVideoTool:(GYHDRecordVideoTool *)recordView mp4Path:(NSString *)mp4Path VideofristFramePath:(NSString *)imagePath
//{
//    NSLog(@"mp4Path = %@,image = %@",mp4Path,imagePath);
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary ];
//    dict[@"mp4Path"] = mp4Path;
//    dict[@"thumbnailsImage"] = imagePath;
//    self.sendDict = dict;
//    if (self.isSendVideo) {
//        [self disMiss];
//        if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
//            [self.delegate GYHDKeyboardSelectBaseView:self sendDict:self.sendDict SendType:GYHDKeyboardSelectBaseSendVideo];
//        }
//        self.sendVideo = NO;
//    }
//}
//- (void)GYHDRecordVideoTool:(GYHDRecordVideoTool *)recordView mp4Path:(NSString *)mp4Path
//{
//    [self removeFromSuperview];
//    if ([self.delegate respondsToSelector:@selector(GYHDVideoView:VideoMp4Path:)]) {
//        [self.delegate GYHDVideoView:self VideoMp4Path:mp4Path];
//    }
//}
//    if ([self.delegate respondsToSelector:@selector(GYHDVideoView:VideoMp4Path:VideoImagePath:)]) {
//        [self.delegate GYHDVideoView:self VideoMp4Path:mp4Path VideoImagePath:imagePath];
//    }

//        if ([self.delegate respondsToSelector:@selector(GYHDVideoView:VideoMp4Data:)]) {
//            [self.delegate GYHDVideoView:self VideoMp4Data:mp4Data];
//        }