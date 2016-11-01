//
//  GYHDInputView.h
//  HSConsumer
//
//  Created by shiang on 16/2/2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYHDInputeViewSendType) {
    GYHDInputeViewSendText,
    GYHDInputeViewSendAudio,
    GYHDInputeViewSendVideo,
    GYHDInputeViewSendPhoto,
    GYHDInputeViewSendGPS,
};
@class GYHDInputView;
@protocol GYHDInputViewDelegate <NSObject>
/**dict key为发送类型，value为发送值*/
- (void)GYHDInputView:(GYHDInputView *)inputView sendDict:(NSDictionary *)dict SendType:(GYHDInputeViewSendType) type;
@end

@interface GYHDInputView : UIView
@property(nonatomic, weak)id<GYHDInputViewDelegate> delegate;
- (void)dismissKeyBoard;
- (void)showToSuperView:(UIView *)mySuperView;
- (void)disMiss;
@end
