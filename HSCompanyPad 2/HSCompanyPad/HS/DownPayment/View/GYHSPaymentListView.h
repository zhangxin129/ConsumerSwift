//
//  GYHSPaymentListView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSPaymentCheckModel;
@protocol GYHSPaymentSelectDelegate <NSObject>

- (void)selectPaymentModel:(GYHSPaymentCheckModel *)model;

@end
@interface GYHSPaymentListView : UIView
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic,weak) id<GYHSPaymentSelectDelegate> delegate;
- (void)addRefreshView:(NSString *)cardNo;
@end
