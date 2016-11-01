//
//  GYHSKeyView.h
//
//  Created by apple on 16/7/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, kPointPayType) {
    kPointPayCash = 1,//现金支付
    kPointPayHSB = 2,//互生币支付
    kPointPayScan = 3,//二维码支付
};
@protocol GYHSKeyViewDelegate <NSObject>

- (void)keyAddWithString:(NSString *)string;
- (void)keyDeleteWithString;
- (void)keyClick:(NSInteger)index;
@end
@interface GYHSKeyView : UIView
@property (nonatomic,weak)id<GYHSKeyViewDelegate>delegate;
@property (nonatomic, assign) kPointPayType pointPay;
@property (nonatomic, strong) UIButton* sureBtn;
@end
