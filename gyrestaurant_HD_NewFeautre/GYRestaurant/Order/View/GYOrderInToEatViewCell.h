//
//  GYOrderInToEatViewCell.h
//  GYRestaurant
//
//  Created by apple on 15/12/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYOrderListModel;

@protocol ToEatViewCellDelegate <NSObject>

- (void)startBtn:(GYOrderListModel *)model button:(UIButton *)button;
- (void)cancelBtn:(GYOrderListModel *)model button:(UIButton *)button;


@end

@interface GYOrderInToEatViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderIdLable;
@property (weak, nonatomic) IBOutlet UILabel *resNoLable;
@property (weak, nonatomic) IBOutlet UILabel *takeTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *bookTimeLable;
@property (weak, nonatomic) IBOutlet UIImageView *coinView;
@property (weak, nonatomic) IBOutlet UILabel *accountLable;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
//@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *LineView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (assign, nonatomic)id<ToEatViewCellDelegate> delegate;
@property (strong, nonatomic)GYOrderListModel *model;


@end
