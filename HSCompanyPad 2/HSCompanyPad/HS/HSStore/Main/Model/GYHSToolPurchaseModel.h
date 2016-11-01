//
//  GYToolApplyNewModel.h
//  company
//
//  Created by apple on 15/12/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSToolPurchaseModel : NSObject
@property (nonatomic, copy) NSString *categoryCode;//工具类别代码
@property (nonatomic, copy) NSString *enableStatus;//工具状态:0新建，1已上架，2已下架
@property (nonatomic, copy) NSString *exeCustId;
@property (nonatomic, copy) NSString *microPic;//缩略图
@property (nonatomic, copy) NSString *price;//单价
@property (nonatomic, copy) NSString *productId;//工具编号
@property (nonatomic, copy) NSString *productName;//产品名称
@property (nonatomic, copy) NSString *status;//审批状态:
@property (nonatomic, copy) NSString *mayBuyquantity; //可申购最大数量
//0申请上架 1同意上架 2拒绝上架
//3申请下架 4同意下架 5拒绝下架
@property (nonatomic, copy) NSString *quanilty;//数量
@property (assign, nonatomic) BOOL selected;

@property (nonatomic,strong) NSMutableArray *marrStyles;//样式数组
@property (nonatomic, copy) NSString *canBuyNum;
@property (nonatomic, copy) NSString *pic;//本地写死的图片，如果这个有值，就使用这个图片 用在消费者资源申购中的特殊显示使用

@end
