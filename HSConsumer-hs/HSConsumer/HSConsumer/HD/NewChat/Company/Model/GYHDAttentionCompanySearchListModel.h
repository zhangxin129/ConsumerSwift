//
//  GYHDAttentionCompanySearchListModel.h
//  HSConsumer
//
//  Created by shiang on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDAttentionCompanySearchListModel : NSObject
/**头像*/
@property (nonatomic, copy) NSString* companyIcon;
/**标题*/
@property (nonatomic, copy) NSString* companyTitle;
/**详情*/
@property (nonatomic, copy) NSString* companyDetail;
/**shopID*/
@property (nonatomic, copy) NSString* companyShopID;
/**VshopID*/
@property (nonatomic, copy) NSString* companyVshopID;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
