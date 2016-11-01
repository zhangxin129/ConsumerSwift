//
//  GYHDAddFriendDetailViewController.h
//  HSConsumer
//
//  Created by shiang on 16/4/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^btnClickBlock)(UIViewController* viewController);
@interface GYHDAddFriendDetailViewController : UIViewController
@property (nonatomic, strong) NSDictionary* bodyDict;
@property (nonatomic, copy) btnClickBlock block;
@property (nonatomic, assign) BOOL hidenSendButton;
@end
