//
//  GYHSNewButton.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//


//重新建造自定义的Button
#import <UIKit/UIKit.h>

@interface GYHSNewButton : UIButton
/**
 *  生成特别的按钮
 *
 *  @param frame         边框尺寸
 *  @param normalName    通常图片名字
 *  @param selectName    选中图片名字
 *  @param titleStr      标题
 *  @param colorNormal   通常颜色
 *  @param colorSelected 选中颜色
 *
 *  @return 返回自身
 */
- (id)initWithFrame:(CGRect)frame normalWithImageName:(NSString *)normalName selectedWithImageName:(NSString *)selectName setTitleString:(NSString *)titleStr normalTitleColor:(UIColor *)colorNormal selectedTitleColor:(UIColor *)colorSelected;

@end
