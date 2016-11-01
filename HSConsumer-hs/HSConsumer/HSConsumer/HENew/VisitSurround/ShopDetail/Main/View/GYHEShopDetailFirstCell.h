//
//  GYHEShopDetailFirstCell.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSRedSelectBtn.h"

@class GYHEShopDetailFirstCell;

@protocol GYHEShopDetailFirstCellDelegate <NSObject>

- (void)firstCell:(GYHEShopDetailFirstCell *)cell didSelectAtIndex:(NSInteger)index;
- (void)hiddenFirstCell:(GYHEShopDetailFirstCell *)cell;

@end

@interface GYHEShopDetailFirstCell : UITableViewCell

@property (nonatomic, weak)id<GYHEShopDetailFirstCellDelegate> delegate;
@property (nonatomic, assign)NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn *distanceBtn1;

@end
