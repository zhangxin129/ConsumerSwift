//
//  GYHEGoodsQueryCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol goodsQueryDelegate <NSObject>

- (void)changeAction;
- (void)deleteAction;
- (void)stateAction;

@end

@interface GYHEGoodsQueryCell : UITableViewCell

@property (nonatomic, assign) id<goodsQueryDelegate> delegate;

@end
