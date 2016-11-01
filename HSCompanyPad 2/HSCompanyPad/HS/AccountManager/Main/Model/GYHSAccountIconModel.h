//
//  GYHSAccountIconModel.h
//  HSCompanyPad
//
//  Created by sqm on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSAccountIconModel : NSObject
@property (nonatomic, copy) NSString *selectedImage;
@property (nonatomic, copy) NSString *unSelectedImage;
@property (nonatomic, copy) NSString *title;
/**
 *  中心数据赋值并返回
 *
 *  @param selected   选中的
 *  @param unselected 未选中的
 *  @param title      标题
 *
 *  @return 返回中心数据
 */
+ (instancetype)modelWithSelectedImage:(NSString *)selected unselectedImage:(NSString *)unselected title:(NSString *)title;
@end
