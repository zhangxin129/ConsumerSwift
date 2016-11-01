//
//  GYHSCompanyPointDetailModel.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
@interface GYHSCompanyPointDetailModel : JSONModel

/**
 *  分配积分数 发生金额
 */
@property (nonatomic, copy) NSString *amount;
/**
 * 备注 再增值积分分配企业收入
 */
@property (nonatomic, copy) NSString *remark;
/**
 *交易子系统
 */
@property (nonatomic, copy) NSString *transType;
@property (nonatomic, copy) NSString *transTypePs;
//transTypePs
/**
 *
 */
@property (nonatomic, copy) NSString *sourceTransNo;
/**
 *账户余额
 */
@property (nonatomic, copy) NSString *accBalanceNew;
/**
 *
 */
@property (nonatomic, strong) NSNumber *businessType;
/**
 *
 */
@property (nonatomic, copy) NSString *batchNo;


@property (nonatomic, copy) NSString *transNo;
/**
 *交易类型
 */
@property (nonatomic, copy) NSString *transSys;

/**
 *  交易日期
 */
@property (nonatomic, copy) NSString *transDate;




@end
