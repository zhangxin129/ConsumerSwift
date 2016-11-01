//
//  GYUserCell.h
//  GYRestaurant
//
//  Created by apple on 15/10/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYUserInfoModel;

@interface GYUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UILabel *actorLable;
@property (weak, nonatomic) IBOutlet UILabel *stateLable;


@property(nonatomic,strong) GYUserInfoModel *model;
//填充cell
- (void)fillCellWithModel:(GYUserInfoModel *)model;


@end
