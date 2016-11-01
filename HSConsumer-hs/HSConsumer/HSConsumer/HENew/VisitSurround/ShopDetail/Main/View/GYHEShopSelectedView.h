//
//  GYHEShopSelectedView.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHEShopSelectedView;

@protocol GYHEShopSelectedViewDelegate <NSObject>

- (void)shopSelectedView:(GYHEShopSelectedView *)shopSelectedView selectIndex:(NSInteger)index;

@end


@interface GYHEShopSelectedView : UIView

@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic, weak)id<GYHEShopSelectedViewDelegate> delegate;
//选中下标
@property (nonatomic, assign)NSInteger selectIndex;

@end
