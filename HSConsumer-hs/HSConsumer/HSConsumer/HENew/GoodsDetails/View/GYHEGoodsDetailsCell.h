//
//  GYHEGoodsDetailsCell.h
//  HSConsumer
//
//  Created by lizp on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHEGoodsDetailsCellIdentifier @"GYHEGoodsDetailsCell"

#import <UIKit/UIKit.h>
#import "GYHEGoodsDetailsModel.h"

@interface GYHEGoodsDetailsCell : UITableViewCell

@property (nonatomic,strong) UIControl *shareControl;//分享
@property (nonatomic,strong) UIControl *collectControl;//收藏
@property (nonatomic,strong) UIControl *enterShopControl;//进入店铺
@property (nonatomic,strong) UIButton *collectBtn;//收藏按钮
@property (nonatomic,strong) GYHEGoodsDetailsModel *model;




////模仿数据模型   测试
//-(void)setModel:(NSAttributedString *)title;



@end
