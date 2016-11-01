//
//  GYHEMyHEHistory.h
//  HS_Consumer_HE
//
//  Created by Yejg on 16/4/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHEMyHEHistory : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *vShopId;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *price;

//+ (instancetype)historyWithDictionary:(NSDictionary *)dict;
//- (NSDictionary *)dictionaryFormat;

@end
