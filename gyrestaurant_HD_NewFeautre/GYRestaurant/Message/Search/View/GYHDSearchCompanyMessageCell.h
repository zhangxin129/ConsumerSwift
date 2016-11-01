//
//  GYHDSearchCompanyMessageCell.h
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDSearchCompanyMessageModel.h"
@interface GYHDSearchCompanyMessageCell : UITableViewCell
@property(nonatomic,strong)UIImageView*iconImage;//头像
@property(nonatomic,strong)UILabel*nameLabel;//姓名
@property(nonatomic,strong)UILabel*contentLabel;//内容
@property(nonatomic,strong)UILabel*timeLabel;//时间
-(void)refreshWithModel:(GYHDSearchCompanyMessageModel*)model;
@end
