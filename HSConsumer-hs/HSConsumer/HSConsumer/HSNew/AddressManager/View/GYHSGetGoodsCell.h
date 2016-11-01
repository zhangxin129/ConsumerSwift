//
//  GYHSGetGoodsCell.h
//  HSConsumer
//
//  Created by lizp on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSGetGoodsCellIdentifier @"GYHSGetGoodsCell"

#import <UIKit/UIKit.h>

@class GYAddressListModel;
@interface GYHSGetGoodsCell : UITableViewCell

@property (nonatomic, strong) GYAddressListModel* model;
@property (nonatomic, assign) BOOL isFood;

@property (nonatomic,strong) UIButton *editorBtn;//编辑
@property (nonatomic,strong) UIButton *deleteBtn;//删除
@property (nonatomic,strong) UIButton *defaultBtn;//设置默认地址 button

@end
