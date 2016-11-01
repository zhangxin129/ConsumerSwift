//
//  GYRateBar.h
//  Test
//
//  Created by zhangqy on 15/10/21.
//  Copyright © 2015年 zhangqy. All rights reserved.
//
typedef void (^FDScoreBarTappedBlock)();
#import <UIKit/UIKit.h>

@interface FDScoreBar : UIView
@property (strong, nonatomic) UIImage* selectImage;
@property (strong, nonatomic) UIImage* unSelectImage;
@property (assign, nonatomic) BOOL canTouch;
@property (assign, nonatomic) NSInteger score;
@property (strong, nonatomic) UIView* bottomView;
@property (strong, nonatomic) UIView* topView;
@property (copy, nonatomic) FDScoreBarTappedBlock block;
- (instancetype)initWithFrame:(CGRect)frame selectImage:(UIImage*)selectImage unSelectImage:(UIImage*)unSelectImage;
@end
