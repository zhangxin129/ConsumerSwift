//
//  GYHSQuickPamentCollectCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSQuickListModel;
@protocol GYHSQuickBankDelegate <NSObject>

- (void)deleteQuickBankWithModel:(GYHSQuickListModel *)model;

@end

static NSString * quickPaymentCollectCell = @"quickPaymentCollectCell";
@interface GYHSQuickPamentCollectCell : UICollectionViewCell
@property (nonatomic,strong) GYHSQuickListModel * model;
@property (nonatomic,weak) id<GYHSQuickBankDelegate> delegate;
@end
