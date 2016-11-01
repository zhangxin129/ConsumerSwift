//
//  GYHDTimeOutModel.h
//  HSCompanyPad
//
//  Created by Yejg on 16/10/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 * 本model是为了把未能成功发送出去的包等待15秒，15秒后还没能成功发送的，把对应的消息cell前的转圈变红色的叹号。如果能发送成功的话，转圈或叹号消失。
 */
#import <Foundation/Foundation.h>

@interface GYHDTimeOutModel : NSObject

// 每秒加1，15秒的时候就停止加一，并且把对应的消息cell前的转圈变红色的叹号。
@property(nonatomic, assign) int counter;
@property(nonatomic, strong) NSString * strMsguid;

- (instancetype)initWithMsguid:(NSString*)msguid;

@end
