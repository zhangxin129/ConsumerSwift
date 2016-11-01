//
//  GYEasybuyLineBtn.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyLineBtn.h"

#define QFLineViewH 2

@interface GYEasybuyLineBtn ()

/** 下划线 */
@property (nonatomic, weak) UIView* lineView;

@end

@implementation GYEasybuyLineBtn

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {

        UIView* lineView = [UIView new];
        lineView.hidden = YES;
        [self addSubview:lineView];
        self.lineView = lineView;
    }
    return self;
}

- (void)awakeFromNib
{
    UIView* lineView = [UIView new];
    lineView.hidden = YES;
    [self addSubview:lineView];
    self.lineView = lineView;
}

- (void)setTitleColor:(UIColor*)color forState:(UIControlState)state
{

    [super setTitleColor:color forState:state];
    if (state == UIControlStateSelected) {

        self.lineView.backgroundColor = color;
    }
}

- (void)layoutSubviews
{

    [super layoutSubviews];

    self.lineView.frame = CGRectMake(0, self.frame.size.height - QFLineViewH, self.frame.size.width, QFLineViewH);
}

- (void)setSelected:(BOOL)selected
{

    [super setSelected:selected];
    self.lineView.hidden = !selected;
}

@end
