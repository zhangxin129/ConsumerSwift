//
//  FDSearchFoodsCell.h
//  HSConsumer
//
//  Created by apple on 15/12/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSearchFoodsModel.h"

@interface FDSearchFoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* foodPic;
@property (weak, nonatomic) IBOutlet UILabel* foodName;
@property (weak, nonatomic) IBOutlet UILabel* foodSaleNum;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImage0;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImage1;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImage2;

@property (weak, nonatomic) IBOutlet UILabel* foodPrice;

@property (weak, nonatomic) IBOutlet UILabel* foodPv;

- (IBAction)addAction:(UIButton*)sender;
@property (nonatomic, strong) FDSearchFoodsModel* model;

@end
