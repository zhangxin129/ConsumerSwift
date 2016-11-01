//
//  GYEasybuyGoodsInfoViewController.h
//  HSConsumer
//
//  Created by zhangqy on 15/11/11.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, URLType) {
    kGYEasyBuyGetGoodsInfoURL = 1, //
    kGYEasyBuyGoodsSkuURL = 2, //
    kGYEasyBuyAddCartURL = 3, //
    kGYEasyBuyCancelCollectURL = 4,
    kGYEasyBuyCollectURL = 5,
    kGYEasyBuyGetCartMaxSizeURL = 6,
};

@interface GYEasybuyGoodsInfoViewController : GYViewController

//id
@property (copy, nonatomic) NSString* itemId;
@property (copy, nonatomic) NSString* vShopId;
@property (nonatomic, assign) BOOL showCoupon;

@end
