//
//  GYHDAddMarkViewController.h
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^markNameBlcok)(NSString*markName);
@interface GYHDAddMarkViewController : GYViewController
/**默认文字*/
@property(nonatomic, copy)NSString *defaultString;
@property(nonatomic,copy)markNameBlcok block;
@end
