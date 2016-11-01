//
//  GYSearchShopsMainModel.h
//  HSConsumer
//
//  Created by apple on 15/11/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewModel.h"

@interface GYSearchShopsMainModel : ViewModel
@property (nonatomic, copy) NSString* categoryName; //标题名
@property (nonatomic, copy) NSString* idStr; //分类id
@property (nonatomic, copy) NSString* picAddr; //图片url
@property (nonatomic, copy) NSString* companyName; //商店名
@property (nonatomic, copy) NSString* addr; //商店地址
@property (nonatomic, copy) NSString* shopPic; //商店图片
@property (nonatomic, copy) NSString* tel; //电话
@property (nonatomic, copy) NSString* dist; //距离
@property (nonatomic, copy) NSString* beReach; //即
@property (nonatomic, copy) NSString* beSell; //卖
@property (nonatomic, copy) NSString* beCash; //现
@property (nonatomic, copy) NSString* beTake; //提
@property (nonatomic, copy) NSString* beQuan; //券
@property (nonatomic, copy) NSString* categoryNames; //主营类别
@property (nonatomic, copy) NSString *vShopId;//商铺id
@property (nonatomic, copy) NSString *shopId;//营业点id
@end
