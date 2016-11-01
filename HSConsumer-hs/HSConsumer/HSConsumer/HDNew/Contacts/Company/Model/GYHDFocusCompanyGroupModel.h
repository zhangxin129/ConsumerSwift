//
//  GYHDFocusCompanyGroupModel.h
//  HSConsumer
//
//  Created by shiang on 16/3/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDFocusCompanyGroupModel : NSObject
/**分组标题*/
@property (nonatomic, copy) NSString* focusCompanyGroupTitle;
/**某分类关注企业数组*/
@property (nonatomic, strong) NSMutableArray* focusCompanyGroupArray;
@end

@interface GYHDFocusCompanyModel : NSObject
/**商铺VshopID*/
@property (nonatomic, copy) NSString* focusCompanyVshopID;
/**商铺shopID*/
@property (nonatomic, copy) NSString* focusCompanyShopID;
/**关注企业头像*/
@property (nonatomic, copy) NSString* focusCompanyIcon;
/**关注企业名称*/
@property (nonatomic, copy) NSString* focusCompanyName;
/**关注企业内容*/
@property (nonatomic, copy) NSString* focusCompanyDetail;

/**关注企业内网址*/
@property (nonatomic, copy) NSString* focusCompanyUrlString;
/**custID*/
@property( nonatomic, copy) NSString* focusCompanyCustID;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end