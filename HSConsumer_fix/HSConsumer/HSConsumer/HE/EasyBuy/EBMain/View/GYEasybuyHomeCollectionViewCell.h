//
//  GYEasybuyHomeCollectionViewCell.h
//  HSConsumer
//
//  Created by zhangqy on 15/11/10.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasybuyMainModel.h"

@interface GYEasybuyHomeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) GYEasybuyMainModel* model;

@end
