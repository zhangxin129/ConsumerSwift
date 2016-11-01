//
//  GYHEAreaLocationModel.h
//  HSConsumer
//
//  Created by xiaoxh on 16/10/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHEChildsChildsModel : JSONModel
@property (nonatomic,copy) NSString *areaCode;
@property (nonatomic,copy) NSString *areaName;
@property (nonatomic,copy) NSString *parentCode;
@property (nonatomic,copy) NSString *sortOrder;

@end

@protocol GYHEChildsChildsModel

@optional

@end

@interface GYHEChildsModel : JSONModel
@property (nonatomic,copy) NSString *areaCode;
@property (nonatomic,copy) NSString *areaName;
@property (nonatomic,strong) NSMutableArray<GYHEChildsChildsModel>  *childs;
@property (nonatomic,copy) NSString *parentCode;
@property (nonatomic,copy) NSString *sortOrder;

@end

@protocol GYHEChildsModel

@optional

@end
@interface GYHEAreaLocationModel : JSONModel
@property (nonatomic,copy) NSString *areaCode;
@property (nonatomic,copy) NSString *areaName;
@property (nonatomic,strong) NSMutableArray <GYHEChildsModel> *childs;
@property (nonatomic,copy) NSString *parentCode;
@property (nonatomic,copy) NSString *sortOrder;
@property (nonatomic,copy) NSString *msg;
@end