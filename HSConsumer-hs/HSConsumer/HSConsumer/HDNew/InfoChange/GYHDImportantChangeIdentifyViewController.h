//
//  GYHDImportantChangeIdentifyViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDImportantChangeIdentifyDelegate <NSObject>

-(void)importantChangeIdentify:(NSMutableDictionary*)dictInside olddic:(NSMutableDictionary*)oldmdictParams changeItem:(NSMutableArray*)changeItem;

@end
@interface GYHDImportantChangeIdentifyViewController : GYViewController
@property(nonatomic,weak)id<GYHDImportantChangeIdentifyDelegate> changeIdentifyDelegate;
@end
