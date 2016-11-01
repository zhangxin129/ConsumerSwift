//
//  GYHDMoveFriendViewController.h
//  HSConsumer
//
//  Created by shiang on 16/3/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GYHDMoveFriendViewControllerBlock)(NSString* message);
@interface GYHDMoveFriendViewController : UIViewController
/**设置标题*/
- (void)movieTitle:(NSString*)title;
/**组ID*/
@property (nonatomic, copy) NSString* teamID;
/**moveID*/
@property (nonatomic, copy) NSString* moveString;
@property (nonatomic, copy) GYHDMoveFriendViewControllerBlock block;

@end
