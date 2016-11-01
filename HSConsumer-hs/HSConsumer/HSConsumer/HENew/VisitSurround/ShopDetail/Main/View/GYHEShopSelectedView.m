//
//  GYHEShopSelectedView.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopSelectedView.h"
#import "GYHSRedSelectBtn.h"
#import "Masonry.h"

@interface GYHEShopSelectedView ()

@end

@implementation GYHEShopSelectedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xebebeb);
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    if(_dataArr.count > 0) {
        [self setSelectBtn];
    }
    
}
- (void)setSelectBtn {
    CGFloat btnW = kScreenWidth*1.0 / _dataArr.count*1.0;
    for(int i = 0 ; i<_dataArr.count; i++) {
        GYHSRedSelectBtn *btn = [[GYHSRedSelectBtn alloc] initWithFrame:CGRectMake( i * btnW, 0, btnW, self.frame.size.height)];
        [btn setTitle:_dataArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xfb7d00) forState:UIControlStateSelected];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
- (void)btnAction:(UIButton *)btn {
    [self allSelectedNo];
    btn.selected = YES;
    if([self.delegate respondsToSelector:@selector(shopSelectedView:selectIndex:)]) {
        [self.delegate shopSelectedView:self selectIndex:btn.tag - 1];
    }
}
- (void)allSelectedNo {
    for(UIButton *btn in self.subviews) {
        if([btn isKindOfClass:[UIButton class]]) {
            btn.selected = NO;
        }
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [self allSelectedNo];
    GYHSRedSelectBtn *btn = [self viewWithTag:selectIndex + 1];
    btn.selected = YES;
}

@end
