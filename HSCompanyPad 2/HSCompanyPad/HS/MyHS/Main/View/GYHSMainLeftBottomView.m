//
//  GYHSMainLeftBottomView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMainLeftBottomView.h"
#import "GYHSMainLeftBottomCommonView.h"
#import "GYHSMyHSMainModel.h"

@interface GYHSMainLeftBottomView ()

@property (nonatomic, strong) GYHSMainLeftBottomCommonView* linkInfoView;
@property (nonatomic, strong) GYHSMainLeftBottomCommonView* emailView;
@property (nonatomic, strong) GYHSMainLeftBottomCommonView* bankCardView;
@property (nonatomic, strong) GYHSMainLeftBottomCommonView* quickPayView;
@end

@implementation GYHSMainLeftBottomView

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - event response
- (void)doSomeBlock
{
    @weakify(self);
    _linkInfoView.buttonBlock = ^{
        @strongify(self);
        if (self.linkmanBlock) {
            self.linkmanBlock();
        }
    };
    
    _emailView.buttonBlock = ^{
        @strongify(self);
        if (self.emailBlock) {
            self.emailBlock();
        }
    };
    _bankCardView.buttonBlock = ^{
        @strongify(self);
        if (self.bankCardBlock) {
            self.bankCardBlock();
        }
    };
    
    _quickPayView.buttonBlock = ^{
        @strongify(self);
        if (self.quickCardBlock) {
            self.quickCardBlock();
        }
    };
}

#pragma mark - pravate method
- (void)setUp
{
    [self addSubview:self.linkInfoView];
    [self.linkInfoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(kDeviceProportion(80)));
    }];
    
    [self addSubview:self.emailView];
    [self.emailView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_linkInfoView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@(kDeviceProportion(80)));
    }];
    
    [self addSubview:self.bankCardView];
    [self.bankCardView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_emailView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@(kDeviceProportion(80)));
    }];
    
    [self addSubview:self.quickPayView];
    [self.quickPayView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_bankCardView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@(kDeviceProportion(80)));
    }];
    
    [self doSomeBlock];
}

- (void)setModel:(GYHSMyHSMainModel*)model
{
    _model = model;
    
    //联系信息
    NSString* infoString = [NSString stringWithFormat:@"%@\n%@", globalData.loginModel.contactPhone, globalData.loginModel.contactPerson];
    NSMutableAttributedString* infoText = [[NSMutableAttributedString alloc] initWithString:infoString attributes:@{ NSFontAttributeName : kFont38, NSForegroundColorAttributeName : kGray666666 }];
    self.linkInfoView.text = infoText;
    
    //邮箱地址
    _emailView.isEmailAuthenticate = self.model.isAuthEmail.boolValue;
    if (_emailView.isEmailAuthenticate) {
        NSString* emailString = [NSString stringWithFormat:@"%@", model.email];
        NSMutableAttributedString* emailText = [[NSMutableAttributedString alloc] initWithString:emailString attributes:@{ NSFontAttributeName : kFont38, NSForegroundColorAttributeName : kGray666666 }];
        _emailView.text = emailText;
        _emailView.buttonTitle = kLocalized(@"GYHS_Myhs_Verified_Two");
        _emailView.buttonBlock = nil;
    }
    else {
        NSString* emailString = [NSString stringWithFormat:@"%@\n%@", model.email,kLocalized(@"GYHS_Myhs_No_Verified_Two")];
        NSRange emailRange = [emailString rangeOfString:kLocalized(@"GYHS_Myhs_No_Verified_Two") options:NSCaseInsensitiveSearch];
        NSMutableAttributedString* emailText = [[NSMutableAttributedString alloc] initWithString:emailString attributes:@{ NSFontAttributeName : kFont38, NSForegroundColorAttributeName : kGray666666 }];
        [emailText setAttributes:@{ NSFontAttributeName : kFont38,
                                    NSForegroundColorAttributeName : kRedE50012 }
                           range:emailRange];
        _emailView.text = model.email.length != 0 ? emailText :[[NSAttributedString alloc] initWithString:kLocalized(@"GYHS_Myhs_Company_No_Email") attributes:@{NSFontAttributeName : kFont38, NSForegroundColorAttributeName : kGray666666}];
        _emailView.buttonTitle =model.email.length != 0 ? kLocalized(@"GYHS_Myhs_Authenticate"):@"";
        if (model.email.length == 0) {
            _emailView.buttonBlock = nil;
        } else {
            _emailView.buttonBlock = self.emailBlock;
        }
    }
    
    //银行账户
    NSString* bankString = [NSString stringWithFormat:@"%@%@%@", kLocalized(@"GYHS_Myhs_Did_Blanld_Bank_Card") ,model.banks, kLocalized(@"GYHS_Myhs_Per")];
    NSRange bankRange = [bankString rangeOfString:model.banks options:NSCaseInsensitiveSearch];
    NSMutableAttributedString* bankText = [[NSMutableAttributedString alloc] initWithString:bankString attributes:@{ NSFontAttributeName : kFont38, NSForegroundColorAttributeName : kGray666666 }];
    [bankText setAttributes:@{ NSFontAttributeName : kFont38,
                               NSForegroundColorAttributeName : kRedE50012 }
                      range:bankRange];
    self.bankCardView.text = bankText;
    
    //我的快捷卡
    NSString* quickString = [NSString stringWithFormat:@"%@%@%@", kLocalized(@"GYHS_Myhs_Did_Blanld_Quick_Card"),model.qkBanks,kLocalized(@"GYHS_Myhs_Per")];
    NSRange quickRange = [quickString rangeOfString:model.qkBanks options:NSCaseInsensitiveSearch];
    NSMutableAttributedString* quickText = [[NSMutableAttributedString alloc] initWithString:quickString attributes:@{ NSFontAttributeName : kFont38, NSForegroundColorAttributeName : kGray666666 }];
    [quickText setAttributes:@{ NSFontAttributeName : kFont38,
                                NSForegroundColorAttributeName : kRedE50012 }
                       range:quickRange];
    self.quickPayView.text = quickText;
}

#pragma mark - lazy load

- (GYHSMainLeftBottomCommonView*)linkInfoView
{
    if (!_linkInfoView) {
        _linkInfoView = [[GYHSMainLeftBottomCommonView alloc] initWithImage:[UIImage imageNamed:@"gyhs_linkPhone_icon"] title:kLocalized(@"GYHS_Myhs_Contact_Info")];
        _linkInfoView.buttonTitle = kLocalized(@"GYHS_Myhs_Look");
    }
    return _linkInfoView;
}

- (GYHSMainLeftBottomCommonView*)emailView
{
    if (!_emailView) {
        _emailView = [[GYHSMainLeftBottomCommonView alloc] initWithImage:[UIImage imageNamed:@"gyhs_mailAddress_icon"] title:kLocalized(@"GYHS_Myhs_Email_Address")];
    }
    return _emailView;
}

- (GYHSMainLeftBottomCommonView*)bankCardView
{
    if (!_bankCardView) {
        _bankCardView = [[GYHSMainLeftBottomCommonView alloc] initWithImage:[UIImage imageNamed:@"gyhs_allBank_icon"] title:kLocalized(@"GYHS_Myhs_Bank_Account")];
        _bankCardView.buttonTitle = kLocalized(@"GYHS_Myhs_Look");
    }
    return _bankCardView;
}

- (GYHSMainLeftBottomCommonView*)quickPayView
{
    if (!_quickPayView) {
        _quickPayView = [[GYHSMainLeftBottomCommonView alloc] initWithImage:[UIImage imageNamed:@"gyhs_quckPay_icon"] title:kLocalized(@"GYHS_Myhs_My_Quick_Pay_Card")];
        
        _quickPayView.buttonTitle = kLocalized(@"GYHS_Myhs_Look");
    }
    return _quickPayView;
}

@end
