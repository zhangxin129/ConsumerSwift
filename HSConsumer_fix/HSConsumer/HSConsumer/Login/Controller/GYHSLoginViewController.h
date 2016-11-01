//
//  GYHSLoginViewControllerNew.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYViewController.h"

typedef NS_ENUM(NSUInteger, GYHSLoginViewControllerEnum) {
    GYHSLoginViewControllerTypeHashsCard = 1, // 有互生卡
    GYHSLoginViewControllerTypeNohsCard = 2 // 无互生卡
};

@interface GYHSLoginViewController : GYViewController

@property (nonatomic, assign) GYHSLoginViewControllerEnum loginType;

@property (nonatomic, assign) NSInteger dismissBarIndex;
@property (nonatomic, assign) BOOL needToMainInterface;

@end
