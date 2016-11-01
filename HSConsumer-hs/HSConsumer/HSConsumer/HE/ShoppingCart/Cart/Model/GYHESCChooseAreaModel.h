//
//  GYHESCChooseAreaModel.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/24.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHESCChooseAreaModel : JSONModel

@property (nonatomic, copy) NSString* tel; //服务热线
@property (nonatomic, copy) NSString* shopId; //商店id
@property (nonatomic, copy) NSString* shopName; //商店名
@property (nonatomic, copy) NSString* addr; //地址
@property (nonatomic, copy) NSString* lat; //纬度
@property (nonatomic, copy) NSString* longitude; //经度

@end
