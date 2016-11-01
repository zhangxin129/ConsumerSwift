//
//  GYHESCDiscountInfoModel.h
//  HS_Consumer_HE
//
//  Created by admin on 16/4/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GYHESCDiscountDetailModel

@end
@interface GYHESCDiscountDetailModel : JSONModel

@property (nonatomic, copy) NSString* amount;
@property (nonatomic, copy) NSString* couponId;
@property (nonatomic, copy) NSString* couponName;
@property (nonatomic, copy) NSString* num;

@end

@protocol GYHESCOrderCouponModel

@end
@interface GYHESCOrderCouponModel : JSONModel

@property (nonatomic, copy) NSString* orderKey;
@property (nonatomic, strong) NSArray<GYHESCDiscountDetailModel>* list;

@end

@protocol GYHESCExpressFeeModel

@end
@interface GYHESCExpressFeeModel : JSONModel

@property (nonatomic, copy) NSString* expressFee; //快递费
@property (nonatomic, copy) NSString* orderKey; //即shopId

@end

@protocol GYHESCUserCouponModel

@end
@interface GYHESCUserCouponModel : JSONModel

@property (nonatomic, copy) NSString* num;
@property (nonatomic, copy) NSString<Optional>* couponId;

@end

@interface GYHESCDiscountInfoModel : JSONModel

@property (nonatomic, strong) NSArray<GYHESCOrderCouponModel, Optional>* orderCouponList;
@property (nonatomic, strong) NSArray<GYHESCExpressFeeModel>* expressFeeList;
@property (nonatomic, strong) NSArray<GYHESCUserCouponModel, Optional>* userCouponList;

@end
