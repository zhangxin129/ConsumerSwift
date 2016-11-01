//
//  GYHEGoodsmanagerMainCollectionViewCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEGoodsmanagerMainCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) dispatch_block_t imageViewBlock;
@end
