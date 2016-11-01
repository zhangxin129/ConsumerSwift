//
//  GYHDPopMessageTopView.h
//  HSConsumer
//
//  Created by shiang on 16/1/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDMessageCenter.h"
typedef void (^messageChildBlock)(NSString* message);
@interface GYHDPopMessageTopView : UIView
/**
 * 返回Block;
 */
@property (nonatomic, copy) messageChildBlock block;
/**
 * 数组为弹出消息的详细内容
 */
- (instancetype)initWithMessageArray:(NSArray *)array;
@end
