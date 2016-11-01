//
//  GYHSExchangeHSBNextViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYQRPayModel.h"
#import "GYHSOtherPayStyleViewController.h"


@interface GYHSExchangeHSBNextViewController : GYViewController
@property (nonatomic, assign) double inputValue; //传过来的值
@property (nonatomic, copy) NSString *transNo;//传过来的流水号
@property (nonatomic, assign) GYFunctionType currentFunctionType;
@property (nonatomic, strong) GYQRPayModel* model;
@property (nonatomic, strong) NSDate *date;
@end
