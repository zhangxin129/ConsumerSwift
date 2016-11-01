//
//  GYHEVisitMainCell.h
//  HSConsumer
//
//  Created by lizp on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHEVisitMainCellIdentifier @"GYHEVisitMainCell"

#import <UIKit/UIKit.h>

@interface GYHEVisitMainCell : UICollectionViewCell

@property (nonatomic,strong) UIView *overlayView;
@property (nonatomic,strong) UIImageView *typeImageView;
@property (nonatomic,strong) UILabel *titlelabel;

@end
