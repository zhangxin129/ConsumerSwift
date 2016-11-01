//
//  GYHSMainRightTopView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMainRightTopView.h"
#import "GYHSMyHSMainModel.h"
#import <YYKit/YYKit.h>

@interface GYHSMainRightTopView () {
    UIView* _lineView; //这只是一根灰色线
}

@property (nonatomic, strong) UIImageView* systemStatusImgView;
@property (nonatomic, strong) UIButton* activityButton;
//@property (nonatomic, strong) UILabel* companyStatusLabel;
@property (nonatomic, strong) UIButton* logoutSystemButton;
@property (nonatomic, strong) UILabel* systemStartDateLabel;
@property (nonatomic, strong) UILabel* systemWorkToDateLabel;
@property (nonatomic, strong) YYLabel* yearFeeLabel;
//实名认证
@property (nonatomic, strong) UIImageView* realNameAuthenticateImgView;
@property (nonatomic, strong) UILabel* realNameAStatusLabel;
@property (nonatomic, strong) UIButton* authenticateNowButton;

@property (nonatomic, assign) NSInteger status;

/*!
 *    认证状态
 */
@property (nonatomic, assign) BOOL isAuthenticate;
@end

@implementation GYHSMainRightTopView

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.activityButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.activityButton.bounds.size.width - 11, 0, 0);
    
    self.logoutSystemButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.logoutSystemButton.bounds.size.width - 11, 0, 0);
    
    self.authenticateNowButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.authenticateNowButton.bounds.size.width - 11, 0, 0);
    
    _lineView.customBorderColor = kGrayE3E3EA;
    _lineView.customBorderType = UIViewCustomBorderTypeBottom;
    _lineView.customBorderLineWidth = @1;
}

#pragma mark - event response

- (void)stopActivityButtonAction
{
    //停止积分活动
    DDLogInfo(@"点击了--停止积分活动");
    if (self.stopActivityBlock) {
        self.stopActivityBlock(NO);
    }
}

- (void)joinActivityButtonAction
{
    DDLogInfo(@"点击了--参与积分活动");
    if (self.joinActivityBlock) {
        self.joinActivityBlock(YES);
    }
}

- (void)logoutButtonAction
{
    //注销系统
    DDLogInfo(@"点击了--注销系统");
    if (self.logoutSystemBlock) {
        self.logoutSystemBlock();
    }
}

- (void)authenticateNowButtonAction
{
    //立即认证
    DDLogInfo(@"点击了--立即认证");
    if (self.toAuthenticateBlock) {
        self.toAuthenticateBlock(NO);
    }
}

- (void)tapAction
{
    DDLogInfo(@"点击了--已认证");
    if (self.toAuthenticateBlock) {
        self.toAuthenticateBlock(YES);
    }
}

#pragma mark -  load data
- (void)setModel:(GYHSMyHSMainModel*)model
{
    _model = model;
  
    self.isAuthenticate = model.isRealnameAuth.boolValue;
    if (model.openDate.length > 10) {
        self.systemStartDateLabel.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_Myhs_Company_Open_Date_Colon"),[[model.openDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] substringToIndex:10]];
    } else {
        self.systemStartDateLabel.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_Myhs_Company_Open_Date_Colon") ,model.openDate];
    }
    
    self.systemWorkToDateLabel.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_Myhs_Current_Year_Fee_Validity_Colon"), model.endDate];
    
    if (globalData.companyType == kCompanyType_Trustcom) {
        
        if (model.arrearAmount.floatValue == 0) {
            //没有欠年费，隐藏欠费标签
            self.yearFeeLabel.hidden = YES;
        } else {
            self.yearFeeLabel.hidden = NO;
            NSString* str = [NSString stringWithFormat:@"%@%@%@", kLocalized(@"GYHS_Myhs_Company_Owe_Year_Fee_Front"),[GYUtils formatCurrencyStyle:model.arrearAmount.doubleValue],kLocalized(@"GYHS_Myhs_Company_Owe_Year_Fee_Tail")];
            NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName : kFont34, NSForegroundColorAttributeName : kGray333333 }];
            NSRange range1 = [str rangeOfString:[GYUtils formatCurrencyStyle:model.arrearAmount.doubleValue] options:NSCaseInsensitiveSearch];
            [text addAttributes:@{ NSFontAttributeName : kFont34,
                                   NSForegroundColorAttributeName : kRedE50012 }
                          range:range1];
            __block NSRange range2 = [str rangeOfString:kLocalized(@"GYHS_Myhs_Pay_Year_Fee_Now") options:NSCaseInsensitiveSearch];
            [text addAttributes:@{ NSFontAttributeName : kFont34,
                                   NSForegroundColorAttributeName : kBlue0C69E9 }
                          range:range2];
            UIImage* image = [UIImage imageNamed:@"gyhs_blue_arrow"];
            NSMutableAttributedString* attachmentString = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeRight attachmentSize:image.size alignToFont:kFont34 alignment:YYTextVerticalAlignmentCenter];
            [text appendAttributedString:attachmentString];
            self.yearFeeLabel.attributedText = text;
            self.yearFeeLabel.textLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(CGFLOAT_MAX, kDeviceProportion(40)) text:text];
            @weakify(self);
            self.yearFeeLabel.textTapAction = ^(UIView* containerView, NSAttributedString* text, NSRange range, CGRect rect) {
                @strongify(self);
                if (NSLocationInRange(range.location, range2)) {
                    DDLogInfo(@"立即缴纳年费");
                    if (self.toPayYearFeeBlock) {
                        self.toPayYearFeeBlock();
                    }
                }
            };
        }
    }
    
    self.status = model.status.integerValue;
}

//NSString* changeStatus(NSInteger status)
//{
//    switch (status) {
//        case 1:
//            return kLocalized(@"GYHS_Myhs_Normal");
//            break;
//        case 2:
//            return kLocalized(@"GYHS_Myhs_Warmming");
//            break;
//       
//        case 3:
//            return kLocalized(@"GYHS_Myhs_Sleeping");
//            break;
//        case 4:
//            return kLocalized(@"GYHS_Myhs_Sleep_Long");
//            break;
//        case 5:
//            return kLocalized(@"GYHS_Myhs_Did_Logout");
//            break;
//        case 6:
//            return kLocalized(@"GYHS_Myhs_Apply_Quit_Point_Actioning");
//            break;
//        case 7:
//            return kLocalized(@"GYHS_Myhs_Quit_Point_Action");
//            break;
//        case 8:
//            return kLocalized(@"GYHS_Myhs_Apply_Logouting");
//            break;
//        default:
//            return nil;
//            break;
//    }
//}

- (void)setStatus:(NSInteger)status
{
    _status = status;
    
    if (globalData.companyType == kCompanyType_Membercom) {
        //不显示有效期和缴纳年费
        self.systemWorkToDateLabel.hidden = YES;
        self.yearFeeLabel.hidden = YES;
        

        if (status == 1 || status == 2) {
//            _companyStatusLabel.text = kLocalized(changeStatus(status));
//            _companyStatusLabel.textColor = kGreen008C00;
            _systemStatusImgView.image = [UIImage imageNamed:@"gyhs_systemStatus_gyhs_systemStatus_normal"];
        } else {
//            _companyStatusLabel.text = kLocalized(changeStatus(status));
//            _companyStatusLabel.textColor = kGray666666;
            _systemStatusImgView.image = [UIImage imageNamed:@"gyhs_systemStatus_unusual_unusual"];
        }
        
        //添加注销系统按钮
        [self addSubview:self.logoutSystemButton];
        [self.logoutSystemButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(_systemStatusImgView.mas_centerY);
            make.height.equalTo(@(kDeviceProportion(28)));
            make.left.equalTo(_systemStatusImgView.mas_right).offset(kDeviceProportion(6));
            make.width.equalTo(@(kDeviceProportion(116)));
        }];
    }
    
    if (globalData.companyType == kCompanyType_Trustcom) {
        
        if (status == 1 || status == 2 || status == 6) {
//            _companyStatusLabel.text = kLocalized(changeStatus(status));
//            _companyStatusLabel.textColor = kGreen008C00;
            [_activityButton setTitle:kLocalized(@"GYHS_Myhs_Quit_Point_Action") forState:UIControlStateNormal];
            [_activityButton addTarget:self action:@selector(stopActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
            _systemStatusImgView.image = [UIImage imageNamed:@"gyhs_systemStatus_gyhs_systemStatus_normal"];
        } else {
//            _companyStatusLabel.text = kLocalized(changeStatus(status));
//            _companyStatusLabel.textColor = kGray666666;
            [_activityButton setTitle:kLocalized(@"GYHS_Myhs_Join_Point_Action") forState:UIControlStateNormal];
            [_activityButton addTarget:self action:@selector(joinActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
            _systemStatusImgView.image = [UIImage imageNamed:@"gyhs_systemStatus_unusual_unusual"];
        }
        
        //添加积分活动按钮
        [self addSubview:self.activityButton];
        [self.activityButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(_systemStatusImgView.mas_centerY);
            make.height.equalTo(@(kDeviceProportion(28)));
            make.left.equalTo(_systemStatusImgView.mas_right).offset(kDeviceProportion(6));
            make.width.equalTo(@(kDeviceProportion(116)));
        }];
    }
}

#pragma mark - pravate method
- (void)setIsAuthenticate:(BOOL)isAuthenticate
{
    _isAuthenticate = isAuthenticate;
    if (self.realNameAStatusLabel) {
        [self.realNameAStatusLabel removeFromSuperview];
    }
    if (self.authenticateNowButton) {
        [self.authenticateNowButton removeFromSuperview];
    }
    
    if (isAuthenticate) {
        self.realNameAuthenticateImgView.image = [UIImage imageNamed:@"gyhs_realNameVerified_normal"];
        [self addSubview:self.realNameAStatusLabel];
        [self.realNameAStatusLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(_realNameAuthenticateImgView.mas_centerY);
            make.height.equalTo(@(kDeviceProportion(28)));
            make.left.equalTo(_realNameAuthenticateImgView.mas_right).offset(kDeviceProportion(14));
            make.right.equalTo(self.mas_right).offset(kDeviceProportion(-8));
        }];
        
        //如果是已认证，则添加一个手势
        self.realNameAStatusLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.realNameAStatusLabel addGestureRecognizer:tap];
    } else {
        self.realNameAuthenticateImgView.image = [UIImage imageNamed:@"gyhs_realNameVerified_unusual"];
        [self addSubview:self.realNameAStatusLabel];
        [self.realNameAStatusLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(_realNameAuthenticateImgView.mas_centerY).offset(kDeviceProportion(-6));
            make.height.equalTo(@(kDeviceProportion(28)));
            make.left.equalTo(_realNameAuthenticateImgView.mas_right).offset(kDeviceProportion(14));
            make.right.equalTo(self.mas_right).offset(kDeviceProportion(-8));
        }];
        
        [self addSubview:self.authenticateNowButton];
        [self.authenticateNowButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(_realNameAuthenticateImgView.mas_centerY).offset(kDeviceProportion(6));
            make.height.equalTo(@(kDeviceProportion(28)));
            make.left.equalTo(_realNameAuthenticateImgView.mas_right).offset(kDeviceProportion(6));
            make.right.equalTo(self.mas_right).offset(kDeviceProportion(-8));
        }];
    }
    
    NSAttributedString* text = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"GYHS_Myhs_Did_Authenticate") attributes:@{ NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kGreen008C00 }];
    UIImage* image = [UIImage imageNamed:@"gyhs_greenTip"];
    NSTextAttachment* att = [[NSTextAttachment alloc] init];
    att.image = image;
    att.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    NSMutableAttributedString* str = [[NSAttributedString attributedStringWithAttachment:att] mutableCopy];
    [str appendAttributedString:text];
    
    NSMutableAttributedString* noAuthentice = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"GYHS_Myhs_No_Authenticate") attributes:@{ NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kRedE50012 }];
    _realNameAStatusLabel.attributedText = isAuthenticate ? str : noAuthentice;
}

- (void)setUp
{
    [self addSubview:self.systemStatusImgView];
    [self.systemStatusImgView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.mas_top).offset(kDeviceProportion(34));
        make.left.equalTo(self.mas_left).offset(kDeviceProportion(12));
        make.width.equalTo(@(kDeviceProportion(75)));
        make.height.equalTo(@(kDeviceProportion(61)));
    }];
    
//    [self addSubview:self.companyStatusLabel];
//    [self.companyStatusLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.bottom.equalTo(_systemStatusImgView.mas_centerY).offset(kDeviceProportion(-14));
//        make.height.equalTo(@(kDeviceProportion(28)));
//        make.left.equalTo(_systemStatusImgView.mas_right).offset(kDeviceProportion(14));
//        make.width.equalTo(@(kDeviceProportion(106)));
//    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = kGrayE3E3EA;
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.mas_top).offset(kDeviceProportion(129));
        make.height.equalTo(@(kDeviceProportion(1)));
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    [self addSubview:self.systemStartDateLabel];
    [self.systemStartDateLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_lineView.mas_bottom);
        make.height.equalTo(@(kDeviceProportion(40)));
        make.left.equalTo(self.mas_left).offset(kDeviceProportion(10));
        make.right.equalTo(self.mas_right).offset(kDeviceProportion(-10));
    }];
    
    [self addSubview:self.systemWorkToDateLabel];
    [self.systemWorkToDateLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_systemStartDateLabel.mas_bottom);
        make.height.equalTo(@(kDeviceProportion(40)));
        make.left.equalTo(self.mas_left).offset(kDeviceProportion(10));
        make.right.equalTo(self.mas_right).offset(kDeviceProportion(-10));
    }];
    
    [self addSubview:self.yearFeeLabel];
    [self.yearFeeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_systemWorkToDateLabel.mas_bottom);
        make.height.equalTo(@(kDeviceProportion(40)));
        make.left.equalTo(self.mas_left).offset(kDeviceProportion(10));
        make.right.equalTo(self.mas_right).offset(kDeviceProportion(-10));
    }];
    
    [self addSubview:self.realNameAuthenticateImgView];
    [self.realNameAuthenticateImgView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(_systemStatusImgView.mas_centerY);
        make.left.equalTo(_systemStatusImgView.mas_right).offset(kDeviceProportion(165));
        make.width.equalTo(@(kDeviceProportion(75)));
        make.height.equalTo(@(kDeviceProportion(61)));
    }];
}

#pragma mark - lazy load
- (UIImageView*)systemStatusImgView
{
    if (!_systemStatusImgView) {
        _systemStatusImgView = [[UIImageView alloc] init];
    }
    return _systemStatusImgView;
}
- (UIButton*)activityButton
{
    if (!_activityButton) {
        _activityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_activityButton setTitleColor:kBlue0C69E9 forState:UIControlStateNormal];
        [_activityButton setImage:[UIImage imageNamed:@"gyhs_blue_arrow"] forState:UIControlStateNormal];
        _activityButton.titleLabel.font = kFont32;
        _activityButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _activityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _activityButton;
}

//- (UILabel*)companyStatusLabel
//{
//    if (!_companyStatusLabel) {
//        _companyStatusLabel = [[UILabel alloc] init];
//        _companyStatusLabel.font = kFont34;
//    }
//    return _companyStatusLabel;
//}

- (UIButton*)logoutSystemButton
{
    if (!_logoutSystemButton) {
        _logoutSystemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutSystemButton setTitle:kLocalized(@"GYHS_Myhs_Logout_System") forState:UIControlStateNormal];
        [_logoutSystemButton setTitleColor:kBlue0C69E9 forState:UIControlStateNormal];
        [_logoutSystemButton setImage:[UIImage imageNamed:@"gyhs_blue_arrow"] forState:UIControlStateNormal];
        _logoutSystemButton.titleLabel.font = kFont32;
        _logoutSystemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _logoutSystemButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_logoutSystemButton addTarget:self action:@selector(logoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutSystemButton;
}

- (UILabel*)systemStartDateLabel
{
    if (!_systemStartDateLabel) {
        _systemStartDateLabel = [[UILabel alloc] init];
        _systemStartDateLabel.font = kFont34;
        _systemStartDateLabel.textColor = kGray333333;
    }
    return _systemStartDateLabel;
}
- (UILabel*)systemWorkToDateLabel
{
    if (!_systemWorkToDateLabel) {
        _systemWorkToDateLabel = [[UILabel alloc] init];
        _systemWorkToDateLabel.font = kFont34;
        _systemWorkToDateLabel.textColor = kGray333333;
    }
    return _systemWorkToDateLabel;
}
- (YYLabel*)yearFeeLabel
{
    if (!_yearFeeLabel) {
        _yearFeeLabel = [[YYLabel alloc] init];
    }
    return _yearFeeLabel;
}

- (UIImageView*)realNameAuthenticateImgView
{
    if (!_realNameAuthenticateImgView) {
        _realNameAuthenticateImgView = [[UIImageView alloc] init];
    }
    return _realNameAuthenticateImgView;
}

- (UILabel*)realNameAStatusLabel
{
    if (!_realNameAStatusLabel) {
        _realNameAStatusLabel = [[UILabel alloc] init];
        _realNameAStatusLabel.font = kFont36;
    }
    return _realNameAStatusLabel;
}

- (UIButton*)authenticateNowButton
{
    if (!_authenticateNowButton) {
        _authenticateNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_authenticateNowButton setTitle:kLocalized(@"GYHS_Myhs_To_Authenticate_Now") forState:UIControlStateNormal];
        [_authenticateNowButton setTitleColor:kBlue0C69E9 forState:UIControlStateNormal];
        [_authenticateNowButton setImage:[UIImage imageNamed:@"gyhs_blue_arrow"] forState:UIControlStateNormal];
        _authenticateNowButton.titleLabel.font = kFont32;
        _authenticateNowButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _authenticateNowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_authenticateNowButton addTarget:self action:@selector(authenticateNowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authenticateNowButton;
}



@end
