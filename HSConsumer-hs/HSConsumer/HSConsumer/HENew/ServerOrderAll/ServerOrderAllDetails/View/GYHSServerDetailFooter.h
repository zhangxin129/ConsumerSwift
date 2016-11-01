//
//  GYHSServerDetailFooter.h
//  HSConsumer
//
//  Created by zhengcx on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSServerDetailAllModel;
@protocol GYHSServerDetailFooterDelegate;

@interface GYHSServerDetailFooter : UIView

@property (nonatomic, strong) GYHSServerDetailAllModel* model;
@property (nonatomic, weak) id<GYHSServerDetailFooterDelegate> delegate;

@property (weak, nonatomic) UIButton* lookLogisterBtn; //查看物流
@property (weak, nonatomic) UIButton* afterSaleBtn; // 售后申请
@property (weak, nonatomic) UIButton* requestBackPayBtn; //申请退款
@property (weak, nonatomic) UIButton* buyAgainBtn; //再订

@end

// 代理---------------------------------
@protocol GYHSServerDetailFooterDelegate <NSObject>

@optional

- (void)lookLogisterBtn:(GYHSServerDetailFooter*)footer;
- (void)requestBackPayBtn:(GYHSServerDetailFooter*)footer;
- (void)afterSaleBtn:(GYHSServerDetailFooter*)footer;
- (void)buyAgainBtn:(GYHSServerDetailFooter*)footer;

@end
