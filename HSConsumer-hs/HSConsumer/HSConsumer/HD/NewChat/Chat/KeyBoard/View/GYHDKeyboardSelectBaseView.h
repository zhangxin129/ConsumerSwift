//
//  GYHDKeyboardSelectBaseView.h
//  HSConsumer
//
//  Created by shiang on 16/3/3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYHDKeyboardSelectBaseSendOption) {
    GYHDKeyboardSelectBaseSendText,
    GYHDKeyboardSelectBaseSendAudio,
    GYHDKeyboardSelectBaseSendVideo,
    GYHDKeyboardSelectBaseSendPhoto,
};

@class GYHDKeyboardSelectBaseView;
@protocol GYHDKeyboardSelectBaseViewDelegate <NSObject>
- (void)GYHDKeyboardSelectBaseView:(GYHDKeyboardSelectBaseView*)view sendDict:(NSDictionary*)dict SendType:(GYHDKeyboardSelectBaseSendOption)type;
@end

@interface GYHDKeyboardSelectBaseView : UIView
@property (nonatomic, weak) id<GYHDKeyboardSelectBaseViewDelegate> delegate;
- (void)show;
- (void)disMiss;
@end
