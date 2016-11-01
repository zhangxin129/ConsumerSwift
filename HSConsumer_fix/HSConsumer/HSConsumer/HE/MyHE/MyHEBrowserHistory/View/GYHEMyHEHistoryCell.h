//
//  GYHEMyHEHistoryCell.h
//  HS_Consumer_HE
//
//  Created by Yejg on 16/4/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHEMyHEHistory;
@interface GYHEMyHEHistoryCell : UITableViewCell

@property (nonatomic, strong) GYHEMyHEHistory *model;

@property (nonatomic, weak) UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
