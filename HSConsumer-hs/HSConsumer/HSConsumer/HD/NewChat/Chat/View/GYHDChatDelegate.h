//
//  GYHDChatDelegate.h
//  HSConsumer
//
//  Created by shiang on 16/3/5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GYHDChatTapType) {
    GYHDChatTapUserIcon,
    GYHDChatTapResendButton,
    GYHDChatTapChatText,
    GYHDChatTapChatImage,
    GYHDChatTapChatVideo,
    GYHDChatTapChatAudio,
    GYHDChatTapChatMap
};

typedef NS_ENUM(NSInteger, GYHDChatSelectOption) {
    GYHDChatSelectDelete,
    GYHDChatSelectResend,
    GYHDChatSelectCopye
};
@class GYHDNewChatModel;
@protocol GYHDChatDelegate <NSObject>
/**点击*/
- (void)GYHDChatView:(UIView*)view tapType:(GYHDChatTapType)type chatModel:(GYHDNewChatModel*)chatModel;
/**长按*/
- (void)GYHDChatView:(UIView*)view longTapType:(GYHDChatTapType)type selectOption:(GYHDChatSelectOption)option chatMessageID:(NSString*)chatMessageID;
@end


