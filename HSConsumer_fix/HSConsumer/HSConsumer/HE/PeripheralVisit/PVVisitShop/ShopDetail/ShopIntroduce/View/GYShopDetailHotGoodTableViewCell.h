//
//  
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHotItemGoods.h"
@interface GYShopDetailHotGoodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* imgLeftImage; //左边图片imgview
@property (weak, nonatomic) IBOutlet UIImageView* imgRightImage; //右边图片imgview
@property (weak, nonatomic) IBOutlet UILabel* lbLeftGoodName; //左边商品名称

@property (weak, nonatomic) IBOutlet UILabel* lbRightGoodName; //右边商品名称
@property (weak, nonatomic) IBOutlet UIButton* btnLeftCover; //左边覆盖BTN
@property (weak, nonatomic) IBOutlet UIButton* btnRightCover; //右边覆盖BTN
- (void)refreshUIWithModel:(GYHotItemGoods*)model WithSecondModel:(GYHotItemGoods*)rightModel;

// 底部
@property (weak, nonatomic) IBOutlet UIView* vBackLeft;
@property (weak, nonatomic) IBOutlet UIImageView* imgCoinLeft;
@property (weak, nonatomic) IBOutlet UILabel* lbPriceLeft;
@property (weak, nonatomic) IBOutlet UIImageView* imgPvLeft;
@property (weak, nonatomic) IBOutlet UILabel* lbPvLeft;

@property (weak, nonatomic) IBOutlet UIView* vBackRight;
@property (weak, nonatomic) IBOutlet UIImageView* imgCoinRight;
@property (weak, nonatomic) IBOutlet UILabel* lbPriceRight;
@property (weak, nonatomic) IBOutlet UIImageView* imgPvRight;
@property (weak, nonatomic) IBOutlet UILabel *lbPvRight;
@end
