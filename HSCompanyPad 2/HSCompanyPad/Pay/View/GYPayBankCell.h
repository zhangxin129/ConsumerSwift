//
//  GYBankCell.h
//  HSCompanyPad
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSBankCradModel;

@protocol GYPayBankCellDelegate <NSObject>

- (void)deleteActionModel:(GYHSBankCradModel*)model;

@end

@interface GYPayBankCell : UICollectionViewCell

@property (nonatomic, strong) GYHSBankCradModel* model;
@property (nonatomic, weak) id<GYPayBankCellDelegate> delegate;

@end
