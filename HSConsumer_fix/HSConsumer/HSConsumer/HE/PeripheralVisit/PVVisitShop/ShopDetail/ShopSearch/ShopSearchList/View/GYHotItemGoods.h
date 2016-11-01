//
//  GYHotItemGoods.h
//  HSConsumer
//
//  Created by apple on 15-3-5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHotItemGoods : NSObject
@property (nonatomic, copy) NSString* strImgUrl;
@property (nonatomic, copy) NSString* strCategoryName;
@property (nonatomic, copy) NSString* strCategoryId;
@property (nonatomic, copy) NSString* strItemId;
@property (nonatomic, copy) NSString* strItemName;
@property (nonatomic, copy) NSString* strVshopId;

@property (nonatomic, copy) NSString* strPV;
@property (nonatomic, copy) NSString *strPrice;
@end
