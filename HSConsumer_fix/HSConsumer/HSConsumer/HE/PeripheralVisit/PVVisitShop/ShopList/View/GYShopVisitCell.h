//
//  GYShopVisitCell.h
//  HSConsumer
//
//  Created by apple on 15/11/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GYEasyBuyModel.h"
typedef void (^BackModelBlock)(ShopModel* model);
@interface GYShopVisitCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray* visitArr; //浏览数组
@property (weak, nonatomic) IBOutlet UITableView* shopVisitTableView;
@property (nonatomic, strong) BackModelBlock block;
@property (weak, nonatomic) IBOutlet UILabel* visitLabel; //光顾历史

@end
