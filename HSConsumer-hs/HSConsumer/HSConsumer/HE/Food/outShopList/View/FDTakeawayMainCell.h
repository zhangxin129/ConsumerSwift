//
//  FDTakeawayMainCell.h
//  HSConsumer
//
//  Created by apple on 15/12/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDShopModel.h"
@interface FDTakeawayMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* fullOffDescLabel;

@property (weak, nonatomic) IBOutlet UILabel* qiSongPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView* shopPic;
@property (weak, nonatomic) IBOutlet UILabel* shopName;
@property (weak, nonatomic) IBOutlet UILabel* shopDistance;
@property (weak, nonatomic) IBOutlet UILabel* shopAddr;
@property (weak, nonatomic) IBOutlet UILabel* shopEvgPrice;
@property (weak, nonatomic) IBOutlet UILabel* sendPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView0;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView1;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView2;
@property (strong, nonatomic) FDShopModel* model;
@end
