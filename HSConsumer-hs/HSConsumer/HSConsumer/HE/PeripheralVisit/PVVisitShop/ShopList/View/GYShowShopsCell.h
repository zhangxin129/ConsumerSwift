//
//  GYShowShopsCell.h
//  HSConsumer
//
//  Created by apple on 15/11/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"
#import "GYSearchShopsMainModel.h"
@interface GYShowShopsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* shopIcon; //商店图片
@property (weak, nonatomic) IBOutlet UILabel* shopLabel; //商店名字
@property (weak, nonatomic) IBOutlet UILabel* tipLabelOne; //标签1
@property (weak, nonatomic) IBOutlet UIImageView* GPSImageView; //定位图
@property (weak, nonatomic) IBOutlet UILabel* distanceLabel; //定位距离
@property (weak, nonatomic) IBOutlet UIImageView* shopCallImageView; //电话图
@property (weak, nonatomic) IBOutlet UILabel* shopAdressLabel; //商店地址
@property (weak, nonatomic) IBOutlet UIImageView* telImage;
@property (weak, nonatomic) IBOutlet UIButton* telBtn;
- (void)refreshUIWith:(ShopModel*)model;
- (void)setCellDataWith:(GYSearchShopsMainModel*)model;
@property (nonatomic, strong) GYSearchShopsMainModel* MainModel;
@property(nonatomic, strong) ShopModel *model;


@end
