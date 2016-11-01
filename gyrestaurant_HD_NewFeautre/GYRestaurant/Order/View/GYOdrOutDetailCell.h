//
//  GYOdrOutDetailCell.h
//  GYRestaurant
//
//  Created by apple on 15/10/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FoodListInModel;

@interface GYOdrOutDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLable;
@property (weak, nonatomic) IBOutlet UILabel *foodLableLable;
@property (weak, nonatomic) IBOutlet UILabel *foodPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *foodNumLable;
@property (weak, nonatomic) IBOutlet UILabel *totalPayLable;
@property (weak, nonatomic) IBOutlet UILabel *pointLable;
@property (weak, nonatomic) IBOutlet UIImageView *coinView1;
@property (weak, nonatomic) IBOutlet UIImageView *coinView2;
@property (weak, nonatomic) IBOutlet UIImageView *pointView;
@property (weak, nonatomic) IBOutlet UIImageView *lineView;

@property(nonatomic, strong)FoodListInModel *model;
@end
