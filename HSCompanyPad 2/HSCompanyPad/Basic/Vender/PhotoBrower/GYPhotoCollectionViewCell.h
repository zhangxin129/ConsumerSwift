//
//  MyCollectionViewCell.h
//  DaGeng
//
//  Created by fu on 15/5/14.
//  Copyright (c) 2015年 fu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYPhotoCollectionViewCell;
@protocol GYPhotoCollectionViewCellDelegate<NSObject>

- (void)cell:(GYPhotoCollectionViewCell *)cell didSelected:(BOOL) selected;
@end
@interface GYPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton* selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView* imageView;

@property (weak, nonatomic) id<GYPhotoCollectionViewCellDelegate> delegate;

@end
