//
//  GYDefaultStyleMacro.h
//  HSConsumer
//
//  Created by apple on 14-10-9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//宏定义
#ifndef GYDefaultStyleMacro_h
#define GYDefaultStyleMacro_h

//10进制GRB转UIColor
#define kCorlorFromRGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

//16进制GRB转UIColor
#define kCorlorFromHexcode(hexcode) [UIColor colorWithRed:((float)((hexcode & 0xFF0000) >> 16)) / 255.0 green:((float)((hexcode & 0xFF00) >> 8)) / 255.0 blue:((float)(hexcode & 0xFF)) / 255.0 alpha:1.0]

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#pragma mark - 背景颜色
//-------------------背景颜色-------------------------
//清除背景色
#define kClearColor [UIColor clearColor]

//默认控制器的背景色
#define kDefaultVCBackgroundColor kCorlorFromRGBA(240, 240, 240, 1)

// 背景颜色
#define kBackgroundGrayColor kCorlorFromRGBA(236, 236, 236, 1)
#define kDefaultViewBorderColor kCorlorFromRGBA(200, 200, 200, 1)
#define kDefaultViewBorderWidth (1 / [UIScreen mainScreen].scale)

//导航栏

#define kNavigationTitleColor kCorlorFromRGBA(255, 255, 255, 1)

#define kLineViewColor kCorlorFromRGBA(82, 82, 82, 1)

//导航栏颜色
#define kNavigationBarColor kCorlorFromRGBA(239, 65, 54, 1)

#define kTabBarTitleNomalColor [UIColor grayColor]
#define kTabBarTitleSelectColor kCorlorFromRGBA(239, 41, 36, 1)

//默认按钮颜色
#define kDefaultButtonColor kCorlorFromRGBA(245, 150, 15, 1)

//Cell主题灰色的字体颜色
#define kCellItemTitleColor kCorlorFromRGBA(70, 70, 70, 1)

//Cell内容灰色的字体颜色
#define kCellItemTextColor kCorlorFromRGBA(140, 140, 140, 1)

//Textfield占位符文本颜色
#define kTextFieldPlaceHolderColor kCorlorFromRGBA(200, 200, 200, 1)

//金额 交易详情中 默认红色字体
#define kValueRedCorlor kCorlorFromRGBA(230, 80, 55, 1)

// 黑色字体颜色
#define kBlackTextColor kCorlorFromRGBA(71, 68, 67, 1)

// 灰色色字体颜色
#define kgrayTextColor kCorlorFromRGBA(130, 130, 130, 1)

//黑色字体颜色#5A5A5A
#define kTitleBlackColor kCorlorFromRGBA(90, 90, 90, 1)
//灰色文字#A0A0A0
#define kNumGrayColor kCorlorFromRGBA(160, 160, 160, 1)
//pv蓝色文字#007EBC
#define kPvBlueColor kCorlorFromRGBA(0, 126, 188, 1)
//价格红色#FF0000
#define kPriceRedColor kCorlorFromRGBA(255, 0, 0, 1)
//商品介绍的背景#EEEEEE
#define kIntroduceBackgroundColor kCorlorFromRGBA(238, 238, 238, 1)
//详情灰色字#999999
#define kDetailGrayColor kCorlorFromRGBA(153, 153, 153, 1)
//详情黑色字#333333
#define kDetailBlackColor kCorlorFromRGBA(51, 51, 51, 1)
//白色#FFFFFF
#define kBtnWriteTextColor kCorlorFromRGBA(255, 255, 255, 1)

//暗灰色文字#787878
#define kNumDarkgrayColor kCorlorFromRGBA(120, 120, 120, 1)

//绿色文字#009B4C
#define kNumGreenColor kCorlorFromRGBA(0, 155, 76, 1)

//红色金额文字#FA3C28
#define kNumRednColor kCorlorFromRGBA(251, 61, 40, 1)

#pragma mark - 基础字号
//-------------------基础字号-------------------------

//不同屏幕的缩放控制
#define kfont(size) kScreenWidth > 320 ? (kScreenWidth > 375 ? [UIFont systemFontOfSize:size * 1.2] : [UIFont systemFontOfSize:size * 1.1]):[UIFont systemFontOfSize:size]

#define kboldfont(size) kScreenWidth > 320 ? (kScreenWidth > 375 ? [UIFont boldSystemFontOfSize:size * 1.2] : [UIFont systemFontOfSize:size * 1.1]):[UIFont boldSystemFontOfSize:size]

//大标题
#define kBigTitleFont [UIFont systemFontOfSize:17]
//常用CELL主标题字体大小
#define kCellTitleFont [UIFont systemFontOfSize:17]

//常用CELL主标题 粗体字体 大小
#define kCellTitleBoldFont [UIFont boldSystemFontOfSize:17]

//各填写，提示项默认字体大小
#define kDefaultFont [UIFont systemFontOfSize:17]

//确定，下一步按钮默认字体大小
#define kButtonTitleDefaultFont [UIFont systemFontOfSize:18]

//常用主标题字体大小
#define kGYTitleFont [UIFont systemFontOfSize:16]

//常用主标描述体大小
#define kGYTitleDescriptionFont [UIFont systemFontOfSize:14]

//常用距离描述体大小
#define kGYOtherDescriptionFont [UIFont systemFontOfSize:12]

//抵扣券文字
#define kGYDiscountFont [UIFont systemFontOfSize:11]

#pragma mark - 基础距离
//-------------------基础距离-------------------------

//距离上、下、左、右 默认的距离
#define kDefaultMarginToBounds 16.0f

#define kCellDefaultMarginToBounds 20.0f

#define kTableViewHeaderMagin 16

// TODO: 后续删除
#define kCellHeight 44 * [GYUtils scaleY]

#endif
