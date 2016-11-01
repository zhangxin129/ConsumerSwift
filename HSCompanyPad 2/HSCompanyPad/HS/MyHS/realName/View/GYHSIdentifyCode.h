//
//  GYHSIdentifyCode.h
//  HSEnterprise
//
//  Created by apple on 16/2/4.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSIdentifyCode : UIView
@property (nonatomic,strong) NSArray * dataSource;//字符内容数组
@property (nonatomic,strong) NSMutableString *authCodeStr;//验证码字符串
@property (nonatomic,assign) BOOL isNeedColor;//验证码视图是否需要背景颜色
@property (nonatomic,assign) BOOL isNeedLine;//验证码视图是否需要干扰线
//刷新验证码
- (void)getAuthcode;

@end
