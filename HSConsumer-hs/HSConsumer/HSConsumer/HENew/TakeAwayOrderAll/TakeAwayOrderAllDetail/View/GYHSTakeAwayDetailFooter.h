//
//  GYHSTakeAwayDetailFooter.h
//  HSConsumer
//
//  Created by kuser on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSTakeAwayDetailAllModel;
@protocol GYHSTakeAwayDetailFooterDelegate;

@interface GYHSTakeAwayDetailFooter : UIView

@property (nonatomic, strong) GYHSTakeAwayDetailAllModel* model;
@property (nonatomic, weak) id<GYHSTakeAwayDetailFooterDelegate> delegate;
@property (weak, nonatomic) UIButton* lookLogisterBtn; //查看物流
@property (weak, nonatomic) UIButton* afterSaleBtn; // 售后申请
@property (weak, nonatomic) UIButton* requestBackPayBtn; //申请退款
@property (weak, nonatomic) UIButton* buyAgainBtn; //再订

@end

// 代理---------------------------------
@protocol GYHSTakeAwayDetailFooterDelegate <NSObject>

@optional

- (void)lookLogisterBtn:(GYHSTakeAwayDetailFooter*)footer;
- (void)requestBackPayBtn:(GYHSTakeAwayDetailFooter*)footer;
- (void)afterSaleBtn:(GYHSTakeAwayDetailFooter*)footer;
- (void)buyAgainBtn:(GYHSTakeAwayDetailFooter*)footer;

@end
