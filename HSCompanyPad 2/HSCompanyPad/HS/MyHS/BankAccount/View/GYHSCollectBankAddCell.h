//
//  GYHSCollectBankAddCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * bankAddCollectCell = @"bankAddCollectCell";
@protocol GYHSBankAddDelegate <NSObject>

- (void)bankAddClick;

@end
@interface GYHSCollectBankAddCell : UICollectionViewCell
@property (nonatomic,weak) id<GYHSBankAddDelegate> delegate;
@property (nonatomic,assign) NSInteger addNumber;
@end
