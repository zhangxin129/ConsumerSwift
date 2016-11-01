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

#define kCellForMyOrderSubCellIdentifier @"CellForMyOrderSubCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellForMyOrderSubCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView* viewContentBkg;
@property (strong, nonatomic) IBOutlet UIImageView* ivGoodsPicture;
@property (strong, nonatomic) IBOutlet UILabel* lbGoodsName;
@property (strong, nonatomic) IBOutlet UILabel* lbGoodsPrice;
@property (strong, nonatomic) IBOutlet UILabel* lbGoodsCnt;
@property (strong, nonatomic) IBOutlet UILabel* lbGoodsProperty;
@property (strong, nonatomic) IBOutlet UIImageView* ivHsbLogo;
@property (weak, nonatomic) IBOutlet UIImageView* pvImgView; //pv图片
@property (weak, nonatomic) IBOutlet UILabel* pvLabel; //积分显示

@end
