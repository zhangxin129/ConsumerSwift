//
//  GYHDPlayVideoView.h
//  HSConsumer
//
//  Created by shiang on 16/2/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHDPlayVideoView;
@protocol GYHDPlayVideoViewDelegate <NSObject>

- (void)GYHDPlayVideoView:(GYHDPlayVideoView*)playVideoView DidSendData:(NSData*)data;

@end

@interface GYHDPlayVideoView : UIView
@property (nonatomic, weak) id<GYHDPlayVideoViewDelegate> delegate;
/**播放MP4*/
- (instancetype)initWithPlayMp4Data:(NSData*)data;
//- (instancetype)initWIthPlayMp4Path:(NSString *)mp4Path;
- (void)show;
@end
