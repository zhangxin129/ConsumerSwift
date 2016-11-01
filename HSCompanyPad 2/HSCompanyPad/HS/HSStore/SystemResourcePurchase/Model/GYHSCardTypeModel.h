//
//  GYHSCardTypeModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSCardTypeModel : NSObject
/*
 *互生卡样id
 */
@property (nonatomic, copy) NSString *cardStyleId;
/*
 *订单编号
 */
@property (nonatomic, copy) NSString *orderNo;
/*
 *卡样名称
 */
@property (nonatomic, copy) NSString *cardStyleName;
/*
 *卡样状态
 *0未启用
 *1已启用
 *2已停用
 */
@property (nonatomic, copy) NSString *enableStatus;
/*
 *订单支付状态
 *0：待付款
 *1：处理中
 *2：已付款
 *3：付款失败
 */
@property (nonatomic, copy) NSString *payStatus;
/*
 *是否锁定
 *true：锁定
 *false：未锁定
 */
@property (nonatomic, copy) NSString *isLock;
/*
 *申请时间
 */
@property (nonatomic, copy) NSString *reqTime;
/*
 *数量
 */
@property (nonatomic, copy) NSString *quantity;
/*
 *价格
 */
@property (nonatomic, copy) NSString *price;
/*
 *是否个性 不是则为标准卡
 */
@property (nonatomic, copy) NSString *isSpecial;
/*
 *本地标示是否被选中
 */
@property (nonatomic, assign) BOOL isSelected;
/*
 *图片
 */
@property (nonatomic, copy) NSString *microPic;

@property (nonatomic, copy) NSString *sourceFile;

@end
