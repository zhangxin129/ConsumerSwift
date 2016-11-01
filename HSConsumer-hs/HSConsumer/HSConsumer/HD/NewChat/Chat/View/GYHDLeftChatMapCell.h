//
//  GYHDLeftChatMapCell.h
//  HSConsumer
//
//  Created by shiang on 16/7/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDChatDelegate.h"

@class GYHDNewChatModel;
@interface GYHDLeftChatMapCell : UITableViewCell
@property (nonatomic, weak) GYHDNewChatModel* chatModel;
@property (nonatomic, weak) id<GYHDChatDelegate> delegate;
@end
