//
//  GYStaffMangerViewCell.h
//  GYRestaurant
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYDeliverModel;

@protocol TabViewCellDelegate <NSObject>

- (void)deleteBtn:(GYDeliverModel *)model;
- (void)changeBtnAction:(GYDeliverModel *)model;

@end

@interface GYStaffMangerViewCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *sexLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLable;
@property (weak, nonatomic) IBOutlet UILabel *stateLable;
@property (weak, nonatomic) IBOutlet UILabel *shopLable;
@property (weak, nonatomic) IBOutlet UILabel *remarkLable;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;


@property (assign, nonatomic)id<TabViewCellDelegate> delegate;
@property (strong, nonatomic)GYDeliverModel *model;

@end
