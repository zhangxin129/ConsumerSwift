//
//  GYPopView.h
//  HSCompanyPad
//
//  Created by User on 16/8/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYPopView : UIView

@property(nonatomic, strong) UIView *chlidView;

- (void)show;
- (void)disMiss;

- (instancetype)initWithChlidView:(UIView *)chlidView;

@end
