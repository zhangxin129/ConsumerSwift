//
//  GYHDCompanyViewController.h
//  HSEnterprise
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "ViewController.h"
#import "GYHDCompanyDetailsView.h"
#import "GYHDCompanyListView.h"
@class GYHDCompanyDetailsView;
@interface GYHDCompanyViewController : ViewController

@property(nonatomic,strong)NSMutableArray*OperatorRelationListArr;//营业点列表数据源
@property(nonatomic,strong)NSMutableArray*companyOperatorListArr;//操作员列表数据源
@property (nonatomic,strong)GYHDCompanyDetailsView *companyDetailsView;//企业操作员视图
@property (nonatomic,strong)GYHDCompanyListView*companyListView;//营业点列表视图
@end
