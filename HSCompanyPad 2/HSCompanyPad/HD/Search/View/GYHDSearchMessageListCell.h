//
//  GYHDSearchMessageListCell.h
//  GYRestaurant
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDSearchCompanyMessageModel.h"
#import "GYHDSearchPushMessageModel.h"
@interface GYHDSearchMessageListCell : UITableViewCell
@property(nonatomic,strong)UIImageView*iconImage;//头像
@property(nonatomic,strong)UILabel*nameLabel;//姓名
@property(nonatomic,strong)UILabel*contentLabel;//内容
@property(nonatomic,strong)UILabel*timeLabel;//时间
@property(nonatomic, strong)UIButton *cardholderButton;//持卡人标志
/**跳转状态imageView*/
@property(nonatomic, strong)UIImageView *pushImageView;
-(void)refreshWithGYHDSearchCompanyMessageModel:(GYHDSearchCompanyMessageModel*)model;
-(void)refreshWithGYHDSearchPushMessageModel:(GYHDSearchPushMessageModel*)model;
@end
