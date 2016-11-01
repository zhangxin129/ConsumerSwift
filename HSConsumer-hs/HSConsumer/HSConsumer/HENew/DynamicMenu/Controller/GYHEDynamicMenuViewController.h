//
//  GYHEDynamicMenuViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/10/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,GYEntranceType){
    GYEntranceVisitSurroundType = 1,//入口为周边逛
    GYEntranceEasyBuyType = 2   //入口为轻松购
};

typedef NS_ENUM(NSUInteger,GYDynamicMenuType){
   GYVisitRecordType = 0, //光顾纪录
   GYFocuStoreType = 1, //关注店铺
   GYCollectionGoodsType = 2, //收藏商品
   GYBrowseRecordsType = 3  //浏览记录
};
@interface GYHEDynamicMenuViewController : GYViewController
@property (nonatomic,assign)GYEntranceType  entranceType;
@property (nonatomic,assign)GYDynamicMenuType  dynamicMenuType;
@end
