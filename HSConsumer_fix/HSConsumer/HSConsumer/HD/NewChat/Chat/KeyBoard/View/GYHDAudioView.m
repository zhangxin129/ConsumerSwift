//
//  GYHDAudioView.m
//  HSConsumer
//
//  Created by shiang on 16/2/2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAudioView.h"
#import "GYHDMessageCenter.h"
#import "GYHDAudioTool.h"

@interface GYHDAudioView () <GYHDAudioToolDelegate>
@property (nonatomic, strong) GYHDAudioTool* audioTool;
/**音波图像数组*/
@property (nonatomic, strong) NSArray* recordFluctuationImageArray;
/**录音时长*/
@property (nonatomic, copy) NSString* recordTimeString;
/**开始录音View*/
@property (nonatomic, weak) UIView* startRecordView;
/**开始录音标题*/
@property (nonatomic, weak) UILabel* startRecordTitleLabel;
/**删除录音*/
@property (nonatomic, weak) UIButton* deleteRecordButton;
/**开始播放按钮*/
@property (nonatomic, weak) UIButton* startPlayRecordButton;
/**开始录音*/
@property (nonatomic, weak) UIImageView* startImageView;
/**时长波动*/
@property (nonatomic, weak) UIButton* startRecordTimerButton;

/**结束录音View*/
@property (nonatomic, weak) UIView* endRecordView;
/**播放录音*/
@property (nonatomic, weak) UIButton* endplayRecordButton;
/**结束音波*/
@property (nonatomic, weak) UIButton* endRecordTimerButton;
/**提示title定时器*/
@property (nonatomic, strong) NSTimer* recordtimer;
/**录音按钮选择时长*/
@property (nonatomic, assign) NSTimeInterval recordSelectTimeInterval;
/**录音时长*/
@property (nonatomic, assign) NSInteger timeLen;

@property (nonatomic, assign) BOOL sendState;
@end
static NSString const* startRecordString = @"00:00";
@implementation GYHDAudioView

- (GYHDAudioTool*)audioTool
{
    if (!_audioTool) {
        _audioTool = [GYHDAudioTool sharedInstance];
        _audioTool.delegate = self;
    }
    return _audioTool;
}

- (NSArray*)recordFluctuationImageArray
{
    if (!_recordFluctuationImageArray) {
        NSMutableArray* arrayM = [NSMutableArray array];
        for (int i = 1; i < 7; ++i) {
            [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gyhd_audio_animation_bg_%d", i]]];
        }
        _recordFluctuationImageArray = arrayM;
    }
    return _recordFluctuationImageArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return self;
    self.backgroundColor = [UIColor blueColor];

    [self setupStartRecordView];
    [self setupEndRecordingView];
    return self;
}

/**
 * 开始录音界面
 */
- (void)setupStartRecordView
{
    WS(weakSelf);
    UIView* StartRecordView = [[UIView alloc] init];
    [self addSubview:StartRecordView];
    _startRecordView = StartRecordView;
    [StartRecordView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    StartRecordView.backgroundColor = [UIColor colorWithRed:236.0f / 255.0f green:237.0f / 255.0f blue:241.0f / 255.0f alpha:1];
    // 标题
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(34)];
    titleLabel.textColor = [UIColor colorWithRed:132.0 / 255.0f green:141.0f / 255.0f blue:153.0f / 255.0f alpha:1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Chat_TouchDown_speak"];
    [StartRecordView addSubview:titleLabel];
    _startRecordTitleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(20);
        make.right.left.equalTo(StartRecordView);
    }];
    // 开始按钮
    UIImageView* startImageView = [[UIImageView alloc] init];
    startImageView.userInteractionEnabled = YES;
    [startImageView setImage:[UIImage imageNamed:@"gyhd_audio_record_btn_normal"]];
    _startImageView = startImageView;
    [StartRecordView addSubview:startImageView];
    [startImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(107, 107));
        make.center.equalTo(StartRecordView);
    }];
    UILongPressGestureRecognizer* tapPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    //    tapPress.minimumPressDuration = 0;
    [startImageView addGestureRecognizer:tapPress];

    // 试听按钮
    UIButton* startPlayRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startPlayRecordButton setImage:[UIImage imageNamed:@"gyhd_audio_start_player_normal"] forState:UIControlStateNormal];
    [startPlayRecordButton setImage:[UIImage imageNamed:@"gyhd_audio_start_player_select"] forState:UIControlStateSelected];
    [StartRecordView addSubview:startPlayRecordButton];
    _startPlayRecordButton = startPlayRecordButton;
    [startPlayRecordButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(45);
        make.left.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(70.0f, 70.0f));
    }];
    startPlayRecordButton.hidden = YES;
    /**删除录音*/
    UIButton* deleteRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteRecordButton setImage:[UIImage imageNamed:@"gyhd_audio_delete_btn_normal"] forState:UIControlStateNormal];
    [deleteRecordButton setImage:[UIImage imageNamed:@"gyhd_audio_delete_btn_select"] forState:UIControlStateSelected];
    [StartRecordView addSubview:deleteRecordButton];
    _deleteRecordButton = deleteRecordButton;
    [deleteRecordButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(45);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(70.0f, 70.0f));
    }];
    deleteRecordButton.hidden = YES;
    // 录音波荡
    UIButton* startRecordTimerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startRecordTimerButton.userInteractionEnabled = NO;
    startRecordTimerButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [startRecordTimerButton setTitleColor:[UIColor colorWithRed:132.0 / 255.0f green:141.0f / 255.0f blue:153.0f / 255.0f alpha:1] forState:UIControlStateNormal];
    [startRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
    [startRecordTimerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
    [startRecordTimerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 125)];
    [startRecordTimerButton setImage:[UIImage imageNamed:@"gyhd_audio_animation_bg_1"] forState:UIControlStateNormal];
    startRecordTimerButton.imageView.animationImages = self.recordFluctuationImageArray;
    startRecordTimerButton.imageView.animationDuration = 0.6;
    startRecordTimerButton.imageView.contentMode = UIViewContentModeCenter;
    [StartRecordView addSubview:startRecordTimerButton];
    _startRecordTimerButton = startRecordTimerButton;
    startRecordTimerButton.hidden = YES;
    [startRecordTimerButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(StartRecordView);
        make.top.mas_equalTo(20);
    }];
}

/**
 * 结束录音界面
 */
- (void)setupEndRecordingView
{
    WS(weakSelf);
    // 显示的控制器
    UIView* endRecordView = [[UIView alloc] init];
    [self addSubview:endRecordView];
    _endRecordView = endRecordView;
    [endRecordView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    self.endRecordView.hidden = YES;
    endRecordView.backgroundColor = [UIColor colorWithRed:236.0f / 255.0f green:237.0f / 255.0f blue:241.0f / 255.0f alpha:1];

    //1.声音波动图
    UIButton* endRecordTimerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endRecordTimerButton.userInteractionEnabled = NO;
    endRecordTimerButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [endRecordTimerButton setTitleColor:[UIColor colorWithRed:132.0 / 255.0f green:141.0f / 255.0f blue:153.0f / 255.0f alpha:1] forState:UIControlStateNormal];
    [endRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
    [endRecordTimerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
    [endRecordTimerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 125)];
    [endRecordTimerButton setImage:[UIImage imageNamed:@"gyhd_audio_animation_bg_1"] forState:UIControlStateNormal];
    endRecordTimerButton.imageView.animationImages = self.recordFluctuationImageArray;
    endRecordTimerButton.imageView.animationDuration = 0.6;
    endRecordTimerButton.imageView.contentMode = UIViewContentModeCenter;
    [endRecordView addSubview:endRecordTimerButton];
    _endRecordTimerButton = endRecordTimerButton;
    [endRecordTimerButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(endRecordView);
        make.top.mas_equalTo(20);
    }];
    //4. 播放按钮
    UIButton* endplayRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endRecordView addSubview:endplayRecordButton];
    [endplayRecordButton setBackgroundImage:[UIImage imageNamed:@"gyhd_audio_player_btn_normal"] forState:UIControlStateNormal];
    [endplayRecordButton setBackgroundImage:[UIImage imageNamed:@"gyhd_audio_stop_btn_selected"] forState:UIControlStateSelected];

    [endplayRecordButton addTarget:self action:@selector(playRecordButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    _endplayRecordButton = endplayRecordButton;
    [endplayRecordButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(107, 107));
        make.center.equalTo(endRecordView);
    }];
    // 取消按钮
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endRecordView addSubview:cancelButton];
    [cancelButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_cancel"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_audio_cancel_btn_normal"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn-n_l_selected"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.bottom.equalTo(endRecordView);
        make.height.mas_equalTo(30);
        make.width.equalTo(endRecordView).multipliedBy(0.5);
    }];
    // 发送按钮
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endRecordView addSubview:sendButton];
    [sendButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Send"] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_audio_send_btn_normal"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn-n_r_selected"] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.bottom.equalTo(endRecordView);
        make.height.mas_equalTo(30);
        make.width.equalTo(endRecordView).multipliedBy(0.5);
    }];
}

- (void)sendButtonClick:(UIButton*)button
{
    [self.audioTool stopPlaying];
    [_recordtimer invalidate];
    self.endplayRecordButton.selected = NO;
    [self.endRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
    self.endRecordView.hidden = YES;
    [self.endRecordTimerButton.imageView stopAnimating];
    if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        dict[@"mp3"] = [self.audioTool mp3NameString];
        dict[@"mp3Len"] = [NSString stringWithFormat:@"%ld", (long)_timeLen];
        if (dict.allKeys.count > 1 && _timeLen) {
            [self.delegate GYHDKeyboardSelectBaseView:self sendDict:dict SendType:GYHDKeyboardSelectBaseSendAudio];
        }
        else {
            UIWindow* window = [UIApplication sharedApplication].windows.lastObject;
            [GYUtils showToast:[GYUtils localizedStringWithKey:@"GYHD_Chat_Recording_less_than_1_seconds"] duration:1.0f position:CSToastPositionCenter];
        }
    }
}

- (void)cancelButtonClick:(UIButton*)button
{
    self.endRecordView.hidden = YES;
    [self.audioTool stopPlaying];
    [_recordtimer invalidate];
    self.endplayRecordButton.selected = NO;
    [self.endRecordTimerButton.imageView stopAnimating];
    [self.endRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
}

/**播放按钮*/
- (void)playRecordButtonClick:(UIButton*)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [self.audioTool startPlayingWithData:nil complete:nil];
        [_recordtimer invalidate];
        _recordtimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(listenRecord) userInfo:nil repeats:YES];
        [self.endRecordTimerButton.imageView startAnimating];
        [self.endRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
    }
    else {
        [self.audioTool stopPlaying];
        [_recordtimer invalidate];
        [self.endRecordTimerButton.imageView stopAnimating];
        [self.endRecordTimerButton setTitle:self.recordTimeString forState:UIControlStateNormal];
    }
}

- (void)listenRecord
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    NSDate* date = [formatter dateFromString:self.endRecordTimerButton.currentTitle];
    NSDate* newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[date timeIntervalSinceReferenceDate] + 1];
    [self.endRecordTimerButton setTitle:[formatter stringFromDate:newDate] forState:UIControlStateNormal];
    if ([self.endRecordTimerButton.currentTitle isEqualToString:self.recordTimeString]) {
        [_recordtimer invalidate];
        [self.endRecordTimerButton.imageView stopAnimating];
        self.endplayRecordButton.selected = NO;
    }
}

/**录音*/
- (void)tapPress:(UILongPressGestureRecognizer*)tapPress
{

    switch (tapPress.state) {
    case UIGestureRecognizerStateBegan: {
        self.sendState = NO;
        if ([NSDate timeIntervalSinceReferenceDate] - self.recordSelectTimeInterval <= 1) {
            UIWindow* window = [UIApplication sharedApplication].windows.lastObject;
            [GYUtils showToast:[GYUtils localizedStringWithKey:@"GYHD_Chat_Recording_less_than_1_seconds"] duration:1.0f position:CSToastPositionCenter];
        }
        else {
            _timeLen = 0;
            self.startPlayRecordButton.hidden = NO;
            self.deleteRecordButton.hidden = NO;
            self.startRecordTitleLabel.hidden = YES;
            self.startRecordTimerButton.hidden = NO;
            [self.startImageView setImage:[UIImage imageNamed:@"gyhd_audio_record_btn_highlighted"]];
            self.recordSelectTimeInterval = [NSDate timeIntervalSinceReferenceDate];
            [self.startRecordTimerButton.imageView startAnimating];
            [self layoutIfNeeded];

            _recordtimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setrecordTitle:) userInfo:nil repeats:YES];
            [self.audioTool startRecord];
        }

        break;
    }

    case UIGestureRecognizerStateChanged: {

        CGPoint point = [tapPress locationInView:self];
        CGFloat pad = [UIScreen mainScreen].bounds.size.width / 3.0f;
        if (point.x < pad) { // 左滑
            self.startPlayRecordButton.selected = YES;
            self.startRecordTimerButton.hidden = YES;
            self.startRecordTitleLabel.hidden = NO;
            self.startRecordTitleLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Chat_TouchUp_listen"];
            self.sendState = NO;
        }
        else if (point.x > pad * 2) { // 右滑
            self.deleteRecordButton.selected = YES;
            self.startRecordTimerButton.hidden = YES;
            self.startRecordTitleLabel.hidden = NO;
            self.startRecordTitleLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Chat_TouchUp_delete"];
            self.sendState = NO;
        }
        else {
            self.deleteRecordButton.selected = NO;
            self.startPlayRecordButton.selected = NO;
            self.startRecordTimerButton.hidden = NO;
            self.startRecordTitleLabel.hidden = YES;
            self.startRecordTitleLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Chat_TouchDown_speak"];
            self.sendState = YES;
        }
        break;
    }
    case UIGestureRecognizerStateEnded: {
        [self.audioTool stopRecord];
        [_recordtimer invalidate];
        [self.startRecordTimerButton.imageView stopAnimating];
        [self.startImageView setImage:[UIImage imageNamed:@"gyhd_audio_record_btn_normal"]];
        if (self.deleteRecordButton.selected) { // 右边
            self.deleteRecordButton.selected = NO;
            self.startRecordTitleLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Chat_TouchDown_speak"];
        }
        else if (self.startPlayRecordButton.selected) { // 左边
            self.recordTimeString = self.startRecordTimerButton.currentTitle;
            self.endRecordView.hidden = NO;
            [self.endRecordTimerButton setTitle:self.recordTimeString forState:UIControlStateNormal];
            self.startPlayRecordButton.selected = NO;
            self.startRecordTitleLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Chat_TouchDown_speak"];
        }
        else { //中间
            self.startRecordTitleLabel.hidden = NO;
            self.startRecordTimerButton.hidden = YES;
            self.sendState = YES;
        }
        self.startPlayRecordButton.hidden = YES;
        self.deleteRecordButton.hidden = YES;
        [self.startRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
        break;
    }
    default:
        break;
    }
}

/**改变显示时长*/
- (void)setrecordTitle:(NSTimer*)timer
{
    if (_timeLen > 28) {
        [_recordtimer invalidate];
        _recordtimer = nil;
        [self.startRecordTimerButton setTitle:[NSString stringWithFormat:@"00:%02ld", (long)++_timeLen] forState:UIControlStateNormal];
        [self.startRecordTimerButton.imageView stopAnimating];
        [GYUtils showToast:[GYUtils localizedStringWithKey:@"GYHD_Chat_Recording_more_than_30_seconds"] duration:1.0f position:CSToastPositionCenter];
    }
    else {
        [self.startRecordTimerButton setTitle:[NSString stringWithFormat:@"00:%02ld", (long)++_timeLen] forState:UIControlStateNormal];
    }
}

- (void)audioRecorderDidFinishRecordingWithPath:(NSString*)mpath
{
    if (self.sendState) {
        self.sendState = NO;
        if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            dict[@"mp3"] = [self.audioTool mp3NameString];
            dict[@"mp3Len"] = [NSString stringWithFormat:@"%ld", (long)_timeLen];
            
            
            if (dict.allKeys.count > 1 && _timeLen) {
                [self.delegate GYHDKeyboardSelectBaseView:self sendDict:dict SendType:GYHDKeyboardSelectBaseSendAudio];
            }else {
                [GYUtils showToast:[GYUtils localizedStringWithKey:@"GYHD_Chat_Recording_less_than_1_seconds"] duration:1.0f position:CSToastPositionCenter];
            }
        }
    }
}

@end
//        [self.audioTool startRecord:^(GYHDAudioToolRecordState state) {
//
//                switch (state) {
//                case GYHDAudioToolRecordSurpass30Seconds:
//                    {
////                        [_recordtimer invalidate];
////                        [self.startRecordTimerButton.imageView stopAnimating];
////                        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
////                        [GYUtils showToast:[GYUtils localizedStringWithKey:@"GYHD_Chat_Recording_more_than_30_seconds"] duration:1.0f position:CSToastPositionCenter];
//                        break;
//                    }
//                case GYHDAudioToolRecordProhibit:
//                    {
//
//                        [_recordtimer invalidate];
//                        [self.startRecordTimerButton.imageView stopAnimating];
//                        self.startPlayRecordButton.hidden = YES;
//                        self.deleteRecordButton.hidden = YES;
//                        self.startRecordTitleLabel.hidden = NO;
//                        self.startRecordTimerButton.hidden = YES;
//
//                        self.startRecordTitleLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Chat_TouchDown_speak"];
//
//                        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
//                        if (appName == nil) {
//                            appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
//                        }
//                        [[[UIAlertView alloc] initWithTitle:[GYUtils localizedStringWithKey:@"GYHD_Chat_Not_record"] message:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Chat_Not_record_tips"], appName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//                        break;
//                    }
//                default:
//                    break;
//                }
//
//            }];
//            else {

//            }
//                if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
//                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                    dict[@"mp3"] = [self.audioTool mp3NameString];
//                    dict[@"mp3Len"] = [NSString stringWithFormat:@"%ld", (long)_timeLen];
//                    if (dict.allKeys.count >1) {
//                        [self.delegate GYHDKeyboardSelectBaseView:self sendDict:dict SendType:GYHDKeyboardSelectBaseSendAudio];
//                    }else {
//                        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
//                        [GYUtils showToast:@"录音失败" duration:1.0f position:CSToastPositionCenter];
//                    }
//
//                }
//            }
