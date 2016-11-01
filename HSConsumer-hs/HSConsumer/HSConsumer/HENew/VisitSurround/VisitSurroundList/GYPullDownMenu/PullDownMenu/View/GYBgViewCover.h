//
//  GYBgViewCover.h
//  GYHEPullDown
//
//  Created by kuser on 16/9/23.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYBgViewCover : UIView

// 点击蒙版调用 
@property (nonatomic, strong) void(^clickCover)();

@end
