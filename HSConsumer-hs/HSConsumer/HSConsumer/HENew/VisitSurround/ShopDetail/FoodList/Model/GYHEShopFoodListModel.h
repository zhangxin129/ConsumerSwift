//
//  GYHEShopFoodListModel.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface GYHEShopFoodListModel : JSONModel



@end

@protocol GYHEShopFoodMainCatesListModel;

@interface GYHEShopFoodMainCatesListModel : JSONModel

@property (nonatomic ,copy)NSString *id;// 3073941738947584;
@property (nonatomic ,copy)NSString *name;// "\U96f6\U552e1";
@property (nonatomic ,copy)NSString *sort;// 959;
@property (nonatomic ,assign)BOOL isSelected;

@end


