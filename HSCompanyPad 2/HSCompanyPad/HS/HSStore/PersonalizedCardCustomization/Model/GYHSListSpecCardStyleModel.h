//
//  GYHSListSpecCardStyleModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSListSpecCardStyleModel : NSObject

/*
 *卡的费用
 */
@property (nonatomic, copy) NSString *cardStyleFee;
/*
 *互生卡样id
 */
@property (nonatomic, copy) NSString *cardStyleId;
/*
 *卡样名称
 */
@property (nonatomic, copy) NSString *cardStyleName;

@property (nonatomic, copy) NSString *custId;
@property (nonatomic, copy) NSString *custName;
/*
 *卡样状态
 *0未启用
 *1已启用
 *2已停用
 */
@property (nonatomic, copy) NSString *enableStatus;

@property (nonatomic, copy) NSString *entResNo;
/*
 *是否确认
 *true：确认
 *false：未确认
 */
@property (nonatomic, copy) NSString *isConfirm;//是否确认true：确认 false：未确认
/*
 *是否锁定
 */
@property (nonatomic, copy) NSString *isLock;
/*
 *订单号
 */
@property (nonatomic, copy) NSString *orderNo;
/*
 *订单支付状态
 *0：待付款
 *1：处理中
 *2：已付款
 *3：付款失败
 */
@property (nonatomic, copy) NSString *payStatus;
/*
 *申请时间
 */
@property (nonatomic, copy) NSString *reqTime;
/*
 *评论
 */
@property (nonatomic, copy) NSString *orderRemark;
/*
 *卡样正面
 */
@property (nonatomic, copy) NSString *microPic;

@property (nonatomic, copy) NSString *sourceFile;

@property (nonatomic, copy) NSString *mSourceFile;

@property (nonatomic, copy) NSString *confirmFile;

@end
