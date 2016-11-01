//
//  GYHDSeachMessageViewController.h
//  HSConsumer
//
//  Created by shiang on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDSeachMessageViewController <NSObject>

- (void)popViewController:(UIViewController*)viewController custID:(NSString*)custID title:(NSString*)title;

@end

@interface GYHDSeachMessageViewController : GYViewController

@property (nonatomic, weak) id<GYHDSeachMessageViewController> delegate;
@end
