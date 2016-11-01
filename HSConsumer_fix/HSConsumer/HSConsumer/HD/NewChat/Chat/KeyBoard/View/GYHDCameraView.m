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
#import "Masonry.h"

@interface GYHDCameraView () <GYHDCameraShowViewDelegate>
/**录制照片*/
@property (nonatomic, strong) GYHDRecordVideoTool* recordCamera;
@property (nonatomic, weak) UIView* showCameraView;
@end

@implementation GYHDCameraView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.showCameraView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    self.recordCamera = [[GYHDRecordVideoTool alloc] initWithCameraView:self.showCameraView];
}

- (void)setup
{
    //3. 显示界面
    UIView* showCameraView = [[UIView alloc] init];
    [self addSubview:showCameraView];
    _showCameraView = showCameraView;

    //1。取消按钮
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_cancel_camera_btn_normal"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_cancel_camera_btn_highlighted"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];

    [cancelButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.mas_equalTo(20);
    }];
    //2. 切换相机
    UIButton* changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeCameraButton setBackgroundImage:[UIImage imageNamed:@"gyhd_change_camera_btn_normal"] forState:UIControlStateNormal];
    [changeCameraButton setBackgroundImage:[UIImage imageNamed:@"gyhd_change_camera_btn_highlighted"] forState:UIControlStateHighlighted];
    [changeCameraButton addTarget:self action:@selector(changeCameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changeCameraButton];
    [changeCameraButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(20);
    }];

    //4 拍照按钮
    UIView* recordPhotoView = [[UIView alloc] init];
    recordPhotoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    [self addSubview:recordPhotoView];
    [recordPhotoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(135);
    }];

    UIButton* recordPhotoButton = [[UIButton alloc] init];
    [recordPhotoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_camera_record_btn_normal"] forState:UIControlStateNormal];
    [recordPhotoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_camera_record_btn_highlighted"] forState:UIControlStateHighlighted];
    [recordPhotoButton addTarget:self action:@selector(recordPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [recordPhotoView addSubview:recordPhotoButton];
    [recordPhotoButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(recordPhotoView);
    }];

    [self.showCameraView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)recordPhotoButtonClick
{

    [self.recordCamera startRecordCamera];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GYHDCameraShowView *showView = [[GYHDCameraShowView alloc] init];
        showView.delegate = self;
        [showView show];
        UIImage *image = [UIImage imageWithData:[self.recordCamera imageData]];

        [showView setImage:image];
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

- (void)GYHDCameraShowView:(UIView*)cameraShowView SendImageData:(NSData*)imageData
{
    [self disMiss];
    if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
        [self.delegate GYHDKeyboardSelectBaseView:self sendDict:[self.recordCamera imagePathDict] SendType:GYHDKeyboardSelectBaseSendPhoto];
    }
}

@end
