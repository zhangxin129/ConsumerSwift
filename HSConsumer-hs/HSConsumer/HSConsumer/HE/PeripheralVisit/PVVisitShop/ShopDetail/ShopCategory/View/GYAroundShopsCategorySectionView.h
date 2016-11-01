//
//  GYAroundShopsCategorySectionView.h
//  HSConsumer
//
//  Created by Apple03 on 15/11/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYAroundShopsCategoryModel;

typedef void (^chooseSectionBlock)(NSInteger index);
typedef void (^showBlock)(NSInteger index);
@interface GYAroundShopsCategorySectionView : UIView
- (void)setViewWithData:(GYAroundShopsCategoryModel*)model;
@property (nonatomic, strong) chooseSectionBlock chooseBlock;
@property (nonatomic, strong) showBlock ShowBlock;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) GYAroundShopsCategoryModel* categoryModel;
@end
