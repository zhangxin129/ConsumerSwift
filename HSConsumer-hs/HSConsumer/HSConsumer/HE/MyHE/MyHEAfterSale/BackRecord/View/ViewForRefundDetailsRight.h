//
//  ViewForRefundDetailsRight.h
//  HSConsumer
//
//  Created by liangzm on 15-2-27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewForRefundDetailsRight;

@protocol ViewForRefundDetailsRightDelegate <NSObject>

- (void)complaintBtnClickDelegate;

@end

@interface ViewForRefundDetailsRight : UIView

@property (strong, nonatomic) IBOutlet UIView* viewLine0;
@property (strong, nonatomic) IBOutlet UIView* viewLine1;
@property (strong, nonatomic) IBOutlet UIImageView* ivTitle;
@property (strong, nonatomic) IBOutlet UILabel* lbRow0;
@property (strong, nonatomic) IBOutlet UILabel* lbRow1;
@property (strong, nonatomic) IBOutlet UILabel* lbRow3;
@property (weak, nonatomic) IBOutlet UILabel* lbRow5;
@property (weak, nonatomic) IBOutlet UIButton* complaintBtn; //投诉
@property (weak, nonatomic) IBOutlet UILabel* lab1;
@property (weak, nonatomic) IBOutlet UILabel* lab2;
@property (weak, nonatomic) IBOutlet UILabel* lab3;
@property (weak, nonatomic) IBOutlet UILabel* lab4;
@property (nonatomic, weak) id<ViewForRefundDetailsRightDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* diatanceLineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* distanceLine0Top;
- (void)setShowTypeIsResult:(BOOL)isResult;
- (void)setValues:(NSArray*)arrValues;

@end

