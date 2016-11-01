//
//  GYHSPaymentCancelCell.h
//  HSCompanyPad
//
//  Created by 梁晓辉 on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSPaymentCheckModel;
@class GYHSPaymentCancelCell;
@protocol GYHSPaymentCancelDelegate <NSObject>

- (void)cancelWithPayment:(GYHSPaymentCheckModel *)model;

@end
static NSString * paymentCancel = @"paymentCancel";
@interface GYHSPaymentCancelCell : UITableViewCell
@property (nonatomic,strong) GYHSPaymentCheckModel * model;
@property (nonatomic,weak) id<GYHSPaymentCancelDelegate> delegate;
@end
