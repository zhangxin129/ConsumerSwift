//
//  GYPayView.h
//  HSCompanyPad
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYPayViewDelegate <NSObject>

- (void)ylPaymentAction;
- (void)quickPaymentAction;

@end

@interface GYPayView : UIView

@property (nonatomic, copy) NSString *accountStr;

@property (nonatomic, weak) id<GYPayViewDelegate> delegate;

@end
