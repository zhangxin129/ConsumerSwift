//
//  GYHSMainLeftTopView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMainLeftTopView.h"
#import "GYAreaHttpTool.h"
#import "GYHSMyHSMainModel.h"

@interface GYHSMainLeftTopView ()

@property (nonatomic, strong) UIImageView* headInformationImgView;
@property (nonatomic, strong) UILabel* companySalesPointsLabel;
@property (nonatomic, strong) UILabel* companyResNoLabel;
@property (nonatomic, strong) UILabel* companyBelongAreaLabel;
@property (nonatomic, strong) UILabel* companyTypeLabel;
@property (nonatomic, strong) UIButton* bigButton;

@end

@implementation GYHSMainLeftTopView

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
        [kDefaultNotificationCenter addObserver:self selector:@selector(chageHeadImage) name:GYChangeHeadImageNotification object:nil];
    }
    return self;
}

-(void)dealloc {
    [kDefaultNotificationCenter removeObserver:self name:GYChangeHeadImageNotification object:nil];
}

#pragma mark - event repose
- (void)bigButtonAction
{
    DDLogInfo(@"点击了 - 大图箭头");
    if (self.bigImageBlock) {
        self.bigImageBlock();
    }
}

- (void)tapHeadImageView:(UITapGestureRecognizer*)tap
{
    DDLogInfo(@"点击了 - 大头像");
    if (self.tapHeadLogoBlock) {
        self.tapHeadLogoBlock();
    }
}

#pragma mark - pravate method
- (void)setUp
{
    UIImageView* backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_changeHead_icon"]];
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.equalTo(self).offset(kDeviceProportion(14));
        make.bottom.equalTo(self).offset(kDeviceProportion(-14));
        make.width.equalTo(@(kDeviceProportion(230)));
    }];
    
    [backView addSubview:self.headInformationImgView];
    [self.headInformationImgView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.equalTo(backView).offset(kDeviceProportion(10));
        make.bottom.right.equalTo(backView).offset(kDeviceProportion(-10));
        make.width.equalTo(@(kDeviceProportion(230)));
    }];
    
    UIImageView* penImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_pen_icon"]];
    penImageView.userInteractionEnabled = YES;
    [self.headInformationImgView addSubview:penImageView];
    [penImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(backView).offset(kDeviceProportion(-12));
        make.bottom.equalTo(backView).offset(kDeviceProportion(-10));
        make.width.equalTo(@(kDeviceProportion(20)));
        make.height.equalTo(@(kDeviceProportion(20)));
    }];
    
    [self addSubview:self.bigButton];
    [self.bigButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(kDeviceProportion(48)));
        make.height.equalTo(@(kDeviceProportion(126)));
        make.right.equalTo(self).offset(kDeviceProportion(-13));
    }];
    
    [self addSubview:self.companyResNoLabel];
    [self.companyResNoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self.mas_centerY);
        make.right.equalTo(_bigButton.mas_left).offset(kDeviceProportion(12));
        make.left.equalTo(backView.mas_right).offset(kDeviceProportion(15));
        make.height.equalTo(@(kDeviceProportion(44)));
    }];
    
    [self addSubview:self.companySalesPointsLabel];
    [self.companySalesPointsLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(_companyResNoLabel.mas_top);
        make.right.equalTo(_bigButton.mas_left).offset(kDeviceProportion(-12));
        make.left.equalTo(backView.mas_right).offset(kDeviceProportion(15));
        make.height.equalTo(@(kDeviceProportion(44)));
    }];
    
    [self addSubview:self.companyBelongAreaLabel];
    [self.companyBelongAreaLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.mas_centerY);
        make.right.equalTo(_bigButton.mas_left).offset(kDeviceProportion(-12));
        make.left.equalTo(backView.mas_right).offset(kDeviceProportion(15));
        make.height.equalTo(@(kDeviceProportion(44)));
    }];
    
    [self addSubview:self.companyTypeLabel];
    [self.companyTypeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_companyBelongAreaLabel.mas_bottom);
        make.right.equalTo(_bigButton.mas_left).offset(kDeviceProportion(-12));
        make.left.equalTo(backView.mas_right).offset(kDeviceProportion(15));
        make.height.equalTo(@(kDeviceProportion(44)));
    }];
    
    //添加此按钮是为了方便点击企业信息
    UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.backgroundColor = [UIColor clearColor];
    [tapButton addTarget:self action:@selector(bigButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tapButton];
    [tapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top);
        make.bottom.equalTo(backView.mas_bottom);
        make.left.equalTo(backView.mas_right);
        make.right.equalTo(_bigButton.mas_left);
    }];
    
    [self chageHeadImage];
}

-(void)chageHeadImage {
    [self.headInformationImgView setImageWithURL:[NSURL URLWithString:GYHE_PICTUREAPPENDING(globalData.loginModel.vshopLogo)] placeholder:[UIImage imageNamed:@"gyhs_upload_image_smallHead"]];
}


#pragma mark - lazy load
- (UIImageView*)headInformationImgView
{
    if (!_headInformationImgView) {
        _headInformationImgView = [[UIImageView alloc] init];
        _headInformationImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImageView:)];
        [_headInformationImgView addGestureRecognizer:tap];
    }
    return _headInformationImgView;
}

- (UILabel*)companySalesPointsLabel
{
    if (!_companySalesPointsLabel) {
        _companySalesPointsLabel = [[UILabel alloc] init];
        _companySalesPointsLabel.font = kFont40;
        _companySalesPointsLabel.textColor = kGray000000;
        _companySalesPointsLabel.text = globalData.loginModel.entCustName;
    }
    return _companySalesPointsLabel;
}

- (UILabel*)companyBelongAreaLabel
{
    if (!_companyBelongAreaLabel) {
        _companyBelongAreaLabel = [[UILabel alloc] init];
            @weakify(self);
            [GYAreaHttpTool queryCityINfoWithNo:globalData.loginModel.cityCode success:^(id responsObject) {
                @strongify(self);
                GYCityAddressModel *addressModel = (GYCityAddressModel*)responsObject;
                
                NSString *fullName = [addressModel.cityFullName stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSString* string = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_Myhs_Belong_Area_Colon"),fullName];
                NSRange range = [string rangeOfString:fullName options:NSCaseInsensitiveSearch];
                NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : kFont38, NSForegroundColorAttributeName : kGray666666 }];
                [text setAttributes:@{ NSFontAttributeName : kFont38,
                                       NSForegroundColorAttributeName : kGray333333 }
                              range:range];
                self.companyBelongAreaLabel.attributedText = text;
            } failure:^{
                
            }];
    }
    return _companyBelongAreaLabel;
}

- (UILabel*)companyResNoLabel
{
    if (!_companyResNoLabel) {
        _companyResNoLabel = [[UILabel alloc] init];
        NSString* string = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_Myhs_Company_HS_Number_Colon"),globalData.loginModel.entResNo];
        NSRange range = [string rangeOfString:globalData.loginModel.entResNo options:NSCaseInsensitiveSearch];
        NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : kFont38, NSForegroundColorAttributeName : kGray666666 }];
        [text setAttributes:@{ NSFontAttributeName : kFont38,
                               NSForegroundColorAttributeName : kRedE50012 }
                      range:range];
        _companyResNoLabel.attributedText = text;
    }
    return _companyResNoLabel;
}

- (UILabel*)companyTypeLabel
{
    if (!_companyTypeLabel) {
        _companyTypeLabel = [[UILabel alloc] init];
        NSString* str = @"";
        if (globalData.companyType == kCompanyType_Trustcom) {
            str = kLocalized(@"GYHS_Myhs_Trust_Company");
        }
        if (globalData.companyType == kCompanyType_Membercom) {
            str = kLocalized(@"GYHS_Myhs_Menber_Company");
        }
        NSString* string = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_Myhs_Company_Type_Colon"),str];
        NSRange range = [string rangeOfString:str options:NSCaseInsensitiveSearch];
        NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : kFont38, NSForegroundColorAttributeName : kGray666666 }];
        [text setAttributes:@{ NSFontAttributeName : kFont38,
                               NSForegroundColorAttributeName : kGray333333 }
                      range:range];
        _companyTypeLabel.attributedText = text;
    }
    return _companyTypeLabel;
}

- (UIButton*)bigButton
{
    if (!_bigButton) {
        _bigButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigButton setImage:[UIImage imageNamed:@"gyhs_grayArrow_bigIcon"] forState:UIControlStateNormal];
        [_bigButton setImage:[UIImage imageNamed:@"gyhs_grayArrow_bigIcon"] forState:UIControlStateHighlighted];
        [_bigButton addTarget:self action:@selector(bigButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigButton;
}


@end
