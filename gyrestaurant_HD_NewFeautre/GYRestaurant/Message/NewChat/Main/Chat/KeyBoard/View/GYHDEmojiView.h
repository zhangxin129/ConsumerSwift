//
//  GYHDEmojiView.h
//  HSConsumer
//
//  Created by shiang on 16/2/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GYHDEmojiView;

@protocol GYHDEmojiViewDelegate <NSObject>
@optional
- (void)GYHDEmojiView:(GYHDEmojiView *)emojiView selectEmojiName:(NSString *)emojiName;
- (void)GYHDemojiVIewSendMessage;
@end

@interface GYHDEmojiView : UIView
@property(nonatomic, weak) id<GYHDEmojiViewDelegate> delegate;
@end
