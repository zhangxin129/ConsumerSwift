//
//  GYHEShopDetailMainCell.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHEShopDetailMainCell;

@protocol GYHEShopDetailMainCellDelegate <NSObject>

- (void)scrollViewDidScrolled:(GYHEShopDetailMainCell *)cell withIndex:(NSInteger)index;

@end

@interface GYHEShopDetailMainCell : UITableViewCell


//商品，餐品，服务
@property (nonatomic, strong)NSArray *subVCsStr;
//选中下标
@property (nonatomic, assign)NSInteger selectIndex;

@property (nonatomic, weak)id<GYHEShopDetailMainCellDelegate> delegate;

@end
