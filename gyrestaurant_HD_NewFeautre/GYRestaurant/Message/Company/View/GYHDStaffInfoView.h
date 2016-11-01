//
//  GYHDStaffInfoView.h
//  HSEnterprise
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDSaleListModel.h"
#import "GYHDOpereotrListModel.h"
@interface GYHDStaffInfoView : UIView
@property(nonatomic,strong)GYHDSaleListModel*model;//营业点列表模型
@property(nonatomic,strong)GYHDOpereotrListModel*operatorModel;//操作员列表模型
@end
