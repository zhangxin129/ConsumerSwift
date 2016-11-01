//
//  GYStoreTableViewCell.h
//  HSConsumer
//
//  Created by apple on 15/8/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kStoreTableViewCell @"StoreTableViewCell"
@class GYShopGoodListModel;
@class GYStoreTableViewCell;

@protocol StoreTableViewCellDelegate <NSObject>
@optional
- (void)StoreTableView:(GYStoreTableViewCell*)cell chooseOne:(NSInteger)type model:(GYShopGoodListModel*)model;

@end

@interface GYStoreTableViewCell : UITableViewCell
@property (nonatomic, strong) GYShopGoodListModel* leftModel;
@property (nonatomic, strong) GYShopGoodListModel* rightModel;
@property (nonatomic, weak) id<StoreTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView* leftView;
@property (weak, nonatomic) IBOutlet UIView* rightView;

+ (instancetype)cellWithTableView:(UITableView*)tableView;
@end
