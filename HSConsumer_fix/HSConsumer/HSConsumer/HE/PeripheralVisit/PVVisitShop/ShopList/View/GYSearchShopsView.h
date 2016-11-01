//
//  GYSearchShopsView.h
//  HSConsumer
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"
typedef void (^BackBlock)(NSInteger tag, NSString* idStr);
typedef void (^BackMyBlock)(NSInteger tag, NSDictionary* model);
typedef void (^BackModelBlock)(ShopModel*);
typedef void (^BackTimeBlock)(NSTimer*);

@interface GYSearchShopsView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BackBlock block;
@property (nonatomic, strong) BackModelBlock modelBlcok;
@property (nonatomic, strong) UITableView* shopTableView; //逛商铺视图
@property (nonatomic, strong) NSMutableArray* vistArr; //光顾商店数组
@property (nonatomic, strong) BackMyBlock myBlock; //传GYSearchShopsMainModel;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) BackTimeBlock timeBlock;

- (void)loadMainData;
- (void)loadHistoryData;

@end
