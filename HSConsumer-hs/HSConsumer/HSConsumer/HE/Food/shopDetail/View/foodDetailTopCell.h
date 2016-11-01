//
//  foodDetailTopCell.h
//  HSConsumer
//
//  Created by apple on 15/12/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDShopModel.h"
#import "FDShopDetailModel.h"
typedef void (^phoneBlock)();
@interface foodDetailTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* shopImageView; //商铺图片
@property (weak, nonatomic) IBOutlet UILabel* shopLabel; //商铺名称
@property (weak, nonatomic) IBOutlet UIImageView* scroeImageViewleft; //评分左
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageViewcenter; //评分中
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageViewRight; //评分右
@property (weak, nonatomic) IBOutlet UILabel* averageLabel; //评价数
@property (weak, nonatomic) IBOutlet UIView* tipView; //支持提示
@property (weak, nonatomic) IBOutlet UILabel* brandLabel; //brand字段

@property (weak, nonatomic) IBOutlet UILabel* shopCategaryLabel; //商铺分类

@property (weak, nonatomic) IBOutlet UILabel* pinjunCashLabel; //人均消费
@property (weak, nonatomic) IBOutlet UILabel* HSNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel* startSaleLabel; //起送价

@property (weak, nonatomic) IBOutlet UILabel* peisongCasheLabel; //配送费
//国际化 add zhangx
@property (weak, nonatomic) IBOutlet UILabel* perConsumptionLabel; //人均消费
@property (weak, nonatomic) IBOutlet UILabel* startSendLabel; //起送价
@property (weak, nonatomic) IBOutlet UILabel* sendPriceLabel; //配送费
@property (weak, nonatomic) IBOutlet UIView* startSendView;
@property (weak, nonatomic) IBOutlet UIView* sendPriceView;

@property (strong, nonatomic) FDShopModel* model;
@property (strong, nonatomic) FDShopDetailModel *shopDetailModel;
@property(nonatomic, strong) phoneBlock block;
@end
