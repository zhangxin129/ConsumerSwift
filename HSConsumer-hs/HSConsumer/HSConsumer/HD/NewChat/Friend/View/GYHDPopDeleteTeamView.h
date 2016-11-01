//
//  GYHDPopDeleteTeamView.h
//  HSConsumer
//
//  Created by shiang on 16/3/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^GYHDPopDeleteTeamBlock)(NSString* message);
@interface GYHDPopDeleteTeamView : UIView
/**删除分类的名字*/
@property (nonatomic, weak) NSString* deleteTeamName;
/**设置标题 和 正文*/
- (void)setTitle:(NSString*)title Content:(NSString*)content;
/**
 * 返回Block;
 */
@property (nonatomic, copy) GYHDPopDeleteTeamBlock block;
@end
