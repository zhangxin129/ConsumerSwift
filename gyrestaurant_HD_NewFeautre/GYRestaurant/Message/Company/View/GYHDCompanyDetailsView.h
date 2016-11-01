//
//  GYHDCompanyDetailsView.h
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDCompanyViewController.h"
#import "GYHDCompanyListView.h"
@class GYHDCompanyViewController;
@interface GYHDCompanyDetailsView : UIView
/**
 *数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic,strong) NSMutableArray *operatorListArr;//所有操作员列表数据源
@property (nonatomic,strong)GYHDCompanyViewController*deledate;
@property(nonatomic,strong)UICollectionView*newsCollectionView;
@property(nonatomic,assign)BOOL isCheckList;//判断是否是点击查看操作员进入
@end
