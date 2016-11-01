//
//  GYMenuTabView.m
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMenuTabView.h"


@interface GYMenuTabView ()
@property (nonatomic, strong) UIView *sliderView;
@end

@implementation GYMenuTabView


- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    CGRect frame = self.frame;
    CGFloat width = frame.size.width/titles.count;
    for (int i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*width, 0, width-1, frame.size.height - 3)];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.tag = 100+i;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleDidTapped:)];
        [label addGestureRecognizer:tap];


        [self addSubview:label];
        if (i != titles.count-1) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*width+width-1, frame.size.height/4, 1/[UIScreen mainScreen].scale, frame.size.height/2)];
            view.backgroundColor = [UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1];
            [self addSubview:view];
        }
        if (i == 0) {
            _sliderView = [[UIView alloc] initWithFrame:CGRectMake(width*0.15, frame.size.height-3, width*0.7, 3)];
            _sliderView.backgroundColor = [UIColor redColor];
            [self addSubview:_sliderView];
        }
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1/[UIScreen mainScreen].scale, self.frame.size.width, 1/[UIScreen mainScreen].scale)];
    view.backgroundColor = [UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1];
    [self addSubview:view];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    CGFloat width = self.frame.size.width/_titles.count;
    [UIView animateWithDuration:0.1 animations:^{
        CGRect frame = _sliderView.frame;
        frame.origin.x = width *selectIndex+width*0.15;
        _sliderView.frame = frame;
    }];
}

- (void)titleDidTapped:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag -100;
    if (_delegate && [_delegate respondsToSelector:@selector(menuTabView:didClickTitleAtIndex:)]) {
        [_delegate menuTabView:self didClickTitleAtIndex:index];
    }
}

@end
