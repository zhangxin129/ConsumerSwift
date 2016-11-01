//
//  GYaddresRestaurantCell.h
//  HSConsumer
//
//  Created by appleliss on 15/9/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYaddresRestaurantCellDelegate <NSObject>
- (void)GYaddresRestaurantCell;

@end
@interface GYaddresRestaurantCell : UITableViewCell
@property (copy, nonatomic) NSString* tel;
@property (weak, nonatomic) IBOutlet UILabel* lbrestaurantName; /////餐厅名称
@property (weak, nonatomic) IBOutlet UILabel* shopHSNUmber;

@property (weak, nonatomic) IBOutlet UILabel* lbaddressrestaurant; //////餐厅详情地址
@property (weak, nonatomic) IBOutlet UILabel* lbHsTitle;
@property (nonatomic, weak) id<GYaddresRestaurantCellDelegate> gyGYaddresRestaurantCellDelegate;
@end
