//
//  GYHDCameraView.m
//  HSConsumer
//
//  Created by shiang on 16/2/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCameraView.h"
#import "GYHDRecordVideoTool.h"
#import "GYHDCameraShowView.h"

@interface GYHDCameraView ()<GYHDCameraShowViewDelegate>
/**录制照片*/
@property(nonatomic, strong)GYHDRecordVideoTool *recordCamera;
@property(nonatomic, weak)UIView *showCameraView;
@end

@implementation GYHDCameraView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.showCameraView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
//        make.left.mas_equalTo(80);
//        make.right.mas_equalTo(-150);
    }];
    self.recordCamera = [[GYHDRecordVideoTool alloc] initWithCameraView:self.showCameraView];
}
- (void)setup
{
    
    //3. 显示界面
    UIView *showCameraView = [[UIView alloc] init];
    [self addSubview:showCameraView];
    _showCameraView = showCameraView;
    UIView *bgView=[[UIView alloc]init];
    bgView.backgroundColor=[ UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
    bgView.userInteractionEnabled=YES;
    [self addSubview:bgView];

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.mas_equalTo(0);
        
        make.width.mas_equalTo(80);
    }];

    //2. 切换相机
    UIButton *changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeCameraButton setBackgroundImage:[UIImage imageNamed:@"btn-qh_n"] forState:UIControlStateNormal];
    [changeCameraButton setBackgroundImage:[UIImage imageNamed:@"btn-qh_h"] forState:UIControlStateHighlighted];
    [changeCameraButton addTarget:self action:@selector(changeCameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:changeCameraButton];
    [changeCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(bgView.centerY);
    }];
    
    //4 拍照按钮
    UIView *recordPhotoView = [[UIView alloc] init];
    recordPhotoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    [self addSubview:recordPhotoView];
    [recordPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.right.mas_equalTo(0);
        make.width.mas_equalTo(150);
//        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    //1。取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"camera_sc_n"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"camera_sc_h"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(-40);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
//    // 确认按钮
//    
//    UIButton *comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [comfirmButton setBackgroundImage:[UIImage imageNamed:@"camera_qd_h"] forState:UIControlStateNormal];
//    [comfirmButton setBackgroundImage:[UIImage imageNamed:@"camera_qd_n"] forState:UIControlStateHighlighted];
//    [comfirmButton addTarget:self action:@selector(comfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:comfirmButton];
    
//    [comfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(20);
//        make.centerX.mas_equalTo(recordPhotoView.centerX);
//    }];
    
    
    UIButton *recordPhotoButton = [[UIButton alloc] init];
    [recordPhotoButton setBackgroundImage:[UIImage imageNamed:@"btn-ps_n"] forState:UIControlStateNormal];
    [recordPhotoButton setBackgroundImage:[UIImage imageNamed:@"btn-ps_h"] forState:UIControlStateHighlighted];
    [recordPhotoButton addTarget:self action:@selector(recordPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [recordPhotoView addSubview:recordPhotoButton];
    [recordPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(recordPhotoView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    
    [self.showCameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
}
- (void)recordPhotoButtonClick
{
    DDLogCInfo(@"拍照");
    [self.recordCamera startRecordCamera];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GYHDCameraShowView *showView = [[GYHDCameraShowView alloc] init];
        showView.delegate = self;
        showView.dele=self;
        [showView show];
        UIImage *image = [UIImage imageWithData:[self.recordCamera imageData]];

        [showView setImage: image];
    });
}
- (void)changeCameraButtonClick
{
    [self.recordCamera changeCamera];
}

- (void)cancelButtonClick
{
    [self disMiss];
}
- (void)GYHDCameraShowView:(UIView *)cameraShowView SendImageData:(NSData *)imageData
{
    [self disMiss];
    if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
        [self.delegate GYHDKeyboardSelectBaseView:self sendDict:[self.recordCamera imagePathDict] SendType:GYHDKeyboardSelectBaseSendPhoto];
    }
}

@end
