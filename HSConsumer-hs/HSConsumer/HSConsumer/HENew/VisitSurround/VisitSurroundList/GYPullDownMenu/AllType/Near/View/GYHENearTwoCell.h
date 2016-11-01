//
//  GYHENearTwoCell.h
//  HSConsumer
//
//  Created by zhengcx on 16/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHEShopQuModel.h"

@interface GYHENearTwoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *shopQuLabel;
@property (nonatomic, strong) GYHEShopQuModel *model;


@end
