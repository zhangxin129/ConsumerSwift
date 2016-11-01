//
//  GYHSCollectBankOpenCell.h
//  HSCompanyPad
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSCollectBankOpenCell;
static NSString * bankOpenCollectCell = @"bankOpenCollectCell";
@protocol GYHSCollectBankOpenDelegate <NSObject>
@optional
- (void)clickWithButtonTag:(NSInteger)tag cell:(GYHSCollectBankOpenCell *)cell;

@end

@interface GYHSCollectBankOpenCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *openImage;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;
@property (nonatomic,weak) id<GYHSCollectBankOpenDelegate>delegate;
@end
