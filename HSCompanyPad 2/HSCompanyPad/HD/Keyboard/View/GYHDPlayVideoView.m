//
//  GYHDPlayVideoView.m
//  HSConsumer
//
//  Created by shiang on 16/2/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPlayVideoView.h"
#import "GYHDRecordVideoTool.h"

@interface GYHDPlayVideoView ()
/**mp4Data*/
@property(nonatomic, strong)NSData *Data;
/**显示播放的View*/
@property(nonatomic, strong)UIView *playerVideoView;
/**播放工具*/
@property(nonatomic, strong)GYHDRecordVideoTool *recordViewTool;
/**播放按钮*/
@property(nonatomic, strong)UIButton *playVideoButton;
/**暂停按钮*/
@property(nonatomic, strong)UIButton *pauseVideoButton;
/**发送按钮*/
@property(nonatomic, strong)UIButton *sendVideoButton;
/**取消按钮*/
@property(nonatomic, strong)UIButton *cancelButton;
/**文件名字*/
@property(nonatomic, copy)NSString *fileName;
@end

@implementation GYHDPlayVideoView
- (GYHDRecordVideoTool *)recordViewTool
{
    if (!_recordViewTool) {
        _recordViewTool = [[GYHDRecordVideoTool alloc] init];
    }
    return _recordViewTool;
}
- (instancetype)initWithPlayMp4Data:(NSData *)data
{
    self = [super init];
    if (!self) return self;
    [self setup];
    _Data = data;
    self.backgroundColor = [UIColor blackColor];
    return  self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.playerVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(0);

    }];
    [self.recordViewTool playRecordVideoWithView:self.playerVideoView Data:self.Data];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_recordViewTool playerVideo];
    });
    
}
- (void)setup
{
    @weakify(self);
    self.playerVideoView = [[UIView alloc] init];
    [self addSubview:self.playerVideoView ];
    
    [self.playerVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(-20);
        make.bottom.mas_equalTo(20);

    }];

    UIView *bgView=[[UIView alloc]init];
    bgView.backgroundColor=[ UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
    bgView.userInteractionEnabled=YES;
    [self addSubview:bgView];
    
  
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
        
    }];
    
    //1. 播放按钮
    self.playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playVideoButton setBackgroundImage:[UIImage imageNamed:@"btn_lx_bf_n"] forState:UIControlStateNormal];
    [self.playVideoButton setBackgroundImage:[UIImage imageNamed:@"btn_lx_bf_h"] forState:UIControlStateHighlighted];
    [self.playVideoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.playVideoButton];
    [self.playVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(bgView);
    make.size.mas_equalTo(CGSizeMake(35, 35));
        
    }];
    self.playVideoButton.hidden = YES;
    
    //1. 取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_video_delete_btn_normal"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_video_delete_btn_selected"] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.playerVideoView .mas_centerY).offset(50);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
//    //2. 暂停按钮
//    UIButton *pauseVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [pauseVideoButton setBackgroundImage:[UIImage imageNamed:@"btn_lx_zt_n"] forState:UIControlStateNormal];
//    [pauseVideoButton setBackgroundImage:[UIImage imageNamed:@"btn_lx_zt_h"] forState:UIControlStateHighlighted];
//    [pauseVideoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:pauseVideoButton];
//    _pauseVideoButton = pauseVideoButton;
//    [pauseVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.equalTo(playVideoButton);
//    }];
    //3. 发送按钮
    self.sendVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendVideoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send_video_btn_normal"] forState:UIControlStateNormal];
    [self.sendVideoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send_video_btn_highlighted"] forState:UIControlStateHighlighted];
    [self.sendVideoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.sendVideoButton];
    
    [self.sendVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.playerVideoView .mas_centerY).offset(-50);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    
}
- (void)buttonClick:(UIButton *)button
{
    if ([button  isEqual:self.playVideoButton]) {
        self.playVideoButton.hidden = YES;
        self.pauseVideoButton.hidden = NO;
        [self.recordViewTool playerVideo];
    } else if ([button isEqual:self.pauseVideoButton]) {
        self.playVideoButton.hidden = NO;
        self.pauseVideoButton.hidden = YES;
        [self.recordViewTool pauseVideo];
    } else if ([button isEqual:self.sendVideoButton]) {
        [self disMiss];
        if ([self.delegate respondsToSelector:@selector(GYHDPlayVideoView:DidSendData:)]) {
            [self.delegate GYHDPlayVideoView:self DidSendData:self.Data];
        }
    } else if ([button isEqual:self.cancelButton]) {
        [self disMiss];
    }
}
- (void)disMiss
{
    [self removeFromSuperview];
}
- (void)show
{
    UIWindow *wind = [UIApplication sharedApplication].windows.lastObject;
    [wind addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}
@end
