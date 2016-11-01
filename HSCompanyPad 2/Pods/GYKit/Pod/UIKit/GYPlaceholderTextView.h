//
//  PlaceholderTextView.h
//  company
//
//  Created by apple on 14-11-13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYPlaceholderTextView : UITextView

@property (copy, nonatomic) NSString* placeholder;

@property (strong, nonatomic) NSIndexPath* indexPath;

//最大长度设置
@property (assign, nonatomic) NSInteger maxTextLength;

//更新高度的时候
@property (assign, nonatomic) float updateHeight;

/**
 *  增加text 长度限制
 *
 *  @param maxLength <#maxLength description#>
 *  @param limit     <#limit description#>
 */
- (void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void (^)(GYPlaceholderTextView* text))limit;
/**
 *  开始编辑 的 回调
 *
 *  @param begin <#begin description#>
 */
- (void)addTextViewBeginEvent:(void (^)(GYPlaceholderTextView* text))begin;

/**
 *  结束编辑 的 回调
 *
 *  @param begin <#begin description#>
 */
- (void)addTextViewEndEvent:(void (^)(GYPlaceholderTextView* text))End;

/**
 *  设置Placeholder 颜色
 *
 *  @param color <#color description#>
 */
- (void)setPlaceholderColor:(UIColor*)color;

/**
 *  设置Placeholder 字体
 *
 *  @param font <#font description#>
 */
- (void)setPlaceholderFont:(UIFont*)font;

/**
 *  设置透明度
 *
 *  @param opacity <#opacity description#>
 */
-(void)setPlaceholderOpacity:(float)opacity;

@end
