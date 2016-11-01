//
//  GYProvinceViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYChooseAreaModel.h"

typedef NS_ENUM(NSInteger, provinceType) {
    provinceTypePush,
    provinceTypePop
};

@class GYProvinceModel;
@protocol selectProvinceDelegate <NSObject>

@optional
- (void)didSelectProvince:(GYChooseAreaModel*)model;

//provinceTypePop
- (void)returnPopPvovince:(GYProvinceModel*)model;

@end

@interface GYProvinceViewController : GYViewController

@property (nonatomic, weak) id<selectProvinceDelegate> delegate;
@property (nonatomic, strong) NSMutableArray* marrSourceData;
@property (nonatomic, copy) NSMutableString* mstrCountry;
@property (nonatomic, copy) NSString* areaId;
@property (nonatomic, assign) int fromWhere;
@property (nonatomic, assign) provinceType type;
@property (nonatomic, copy) NSString* countryName;

@end
