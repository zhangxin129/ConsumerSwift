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


@interface GYHDAudioView ()
@property(nonatomic, strong)GYHDAudioTool *audioTool;
/**音波图像数组*/
@property(nonatomic, strong)NSArray *recordFluctuationImageArray;
/**录音时长*/
@property(nonatomic, copy)NSString *recordTimeString;
/**开始录音View*/
@property(nonatomic, weak)UIView *startRecordView;
/**开始录音标题*/
@property(nonatomic, weak)UILabel *startRecordTitleLabel;
/**删除录音*/
@property(nonatomic, weak)UIButton *deleteRecordButton;
/**开始播放按钮*/
@property(nonatomic, weak)UIButton *startPlayRecordButton;
/*左边线条*/
@property(nonatomic,weak)UIImageView*leftLineImg;
/*右边线条*/
@property(nonatomic,weak)UIImageView*rightLineImg;
/**开始录音*/
@property(nonatomic, weak)UIImageView *startImageView;
/**时长波动*/
@property(nonatomic, weak)UIButton *startRecordTimerButton;

/**结束录音View*/
@property(nonatomic, weak)UIView *endRecordView;
/**播放录音*/
@property(nonatomic, weak)UIButton *endplayRecordButton;
/**结束音波*/
@property(nonatomic, weak)UIButton *endRecordTimerButton;
/**提示title定时器*/
@property(nonatomic, strong)NSTimer *recordtimer;
/**录音按钮选择时长*/
@property(nonatomic, assign)NSTimeInterval recordSelectTimeInterval;
@end
static NSString const *startRecordString = @"00:00";
@implementation GYHDAudioView

- (GYHDAudioTool *)audioTool
{
    if (!_audioTool) {
        _audioTool = [GYHDAudioTool sharedInstance];
    }
    return _audioTool;
}
- (NSArray *)recordFluctuationImageArray
{
    if (!_recordFluctuationImageArray) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 1; i < 7; ++i) {
            [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"icon-sbxg-%d",i]]];
        }
        _recordFluctuationImageArray = arrayM;
    }
    return _recordFluctuationImageArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return self;
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
    UIView *StartRecordView = [[UIView alloc] init];
    [self addSubview:StartRecordView];
    _startRecordView = StartRecordView;
    [StartRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    StartRecordView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:237.0f/255.0f blue:241.0f/255.0f alpha:1];
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(34)];
    titleLabel.textColor = [UIColor colorWithRed:132.0/255.0f green:141.0f/255.0f blue:153.0f/255.0f alpha:1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"按住说话";
    [StartRecordView addSubview:titleLabel];
    _startRecordTitleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.left.equalTo(StartRecordView);
    }];
    
    // 开始按钮
    UIImageView *startImageView = [[UIImageView alloc] init];
    startImageView.userInteractionEnabled = YES;
    [startImageView setImage:[UIImage imageNamed:@"btn-yy_big"]];
    _startImageView = startImageView;
    [StartRecordView addSubview:startImageView];
    [startImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(107, 107));
        make.center.equalTo(StartRecordView);
    }];
    
    UILongPressGestureRecognizer *tapPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    tapPress.minimumPressDuration = 0;
    [startImageView addGestureRecognizer:tapPress];
    
    
    
    // 试听按钮
    UIButton *startPlayRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startPlayRecordButton setImage:[UIImage imageNamed:@"icon-yy_st_normal"] forState:UIControlStateNormal];
    [startPlayRecordButton setImage:[UIImage imageNamed:@"icon-yy_st_selected"] forState:UIControlStateSelected];
    [StartRecordView addSubview:startPlayRecordButton];
    _startPlayRecordButton = startPlayRecordButton;
    [startPlayRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.startImageView.mas_left).offset(-75);
        make.size.mas_equalTo(CGSizeMake(70.0f, 70.0f));
        make.centerY.mas_equalTo(weakSelf.startImageView).offset(-20);
    }];
    
    startPlayRecordButton.hidden = YES;
    
    /**删除录音*/
    UIButton *deleteRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteRecordButton setImage:[UIImage imageNamed:@"icon-yy_sc_normal"] forState:UIControlStateNormal];
    [deleteRecordButton setImage:[UIImage imageNamed:@"icon-yy_sc_selected"] forState:UIControlStateSelected];
    [StartRecordView addSubview:deleteRecordButton];
    _deleteRecordButton = deleteRecordButton;
    [deleteRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.startImageView.mas_right).offset(75);
        make.size.mas_equalTo(CGSizeMake(70.0f, 70.0f));
        make.centerY.mas_equalTo(weakSelf.startImageView).offset(-20);
    }];
    deleteRecordButton.hidden = YES;
    
//    左边线条
    UIImageView*leftLineImg=[[UIImageView alloc]init];
    
    leftLineImg.image=[UIImage imageNamed:@"HD_video_lineLeft"];
    
    [StartRecordView addSubview:leftLineImg];
    _leftLineImg =leftLineImg;
    
    [leftLineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.startPlayRecordButton.mas_right).offset(0);
        make.right.equalTo(weakSelf.startImageView.mas_left).offset(0);
        make.centerY.mas_equalTo(weakSelf.startImageView).offset(0);
        
    }];
    leftLineImg.hidden=YES;
    
//    右边线条
    UIImageView*rightLineImg=[[UIImageView alloc]init];
    
    rightLineImg.image=[UIImage imageNamed:@"HD_video_lineRight"];
    
    [StartRecordView addSubview:rightLineImg];
    _rightLineImg =rightLineImg;
    
    [rightLineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.startImageView.mas_right).offset(0);
        make.right.equalTo(weakSelf.deleteRecordButton.mas_left).offset(0);
        make.centerY.mas_equalTo(weakSelf.startImageView).offset(0);
    }];
    
    rightLineImg.hidden=YES;
    
    // 录音波荡
    UIButton *startRecordTimerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startRecordTimerButton.userInteractionEnabled = NO;
    startRecordTimerButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [startRecordTimerButton setTitleColor:[UIColor colorWithRed:132.0/255.0f green:141.0f/255.0f blue:153.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [startRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
    [startRecordTimerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
    [startRecordTimerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 125)];
    [startRecordTimerButton setImage:[UIImage imageNamed:@"icon-sbxg-1"] forState:UIControlStateNormal];
    startRecordTimerButton.imageView.animationImages = self.recordFluctuationImageArray;
    startRecordTimerButton.imageView.animationDuration = 0.6;
    startRecordTimerButton.imageView.contentMode = UIViewContentModeCenter;
    [StartRecordView addSubview:startRecordTimerButton];
    _startRecordTimerButton = startRecordTimerButton;
    startRecordTimerButton.hidden = YES;
    [startRecordTimerButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
    UIView *endRecordView = [[UIView alloc] init];
    [self addSubview:endRecordView];
    _endRecordView = endRecordView;
    [endRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    self.endRecordView.hidden = YES;
    endRecordView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:237.0f/255.0f blue:241.0f/255.0f alpha:1];
    
    //1.声音波动图
    UIButton *endRecordTimerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endRecordTimerButton.userInteractionEnabled = NO;
    endRecordTimerButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [endRecordTimerButton setTitleColor:[UIColor colorWithRed:132.0/255.0f green:141.0f/255.0f blue:153.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [endRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
    [endRecordTimerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
    [endRecordTimerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 125)];
    [endRecordTimerButton setImage:[UIImage imageNamed:@"icon-sbxg-1"] forState:UIControlStateNormal];
    endRecordTimerButton.imageView.animationImages = self.recordFluctuationImageArray;
    endRecordTimerButton.imageView.animationDuration = 0.6;
    endRecordTimerButton.imageView.contentMode = UIViewContentModeCenter;
    [endRecordView addSubview:endRecordTimerButton];
    _endRecordTimerButton = endRecordTimerButton;
    [endRecordTimerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(endRecordView);
        make.top.mas_equalTo(20);
    }];
    //4. 播放按钮
    UIButton *endplayRecordButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [endRecordView addSubview:endplayRecordButton];
    [endplayRecordButton setBackgroundImage:[UIImage imageNamed:@"btn-yy_big_3"] forState:UIControlStateNormal];
    [endplayRecordButton setBackgroundImage:[UIImage imageNamed:@"btn-yy_big_4"] forState:UIControlStateSelected];

    [endplayRecordButton addTarget:self action:@selector(playRecordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
   
    _endplayRecordButton = endplayRecordButton;
    [endplayRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(107, 107));
        make.center.equalTo(endRecordView);
    }];
    // 发送按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endRecordView addSubview:cancelButton];
    [cancelButton setTitle:@"发送" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0/255.0 green:164/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn-n_l_normal"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn-n_l_selected"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(endRecordView);
        make.height.mas_equalTo(40);
        make.width.equalTo(endRecordView).multipliedBy(0.5);
    }];
    // 取消按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endRecordView addSubview:sendButton];
    [sendButton setTitle:@"取消" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:0/255.0 green:164/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn-n_r_normal"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn-n_r_selected"] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(endRecordView);
        make.height.mas_equalTo(40);
        make.width.equalTo(endRecordView).multipliedBy(0.5);
    }];

}

- (void)sendButtonClick:(UIButton *)button
{
    [self.audioTool stopPlaying];
    [_recordtimer invalidate];
    self.endplayRecordButton.selected = NO;
    [self.endRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
    self.endRecordView.hidden = YES;
    [self.endRecordTimerButton.imageView stopAnimating];
    if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"mp3"] = [self.audioTool mp3NameString];
        dict[@"mp3Len"] = [NSString stringWithFormat:@"%f",self.audioTool. gettime];
        if (dict.allKeys.count>1) {
            
            [self.delegate GYHDKeyboardSelectBaseView:self sendDict:dict SendType:GYHDKeyboardSelectBaseSendAudio];
        }else{
        
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            [window makeToast:@"录音失败" duration:0.25f position:CSToastPositionCenter];
        }
        
    }
}
- (void)cancelButtonClick:(UIButton *)button
{
    self.endRecordView.hidden = YES;
    [self.audioTool stopPlaying];
    [_recordtimer invalidate];
    self.endplayRecordButton.selected = NO;
    [self.endRecordTimerButton.imageView stopAnimating];
    [self.endRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
}
/**播放按钮*/
- (void)playRecordButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [self.audioTool startPlayingWithData:nil complete:nil];
        _recordtimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(listenRecord) userInfo:nil repeats:YES];
        [self.endRecordTimerButton.imageView startAnimating];
        [self.endRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
    } else {
        [self.audioTool stopPlaying];
        [_recordtimer invalidate];
        [self.endRecordTimerButton.imageView stopAnimating];
        [self.endRecordTimerButton setTitle:self.recordTimeString forState:UIControlStateNormal];
    }
}
- (void)listenRecord
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    NSDate *date =  [formatter dateFromString:self.endRecordTimerButton.currentTitle];
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[date timeIntervalSinceReferenceDate]+1];
    [self.endRecordTimerButton setTitle:[formatter stringFromDate:newDate] forState:UIControlStateNormal];
    if ([self.endRecordTimerButton.currentTitle isEqualToString:self.recordTimeString]) {
        [_recordtimer invalidate];
        [self.endRecordTimerButton.imageView stopAnimating];
        self.endplayRecordButton.selected = NO;
    }
}
/**录音*/
- (void)tapPress:(UILongPressGestureRecognizer *)tapPress
{

    switch (tapPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.startPlayRecordButton.hidden = NO;
            self.deleteRecordButton.hidden = NO;
            self.leftLineImg.hidden=NO;
            self.rightLineImg.hidden=NO;
            self.startRecordTitleLabel.hidden = YES;
            self.startRecordTimerButton.hidden = NO;
            [self.startImageView setImage:[UIImage imageNamed:@"btn-yy_big_2"]];
            self.recordSelectTimeInterval = [NSDate timeIntervalSinceReferenceDate];
            [self.startRecordTimerButton.imageView startAnimating];
            [self layoutIfNeeded];
            
            _recordtimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setrecordTitle:) userInfo:nil repeats:YES];

            [self.audioTool startRecord:^(GYHDAudioToolRecordState state) {
                
                switch (state) {
                    case GYHDAudioToolRecordSurpass30Seconds:
                    {
                        [_recordtimer invalidate];
                        [self.startRecordTimerButton.imageView  stopAnimating];
                        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                        [window makeToast:@"录音时间超过30秒" duration:0.25f position:CSToastPositionCenter];
                        break;
                    }
                    case GYHDAudioToolRecordProhibit:
                    {
                        
                        [_recordtimer invalidate];
                        [self.startRecordTimerButton.imageView  stopAnimating];
                        self.startPlayRecordButton.hidden = YES;
                        self.deleteRecordButton.hidden = YES;
                        self.leftLineImg.hidden=YES;
                        self.rightLineImg.hidden=YES;
                        self.startRecordTitleLabel.hidden = NO;
                        self.startRecordTimerButton.hidden = YES;
                        
                        self.startRecordTitleLabel.text = @"按住说话";
                        
                        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                        if (appName == nil) {
                            appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
                        }
                        [[[UIAlertView alloc] initWithTitle:@"无法录音" message:[NSString stringWithFormat:@"请在“设置-隐私-麦克风”选项中允许<< %@ >>访问你的麦克风",appName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                        break;
                    }
                    default:
                        break;
                }
  
            }];

            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            
            CGPoint point =[tapPress locationInView:self];
            CGFloat pad = self.bounds.size.width / 3.0f;
            DDLogCInfo(@"%f",point.x);
            if (point.x < pad) { // 左滑
                self.startPlayRecordButton.selected = YES;
                self.startRecordTimerButton.hidden = YES;
                self.startRecordTitleLabel.hidden = NO;
                self.startRecordTitleLabel.text = @"松手试听";
            }else if (point.x > pad *2) { // 右滑
                self.deleteRecordButton.selected = YES;
                self.startRecordTimerButton.hidden = YES;
                self.startRecordTitleLabel.hidden = NO;
                self.startRecordTitleLabel.text = @"松手删除";
            } else {
                self.deleteRecordButton.selected = NO;
                self.startPlayRecordButton.selected = NO;
                self.startRecordTimerButton.hidden = NO;
                self.startRecordTitleLabel.hidden = YES;
                self.startRecordTitleLabel.text = @"按住说话";
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.audioTool stopRecord];
            [_recordtimer invalidate];
            [self.startRecordTimerButton.imageView  stopAnimating];
            [self.startImageView setImage:[UIImage imageNamed:@"btn-yy_big_2"]];
            if (self.deleteRecordButton.selected) { // 右边
                self.deleteRecordButton.selected = NO;
                self.startRecordTitleLabel.text = @"按住说话";
            } else if (self.startPlayRecordButton.selected) { // 左边
                self.recordTimeString = self.startRecordTimerButton.currentTitle;
                self.endRecordView.hidden = NO;
                [self.endRecordTimerButton setTitle:self.recordTimeString forState:UIControlStateNormal];
                self.startPlayRecordButton.selected = NO;
                self.startRecordTitleLabel.text = @"按住说话";
            } else { //中间
                self.startRecordTitleLabel.hidden = NO;
                self.startRecordTimerButton.hidden = YES;

                if ([NSDate timeIntervalSinceReferenceDate] - self.recordSelectTimeInterval <= 1) {
                    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                    [window makeToast:@"录音时间太短" duration:0.25f position:CSToastPositionCenter];
                } else {
                    if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        dict[@"mp3"] = [self.audioTool mp3NameString];
                        dict[@"mp3Len"] = [NSString stringWithFormat:@"%f",self.audioTool. gettime];
                        if (dict.allKeys.count>1) {
                            
                            [self.delegate GYHDKeyboardSelectBaseView:self sendDict:dict SendType:GYHDKeyboardSelectBaseSendAudio];
                        }else{
                            
                            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                            [window makeToast:@"录音失败" duration:0.25f position:CSToastPositionCenter];
                        }
                    }
                }
            }
            self.startPlayRecordButton.hidden = YES;
            self.deleteRecordButton.hidden = YES;
            self.leftLineImg.hidden=YES;
            self.rightLineImg.hidden=YES;
            [self.startRecordTimerButton setTitle:startRecordString.copy forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }

}
/**改变显示时长*/
- (void)setrecordTitle:(NSTimer *)timer
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    NSDate *date =  [formatter dateFromString:self.startRecordTimerButton.currentTitle];
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[date timeIntervalSinceReferenceDate]+1];
    [self.startRecordTimerButton setTitle:[formatter stringFromDate:newDate] forState:UIControlStateNormal];
}


@end

