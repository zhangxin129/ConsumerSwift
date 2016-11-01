//
//  GYHSPointCheckView.h
//
//  Created by apple on 16/7/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GYHSCheckDelegate <NSObject>
- (void)click:(NSInteger)index;
@end

@interface GYHSPointCheckView : UIView
@property (nonatomic,weak) id<GYHSCheckDelegate>delegate;

@end
