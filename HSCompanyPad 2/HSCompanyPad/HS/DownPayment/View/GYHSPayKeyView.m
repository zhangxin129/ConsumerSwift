//
//  GYHSPayKeyView.m
//
//  Created by apple on 16/8/2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPayKeyView.h"
#import "GYPadKeyboradView.h"
#define kKeyBtnWidth kDeviceProportion(130)
#define kLetfwidth kDeviceProportion(20)
#define kButtonTag 100
@interface GYHSPayKeyView () <GYPadKeyboradViewDelegate>
@property (nonatomic, weak) UIView* keyView;
@property (nonatomic, weak) GYPadKeyboradView* keyboard;
@property (nonatomic, strong) UIButton* clearBtn;

@end
@implementation GYHSPayKeyView

- (instancetype)init
{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    UIView* keyView = [[UIView alloc] init];
    keyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:keyView];
    self.keyView = keyView;
    @weakify(self);
    [self.keyView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.right.left.bottom.equalTo(self);
    }];
    
    GYPadKeyboradView* keyboard = [[GYPadKeyboradView alloc] init];
    keyboard.delegate = self;
    [self.keyView addSubview:keyboard];
    self.keyboard = keyboard;
    [self.keyboard mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self.keyView);
        make.right.equalTo(self.keyView).offset(-(kKeyBtnWidth + kLetfwidth));
    }];
    
    CGFloat clearHeight = kDeviceProportion(299);
    
    UIButton* clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.tag = kButtonTag;
    [clearBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_payment_clean"] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyView addSubview:clearBtn];
    self.clearBtn = clearBtn;
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.right.equalTo(self.keyView).offset(-kLetfwidth);
        make.top.equalTo(self.keyView).offset(kLetfwidth / 2);
        make.size.mas_equalTo(CGSizeMake(kKeyBtnWidth, clearHeight));
    }];
    
    UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_payment_ok"] forState:UIControlStateNormal];
    
    sureBtn.tag = kButtonTag + 1;
    [sureBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyView addSubview:sureBtn];
    self.sureBtn = sureBtn;
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.right.equalTo(self.keyView).offset(-kLetfwidth);
        make.top.equalTo(self.clearBtn).offset(kLetfwidth / 4 + clearHeight);
        make.width.mas_equalTo(kKeyBtnWidth);
        make.bottom.equalTo(self.keyView).offset(-13);
    }];
}

#pragma mark - click
- (void)click:(UIButton*)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(keyClick:)]) {
        [_delegate keyClick:button.tag - kButtonTag];
    }
}

#pragma mark -GYPadKeyboradViewDelegate
- (void)padKeyBoardViewDidClickNumberWithString:(NSString*)string;
{
    if (_delegate && [_delegate respondsToSelector:@selector(keyPayAddWithString:)]) {
        [_delegate keyPayAddWithString:string];
    }
}

- (void)padKeyBoardViewDidClickDelete
{
    if (_delegate && [_delegate respondsToSelector:@selector(keyPayDeleteWithString)]) {
        [_delegate keyPayDeleteWithString];
    }
}


@end
