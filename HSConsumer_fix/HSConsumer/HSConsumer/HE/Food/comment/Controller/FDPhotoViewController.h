//
//  FDPhotoViewController.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYViewController.h"

@interface FDPhotoViewController : GYViewController
@property (strong, nonatomic) NSArray* images;
@property (assign, nonatomic) NSInteger currentSelected;
@end
