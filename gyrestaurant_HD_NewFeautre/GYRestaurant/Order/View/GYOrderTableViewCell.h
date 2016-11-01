//
//  GYOrderTableViewCell.h
//  GYRestaurant
//
//  Created by ios007 on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYOrderListModel;



@protocol TableViewCellDelegate <NSObject>

- (void)operateBtn:(GYOrderListModel*)model withTableViewType:(NSInteger)tableViewType  button:(UIButton *)button;

@end

@interface GYOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *oprateBtn;
@property (assign, nonatomic)id<TableViewCellDelegate> delegate;
@property (strong, nonatomic)GYOrderListModel *model;
@property (assign, nonatomic)NSInteger tableViewType;



@end
