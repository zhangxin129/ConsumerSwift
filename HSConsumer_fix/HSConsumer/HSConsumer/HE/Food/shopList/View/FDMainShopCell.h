//
//  FDMainShopCell.h
//  HSConsumer
//
//  Created by apple on 15/12/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDShopModel.h"
@interface FDMainShopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* shopImageView; //商铺图片
@property (weak, nonatomic) IBOutlet UILabel* shopLabel; //商铺名称
@property (weak, nonatomic) IBOutlet UIImageView* scroeImageViewleft; //评分左
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageViewcenter; //评分中
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageViewRight; //评分右
@property (weak, nonatomic) IBOutlet UILabel* cashLabel; //人均消费
@property (weak, nonatomic) IBOutlet UILabel* shopAdressLabel; //商铺地址
@property (weak, nonatomic) IBOutlet UILabel* shopTipLabel; //商铺风格特色
@property (weak, nonatomic) IBOutlet UILabel* shopDistanceLabel; //商铺定位距离
@property (strong, nonatomic) FDShopModel *model;

@end
