//
//  GYHSBasicInformationModel.h
//  HSConsumer
//
//  Created by zhangqy on 16/4/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSBasicInformationModel : JSONModel

@property (nonatomic, copy) NSString* custId;
/**昵称*/
@property (nonatomic, copy) NSString* nickname;
/**年龄*/
@property (nonatomic, copy) NSString* age;
/**姓名*/
@property (nonatomic, copy) NSString* name;
/**头像*/
@property (nonatomic, copy) NSString* headShot;
/**个性签名*/
@property (nonatomic, copy) NSString* individualSign;
/**性别 1：男  0：女*/
@property (nonatomic, copy) NSString* sex;
/**出生年月*/
@property (nonatomic, copy) NSString* birthday;
/**爱好*/
@property (nonatomic, copy) NSString* hobby;
/**血型
 * 1：A;2：B;3：AB;4：O;5：其他*/
@property (nonatomic, copy) NSNumber* blood;
/**职业*/
@property (nonatomic, copy) NSString* job;
/**电话*/
@property (nonatomic, copy) NSString* telNo;
/**邮编*/
@property (nonatomic, copy) NSString* postcode;
/**邮箱*/
@property (nonatomic, copy) NSString* email;
/**毕业院校*/
@property (nonatomic, copy) NSString* graduateSchool;
/**手机号*/
@property (nonatomic, copy) NSString* mobile;
/**地址*/
@property (nonatomic, copy) NSString* homeAddr;
/**微信号*/
@property (nonatomic, copy) NSString* weixin;
/**qq号*/
@property (nonatomic, copy) NSString* qqNo;
/**国家编号*/
@property (nonatomic, copy) NSString* countryNo;
/**省编号*/
@property (nonatomic, copy) NSString* provinceNo;
/**市编号*/
@property (nonatomic, copy) NSString* cityNo;
/**国家*/
@property (nonatomic, copy) NSString* country;
/**省*/
@property (nonatomic, copy) NSString* province;
/**市*/
@property (nonatomic, copy) NSString* city;
/**区域*/
@property (nonatomic, copy) NSString *area;
/**地址*/
@property (nonatomic, copy) NSString *address;
@end
