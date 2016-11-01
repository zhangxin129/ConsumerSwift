//
//  GYEasybuyGoodsInfoTableViewCell.h
//  HSConsumer
//
//  Created by zhangqy on 15/11/11.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasybuyGoodsInfoModel.h"
#import "GYEasybuyGoodsInfoViewController.h"
@class GYEasybuyGoodsInfoTableViewCell;
@protocol GYEasybuyGoodsInfoTableViewCellDelegate <NSObject>

- (void)showCouponView:(GYEasybuyGoodsInfoTableViewCell*)cell;

@end

@interface GYEasybuyGoodsInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) GYEasybuyGoodsInfoModel* model;
@property (weak, nonatomic) IBOutlet UIButton* collectBtn;
@property (weak, nonatomic) IBOutlet UIImageView* beFocusIv; //收藏
@property (weak, nonatomic) IBOutlet UILabel* beFocusLabel;
@property (weak, nonatomic) GYEasybuyGoodsInfoViewController* vc;

@property (nonatomic, weak) id<GYEasybuyGoodsInfoTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* couponViewHeight;

@property (weak, nonatomic) IBOutlet UIButton* downBtn;

@end
