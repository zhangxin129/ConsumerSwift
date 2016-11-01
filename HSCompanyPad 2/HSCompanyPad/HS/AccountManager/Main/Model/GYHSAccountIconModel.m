//
//  GYHSAccountIconModel.m
//  HSCompanyPad
//
//  Created by sqm on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSAccountIconModel.h"

@implementation GYHSAccountIconModel
/**
 *  数据绑定模型
 *
 *  @param selected   选中状态图片名称
 *  @param unselected 未选中状态图片名称
 *  @param title      设置标题
 *
 *  @return 返回自身模型对象
 */
+ (instancetype)modelWithSelectedImage:(NSString *)selected unselectedImage:(NSString *)unselected title:(NSString *)title
{
    GYHSAccountIconModel *model = [[GYHSAccountIconModel alloc]init];
    model.selectedImage   = selected;
    model.unSelectedImage = unselected;
    model.title           = title;
    return model;
}

@end
