//
//  GYHESCDefaultAddressModel.h
//  HS_Consumer_HE
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHESCDefaultAddressModel : JSONModel

@property (nonatomic, copy) NSString* postCode;
@property (nonatomic, copy) NSString* receiver;
@property (nonatomic, copy) NSString* addrId;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* provinceNo;
@property (nonatomic, copy) NSString* isDefault;
@property (nonatomic, copy) NSString<Optional>* area;
@property (nonatomic, copy) NSString* cityNo;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* custId;
@property (nonatomic, copy) NSString* telphone;
@property (nonatomic, copy) NSString* countryNo;

@end
