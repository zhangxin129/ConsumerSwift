//
//  GYHSPaymentSettleView.h
//  HSCompanyPad
//
//  Created by 梁晓辉 on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSPointInputView;
@class GYHSPaymentCheckModel;
@protocol GYHSPaymentSetPointDelegate <NSObject>

- (void)popPointRate;

@end
@interface GYHSPaymentSettleView : UIView
@property (nonatomic, weak) GYHSPointInputView* cardView;
@property (nonatomic, weak) GYHSPointInputView* cashView;
@property (nonatomic, weak) GYHSPointInputView* consumView;
@property (nonatomic, weak) GYHSPointInputView* HSBView;
@property (nonatomic, weak) GYHSPointInputView* pointView;
@property (nonatomic, strong) UIButton* volumeBtn;
@property (nonatomic, copy) NSString * volumeAmount;
@property (nonatomic, copy) NSString * volumePage;
@property (nonatomic, copy) NSString* pointRate;
@property (nonatomic, strong) GYHSPaymentCheckModel * model;
@property (nonatomic,weak) id<GYHSPaymentSetPointDelegate> delegate;
@end
