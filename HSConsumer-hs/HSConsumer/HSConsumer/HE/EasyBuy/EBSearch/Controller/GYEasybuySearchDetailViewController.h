//
//  GYEasybuySearchDetailViewController.h
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasybuySearchMainController.h"

typedef NS_ENUM(NSUInteger, UrlType) {
    kGYEasyBuySearchListUrl = 1, //请求商品列表
    kGYEasyBuyColumnClassifyUrl = 2, //商品的种类列表
    kGYEasyBuySortNameUrl = 3, //配送方式列表
    kGYEasyBuySortTypeUrl = 4, //服务方式的列表
    kGYEasyBuySearchShopsListUrl = 5 //商铺列表
};

@interface GYEasybuySearchDetailViewController : GYViewController

@property (nonatomic, copy) NSString* keyWord;
@property (nonatomic, assign) SearchType searchType;

@end
