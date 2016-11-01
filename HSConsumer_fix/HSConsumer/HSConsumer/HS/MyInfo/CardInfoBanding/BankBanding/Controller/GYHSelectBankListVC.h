//
//  GYBankListViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  银行列表
#import "GYHSBankListModel.h"

@protocol GYHSBankListSelectBankDeleage <NSObject>

- (void)getSelectBank:(GYHSBankListModel*)model selectIndexPath:(NSIndexPath*)selectIndexPath;

@end
#import <UIKit/UIKit.h>

@interface GYHSelectBankListVC : GYViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray* marrBankList;
@property (nonatomic, strong) NSMutableDictionary* filterDictionary;
@property (nonatomic, strong) NSMutableDictionary* nameDictionary;
@property (nonatomic, strong) NSIndexPath* selectIndexPath;

@property (nonatomic, weak) id<GYHSBankListSelectBankDeleage> delegate;

@end
