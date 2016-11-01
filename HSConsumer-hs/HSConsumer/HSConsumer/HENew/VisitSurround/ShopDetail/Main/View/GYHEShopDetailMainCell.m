//
//  GYHEShopDetailMainCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopDetailMainCell.h"
#import "Masonry.h"

@interface GYHEShopDetailMainCell()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GYHEShopDetailMainCell

- (void)awakeFromNib {
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
}
- (void)setSubVCsStr:(NSArray *)subVCsStr {
    _subVCsStr = subVCsStr;
    if(_subVCsStr.count > 0) {
        [self setUpScrollView];
    }else {
        //没有商品，餐品，服务，显示无数据页面
    }
    
}
- (void)setUpScrollView {
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _subVCsStr.count, 0);
    UIViewController * fatherVC = [self superViewController];
    for(int i = 0;i <_subVCsStr.count;i ++) {
        Class class = NSClassFromString(_subVCsStr[i]);
        UIViewController *sonVC = [[class alloc] init];
        [fatherVC addChildViewController:sonVC];
        [_scrollView addSubview:sonVC.view];
        [sonVC.view mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.mas_equalTo(i * kScreenWidth);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(kScreenHeight - 64 - 40);
        }];
        
    }
}
//scroll滑动时
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([self.delegate respondsToSelector:@selector(scrollViewDidScrolled:withIndex:)]) {
        [self.delegate scrollViewDidScrolled:self withIndex:scrollView.contentOffset.x / kScreenWidth];
    }
}
//让scroll滑到某处
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    _scrollView.contentOffset = CGPointMake(selectIndex * kScreenWidth, 0);
}

- (UIViewController*)superViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
