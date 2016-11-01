//
//  GYConcernsCollectGoodsViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyPurchaseData.h"

//设置菜单角标的block
typedef void (^setMenu)(NSInteger index, NSString* title);

@interface GYConcernsCollectGoodsViewController : GYViewController

@property (nonatomic, strong) NSMutableArray* arrResult;
@property (nonatomic, strong) UINavigationController* nav;
@property (nonatomic, strong) UIButton* btnMenu; //对应哪个menu的btn

@property (nonatomic, strong) setMenu block;

@end
