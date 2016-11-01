//
//  GYHENavTitleView.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHENavTitleView.h"

@implementation GYHENavTitleView
- (void)awakeFromNib {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(search)];
    self.localView.hidden = YES;
    self.nationalView.hidden = NO;
    [self.searchView addGestureRecognizer:tap];
    self.searchView.backgroundColor = kDefaultVCBackgroundColor;
    [self.nationalBtn setTitleColor:kCorlorFromHexcode(0xfc9733) forState:UIControlStateNormal];
    [self.localBtn setTitleColor:kCorlorFromHexcode(0xfc9733) forState:UIControlStateNormal];
}

//切换到本地购
- (IBAction)localBtn:(id)sender {
    self.nationalView.hidden = YES;
    self.localView.hidden = NO;
}
//切换到全国购
- (IBAction)nationalBtn:(id)sender {
    self.localView.hidden = YES;
     self.nationalView.hidden = NO;
}
//本地购选择城市
- (IBAction)cityBtn:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(cityBtn)]) {
        [self.delegate cityBtn];
    }
}
-(void)search
{
    if ([_delegate respondsToSelector:@selector(search)]) {
        [self.delegate search];
    }
}
@end
