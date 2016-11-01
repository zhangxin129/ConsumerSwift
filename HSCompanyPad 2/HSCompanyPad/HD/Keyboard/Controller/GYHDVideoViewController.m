//
//  GYHDVideoViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDVideoViewController.h"
#import "GYHDRecordVideoTool.h"
#import "GYHDPlayVideoView.h"
@interface GYHDVideoViewController ()<GYHDPlayVideoViewDelegate,GYHDRecordVideoDelegate>
/**相机展示图层*/
@property(nonatomic, strong)UIView *showVideoView;
/**录制界面*/
@property(nonatomic, strong)UIView *startRecordVideoView;
/**试看按钮*/
@property(nonatomic, strong)UIButton *startPlayRecordButton;
/**开始录制*/
@property(nonatomic, strong)UIImageView *startImageView;
/**删除按钮*/
@property(nonatomic, strong)UIButton *deleteRecordButton;
/**录制视频工具*/
@property(nonatomic, strong)GYHDRecordVideoTool *recordViewTool;
/**录音提示*/
@property(nonatomic, strong)UILabel *recordNoticeLabel;
/**录音时长提示*/
@property(nonatomic, strong)UIButton *recordTimeCountButton;
/*调转摄像头*/
@property(nonatomic, strong)UIButton *changeCameraButton;
/**是否为发送*/
@property(nonatomic, assign, getter=isSendVideo)BOOL sendVideo;
/**是否为播放*/
@property(nonatomic, assign) BOOL playeVideo;

@property(nonatomic, strong)NSDictionary *sendDict;
@property(nonatomic,strong)UILabel*deleLabel;
@property(nonatomic,strong)UILabel*tryPlayLabel;
@end

@implementation GYHDVideoViewController


-(void)setup{

    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2-100, 74, 200, 50)];
    bgView.backgroundColor=[ UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
    bgView.userInteractionEnabled=YES;
    
    [self.view addSubview:bgView];
    
    // 录音提示
    self.recordTimeCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.recordTimeCountButton setTitle:@"00:00:00" forState:UIControlStateNormal];
     self.recordTimeCountButton.titleLabel.font = kFont40 ;
    [bgView addSubview: self.recordTimeCountButton];
    [ self.recordTimeCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(12);
        make.centerX.equalTo(bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
    
    self.changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeCameraButton setBackgroundImage:[UIImage imageNamed:@"gyhd_change_camera_btn_normal"] forState:UIControlStateNormal];
    [self.changeCameraButton setBackgroundImage:[UIImage imageNamed:@"gyhd_change_camera_btn_highlighted"] forState:UIControlStateHighlighted];
    [self.changeCameraButton addTarget:self action:@selector(changeCameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.changeCameraButton];
    [self.changeCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];


}

/**底部*/
- (void)setupDown
{
    @weakify(self);
    //1. 录制界面
    self.startRecordVideoView = [[UIView alloc] init];
    [self.view addSubview:self.startRecordVideoView];
    
    [self.startRecordVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(150);
    }];
    self.startRecordVideoView.userInteractionEnabled=YES;
    self.startRecordVideoView.backgroundColor = [ UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
    ;
    
    // 开始按钮
    self.startImageView = [[UIImageView alloc] init];
    self.startImageView .userInteractionEnabled = YES;
    self.startImageView.image=[UIImage imageNamed:@"gyhd_start_video_btn_normal"];
    [self.startRecordVideoView addSubview:self.startImageView ];
    [self.startImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.center.equalTo(self.startRecordVideoView);
    }];
    UILongPressGestureRecognizer *tapPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    tapPress.minimumPressDuration = 1;
    [self.startImageView addGestureRecognizer:tapPress];
    
    // 试看按钮
    self.startPlayRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startPlayRecordButton setImage:[UIImage imageNamed:@"gyhd_player_video_btn_normal"] forState:UIControlStateNormal];
    [self.startPlayRecordButton setImage:[UIImage imageNamed:@"gyhd_player_video_btn_select"] forState:UIControlStateSelected];
    [self.startRecordVideoView addSubview:self.startPlayRecordButton];
    
    [self.startPlayRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.startImageView.centerY-100);
        make.right.mas_equalTo(-40);
        make.size.mas_equalTo(CGSizeMake(70 , 70));
    }];
    self.startPlayRecordButton.hidden = YES;
    /**删除录像*/
    self.deleteRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.deleteRecordButton setImage:[UIImage imageNamed:@"gyhd_video_delete_btn_normal"] forState:UIControlStateNormal];
    [ self.deleteRecordButton setImage:[UIImage imageNamed:@"gyhd_video_delete_btn_selected"] forState:UIControlStateSelected];
    [self.startRecordVideoView addSubview: self.deleteRecordButton];
    
    [ self.deleteRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.startImageView.centerY+100);
        make.right.mas_equalTo(-40);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    self.deleteRecordButton.hidden = YES;
    // 预览提示
    self.tryPlayLabel = [[UILabel alloc] init];
    self.tryPlayLabel.font =kFont34;
    self.tryPlayLabel.textColor = [UIColor whiteColor];
    self.tryPlayLabel.textAlignment = NSTextAlignmentCenter;
    self.tryPlayLabel.text = kLocalized(@"GYHD_Go_Of_The_Preview");
    self.tryPlayLabel.hidden=YES;
    [self.startRecordVideoView addSubview:self.tryPlayLabel];
    [self.tryPlayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.startImageView.centerY-50);
        make.right.mas_equalTo(-40);
    }];
    // 删除提示
    self.deleLabel = [[UILabel alloc] init];
    self.deleLabel.font = kFont34;
    self.deleLabel.textColor = [UIColor whiteColor];
    self.deleLabel.textAlignment = NSTextAlignmentCenter;
    self.deleLabel.text = kLocalized(@"GYHD_Go_Delete");
    self.deleLabel.hidden=YES;
    [self.startRecordVideoView addSubview:self.deleLabel];
    [self.deleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.startImageView.centerY+50);
        make.right.mas_equalTo(-40);
        
    }];
    
    // 标题
    self.recordNoticeLabel = [[UILabel alloc] init];
    self.recordNoticeLabel.font =kFont34;
    self.recordNoticeLabel.textColor = [UIColor whiteColor];
    self.recordNoticeLabel.textAlignment = NSTextAlignmentCenter;
    self.recordNoticeLabel.text = kLocalized(@"GYHD_Hold_The_Video");
    [self.startRecordVideoView addSubview:self.recordNoticeLabel];
    [self.recordNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.startImageView.centerX);
        make.centerY.mas_equalTo(self.startImageView.centerY).offset(80);

    }];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self setup];
    [self setupDown];
    
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
//    [self setupCenter];
    self.recordViewTool = [[GYHDRecordVideoTool alloc] initWithView:self.view];
    self.recordViewTool.delegate = self;
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHD_Videotape");
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]init]];
    self.view.backgroundColor=[UIColor blackColor];
    DDLogInfo(@"Load Controller: %@", [self class]);
}

/**中间*/
- (void)setupCenter
{
    self.view.userInteractionEnabled=YES;
    self.showVideoView = [[UIView alloc] init];
    self.showVideoView.userInteractionEnabled=YES;
    [self.view addSubview:self.showVideoView];
    [self.showVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(0);

    }];
}

#pragma mark -- 录音代理
/**录音中*/
- (void)recordViewTimeInterval:(NSTimeInterval)timelen
{
    
    [self.recordTimeCountButton setImage:[UIImage imageNamed:@"gyhd_timtCount_show_icon"] forState:UIControlStateNormal];

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
            
            self.startImageView.image=[UIImage imageNamed:@"gyhd_start_video_btn_normal"];
            self.startPlayRecordButton.hidden = NO;
            self.deleteRecordButton.hidden = NO;
            self.recordTimeCountButton.hidden = NO;
            self.changeCameraButton.hidden=YES;
            self.recordNoticeLabel.hidden=YES;
            self.tryPlayLabel.hidden=YES;
            self.deleLabel.hidden=YES;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point =[tapPress locationInView:self.view];
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
        [self.navigationController popViewControllerAnimated:YES];
        if (self.bloclk) {
            
            self.bloclk(self.sendDict);
        }
    }
}

- (void)GYHDRecordVideoTool:(GYHDRecordVideoTool *)recordView sendDict:(NSDictionary *)dict {
    self.sendDict = dict;
    if (self.sendVideo || self.recordTimeCountButton.currentTitle.integerValue > 14) {
        [self.navigationController popViewControllerAnimated:YES];
        if (dict.allKeys.count > 1) {
            if (self.bloclk) {
                
                self.bloclk(self.sendDict);
            }
        }else {
            [GYUtils showToast:kLocalized(@"GYHD_Video_Failed")];
        }
        
    } else if (self.playeVideo) {
        GYHDPlayVideoView *playeView = [[GYHDPlayVideoView alloc] initWithPlayMp4Data:[self.recordViewTool mp4Data]];
        playeView.delegate = self;
        [playeView show];
    }
    // 结束录制
    [self.recordViewTool stopRecordVideo];
    self.recordNoticeLabel.hidden = NO;
    self.startImageView.image=[UIImage imageNamed:@"gyhd_start_video_btn_normal"];
    self.startPlayRecordButton.hidden = YES;
    self.deleteRecordButton.hidden = YES;
    [self.recordTimeCountButton setTitle:@"00:00:00" forState:UIControlStateNormal];
    self.deleteRecordButton.selected = NO;
    self.startPlayRecordButton.selected = NO;
    self.changeCameraButton.hidden=NO;
    self.deleLabel.hidden=YES;
    self.tryPlayLabel.hidden=YES;
    
}
@end
