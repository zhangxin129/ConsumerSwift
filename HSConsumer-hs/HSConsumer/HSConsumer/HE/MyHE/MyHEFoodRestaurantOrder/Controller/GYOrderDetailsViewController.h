//
//  GYOrderDetailsViewController.h
//  HSConsumer
//
//  Created by appleliss on 15/9/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYOrderModel.h"
#import "FDFoodModel.h"
#import "GYPayMentModel.h"
@interface GYOrderDetailsViewController : GYViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) GYOrderModel* moder;

@property (weak, nonatomic) IBOutlet UIButton* paybtn;
@property (weak, nonatomic) IBOutlet UIButton* cancikbtn;
@property (weak, nonatomic) IBOutlet UIButton* newclick;
@property (weak, nonatomic) IBOutlet UITableView* myTableView;
@property (nonatomic, copy) NSString* orderId;
@property (nonatomic, copy) NSString* moderType;
@property (strong, nonatomic) GYPayMentModel* pyModel;
@property (nonatomic, copy) NSString* mobile;

@property (nonatomic, assign) BOOL isComeOrder;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceBottomConstraint;


//@property (weak, nonatomic) IBOutlet UIView *btnBG;
//@property (weak, nonatomic) IBOutlet UIView *myview;
//
@end
