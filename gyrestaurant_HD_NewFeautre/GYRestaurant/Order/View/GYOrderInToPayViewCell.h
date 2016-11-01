//
//  GYOrderInToPayViewCell.h
//  GYRestaurant
//
//  Created by apple on 15/12/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYOrderListModel;

@protocol ToPayViewCellDelegate <NSObject>

- (void)changeBtn:(GYOrderListModel *)model;
- (void)payBtn:(GYOrderListModel *)model;


@end


@interface GYOrderInToPayViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumLable;
@property (weak, nonatomic) IBOutlet UILabel *resNoLable;
@property (weak, nonatomic) IBOutlet UILabel *eatTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *tabNoLable;
@property (weak, nonatomic) IBOutlet UILabel *accountLable;
@property (weak, nonatomic) IBOutlet UIImageView *coinView;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIView *centerLineView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (assign, nonatomic)id<ToPayViewCellDelegate> delegate;
@property (strong, nonatomic)GYOrderListModel *model;

@end
