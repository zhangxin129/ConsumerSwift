//
//  GYAroundGoodsListCell.h
//  HSConsumer
//
//  Created by Apple03 on 15/11/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchGoodModel;
#define KGYAroundGoodsListCell @"GYAroundGoodsListCell"

@protocol GYAroundGoodsListCellDelegate <NSObject>
- (void)AroundGoodsListCellDidCallWithIndexPath:(NSIndexPath*)indexP;

@end

@interface GYAroundGoodsListCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath* indexPath;
+ (instancetype)cellWithTableView:(UITableView*)tableView;
- (void)seCellWithModel:(SearchGoodModel*)model;

@property (nonatomic, weak) id<GYAroundGoodsListCellDelegate> delegate;
@end
