//
//  GYEasybuyGoodsInfoPropView.h
//  HSConsumer
//
//  Created by xiongyn on 16/8/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYEasybuyGoodsInfoPropView : UIView

@property (weak, nonatomic) IBOutlet UIView* propHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView* propHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel* propHeaderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel* propHeaderPriceLabel;
@property (strong, nonatomic) IBOutlet UITableView* propTableView;

@end
