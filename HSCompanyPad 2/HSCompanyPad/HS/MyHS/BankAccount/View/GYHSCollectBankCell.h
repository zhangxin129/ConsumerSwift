//
//  GYHSCollectBankCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSBankListModel;
@protocol GYHSCollectBanClickDelegate <NSObject>

- (void)collectBankClick:(NSInteger)index model:(GYHSBankListModel *)model;

@end
static NSString * bankCollectCell = @"bankCollectCell";
@interface GYHSCollectBankCell : UICollectionViewCell
@property (nonatomic,weak) id<GYHSCollectBanClickDelegate> delegate;
@property (nonatomic,strong) GYHSBankListModel * model;
@end
