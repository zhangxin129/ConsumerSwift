//
//  GYHSAccountKeyBoard.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSAccountKeyBoard.h"
#import "GYPadKeyboradView.h"
#import <GYKit/UIColor+HEX.h>

#define kKeyBtnWidth kDeviceProportion(130)
#define kLetfwidth kDeviceProportion(20)
#define kKeyTabelWidth kDeviceProportion(130)
#define kKeyTabelCommonHeight kDeviceProportion(147)

@interface GYHSAccountKeyBoard () <GYPadKeyboradViewDelegate>
@property (nonatomic, strong) GYPadKeyboradView *keyboard;
@property (nonatomic, strong) UIButton *showDetailBtn;
@property (nonatomic, strong) UIButton *switchBtn;

@property (nonatomic, strong) UIView *coverView;
@end

@implementation GYHSAccountKeyBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.keyboard];
        [self addSubview:self.coverView];
        [self.coverView
         addSubview:self.showDetailBtn];
        [self.coverView
         addSubview:self.switchBtn];
        [self.coverView
         addSubview:self.clickOKBtn];
    }

    return self;
}

- (GYPadKeyboradView *)keyboard
{
    if (!_keyboard)
    {
        _keyboard                 = [[GYPadKeyboradView alloc] init];
        _keyboard.delegate        = self;
        _keyboard.backgroundColor = kWhiteFFFFFF;
    }
    return _keyboard;
}

- (UIView *)coverView
{
    if (!_coverView)
    {
        _coverView                 = [[UIView alloc] init];
        _coverView.backgroundColor = kWhiteFFFFFF;
    }
    return _coverView;
}

- (UIButton *)showDetailBtn
{
    if (!_showDetailBtn)
    {
        //重新修改ui //原来的第一个按钮
        _showDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showDetailBtn setBackgroundImage:[UIImage imageNamed:kLocalized(@"gyhs_showDetailCheckBtn")]
                                  forState:UIControlStateNormal];
        _showDetailBtn.tag = kAccountKeyBoardButtonEventShowDetail;
        [_showDetailBtn addTarget:self
                           action:@selector(click:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _showDetailBtn;
}

- (UIButton *)switchBtn
{
    if (!_switchBtn)
    {
        //原来的第二个按钮
        _switchBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchBtn.tag = kAccountKeyBoardButtonEventSwitch;

        [_switchBtn addTarget:self
                       action:@selector(click:)
             forControlEvents:UIControlEventTouchUpInside];
    }

    return _switchBtn;
}

- (UIButton *)clickOKBtn
{
    if (!_clickOKBtn)
    {
        _clickOKBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickOKBtn.tag = kAccountKeyBoardButtonEventOK;
        [_clickOKBtn addTarget:self
                        action:@selector(click:)
              forControlEvents:UIControlEventTouchUpInside];                                                //还是要重新写方法
    }

    return _clickOKBtn;
}

/**
 *  布局
 */
- (void)updateConstraints
{
    [super updateConstraints];

    @weakify(self);
    [_keyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-(kKeyBtnWidth + kLetfwidth));
    }];
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.top.bottom.equalTo(self);
        make.left.equalTo(_keyboard.mas_right);
    }];
    [_showDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        // @strongify(self);
        make.right.equalTo(_coverView).offset(-kLetfwidth);
        make.top.equalTo(_coverView).offset(kLetfwidth / 2);
        make.width.mas_equalTo(@(kKeyTabelWidth));
        make.height.mas_equalTo(@(kKeyTabelCommonHeight));//这个地方重新修改了原来ui的数字
    }];

    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.right.equalTo(_coverView).offset(-kLetfwidth);
        make.width.mas_equalTo(@(kKeyTabelWidth));
        make.top.equalTo(_showDetailBtn.mas_bottom).offset(kDeviceProportion(5));
        make.height.mas_equalTo(@(kKeyTabelCommonHeight));//这个地方重新修改了原来ui的数字
    }];

    [_clickOKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(_coverView).offset(-kLetfwidth);
        if (((globalData.companyType != kCompanyType_Membercom) && (self.type != kAccountKeyBoardTypeCashToBank)) || ((self.type == kAccountKeyBoardTypeHSBToCash) && (globalData.companyType == kCompanyType_Membercom)))
        {
            make.top.equalTo(self.switchBtn.mas_bottom).offset(kDeviceProportion(5));
            make.height.mas_equalTo(@(kDeviceProportion(299)));
        }
        else
        {
            make.top.equalTo(self.showDetailBtn.mas_bottom).offset(kDeviceProportion(5));
            make.height.mas_equalTo(@(kDeviceProportion(451)));
        }

        make.width.mas_equalTo(@(kKeyTabelWidth));
    }];
}

/**
 *  按照键盘结构配置不同的图片
 *
 *  @param type 键盘结构
 */
- (void)setType:(kAccountKeyBoardType)type
{
    _type = type;
    switch (type)
    {
        case kAccountKeyBoardTypePointToInvest: {
            [self.switchBtn
             setBackgroundImage:[UIImage imageNamed:kLocalized(@"gyhs_pointTransformHSB_Btn")]
                       forState:UIControlStateNormal];
            [self.clickOKBtn
             setBackgroundImage:[UIImage imageNamed:kLocalized(@"gyhs_blueOKShortBtn")]
                       forState:UIControlStateNormal];
        } break;
        case kAccountKeyBoardTypePointToHSB: {
            [self.switchBtn
             setBackgroundImage:[UIImage imageNamed:kLocalized(@"gyhs_pointInvestmentBtn")]
                       forState:UIControlStateNormal];
            if (globalData.companyType == kCompanyType_Membercom)
            {
                [self.clickOKBtn
                 setBackgroundImage:[UIImage imageNamed:kLocalized(@"gyhs_blueOK_longBig_Btn")]
                           forState:UIControlStateNormal];
            }
            else
            {
                [self.clickOKBtn
                 setBackgroundImage:[UIImage imageNamed:kLocalized(@"gyhs_blueOKShortBtn")]
                           forState:UIControlStateNormal];
            }
        } break;
        case kAccountKeyBoardTypeHSBToCash: {
            [self.switchBtn
             setBackgroundImage:[UIImage imageNamed:kLocalized(@"gyhs_exchangeHSB_keyboard_btn")]
                       forState:UIControlStateNormal];

            [self.clickOKBtn
             setBackgroundImage:[UIImage imageNamed:kLocalized(@"gyhs_blueOKShortBtn")]
                       forState:UIControlStateNormal];

        } break;
        case kAccountKeyBoardTypeCashToBank: {
            [self.clickOKBtn
             setBackgroundImage:[UIImage imageNamed:kLocalized(@"gyhs_blueOK_longBig_Btn")]
                       forState:UIControlStateNormal];
        } break;
        default:
            break;
    }
}

//点击按钮实现状态转换
- (void)click:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(padKeyBoardViewDidClickEvent:)])
    {
        [_delegate padKeyBoardViewDidClickEvent:button.tag]; //代理方法响应相应tag值的事件 代理传值
    }
}

#pragma mark - GYPadKeyboradViewDelegate
/**
 *  代理传递 添加字符
 *
 *  @param string 具体字符
 */
- (void)padKeyBoardViewDidClickNumberWithString:(NSString *)string;
{
    if (_delegate && [_delegate respondsToSelector:@selector(padKeyBoardViewDidClickNumberWithString:)])
    {
        [_delegate padKeyBoardViewDidClickNumberWithString:string];
    }
}
/**
 *  代理传递 删除字符
 */
- (void)padKeyBoardViewDidClickDelete
{
    if (_delegate && [_delegate respondsToSelector:@selector(padKeyBoardViewDidClickDelete)])
    {
        [_delegate padKeyBoardViewDidClickDelete];
    }
}

@end
