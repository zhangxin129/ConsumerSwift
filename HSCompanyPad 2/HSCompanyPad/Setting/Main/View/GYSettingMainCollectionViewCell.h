//
//  GYSettingMainCollectionViewCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYSettingMainCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) dispatch_block_t imageViewBlock;
@end
