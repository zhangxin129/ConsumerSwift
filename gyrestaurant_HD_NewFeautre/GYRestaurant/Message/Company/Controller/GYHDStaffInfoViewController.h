//
//  GYHDStaffInfoViewController.h
//  HSEnterprise
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDSaleListModel.h"
#import "GYHDOpereotrListModel.h"
@interface GYHDStaffInfoViewController : UIViewController
@property (nonatomic,strong)GYHDSaleListModel*model;//营业点列表模型
@property (nonatomic,strong)GYHDOpereotrListModel*OperatorModel;//操作员列表模型
@property (nonatomic,assign)BOOL isCheckAllOperator;//是否点击查看所有操作员
@property (nonatomic,assign)BOOL isFromSearch;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *primaryId;
@end
