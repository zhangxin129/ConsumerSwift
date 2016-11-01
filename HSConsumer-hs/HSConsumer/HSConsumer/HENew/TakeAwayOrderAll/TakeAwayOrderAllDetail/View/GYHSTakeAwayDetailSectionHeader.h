//
//  GYHSTakeAwayDetailSectionHeader.h
//  HSConsumer
//
//  Created by kuser on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSTakeAwayDetailAllModel;

@protocol GYHSTakeAwayDetailSectionHeaderDelegate;

@interface GYHSTakeAwayDetailSectionHeader : UIView

@property (strong, nonatomic) IBOutlet UILabel* shopNameLabel;
@property (nonatomic, strong) GYHSTakeAwayDetailAllModel* model;
@property (strong, nonatomic) IBOutlet UILabel* connectLabel;
@property (nonatomic, weak) id<GYHSTakeAwayDetailSectionHeaderDelegate> delegate;

@end

// 代理---------------------------------
@protocol GYHSTakeAwayDetailSectionHeaderDelegate <NSObject>

@optional

- (void)didSelectedIntoShopBtn:(GYHSTakeAwayDetailSectionHeader*)header;
- (void)didSelectedContactBtn:(GYHSTakeAwayDetailSectionHeader*)header;

@end
