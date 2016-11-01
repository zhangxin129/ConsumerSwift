//
//  GYHDCustomerOrderListCell.h
//  GYRestaurant
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDCustomerOrderListModel.h"
@protocol GYHDCustomerOrderListCellDelegate <NSObject>

-(void)pushOrderDetailWithModel:(GYHDCustomerOrderListModel*)model;

@end
@interface GYHDCustomerOrderListCell : UITableViewCell
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *orderNumLabel;
@property(nonatomic,strong)UILabel *tradeStateLabel;
@property(nonatomic,strong)UILabel *businessPointLabel;
@property(nonatomic,strong)UIButton *orderDetailsBtn;
@property(nonatomic,weak)id<GYHDCustomerOrderListCellDelegate> delegate;
@property(nonatomic,strong)GYHDCustomerOrderListModel*model;
-(void)refreshUIWithModel:(GYHDCustomerOrderListModel*)model;
@end
