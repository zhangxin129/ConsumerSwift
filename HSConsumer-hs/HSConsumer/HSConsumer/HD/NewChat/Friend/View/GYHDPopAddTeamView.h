//
//  GYHDPopAddTeamView.h
//  HSConsumer
//
//  Created by shiang on 16/3/21.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GYHDPopAddTeamBlock)(NSString* message);
@interface GYHDPopAddTeamView : UIView
/**设置标题*/
- (void)setTitle:(NSString*)title;
/**等待字*/
- (void)setPlaceholder:(NSString*)placeholder;
/**默认字*/
- (void)setDefaulText:(NSString*)string;
/**输入最大字符数*/
@property (nonatomic, assign) NSInteger maxCharCount;
/**
 * 返回Block;
 */
@property (nonatomic, copy) GYHDPopAddTeamBlock block;

@end
