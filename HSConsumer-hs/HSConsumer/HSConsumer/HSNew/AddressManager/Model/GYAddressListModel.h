//
//  GYAddressListModel.h
//  HSConsumer
//
//  Created by lizp on 2016/10/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class GYAddressListHeightModel;
@interface GYAddressListModel : JSONModel


@property (nonatomic,copy) NSString <Optional>*address ;
@property (nonatomic,copy) NSString <Optional>*area ;
@property (nonatomic,copy) NSString <Optional>*city ;
@property (nonatomic,copy) NSString <Optional>*country ;
@property (nonatomic,copy) NSString <Optional>*createTime ;
@property (nonatomic,copy) NSString <Optional>*creator ;
@property (nonatomic,copy) NSString <Optional>*ecKey ;
@property (nonatomic,copy) NSString <Optional>*fixedTelephone ;
@property (nonatomic,copy) NSString <Optional>*from ;
@property (nonatomic,copy) NSString <Optional>*idString ;//id
@property (nonatomic,copy) NSString <Optional>*isDefault ;
@property (nonatomic,copy) NSString <Optional>*mid ;
@property (nonatomic,copy) NSString <Optional>*modifer ;
@property (nonatomic,copy) NSString <Optional>*modifyTime ;
@property (nonatomic,copy) NSString <Optional>*phone;
@property (nonatomic,copy) NSString <Optional>*postcode ;
@property (nonatomic,copy) NSString <Optional>*province ;
@property (nonatomic,copy) NSString <Optional>*receiverName;
@property (nonatomic,copy) NSString <Optional>*status ;
@property (nonatomic,copy) NSString <Optional>*street ;
@property (nonatomic,copy) NSString <Optional>*type ;
@property (nonatomic,copy) NSString <Optional>*userId ;
@property (nonatomic, strong) GYAddressListHeightModel *heightModel;


-(GYAddressListModel *)dataWithDic:(NSDictionary *)dic isFood:(BOOL)isFood;

@end
