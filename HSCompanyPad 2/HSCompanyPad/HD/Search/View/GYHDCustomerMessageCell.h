//
//  GYHDCustomerMessageCell.h
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDSearchCustomerListModel.h"
@interface GYHDCustomerMessageCell : UITableViewCell
@property(nonatomic,strong)UIImageView*iconImage;//头像
@property(nonatomic,strong)UILabel*nameLabel;//姓名
@property(nonatomic,strong)UILabel*hsCardLabel;//内容
@property(nonatomic, strong)UIButton *cardholderButton;//持卡人标志
-(void)refreshWithModel:(GYHDSearchCustomerListModel*)model;
@end
