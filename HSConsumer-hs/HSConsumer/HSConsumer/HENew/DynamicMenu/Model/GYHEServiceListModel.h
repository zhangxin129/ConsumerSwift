//
//  GYHEServiceListModel.h
//  HSConsumer
//
//  Created by xiaoxh on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHEServiceListModel : JSONModel
@property (nonatomic,copy) NSString *serCode;
@property (nonatomic,copy) NSString *serTypeId;
@property (nonatomic,copy) NSString *serTypeName;
@end
