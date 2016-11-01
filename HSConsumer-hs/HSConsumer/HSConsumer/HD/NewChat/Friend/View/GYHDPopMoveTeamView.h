//
//  GYHDPopMoveTeamView.h
//  HSConsumer
//
//  Created by shiang on 16/3/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GYHDPopMoveTeamBlock)(NSString* message);
@interface GYHDPopMoveTeamView : UIView
/**设置标题*/
- (void)settitle:(NSString*)title;
/**数据源*/
- (void)setDataSource:(NSArray*)array;
/**
 * 返回Block;
 */
@property (nonatomic, copy) GYHDPopMoveTeamBlock block;
@end
