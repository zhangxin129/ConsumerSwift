//
//  GYHEListSearchViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

//搜索状态searchType
typedef NS_ENUM(NSInteger, GYHESearchType) {
    GYHESearchTypeShops = 1, //商铺
    GYHESearchTypeGoods = 2, //商品
};
@interface GYHEListSearchViewController : GYViewController

@property (nonatomic, assign) GYHESearchType searchType;
@end
