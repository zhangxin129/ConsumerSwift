//
//  GYHEShopServerListCell.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHEShopDetailGoodListModel.h"

@class GYHEShopServerListCell;
@protocol GYHEShopServerListCellDelegate <NSObject>
/**
 *  代理方法 点击传值
 *
 *  @param index 整数值
 */
- (void)clickServiceOrder:(GYHEShopServerListCell*)cell;
@end

@interface GYHEShopServerListCell : UITableViewCell

@property (nonatomic, strong)GYHEShopDetailGoodListModel *model;
@property (nonatomic, weak) id<GYHEShopServerListCellDelegate> delegate;

@end
