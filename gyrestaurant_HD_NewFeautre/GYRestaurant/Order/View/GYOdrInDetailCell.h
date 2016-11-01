//
//  GYOdrInDetailCell.h
//  GYRestaurant
//
//  Created by ios007 on 15/10/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FoodListInModel;
@protocol GYOdrInDetailDelegate <NSObject>

- (void)deleteFoodId:(FoodListInModel*)model;

@end
@interface GYOdrInDetailCell : UITableViewCell

/**数据模型*/
@property (nonatomic, strong)FoodListInModel *model;
@property (nonatomic, assign)id<GYOdrInDetailDelegate> delagete;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
