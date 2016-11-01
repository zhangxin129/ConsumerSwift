//
//  GYHDMsgListCell.h
//  GYRestaurant
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYOrderMessageListModel.h"
@protocol GYHDMsgListCellDelegate <NSObject>

-(void)reFreshCellRowHight:(CGFloat)rowHight;

@end
@interface GYHDMsgListCell : UITableViewCell
@property(nonatomic,weak)id <GYHDMsgListCellDelegate> delegate;
@property(nonatomic,strong)GYOrderMessageListModel*model;
@end