//
//  GYHDCountrySelectionViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAddressCountryModel.h"

@protocol selectNationalityDelegate <NSObject>
@optional
- (void)selectNationalityModel:(GYAddressCountryModel*)CountryInfo;

@end

@interface GYHDCountrySelectionViewController : GYViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* marrSourceData;
@property (nonatomic, weak) id<selectNationalityDelegate> Delegate;
@property (nonatomic,copy)NSString *countryName;
@end
