//
//  GYHDChatVideoShowView.m
//  HSConsumer
//
//  Created by shiang on 16/3/7.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDChatVideoShowView.h"
#import "GYHDRecordVideoTool.h"

@interface GYHDChatVideoShowView ()
@property(nonatomic , strong)GYHDRecordVideoTool *playeVideo;
@property(nonatomic, strong)NSURL *playUrl;
@end



@implementation GYHDChatVideoShowView
- (GYHDRecordVideoTool *)playeVideo {
    if (!_playeVideo) {
        _playeVideo = [[GYHDRecordVideoTool alloc] init];
    }
    return _playeVideo;
}
- (void)setVideoWithUrl:(NSURL *)url {
    _playUrl = url;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor blackColor];
    [self.playeVideo playVideoWithView:self Url:self.playUrl];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.playeVideo playerVideo];
    });
}
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self disMiss];
}
- (void)disMiss {
    [self removeFromSuperview];
}
@end
