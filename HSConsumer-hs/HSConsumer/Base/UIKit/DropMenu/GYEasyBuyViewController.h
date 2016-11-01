//
//  GYEasyBuyViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "DropDownWithChildChooseProtocol.h"
//协议目的：将controller中创建的tableview  选中title 和对应 section 传到另一个controler 中显示
@protocol sendTitleText <NSObject>

- (void)chooseRowWith:(NSString*)titile WithSection:(NSInteger)index WithTableView:(UITableView*)table;
@optional
- (void)hidenBackgroundView;

@end

#import <UIKit/UIKit.h>
#import "DropDownWithChildListView.h"

@interface GYEasyBuyViewController : GYViewController <UITableViewDataSource, UITableViewDelegate, DropDownWithChildChooseDataSource, DropDownWithChildChooseDelegate, deleteTableviewInSectionOne>

@property (nonatomic, weak) id<sendTitleText> delegate;
@property (nonatomic, strong) NSString *strGoodsCategoryId;
@end
