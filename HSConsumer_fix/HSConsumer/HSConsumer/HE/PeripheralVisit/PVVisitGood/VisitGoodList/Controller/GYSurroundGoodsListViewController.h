//
//  GYSurroundGoodsListViewController.h
//  GYHSConsumer_SurroundVisit
//
//  Created by apple on 16/3/22.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, kUrlTag) {
    //请求URL的Tag
    kGoodsTopicListTag = 1,
    kCategoryTag = 2,
    kCategorySonTag = 3,
    kSortTypeTag = 4,
    kServiceTypeTag = 5,
    kLocationTypeTag = 6,
};

@interface GYSurroundGoodsListViewController : GYViewController

@property (nonatomic, strong) NSString* categoryName;
@property (nonatomic, strong) NSString* categoryId;

@end
