//
//  GYHESCOrderTableFooterView.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHESCOrderTableFooterViewDelegate <NSObject>

@optional
- (void)pushToChoosePaymentMethod; //跳转代理

@end

@interface GYHESCOrderTableFooterView : UIView

@property (weak, nonatomic) IBOutlet UILabel* paymentMethodTagLabel;
@property (weak, nonatomic) IBOutlet UILabel* paymentMethodLabel;

@property (nonatomic, weak) id<GYHESCOrderTableFooterViewDelegate> delegate;
@end
