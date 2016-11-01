//
//  GYHEShopDetailViewController.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYScrollType) {
    GYScrollTypeFatherTabView,
    GYScrollTypeSonTabView
};


@interface GYHEShopDetailViewController : GYViewController

@property (nonatomic, copy)NSString * vShopId;

@end
