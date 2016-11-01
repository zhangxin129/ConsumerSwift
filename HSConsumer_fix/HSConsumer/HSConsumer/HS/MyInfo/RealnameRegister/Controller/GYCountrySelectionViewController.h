//
//  GYCountrySelectionViewController.h
//  HSConsumer
//
//  Created by apple on 15-3-10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAddressCountryModel.h"

@protocol selectNationalityDelegate <NSObject>

- (void)selectNationalityModel:(GYAddressCountryModel*)CountryInfo;

@end

@interface GYCountrySelectionViewController : GYViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* marrSourceData;
@property (nonatomic, weak) id<selectNationalityDelegate> Delegate;

@end
