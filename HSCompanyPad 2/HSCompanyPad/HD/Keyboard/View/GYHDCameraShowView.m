//
//  GYHDCameraShowView.m
//  HSConsumer
//
//  Created by shiang on 16/2/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCameraShowView.h"
@interface GYHDCameraShowView ()
/**照片显示*/
@property(nonatomic, weak)UIImageView *cameraImageView;
@end

@implementation GYHDCameraShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    // 1. 显示控制器
    UIImageView *cameraImageView = [[UIImageView alloc] init];
    [self addSubview:cameraImageView];
    _cameraImageView = cameraImageView;
    cameraImageView.contentMode=UIViewContentModeScaleAspectFill;
    [cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    // 底部View
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.right.mas_equalTo(0);
        make.width.mas_equalTo(140);
    }];
    // 2. 重拍按钮
    UIButton *rephotographButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rephotographButton setBackgroundImage:[UIImage imageNamed:@"gyhd_rephotograph_btn_select"] forState:UIControlStateNormal];
    [rephotographButton setBackgroundImage:[UIImage imageNamed:@"gyhd_rephotograph_btn_unselect"] forState:UIControlStateHighlighted];
    [self addSubview:rephotographButton];
    [rephotographButton addTarget:self action:@selector(rephotographButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rephotographButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.center.equalTo(bottomView);
    }];
    //   发送按钮
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_camera_send_btn_normal"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_camera_send_btn_highlighted"] forState:UIControlStateHighlighted];
    [self addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.bottom.mas_equalTo(-50);
        make.centerX.equalTo(bottomView);
    }];
    
    
    // 3. 删除按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_camera_delete_normal"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_camera_delete_highlighted"] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.top.mas_equalTo(50);
        make.centerX.equalTo(bottomView);
    }];

}
- (void)rephotographButtonClick
{
    [self disMiss];
}

- (void)cancelButtonClick
{
    [self disMiss];
    [self.object.navigationController popViewControllerAnimated:YES];
    
}

- (void)sendButtonClick
{
    [self disMiss];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(GYHDCameraShowView:SendImageData:)]) {
        NSData *imageData = nil;
        if (UIImageJPEGRepresentation(self.cameraImageView.image, 0.5)) {
            imageData = UIImageJPEGRepresentation(self.cameraImageView.image, 0.5);
        } else {
            imageData = UIImagePNGRepresentation(self.cameraImageView.image);
        }
        [self.delegate GYHDCameraShowView:self SendImageData:imageData];
    }
}
- (void)disMiss
{
    [self removeFromSuperview];
}
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
}
- (void)setImage:(UIImage *)image
{
    self.cameraImageView.image = image;
}

@end
