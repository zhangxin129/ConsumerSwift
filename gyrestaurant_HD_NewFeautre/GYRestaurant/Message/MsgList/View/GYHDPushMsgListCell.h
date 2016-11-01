//
//  GYHDPushMsgListCell.h
//  GYRestaurant
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYOrderMessageListModel.h"
@protocol GYHDPushMsgListCellDelegate <NSObject>

-(void)reFreshCellRowHight:(CGFloat)rowHight;

@end
@interface GYHDPushMsgListCell : UITableViewCell
@property(nonatomic,weak)id <GYHDPushMsgListCellDelegate> delegate;
@property(nonatomic,strong)GYOrderMessageListModel*model;
@end
