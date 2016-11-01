//
//  GYHSPointInvestmentViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSPointInvestmentNextViewController.h"

@interface GYHSPointInvestmentViewController : GYViewController
@property (nonatomic,assign)GYHSAccountOperationType accountOperationType;

-(void)refreshAccountBalance;

@end
