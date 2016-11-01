//
//  GYCitySelectViewController.h
//  HSConsumer
//
//  Created by apple on 15-2-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

@protocol selectCity <NSObject>

- (void)getCity:(NSString*)CityTitle WithType:(int)type;

@end

#import <UIKit/UIKit.h>

@interface GYCitySelectViewController : GYViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray* marrDatasource;

@property (nonatomic, strong) NSMutableArray* indexMarr; //索引

@property (nonatomic, strong) NSMutableArray* chineseString;

@property (nonatomic, weak) id<selectCity> delegate;

@end
