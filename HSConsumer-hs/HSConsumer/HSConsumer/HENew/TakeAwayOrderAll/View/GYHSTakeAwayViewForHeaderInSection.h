//
//  GYHSTakeAwayViewForHeaderInSection.h
//  HSConsumer
//
//  Created by kuser on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class GYHSTakeAwayOrderCellSectionModel;

@class GYHSTakeAwayModels;

@protocol GYHSTakeAwayOrderCellSectionModelDelegate;

@interface GYHSTakeAwayViewForHeaderInSection : UIView

@property (nonatomic, strong) GYHSTakeAwayModels* model;

//商店图标
@property (strong, nonatomic) IBOutlet UIImageView* shopUrlIcon;
//商店名字
@property (strong, nonatomic) IBOutlet UILabel* shopNameLabel;
//商品状态
@property (strong, nonatomic) IBOutlet UILabel* statusLabel;
//背景颜色
@property (strong, nonatomic) IBOutlet UIView* backColorView;

@property (nonatomic, weak) id<GYHSTakeAwayOrderCellSectionModelDelegate> delegate;
@property (nonatomic, assign) NSInteger section;

@end

// 代理---------------------------------
@protocol GYHSTakeAwayOrderCellSectionModelDelegate <NSObject>

@optional

- (void)didSelectedDetailsBtn:(GYHSTakeAwayViewForHeaderInSection*)header;

@end
