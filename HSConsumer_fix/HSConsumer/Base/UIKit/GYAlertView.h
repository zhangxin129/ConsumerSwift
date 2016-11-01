//
//  GYAlertView.h
//  HS_Consumer_HE
//
//  Created by admin on 16/5/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYAlertView : UIView

//单个按钮不带处理情况
+ (GYAlertView*)showMessage:(NSString*)message;

//单个按钮带处理情况
+ (GYAlertView*)showMessage:(NSString*)message confirmBlock:(dispatch_block_t)confirmBlock;

//两个按钮及处理情况
+ (GYAlertView*)showMessage:(NSString*)message cancleBlock:(dispatch_block_t)cancleBlock confirmBlock:(dispatch_block_t)confirmBlock;

// 支持按钮按钮名称自定义，当只需要一个按钮时将title和对应的block设置为nil即可
+ (GYAlertView*)showMessage:(NSString*)message
          cancleButtonTitle:(NSString*)cancleTitle
         confirmButtonTitle:(NSString*)confirmTitle
                cancleBlock:(dispatch_block_t)cancleBlock
               confirmBlock:(dispatch_block_t)confirmBlock;

//单个按钮带处理情况的富文本显示
+ (GYAlertView*)showAttributedMessage:(NSAttributedString*)message confirmBlock:(dispatch_block_t)confirmBlock;
@end
