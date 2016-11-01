//
//  GYShopBrandsCell.h
//  HSConsumer
//
//  Created by apple on 15/11/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYShopBrandModel.h"
@interface GYShopBrandsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton* stateBtn; //按钮状态
@property (weak, nonatomic) IBOutlet UILabel* brandLabel; //品牌名
@property (nonatomic, assign) BOOL isSelect; //判断是否选定
- (void)refreshCellWithModel:(GYShopBrandModel *)model;
@end
