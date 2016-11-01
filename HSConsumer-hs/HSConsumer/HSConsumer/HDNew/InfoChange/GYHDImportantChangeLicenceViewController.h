//
//  GYHDImportantChangeLicenceViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDImportantChangeLicenceDelegate <NSObject>
-(void)importantChangeLicence:(NSMutableDictionary*)dictInside olddic:(NSMutableDictionary*)oldmdictParams changeItem:(NSMutableArray*)changeItem;

@end
@interface GYHDImportantChangeLicenceViewController : GYViewController
@property (nonatomic,weak)id<GYHDImportantChangeLicenceDelegate> changeLicenceDelegate;
@end
