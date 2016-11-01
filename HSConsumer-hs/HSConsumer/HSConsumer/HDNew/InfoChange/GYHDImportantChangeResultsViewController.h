//
//  GYHDImportantChangeResultsViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDImportantChangeResultsDelegate <NSObject>
@optional
-(void)againImportantChange;

@end
@interface GYHDImportantChangeResultsViewController : GYViewController
@property (nonatomic, strong) NSString* approveDate;
@property (nonatomic, strong) NSString* changeItem;
@property (nonatomic, strong) NSString* approvestatus;
@property (nonatomic, weak)id<GYHDImportantChangeResultsDelegate> changeResultsDelegate;
@end
