//
//  GYHESCDistributionWayViewController.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHESCOrderModel.h"
#import "GYHESCDistributionWayModel.h"

typedef void (^distributionBlock)(GYHESCDistributionTypeModel* typeModel);

@interface GYHESCDistributionWayViewController : GYViewController

@property (nonatomic, strong) GYHESCOrderModel* orderModel;
@property (nonatomic, strong) distributionBlock distributionBlock; //配送方式block

@end
