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


@interface GYHDVideoView ()<GYHDRecordVideoDelegate,GYHDPlayVideoViewDelegate>
/**相机展示图层*/
@property(nonatomic, weak)UIView *showVideoView;
/**录制界面*/
@property(nonatomic, weak)UIView *startRecordVideoView;
/**试看按钮*/
@property(nonatomic, weak)UIButton *startPlayRecordButton;
/**开始录制*/
@property(nonatomic, weak)UIImageView *startImageView;
/**删除按钮*/
@property(nonatomic, weak)UIButton *deleteRecordButton;
/**录制视频工具*/
@property(nonatomic, strong)GYHDRecordVideoTool *recordViewTool;
/**录音提示*/
@property(nonatomic, weak)UILabel *recordNoticeLabel;
/**录音时长提示*/
@property(nonatomic, weak)UIButton *recordTimeCountButton;
/**进度条白色View*/
@property(nonatomic, weak)UIView *progressWhiteView;
/**进度条背景View*/
@property(nonatomic, weak)UIView *progressBackgroundView;
/**进度条蓝色View*/
@property(nonatomic, weak)UIView *progressBlueView;
/*调转摄像头*/
@property(nonatomic, strong)UIButton *changeCameraButton;
/*取消按钮*/
@property(nonatomic,strong)UIButton *cancelButton;

/**是否为发送*/
@property(nonatomic, assign, getter=isSendVideo)BOOL sendVideo;
/**是否为发送*/
//@property(nonatomic, assign, getter = isSendVideo) BOOL sendVideo;
/**是否为播放*/
@property(nonatomic, assign) BOOL playeVideo;

@property(nonatomic, strong)NSDictionary *sendDict;
@property(nonatomic,weak)UILabel*deleLabel;
@property(nonatomic,weak)UILabel*tryPlayLabel;

@end

@implementation GYHDVideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return self;
    self.backgroundColor = [UIColor blackColor];

//    [self setuptUp];
    [self setupCenter];
    [self setupDown];
    
    UIView *bgView=[[UIView alloc]init];
    bgView.backgroundColor=[ UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
//        bgView.backgroundColor=[UIColor redColor];
    bgView.userInteractionEnabled=YES;
    [self addSubview:bgView];
    
    @weakify(self);
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.centerX);
        
        make.top.mas_equalTo(30);
        
        make.width.mas_equalTo(300);
        
        make.height.mas_equalTo(50);
    }];
    
    
    // 录音提示
    UIButton *recordTimeCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [recordTimeCountButton setBackgroundImage:[UIImage imageNamed:@"icon_timeCount_normal"] forState:UIControlStateNormal];
    //    [recordTimeCountButton setImage:[UIImage imageNamed:@"icon_timtCount_show"] forState:UIControlStateNormal];
    [recordTimeCountButton setTitle:@"00:00:00" forState:UIControlStateNormal];
    recordTimeCountButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(40)] ;
    [bgView addSubview:recordTimeCountButton];
    _recordTimeCountButton = recordTimeCountButton;
    [recordTimeCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(12);
        make.centerX.mas_equalTo(bgView.centerX);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
    //    recordTimeCountButton.hidden = YES;
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"btn-qx_n"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"btn-qx_h"] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.cancelButton];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    self.changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeCameraButton setBackgroundImage:[UIImage imageNamed:@"btn-qh_n"] forState:UIControlStateNormal];
    [self.changeCameraButton setBackgroundImage:[UIImage imageNamed:@"btn-qh_h"] forState:UIControlStateHighlighted];
    [self.changeCameraButton addTarget:self action:@selector(changeCameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.changeCameraButton];
    [self.changeCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    


    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.recordViewTool = [[GYHDRecordVideoTool alloc] initWithView:self.showVideoView];
    self.recordViewTool.delegate = self;
}
/**顶部*/
- (void)setuptUp
{

}

- (void)cancelButtonClick
{
    [self disMiss];
}
/**中间*/
- (void)setupCenter
{
    self.userInteractionEnabled=YES;
    UIView *showVideoView = [[UIView alloc] init];
    [self addSubview:showVideoView];
    _showVideoView = showVideoView;
    
    [showVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(0);
//        make.right.mas_equalTo(-150);
//        make.center.equalTo(weakSelf);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenWidth * 2 / 3));
    }];
}

/**底部*/
- (void)setupDown
{
    //1. 录制界面
    UIView  *startRecordVideoView = [[UIView alloc] init];
    [self addSubview:startRecordVideoView];
    _startRecordVideoView = startRecordVideoView;

    [startRecordVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(150);
    }];
    startRecordVideoView.userInteractionEnabled=YES;
    startRecordVideoView.backgroundColor = [ UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
;
 
    // 开始按钮
    UIImageView *startImageView = [[UIImageView alloc] init];
    startImageView.userInteractionEnabled = YES;
    [startImageView setImage:[UIImage imageNamed:@"btn-lx_lz_n"]];
    _startImageView = startImageView;
    [startRecordVideoView addSubview:startImageView];
    [startImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.center.equalTo(startRecordVideoView);
    }];
    UILongPressGestureRecognizer *tapPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    tapPress.minimumPressDuration = 1;
    [startImageView addGestureRecognizer:tapPress];
    
    // 试看按钮
    UIButton *startPlayRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startPlayRecordButton setImage:[UIImage imageNamed:@"btn-lx_yl_n"] forState:UIControlStateNormal];
    [startPlayRecordButton setImage:[UIImage imageNamed:@"btn-lx_yl_h"] forState:UIControlStateSelected];
    [startRecordVideoView addSubview:startPlayRecordButton];
    _startPlayRecordButton = startPlayRecordButton;

    [startPlayRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-20);
        make.bottom.mas_equalTo(startImageView.centerY-100);
        make.right.mas_equalTo(-40);
        make.size.mas_equalTo(CGSizeMake(70 , 70));
    }];
    startPlayRecordButton.hidden = YES;
    /**删除录像*/
    UIButton *deleteRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteRecordButton setImage:[UIImage imageNamed:@"btn-ps_sc_n"] forState:UIControlStateNormal];
    [deleteRecordButton setImage:[UIImage imageNamed:@"btn-ps_sc_h"] forState:UIControlStateSelected];
    [startRecordVideoView addSubview:deleteRecordButton];
    _deleteRecordButton = deleteRecordButton;

    [deleteRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(20);
        make.top.mas_equalTo(startImageView.centerY+100);
        make.right.mas_equalTo(-40);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    deleteRecordButton.hidden = YES;
    // 预览提示
    UILabel *tryPlayLabel = [[UILabel alloc] init];
    tryPlayLabel.font = [UIFont systemFontOfSize:KFontSizePX(34)];
    tryPlayLabel.textColor = [UIColor whiteColor];
    tryPlayLabel.textAlignment = NSTextAlignmentCenter;
    tryPlayLabel.text = @"松手预览";
    tryPlayLabel.hidden=YES;
    [startRecordVideoView addSubview:tryPlayLabel];
    _tryPlayLabel = tryPlayLabel;
    [tryPlayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.bottom.mas_equalTo(startImageView.centerY-50);
        make.right.mas_equalTo(-40);
//        make.size.mas_equalTo(CGSizeMake(200, 70));
        
    }];
    // 删除提示
    UILabel *deleLabel = [[UILabel alloc] init];
    deleLabel.font = [UIFont systemFontOfSize:KFontSizePX(34)];
    deleLabel.textColor = [UIColor whiteColor];
    deleLabel.textAlignment = NSTextAlignmentCenter;
    deleLabel.text = @"松手删除";
    deleLabel.hidden=YES;
    [startRecordVideoView addSubview:deleLabel];
    _deleLabel = deleLabel;
    [deleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.top.mas_equalTo(startImageView.centerY+50);
        make.right.mas_equalTo(-40);
        
    }];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(34)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"按住录像";
    [startRecordVideoView addSubview:titleLabel];
    _recordNoticeLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(startImageView.centerX);
        make.centerY.mas_equalTo(startImageView.centerY).offset(80);
//        make.right.left.equalTo(startRecordVideoView);
    }];
    
    
}

#pragma mark -- 录音代理
/**录音中*/
- (void)recordViewTimeInterval:(NSTimeInterval)timelen
{
//    NSInteger time = timelen+1;
    [self.recordTimeCountButton setImage:[UIImage imageNamed:@"icon_timtCount_show"] forState:UIControlStateNormal];
//    [self.recordTimeCountButton setTitle:[NSString stringWithFormat:@" %ld\"", (long)time] forState:UIControlStateNormal];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy:mm:ss"];
    NSDate *date =  [formatter dateFromString:self.recordTimeCountButton .currentTitle];
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[date timeIntervalSinceReferenceDate]+1];
    [self.recordTimeCountButton  setTitle:[formatter stringFromDate:newDate] forState:UIControlStateNormal];
}

/**录音*/
- (void)tapPress:(UILongPressGestureRecognizer *)tapPress {
    switch (tapPress.state) {
        case UIGestureRecognizerStateBegan:
        {
                        // 开始录制视频
                        [self.recordViewTool startRecordVideoForDuration:16.0f];
            
                        [self.startImageView setImage:[UIImage imageNamed:@"btn-lx_lz_h"]];
                        self.startPlayRecordButton.hidden = NO;
                        self.deleteRecordButton.hidden = NO;
                        self.recordTimeCountButton.hidden = NO;
                        self.cancelButton.hidden=YES;
                        self.changeCameraButton.hidden=YES;
                        self.recordNoticeLabel.hidden=YES;
                        self.tryPlayLabel.hidden=YES;
                        self.deleLabel.hidden=YES;
                        break;
                    }
                        case UIGestureRecognizerStateChanged:
                    {
                        CGPoint point =[tapPress locationInView:self];
                        CGFloat pad = [UIScreen mainScreen].bounds.size.height / 3.0f;
                        if (point.y > pad *2) { // 下滑
            
                            self.startPlayRecordButton.selected = YES;
                            self.deleteRecordButton.selected = NO;
                            self.recordNoticeLabel.hidden = YES;
//                            self.recordNoticeLabel.text = @"松手预览";
                            self.deleLabel.hidden=YES;
                            self.tryPlayLabel.hidden=NO;
                        }else if (point.y<pad*2 && point.y>pad) { // 上滑
            
                            self.startPlayRecordButton.selected = NO;
                            self.deleteRecordButton.selected = NO;
                            self.recordNoticeLabel.hidden = YES;
                            self.tryPlayLabel.hidden=YES;
                            self.deleLabel.hidden=YES;
                        } else {
                            self.startPlayRecordButton.selected = NO;
                            self.deleteRecordButton.selected = YES;
                            self.recordNoticeLabel.hidden = YES;
                            self.tryPlayLabel.hidden=YES;
//                            self.recordNoticeLabel.text = @"松手删除";
                            self.deleLabel.hidden=NO;
                        }
            
                        break;
                    }
                    case UIGestureRecognizerStateEnded:
                    {

            if (self.startPlayRecordButton.selected || self.deleteRecordButton.selected) {
                if (self.startPlayRecordButton.selected) {
                    self.playeVideo = YES;
                }
                if (self.deleteRecordButton.selected) {
                    
                    self.playeVideo=NO;
                }
                self.sendVideo = NO;
            } else {
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

- (void)changeCameraButtonClick {
    [self.recordViewTool changeCamera];
}

/**结束录音*/
#pragma mark --GYHDPlayVideoViewDelegate
- (void)GYHDPlayVideoView:(GYHDPlayVideoView *)playVideoView DidSendData:(NSData *)data {
    if (!(self.startPlayRecordButton.selected && self.deleteRecordButton.selected)) {
        [self disMiss];
        if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
            [self.delegate GYHDKeyboardSelectBaseView:self sendDict:self.sendDict SendType:GYHDKeyboardSelectBaseSendVideo];
        }
    }
    
}

- (void)GYHDRecordVideoTool:(GYHDRecordVideoTool *)recordView sendDict:(NSDictionary *)dict {
    self.sendDict = dict;
    if (self.sendVideo || self.recordTimeCountButton.currentTitle.integerValue > 14) {
        [self disMiss];
        if (dict.allKeys.count > 1) {
            if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
                [self.delegate GYHDKeyboardSelectBaseView:self sendDict:self.sendDict SendType:GYHDKeyboardSelectBaseSendVideo];
            }
        }else {
           [Utils showToastMessage:@"录像失败"];
        }
        
    } else if (self.playeVideo) {
        GYHDPlayVideoView *playeView = [[GYHDPlayVideoView alloc] initWithPlayMp4Data:[self.recordViewTool mp4Data]];
        playeView.delegate = self;
        [playeView show];
    }
                // 结束录制
                [self.recordViewTool stopRecordVideo];
//                self.recordNoticeLabel.text = @"按住录像";
                self.recordNoticeLabel.hidden = NO;
    
                [self.startImageView setImage:[UIImage imageNamed:@"btn-lx_lz_n"]];
                self.startPlayRecordButton.hidden = YES;
                self.deleteRecordButton.hidden = YES;
    //            self.recordTimeCountButton.hidden = YES;
                [self.recordTimeCountButton setTitle:@"00:00:00" forState:UIControlStateNormal];
                self.deleteRecordButton.selected = NO;
                self.startPlayRecordButton.selected = NO;
                self.cancelButton.hidden=NO;
                self.changeCameraButton.hidden=NO;
    
                self.deleLabel.hidden=YES;
                self.tryPlayLabel.hidden=YES;
    
}

@end
