//
//  GYEasybuySearchViewController.h
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

//搜索状态searchType
typedef NS_ENUM(NSInteger, SearchType) {
    kShops = 1, //商铺
    kGoods = 2, //商品
};

@interface GYEasybuySearchMainController : GYViewController

@property (nonatomic, assign) SearchType searchType;

@end
