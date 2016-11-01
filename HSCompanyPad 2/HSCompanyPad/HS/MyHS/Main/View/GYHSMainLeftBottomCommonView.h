//
//  GYHSMainLeftBottomCommonView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSMainLeftBottomCommonView : UIView

- (instancetype)initWithImage:(UIImage*)image title:(NSString*)title;

/*!
 *    正文label的内容
 */
@property (nonatomic, copy) NSAttributedString *text;

/*!
 *    是否为邮箱一行视图（在这里重新设置按钮颜色字体颜色）
 */
@property (nonatomic, assign) BOOL isEmailAuthenticate;
/*!
 *    后面按钮的文字
 */
@property (nonatomic, copy) NSString *buttonTitle;
/*!
 *    后面按钮点击事件
 */
@property (nonatomic, copy) dispatch_block_t buttonBlock;
@end
