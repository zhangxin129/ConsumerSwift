//
//  GYShopHeader.h
//  HSConsumer
//
//  Created by apple on 15/8/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYMallBaseInfoModel;
@class GYShopHeader;

@protocol ShopHeaderDelegate <NSObject>
@optional
- (void)ShopHeaderDidSelectPayAtentionBtn:(GYShopHeader*)header;
- (void)ShopHeaderDidSelectShowBigPicWithHeader:(GYShopHeader*)header index:(NSInteger)index;
@end

@interface GYShopHeader : UIView
+ (instancetype)initWithXib;
+ (CGFloat)height;

@property (weak, nonatomic) IBOutlet UIScrollView* svBack;
@property (nonatomic, strong) GYMallBaseInfoModel* model;

@property (nonatomic, weak) id<ShopHeaderDelegate> delegate;

- (void)changePayAttentionBtnWithStatus:(BOOL)status;
@end
