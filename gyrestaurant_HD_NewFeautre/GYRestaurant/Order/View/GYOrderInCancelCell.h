//
//  GYOrderInCancelCell.h
//  GYRestaurant
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 kuser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYOrderListModel;

@protocol CancelDelegate <NSObject>

- (void)confirmBtn:(GYOrderListModel *)model button:(UIButton *)button;

@end


@interface GYOrderInCancelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ordIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *useIdlabel;
@property (weak, nonatomic) IBOutlet UILabel *ordStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arriveTimeLable;

@property (weak, nonatomic) IBOutlet UIImageView *coinImageView;
@property (weak, nonatomic) IBOutlet UILabel *payCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic)GYOrderListModel *model;

@property (assign, nonatomic)id<CancelDelegate> canceldelegate;


@end
