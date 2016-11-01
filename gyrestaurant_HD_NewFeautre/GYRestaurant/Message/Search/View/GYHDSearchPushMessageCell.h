//
//  GYHDSearchPushMessageCell.h
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDSearchPushMessageModel.h"
@interface GYHDSearchPushMessageCell : UITableViewCell
@property(nonatomic,strong)UILabel*titleLabel;//标题
@property(nonatomic,strong)UILabel*timeLabel;//时间
@property(nonatomic,strong)UILabel*contentLabel;//内容
-(void)refreshWithModel:(GYHDSearchPushMessageModel*)model;
@end
