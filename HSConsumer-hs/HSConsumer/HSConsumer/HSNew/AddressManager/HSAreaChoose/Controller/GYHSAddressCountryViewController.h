//
//  GYAddressCountryViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    noLocationfunction = 1,
    locationFunction,
} kAddressType;

typedef NSComparisonResult (^NSComparator)(id obj1, id obj2);
@interface GYHSAddressCountryViewController : GYViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* marrSourceData;
@property (nonatomic, copy) NSString* strSelectedArea;
@property (nonatomic, assign) kAddressType addressType;
@property (nonatomic, assign) int fromBandingCard;

@end
