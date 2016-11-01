//
//  GYHDSearchUserModel.h
//  HSConsumer
//
//  Created by wangbiao on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSearchUserGroupModel: NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong)NSMutableArray *userArray;
@end

@interface GYHDSearchUserModel : NSObject
/**头像地址*/
@property(nonatomic, copy)NSString *iconString;
/**名字*/
@property(nonatomic, copy)NSString *nameString;
/**互生号*/
@property(nonatomic, copy)NSString *hushengString;
/**用户类型*/
@property(nonatomic, copy)NSString *userType;
/**商品ID*/
@property(nonatomic, copy)NSString *vshopID;
/**地区*/
@property(nonatomic, copy)NSString *address;
/**爱好*/
@property(nonatomic, copy)NSString *hobby;
/**签名*/
@property(nonatomic, copy)NSString *sign;
/**资源号*/
@property(nonatomic, copy)NSString *custID;
/**好友添加状态*/
@property(nonatomic, copy)NSString *friendStatus;
/**手机名字*/
@property(nonatomic, copy)NSString *bookName;
@end
