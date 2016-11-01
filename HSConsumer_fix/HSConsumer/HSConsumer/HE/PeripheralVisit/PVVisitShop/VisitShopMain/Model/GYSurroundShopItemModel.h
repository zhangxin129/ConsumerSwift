//
//  GYSurroundShopModel.h
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYSurroundShopItemModel : JSONModel
@property (nonatomic, copy) NSString* itemId;
@property (nonatomic, copy) NSString* pv;
@property (nonatomic, copy) NSString* shopId;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* itemName;
@property (nonatomic, copy) NSString* rate;
@property (nonatomic, copy) NSString* salesCount;
@property (nonatomic, copy) NSString* price;
@end
