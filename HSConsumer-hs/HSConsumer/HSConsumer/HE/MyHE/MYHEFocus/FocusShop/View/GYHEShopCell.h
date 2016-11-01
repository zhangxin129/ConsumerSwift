//
//  CellShopCell.h
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//


#define kCellShopCellIdentifier @"GYHEShopCell"
#import "GYHEFocusShopModel.h"
#import <UIKit/UIKit.h>

@interface GYHEShopCell : UITableViewCell

@property (nonatomic, strong)GYHEFocusShopModel *model;

@property (strong, nonatomic) IBOutlet UIImageView *ivShopImage;//商铺图标
@property (strong, nonatomic) IBOutlet UILabel *lbShopName;     //商铺名称
@property (strong, nonatomic) IBOutlet UILabel *lbShopScope;    //商铺经营范围
@property (strong, nonatomic) IBOutlet UILabel *lbShopConcernTime;//商铺关注时间

@end
