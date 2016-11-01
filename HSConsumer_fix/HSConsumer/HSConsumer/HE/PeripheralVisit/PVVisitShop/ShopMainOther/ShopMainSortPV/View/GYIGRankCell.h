//
//  GYIGRankCell.h
//  HSConsumer
//
//  Created by apple on 15/11/18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GYSurroundVisitShopListModel.h"
#import "GYEasyBuyModel.h"
@interface GYIGRankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* shopIcon; //商店图片
@property (weak, nonatomic) IBOutlet UILabel* shopName; //商店名
@property (weak, nonatomic) IBOutlet UILabel* shopTipLabel; //商店 标识
@property (weak, nonatomic) IBOutlet UILabel* shopAdressLabel; //商店地址
@property (weak, nonatomic) IBOutlet UILabel* igPrecentLabel; //商店积分比例
@property (weak, nonatomic) IBOutlet UILabel* adressCenterLabel; //商店地址中心
@property (weak, nonatomic) IBOutlet UILabel* distanceLabel; //距离
- (void)refreshUIWith:(ShopModel*)model;
@property(nonatomic, strong) ShopModel *model;
@end
