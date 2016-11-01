//
//  GYPasswordSelectButton.m
//  HSConsumer
//
//  Created by lizp on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYPasswordSelectButton.h"

@interface GYPasswordSelectButton ()

@property (nonatomic, strong) UIView* lineView;

@end

@implementation GYPasswordSelectButton

- (void)setTitleColor:(UIColor*)color forState:(UIControlState)state
{

    [super setTitleColor:color forState:state];
    if (state == UIControlStateSelected) {
        self.lineView.backgroundColor = color;
    }
}

- (void)setSelected:(BOOL)selected
{

    [super setSelected:selected];
    if (selected == YES) {
        _lineView.hidden = NO;
    }
    else {
        _lineView.hidden = YES;
    }
}

- (UIView*)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1)];
        [self addSubview:_lineView];
    }
    return _lineView;
}

@end
