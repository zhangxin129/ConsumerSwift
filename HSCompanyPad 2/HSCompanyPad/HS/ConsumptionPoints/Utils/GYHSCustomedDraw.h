//
//  GYHSCustomedDraw.h
//  HSCompanyPad
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSCustomedDraw : NSObject
/**
 *  绘制按钮大小动画
 *
 *  @param btn 按钮
 */
+ (void)setAnimationWithLayer:(UIButton *)btn;

/**
 *  绘制按钮旋转动画
 *
 *  @param btn 按钮
 */
+ (void)setRoateWithhLayer:(UIButton *)btn;

@end
