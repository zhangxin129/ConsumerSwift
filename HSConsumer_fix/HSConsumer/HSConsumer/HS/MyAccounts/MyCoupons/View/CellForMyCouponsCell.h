//
//  CellForMyOrderSubCell.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kCellForMyCouponsCellIdentifier @"CellForMyCouponsCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellForMyCouponsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* lbRow0;
@property (strong, nonatomic) IBOutlet UILabel* lbRow1L;
@property (strong, nonatomic) IBOutlet UILabel* lbRow1R;
@property (strong, nonatomic) IBOutlet UILabel* lbRow2L;
@property (strong, nonatomic) IBOutlet UILabel* lbRow2R;
@property (strong, nonatomic) IBOutlet UILabel* lbRow3L;
@property (strong, nonatomic) IBOutlet UILabel* lbRow3R;
@property (strong, nonatomic) IBOutlet UILabel* lbRow4L;
@property (strong, nonatomic) IBOutlet UILabel* lbRow4R;
@property (strong, nonatomic) IBOutlet UIImageView* ivHsbLogo;

+ (CGFloat)getHeight;
@end
