//
//  GYHECollectionGoodCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHECollectListModel.h"


@interface GYHECollectionGoodCell : UITableViewCell
@property (nonatomic,strong)GYHECollectListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *picURLImageView; //商品图片
@property (weak, nonatomic) IBOutlet UILabel *nameLb;              //商品名称
@property (weak, nonatomic) IBOutlet UILabel *specificationLb;     //规格
@property (weak, nonatomic) IBOutlet UIImageView *priceImageView;  //互生币图片
@property (weak, nonatomic) IBOutlet UILabel *priceLb;             //互生币数量
@property (weak, nonatomic) IBOutlet UIView *iconView;             //服务图标数组
@property (weak, nonatomic) IBOutlet UIImageView *integralImageView;//积分图标
@property (weak, nonatomic) IBOutlet UILabel *integralLb;           //积分数量
@property (weak, nonatomic) IBOutlet UILabel *freightLb;            //运费

@end
