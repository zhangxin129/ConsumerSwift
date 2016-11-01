//
//  GYOderTakeOutSendingCell.h
//  GYRestaurant
//
//  Created by ios007 on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYOrderTakeOutModel;

@protocol PayDelegate <NSObject>

- (void)payBtn:(GYOrderTakeOutModel *)model withTableViewType:(NSInteger)tableViewType button:(UIButton *)button;
@end

@interface GYOderTakeOutSendingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ordIdLabel;

@property (weak, nonatomic) IBOutlet UILabel *useIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *ordStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coinImv;
@property (weak, nonatomic) IBOutlet UILabel *payCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *postManLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDateTimeRangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *oparateBtn;

@property (assign, nonatomic)id<PayDelegate> paydelegate;
@property (strong, nonatomic)GYOrderTakeOutModel *model;
@property (assign, nonatomic)NSInteger tableViewType;

@end
