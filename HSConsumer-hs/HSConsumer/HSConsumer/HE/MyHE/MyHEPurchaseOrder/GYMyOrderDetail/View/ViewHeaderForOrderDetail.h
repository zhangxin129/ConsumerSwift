//
//  ViewHeaderForOrderDetail.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewHeaderForOrderDetail;
@protocol ViewHeaderForOrderDetailDelegate <NSObject>
@optional
- (void)ViewHeaderForOrderDetailContactDidClickedWithView:(ViewHeaderForOrderDetail*)view;

@end

@interface ViewHeaderForOrderDetail : UIView
@property (strong, nonatomic) IBOutlet UILabel* lbLabelLogisticInfo;
@property (strong, nonatomic) IBOutlet UILabel* lbLogisticName;
@property (strong, nonatomic) IBOutlet UILabel* lbLogisticOrderNo;
@property (strong, nonatomic) IBOutlet UIButton* btnCheckLogisticDetail;

@property (strong, nonatomic) IBOutlet UILabel* lbConsignee;
@property (strong, nonatomic) IBOutlet UILabel* lbTel;

@property (strong, nonatomic) IBOutlet UILabel* lbConsigneeAddress;
@property (strong, nonatomic) IBOutlet UIButton* btnVshopName;
@property (weak, nonatomic) IBOutlet UILabel* labVshopName;
@property (strong, nonatomic) IBOutlet UIView* viewBkg2; //新增 物流信息
@property (weak, nonatomic) IBOutlet UIView* viewBkg3; // 自动收货倒计时
@property (weak, nonatomic) IBOutlet UIView* viewBkg0;
@property (weak, nonatomic) IBOutlet UIView* viewBkg1;

@property (weak, nonatomic) IBOutlet UILabel* lbTimeLeft;
@property (weak, nonatomic) IBOutlet UIImageView* mvArrowRight; // add by songjk 进入商铺按钮

@property (strong, nonatomic) NSString* strCheckLogisticDetailUrl; //保存查看物流详情的URL，初始为nil

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* distanceTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewbBGHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* addressDistanceTopConstraint;

+ (CGFloat)getHeight;

@property (weak, nonatomic) id<ViewHeaderForOrderDetailDelegate> delegate;
@end
