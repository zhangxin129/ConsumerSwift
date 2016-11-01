//
//  GYEasybuyGoodsListViewController.h
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UrlType) {
    kGYEasyBuyTopicListUrl = 1, //请求商品列表
    kGYEasyBuyColumnClassifyUrl = 2, //商品的种类列表
    kGYEasyBuySortNameUrl = 3, //配送方式列表
    kGYEasyBuySortTypeUrl = 4, //服务方式的列表
};

@interface GYEasybuyGoodsListViewController : GYViewController

@property (copy, nonatomic) NSString* categoryId;
@property (copy, nonatomic) NSString* categoryName;

@property (nonatomic, assign) NSInteger index;

@end
