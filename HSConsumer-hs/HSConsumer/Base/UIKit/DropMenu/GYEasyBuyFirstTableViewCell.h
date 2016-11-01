//
//  FirstTableViewCell.h
//  DropDownDemo
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

//用于实现单选图片的代理
@class GYEasyBuyFirstTableViewCell;
@protocol setSelectedPicture <NSObject>

- (void)sendSelectedPictureToVC:(UIImageView*)frontImg;

@end

#import <UIKit/UIKit.h>

@interface GYEasyBuyFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* imgFrontPicture;
@property (assign, nonatomic) id<setSelectedPicture> delegate;

- (void)refreshUIWith:(NSString*)title;
- (void)setSelectPicture:(BOOL)selected;
@end
