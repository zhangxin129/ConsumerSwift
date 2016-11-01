//
//  GYToolApplyAddressNewModel.h
//  company
//
//  Created by apple on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYAddressCountryModel.h"
@interface GYHSAddressListModel : NSObject
@property (nonatomic,copy) NSString *contactAddr;
/**收货人电话*/
@property (nonatomic,copy) NSString *contactName;
/**收货人地址*/
@property (nonatomic,copy) NSString *contactPhone;
/**收货人电话*/
@property (nonatomic,copy) NSString *telphone;
/**收货人邮编*/
@property (nonatomic,copy) NSString *postCode;
@property (nonatomic,copy) NSString *cityNo;
//是否默认
@property (nonatomic, copy) NSString *isDefault;

@property (nonatomic, copy) NSString *provinceNo;

@property (nonatomic, assign) BOOL isSelected;
//完整地址信息
@property (nonatomic,strong) GYCityAddressModel * cityModel;

@property (nonatomic, copy) NSString *addressId;//如果为非自定义的则没有值
//获取详情
- (void)getDetailArressWithBlock:(void(^)(NSString *address)) block;

#define kAddressFont [UIFont systemFontOfSize:14]
#define kNameFont [UIFont systemFontOfSize:16]


@end

@interface GYHSAddressDetailModel : NSObject
@property (nonatomic, copy) NSString *mobile;//手机
@property (nonatomic, copy) NSString *provinceNo;
@property (nonatomic, copy) NSString *telphone;//固话
@property (nonatomic, copy) NSString *isDefault;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *addrId;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *countryNo;
@property (nonatomic, copy) NSString *custId;
@property (nonatomic, copy) NSString *cityNo;
@property (nonatomic, copy) NSString *receiver;


@end
