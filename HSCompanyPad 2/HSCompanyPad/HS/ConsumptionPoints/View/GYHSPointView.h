//
//  GYHSPointView.h
//
//  Created by apple on 16/7/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^selectBlock)(NSString* pointString);
@interface GYHSPointView : UIView

@property (nonatomic, copy) selectBlock block;
@property (nonatomic, copy) NSString* pointStr;
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray*)array;
@end
