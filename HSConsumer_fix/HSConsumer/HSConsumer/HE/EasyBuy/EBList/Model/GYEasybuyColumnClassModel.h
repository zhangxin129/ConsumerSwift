//
//  GYEasybuyColumnClassModel.h
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GYEasybuyColumnClassSonModel <NSObject>
@end

@interface GYEasybuyColumnClassModel : JSONModel

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSArray<GYEasybuyColumnClassSonModel>* categories;

@end

@interface GYEasybuyColumnClassSonModel : JSONModel

@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface GYEasybuySortModel : JSONModel

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* sortType;

@end