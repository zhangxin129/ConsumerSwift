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
#import "Masonry.h"

@interface GYHDCameraShowView ()
/**照片显示*/
@property (nonatomic, weak) UIImageView* cameraImageView;
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
    UIImageView* cameraImageView = [[UIImageView alloc] init];
    [self addSubview:cameraImageView];
    _cameraImageView = cameraImageView;
    [cameraImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    // 底部View
    UIView* bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(135);
    }];
    // 2. 删除按钮
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_camera_delete_btn_normal"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"gyhd_camera_delete_btn_Highlighted"] forState:UIControlStateHighlighted];
    [self addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(bottomView);
    }];
    // 3. 发送按钮
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_camera_send_btn_normal"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_camera_send_btn_Highlighted"] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
    [sendButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(bottomView);
    }];
}

- (void)cancelButtonClick
{
    [self disMiss];
}

- (void)sendButtonClick
{
    [self disMiss];
    if ([self.delegate respondsToSelector:@selector(GYHDCameraShowView:SendImageData:)]) {
        NSData* imageData = nil;
        if (UIImageJPEGRepresentation(self.cameraImageView.image, 0.5)) {
            imageData = UIImageJPEGRepresentation(self.cameraImageView.image, 0.5);
        }
        else {
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
    UIWindow* window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)setImage:(UIImage*)image
{
    self.cameraImageView.image = image;
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
   }
 */

@end
