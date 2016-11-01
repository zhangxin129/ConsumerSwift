//
//  FDRecomdFoodCell.h
//  HSConsumer
//
//  Created by apple on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSubmitCommitOrderDetailFoodModel.h"
#import "FDRecomdModel.h"
@interface FDRecomdFoodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* foodPic;
@property (weak, nonatomic) IBOutlet UILabel* foodName;
@property (weak, nonatomic) IBOutlet UILabel* reconmCount;

@property (weak, nonatomic) IBOutlet UIImageView* addImgeView;
@property (nonatomic, strong) FDSubmitCommitOrderDetailFoodModel* model;
@property (nonatomic, strong) FDRecomdModel* recomdModel;
@end
