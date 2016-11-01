//
//  CellGoodsNameAndPriceCell.h
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//


#define kCellGoodsNameAndPriceCellIdentifier @"kGoodsNameAndPriceCellIdentifier"

#import <UIKit/UIKit.h>
#import "GYHEFocusGoodModel.h"

@interface GYHEGoodsNameWithPriceCell : UITableViewCell
        //商品价格
@property (nonatomic, strong)GYHEFocusGoodModel *model;

@property (strong, nonatomic) IBOutlet UIImageView *ivGoodsImage;   //商品图标
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsName;        //商品名称
@property (strong, nonatomic) IBOutlet UILabel *lbPrice;

@end
