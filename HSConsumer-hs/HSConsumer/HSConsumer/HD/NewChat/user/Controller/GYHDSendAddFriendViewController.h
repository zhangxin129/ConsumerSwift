//
//  GYHDSendAddFriendViewController.h
//  HSConsumer
//
//  Created by shiang on 16/4/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sendTextBlock)(NSString* string);
@interface GYHDSendAddFriendViewController : GYViewController

@property (nonatomic, copy) sendTextBlock block;
@end
