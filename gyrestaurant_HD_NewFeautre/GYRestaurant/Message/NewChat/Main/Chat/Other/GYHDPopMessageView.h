//
//  GYHDPopMessageView.h
//  company
//
//  Created by Yejg on 16/6/16.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDMessageCenter.h"
typedef void(^messageChildBlock)(NSString *message);

@interface GYHDPopMessageView : UIView


/**
 * 返回Block;
 */
@property(nonatomic, copy)messageChildBlock block;
/**
 * 数组为弹出消息的详细内容
 */
- (instancetype)initWithMessageArray:(NSArray *)array;
@end


