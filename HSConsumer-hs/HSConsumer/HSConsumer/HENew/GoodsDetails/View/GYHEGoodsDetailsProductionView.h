//
//  GYHEGoodsImageTextDetailsView.h
//  HSConsumer
//
//  Created by lizp on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

@protocol GYHEGoodsImageTextDetailsViewDelegate<NSObject>

@optional

-(void)checkProductionDetail;
-(void)productionBack;

@end

#import <UIKit/UIKit.h>
#import "GYHEGoodsDetailsModel.h"

@interface GYHEGoodsDetailsProductionView : UIView

@property (nonatomic,weak) id<GYHEGoodsImageTextDetailsViewDelegate>delegate;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *productButton;//箭头按钮
@property (nonatomic,strong) UIView *overlayView;//背景
@property (nonatomic,strong) UIControl *footerControl;//尾部
@property (nonatomic,strong) GYHEGoodsDetailsModel *model;


@end
