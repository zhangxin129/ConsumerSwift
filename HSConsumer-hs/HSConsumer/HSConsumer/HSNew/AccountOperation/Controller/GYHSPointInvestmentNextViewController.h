//
//  GYHSPointInvestmentNextViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSCardBandModel.h"

typedef  NS_ENUM(NSInteger,GYHSAccountOperationType){
    GYHSPointHSBType = 0,  //积分转互生币
    GYHSPointInvestmentType = 1 , //积分投资
    GYHSHSBCurrencyType = 2   //互生币转货币
};

@protocol GYHSSuccessfulDealDelegate <NSObject>
@optional
-(void)successfulDeal;//交易成功后刷新账户余额

@end
@interface GYHSPointInvestmentNextViewController : GYViewController
//用于上一步传递过来的详情信息
@property (nonatomic, assign) double inputValue;
@property (nonatomic, copy) NSString* integral;
@property (nonatomic,assign)GYHSAccountOperationType accountOperationType;
@property (nonatomic,copy)NSArray *delArray;
@property (nonatomic,copy)GYHSCardBandModel *bandModel;

@property (nonatomic,weak)id <GYHSSuccessfulDealDelegate>  successfulDealDelegate;
@end
