//
//  GYHSServerDetailSectionHeader.h
//  HSConsumer
//
//  Created by zhengcx on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSServerDetailAllModel;

@protocol GYHSServerDetailSectionHeaderDelegate;

@interface GYHSServerDetailSectionHeader : UIView

@property (nonatomic, strong) GYHSServerDetailAllModel* model;

@property (strong, nonatomic) IBOutlet UILabel* shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel* connectLabel;

@property (nonatomic, weak) id<GYHSServerDetailSectionHeaderDelegate> delegate;

@end

// 代理---------------------------------
@protocol GYHSServerDetailSectionHeaderDelegate <NSObject>

@optional

- (void)didSelectedIntoShopBtn:(GYHSServerDetailSectionHeader*)header;
- (void)didSelectedContactBtn:(GYHSServerDetailSectionHeader*)header;

@end
