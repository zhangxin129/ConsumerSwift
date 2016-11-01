//
//  GYHESCDiscountInfoView.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#import "GYHESCDiscountInfoView.h"

@implementation GYHESCDiscountInfoView

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
   }
 */

- (void)awakeFromNib
{
    self.isShowMore = YES;
    self.titleLabel.text = kLocalized(@"HE_SC_CartShowDiscount");
    self.showImageView.transform = CGAffineTransformMakeRotation(M_PI);
}

- (IBAction)showMoreButtonClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(resetDiscountInfoView:)]) {
        [self.delegate resetDiscountInfoView:self.indexPath];
    }
}

- (void)setIsShowMore:(BOOL)isShowMore
{
    _isShowMore = isShowMore;
    if (_isShowMore) {

        self.showImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    else {

        self.showImageView.transform = CGAffineTransformMakeRotation(0);
    }
}

@end
