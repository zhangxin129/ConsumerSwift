//
//  GYHDAllMsgListCell.h
//  GYRestaurant
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDAllMsgListModel.h"
@interface GYHDAllMsgListCell : UITableViewCell
@property(nonatomic,strong)UIImageView*iconImageView;//头像
@property(nonatomic,strong)UILabel*nameLabel;//客户姓名
@property(nonatomic,strong)UILabel*lastMsgLabel;//最后一条信息
@property(nonatomic,strong)UILabel*timeLabel;
@property(nonatomic,strong)UILabel*unreadMessageCountLabel;//未读消息数量显示
-(void)refreshUIWithModle:(GYHDAllMsgListModel*)model;
@end
