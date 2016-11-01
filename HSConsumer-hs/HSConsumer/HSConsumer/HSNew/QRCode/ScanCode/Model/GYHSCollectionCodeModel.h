//
//  GYHSCollectionCodeModel.h
//  HSConsumer
//
//  Created by sqm on 16/10/10.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSCollectionCodeModel : JSONModel
@property (nonatomic, copy) NSString *amount;//金额，codeType为1时，该值才有意义
@property (nonatomic, copy) NSString *codeId;//二维码ID
@property (nonatomic, copy) NSString *codeName;//二维码名称
@property (nonatomic, copy) NSString *codeType;//31为固定消费金额的二维码，32为非固定消费金额的二维码
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, copy) NSString *entName;//企业名称
@property (nonatomic, copy) NSString *status;//状态，0为已禁用，1为使用中
@property (nonatomic, copy) NSString *entCustId;//企业客户号
@property (nonatomic, copy) NSString *minPointRate;//最小积分比例，codeType为1时与maxPointRate值相同
@property (nonatomic, copy) NSString *maxPointRate;//最大积分比例
@property (nonatomic, copy) NSString *freePayType;//是否免密
@property (nonatomic, copy) NSString *entResNo;//企业互生号

@property (nonatomic, assign) BOOL isExpired;//是否已失效

@end
