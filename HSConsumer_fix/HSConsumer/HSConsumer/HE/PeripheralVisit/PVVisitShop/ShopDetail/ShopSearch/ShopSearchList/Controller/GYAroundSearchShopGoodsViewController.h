//
//  GYAroundSearchShopGoodsViewController.h
//  HSConsumer
//
//  Created by apple on 15/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GYAroundSearchShopGoodsViewController : GYViewController
@property (copy, nonatomic) NSString* vshopId;
@property (copy, nonatomic) NSString* categoryName;
@property (copy, nonatomic) NSString* categoryId;
@property (strong, nonatomic) NSMutableDictionary* params;
@property (copy, nonatomic) NSString* brandName;
@property (nonatomic, assign) BOOL isNeedLoad;

- (void)loadDataAll;
@end
