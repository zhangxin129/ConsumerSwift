//
//  GYHSRedSelectBtn.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSRedSelectBtn.h"
#import "Masonry.h"

#define LineViewH 2

@interface GYHSRedSelectBtn()



@end

@implementation GYHSRedSelectBtn


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        UIView* lineView = [UIView new];
        lineView.hidden = YES;
        lineView.backgroundColor = [UIColor redColor];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(LineViewH);
//            make.left.mas_equalTo(5);
//            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.centerX.mas_equalTo(0);
        }];
        self.lineView = lineView;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView* lineView = [UIView new];
        lineView.hidden = YES;
        lineView.backgroundColor = [UIColor redColor];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(LineViewH);
//            make.left.mas_equalTo(5);
//            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.centerX.mas_equalTo(0);
        }];
        self.lineView = lineView;
    }
    return self;
}

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
    self.lineView.hidden = !selected;
}



@end
