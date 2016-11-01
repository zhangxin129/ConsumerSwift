//
//  GYHDPhotoShowView.m
//  HSConsumer
//
//  Created by shiang on 16/2/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPhotoShowView.h"
#import "GYHDMessageCenter.h"
#import <AssetsLibrary/AssetsLibrary.h>
//  GYMessageCenter.h


@interface GYHDPhotoShowView ()
/**显示图片控制器*/
@property(nonatomic, weak)UIImageView *photoImageView;
@end

@implementation GYHDPhotoShowView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
        [self setup];
    }
    return self;
}
- (void)setup
{

    
    //2. 显示ImageView;
    UIImageView *photoImgaeView = [[UIImageView alloc] init];
    photoImgaeView.backgroundColor = [UIColor blackColor];
    photoImgaeView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:photoImgaeView];
    _photoImageView = photoImgaeView;
    [photoImgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    //3. 发送按钮
    UIButton *sendButton = [[UIButton alloc] init];
    
    sendButton.backgroundColor = [UIColor whiteColor];
    [sendButton setTitleColor:[UIColor colorWithRed:0 green:167.0/255.0 blue:215.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self addSubview:sendButton];
    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    //4. 展示图片
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor whiteColor];
    [self addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    UIButton *navbutton = [[UIButton alloc] init];
    navbutton.backgroundColor = [UIColor whiteColor];
    [navbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [navbutton setTitle:@"照片" forState:UIControlStateNormal];
    [navbutton setImage:[UIImage imageNamed:@"hd_nav_leftView_back"] forState:UIControlStateNormal];
    [navView addSubview:navbutton];
    [navbutton addTarget:self action:@selector(navButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
}
- (void)sendButtonClick
{
    if ([self.delegate respondsToSelector:@selector(GYHDPhotoShowView:SendImageData:)]) {
        
        UIImage *image = nil;
        
        if (self.photoImageView.image.size.width >1080 || self.photoImageView.image.size.height > 1080) {
            image =  [Utils imageCompressForWidth:self.photoImageView.image targetWidth:1080];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        } else {
            image = self.photoImageView.image;
        }
        NSData *imageData = nil;
        if (UIImageJPEGRepresentation(image, 0.5)) {
            imageData = UIImageJPEGRepresentation(image, 0.5);
        } else {
            imageData = UIImagePNGRepresentation(image);
        }
        [self.delegate GYHDPhotoShowView:self SendImageData:imageData];
    }
    [self disMiss];
}

- (void)navButtonClick
{
    [self disMiss];
}
- (void)setImage:(UIImage *)image
{
    self.photoImageView.image = image;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
}
- (void)disMiss
{
    [self removeFromSuperview];
}
@end
