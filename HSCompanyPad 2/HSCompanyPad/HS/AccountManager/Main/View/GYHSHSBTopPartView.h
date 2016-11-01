//
//  GYHSHSBTopPartView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/9.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSHSBTopPartViewDelegate <NSObject>
/**
 *  代理方法 点击传值
 *
 *  @param index 整数值
 */
- (void)click:(NSInteger)index;
@end

@interface GYHSHSBTopPartView : UIView
@property (nonatomic, weak) id<GYHSHSBTopPartViewDelegate> delegate;

@end
