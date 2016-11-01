//
//  GYMainBtnCell.h
//  HSCompanyPad
//
//  Created by User on 16/7/26.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYMainHistoryModel.h"

@interface GYMainBtnCell : UICollectionViewCell


@property (nonatomic,weak)IBOutlet UIImageView *centerImgView;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic,weak)IBOutlet UILabel *leftLabel;
@property (nonatomic, strong) GYMainHistoryModel *model;



@end
