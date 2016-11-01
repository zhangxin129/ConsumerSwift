//
//  GYHSPayKeyView.h
//
//  Created by apple on 16/8/2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GYHSPayKeyDelegate <NSObject>
- (void)keyPayAddWithString:(NSString *)string;
- (void)keyPayDeleteWithString;
- (void)keyClick:(NSInteger)index;
@end

@interface GYHSPayKeyView : UIView
@property (nonatomic,weak)id<GYHSPayKeyDelegate> delegate;
@property (nonatomic, strong) UIButton* sureBtn;
@end
