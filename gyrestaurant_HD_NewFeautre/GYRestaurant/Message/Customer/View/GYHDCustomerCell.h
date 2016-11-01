//
//  GYCustomerCell.h
//  GYRestaurant
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDCustomerViewController.h"
#import "GYHDCustomerModel.h"
#import "GYHDChatViewController.h"
//typedef void (^headPicBlock)(GYHDCustomerModel*);
@protocol GYHDCustomerDelegate <NSObject>

-(void)refreshChatViewControllerWithModel:(GYHDCustomerModel*)model;

@end
@interface GYHDCustomerCell : UITableViewCell
@property(nonatomic,strong)UIImageView*iconImageView;//头像
@property(nonatomic,strong)UILabel*nameLabel;//客户姓名
@property(nonatomic,strong)UILabel*lastMsgLabel;//最后一条信息
@property(nonatomic,strong)UILabel*unreadMessageCountLabel;//未读消息数量显示
//@property(nonatomic,strong)headPicBlock headBlock;
@property(nonatomic,strong)GYHDCustomerModel*model;
@property(nonatomic,weak)  id <GYHDCustomerDelegate> delegate;
-(void)refreshUIWithModle:(GYHDCustomerModel*)model;
@end
