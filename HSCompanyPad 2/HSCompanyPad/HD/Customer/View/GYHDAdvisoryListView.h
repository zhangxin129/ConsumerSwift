//
//  GYHDAdvisoryListView.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/9.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//  咨询记录

#import <UIKit/UIKit.h>
#import "GYHDCustomerModel.h"
#import "GYHDAdvisoryListModel.h"
@protocol GYHDAdvisoryListViewDelegate<NSObject>

-(void)closeAdvisoryListView;
-(void)showCustomerServiceListDetailViewWithModel:(GYHDAdvisoryListModel*)model;

@end
@interface GYHDAdvisoryListView : UIView
@property(nonatomic,strong)GYHDCustomerModel*model;
@property(nonatomic,weak)id<GYHDAdvisoryListViewDelegate> delegate;
@property(nonatomic, strong)UIButton    *migrateAdvisoryButton;//转移咨询按钮
@property(nonatomic, strong)UIButton    *endAdvisoryButton;//结束咨询按钮
@end
