//
//  GYHEGoodsImageTextDetailsCell.h
//  HSConsumer
//
//  Created by lizp on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHEGoodsImageTextDetailsCellIdentifier @"GYHEGoodsImageTextDetailsCell"

#import <UIKit/UIKit.h>

@interface GYHEGoodsDetailsProductionCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;//产品参数类型
@property (nonatomic,strong) UILabel *detailLabel;//产品参数详情


-(void)refreshTitle:(NSString *)title  detail:(NSString *)detail titleHeight:(CGFloat)titleHeight detailHeight:(CGFloat)detailHeight;

@end
