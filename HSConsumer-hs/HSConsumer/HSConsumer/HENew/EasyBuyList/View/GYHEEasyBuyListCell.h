//
//  GYHEEasyBuyListCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHEEasyBuyListModel.h"
//@class GYHEEasyBuyListModel;

@interface GYHEEasyBuyListCell : UITableViewCell
@property (nonatomic,weak)GYHEEasyBuyListModel *model;
//示例图片
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
//标题
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
//价格图标
@property (weak, nonatomic) IBOutlet UIImageView *priceImageView;
//积分图标
@property (weak, nonatomic) IBOutlet UIImageView *integralImageView;
//卖家服务图标
@property (weak, nonatomic) IBOutlet UIImageView *sellerImageView;
//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//积分
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
//详细地址
@property (strong, nonatomic) IBOutlet UILabel *detailAddressLabel;
//地址
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
//地址图标
@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;

@end
