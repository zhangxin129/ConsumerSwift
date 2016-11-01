//
//  GYHDMoveFriendViewController.h
//  HSConsumer
//
//  Created by shiang on 16/3/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GYHDMoveFriendViewControllerBlock)(NSString* message);
typedef void (^GYHDMoveFriendViewControllerArrayBlock)(NSArray* modelArray);
@interface GYHDMoveFriendViewController : GYViewController
/**设置标题*/
- (void)movieTitle:(NSString*)title;
/**组ID*/
@property (nonatomic, copy) NSString* teamID;
/**moveID*/
@property (nonatomic, copy) NSString* moveString;
/**选中的custID 例如 06033110123,06033110124*/
@property (nonatomic, copy) NSString *selectCustIDString;
@property (nonatomic, copy) GYHDMoveFriendViewControllerBlock block;
@property (nonatomic, copy) GYHDMoveFriendViewControllerArrayBlock arrayblock;
@end
