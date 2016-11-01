//
//  GYEPMyOrderViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CouponsType) { //抵扣券类型
    kCouponsTypeUnUse = 1, //未使用
    kCouponsTypeUsed //已使用
};

#import <UIKit/UIKit.h>

@interface GYEPMyCouponsViewController : GYViewController
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) CouponsType couponsType; //抵扣券类型
@property (nonatomic, strong) NSMutableArray* arrResult;
@property (nonatomic, strong) UINavigationController* nav;
@property (nonatomic, assign) BOOL firstTipsErr; //查询及结果错误首次提示提示
@property (nonatomic, assign) int startPageNo;          //从第几开始 这里默认从第1页开始传
@end
