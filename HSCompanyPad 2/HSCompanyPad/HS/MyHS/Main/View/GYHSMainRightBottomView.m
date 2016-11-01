//
//  GYHSMainRightBottomView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMainRightBottomView.h"
#import "GYHSMyHSMainModel.h"
#import "GYLabel.h"

@interface GYHSMainRightBottomView ()

@property (nonatomic, strong) UIImageView* myServiceImgView;
@property (nonatomic, strong) GYLabel* enterpriseNameLabel;
@property (nonatomic, strong) UILabel* enterpriseResNoLabel;
@property (nonatomic, strong) UILabel* enterpriseLinkmanLabel;
@property (nonatomic, strong) GYLabel* enterpriseAddressLabel;

@end

@implementation GYHSMainRightBottomView

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - pravate method
- (void)setUp
{
    [self addSubview:self.myServiceImgView];
    [self.myServiceImgView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self).offset(kDeviceProportion(8));
        make.centerX.equalTo(self.mas_centerX);
        make.width.height.equalTo(@(kDeviceProportion(150)));
    }];
    
    [self addSubview:self.enterpriseNameLabel];
    [self.enterpriseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_myServiceImgView.mas_bottom).offset(kDeviceProportion(8));
        make.left.equalTo(self).offset(kDeviceProportion(15));
        make.right.equalTo(self).offset(kDeviceProportion(-15));
        make.height.greaterThanOrEqualTo(@(kDeviceProportion(21)));
    }];

    [self addSubview:self.enterpriseResNoLabel];
    [self.enterpriseResNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_enterpriseNameLabel.mas_bottom).offset(kDeviceProportion(16));
        make.left.equalTo(self).offset(kDeviceProportion(15));
        make.right.equalTo(self).offset(kDeviceProportion(-15));
        make.height.equalTo(@(kDeviceProportion(21)));
    }];

    [self addSubview:self.enterpriseLinkmanLabel];
    [self.enterpriseLinkmanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_enterpriseResNoLabel.mas_bottom).offset(kDeviceProportion(16));
        make.left.equalTo(self).offset(kDeviceProportion(15));
        make.right.equalTo(self).offset(kDeviceProportion(-15));
        make.height.equalTo(@(kDeviceProportion(21)));
    }];

    [self addSubview:self.enterpriseAddressLabel];
    [self.enterpriseAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_enterpriseLinkmanLabel.mas_bottom).offset(kDeviceProportion(16));
        make.left.equalTo(self).offset(kDeviceProportion(15));
        make.right.equalTo(self).offset(kDeviceProportion(-15));
        make.height.equalTo(@(kDeviceProportion(21)));
    }];
    
}


-(void)setModel:(GYHSMyHSMainModel *)model {
    _model = model;
    
    self.enterpriseNameLabel.text = model.superEntCustName;
    self.enterpriseNameLabel.fullText = model.superEntCustName;
    if (model.superContactPerson.length > 10) {
        self.enterpriseNameLabel.text = [[model.superEntCustName substringToIndex:10] stringByAppendingString:@"..."] ;
    }
    
    self.enterpriseLinkmanLabel.text = [NSString stringWithFormat:@"%@(%@)",model.superContactPerson,model.superContactPhone];
    self.enterpriseResNoLabel.text = model.superEntResNo;
    
    self.enterpriseAddressLabel.text = model.superEntRegAddr;
    self.enterpriseAddressLabel.fullText = model.superEntRegAddr;
    if (model.superContactPerson.length > 10) {
        self.enterpriseAddressLabel.text = [[model.superEntRegAddr substringToIndex:10] stringByAppendingString:@"..."] ;
    }
    
}

#pragma mark -  lazy load
- (UIImageView*)myServiceImgView
{
    if (!_myServiceImgView) {
        _myServiceImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_myService_icon"]];
    }
    return _myServiceImgView;
}

- (GYLabel*)enterpriseAddressLabel
{
    if (!_enterpriseAddressLabel) {
        _enterpriseAddressLabel = [[GYLabel alloc] init];
        _enterpriseAddressLabel.font = kFont30;
        _enterpriseAddressLabel.textAlignment = NSTextAlignmentCenter;
        _enterpriseAddressLabel.userInteractionEnabled = YES;
        _enterpriseAddressLabel.textColor = kGray666666;
    }
    return _enterpriseAddressLabel;
}
- (UILabel*)enterpriseLinkmanLabel
{
    if (!_enterpriseLinkmanLabel) {
        _enterpriseLinkmanLabel = [[UILabel alloc] init];
        _enterpriseLinkmanLabel.font = kFont30;
        _enterpriseLinkmanLabel.textAlignment = NSTextAlignmentCenter;
        _enterpriseLinkmanLabel.textColor = kGray666666;
    }
    return _enterpriseLinkmanLabel;
}
- (UILabel*)enterpriseResNoLabel
{
    if (!_enterpriseResNoLabel) {
        _enterpriseResNoLabel = [[UILabel alloc] init];
        _enterpriseResNoLabel.font = kFont30;
        _enterpriseResNoLabel.textAlignment = NSTextAlignmentCenter;
        _enterpriseResNoLabel.textColor = kGray666666;
    }
    return _enterpriseResNoLabel;
}
- (GYLabel*)enterpriseNameLabel
{
    if (!_enterpriseNameLabel) {
        _enterpriseNameLabel = [[GYLabel alloc] init];
        _enterpriseNameLabel.font = kFont30;
        _enterpriseNameLabel.userInteractionEnabled = YES;
        _enterpriseNameLabel.textAlignment = NSTextAlignmentCenter;
        _enterpriseNameLabel.textColor = kGray666666;
    }
    return _enterpriseNameLabel;
}

@end
