//
//  GYHSCardConfirmVC.m
//
//  Created by apple on 16/8/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  对未确认的定制个性卡订单可以进行确认操作，并可以查看已确认的个性卡定制的订单
 */
#import "GYHSCardConfirmVC.h"
#import <YYKit/UIImageView+YYWebImage.h>
#import <GYKit/GYPhotoGroupView.h>
#import "GYHSListSpecCardStyleModel.h"
#import "UILabel+Category.h"
#import "GYHSStoreHttpTool.h"

@interface GYHSCardConfirmVC ()

@property (nonatomic, strong) UIView* cardStyleView;
@property (nonatomic, strong) UIView* confirmView;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) UIButton* confirmButton;
@property (nonatomic, strong) UIImageView* picImg;
@property (nonatomic, strong) UIView* noDataView;

@end

@implementation GYHSCardConfirmVC

#pragma mark - lazy load

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
}

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
// #pragma mark - event response

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_HSStore_PerCardCustomization_PersonalizedCardCustomization");
    self.view.backgroundColor = kWhiteFFFFFF;

    [self createCardStyleView];
    [self createConfirmView];
    [self createFooterView];
}
/**
 *  创建个性卡样式的视图
 */
- (void)createCardStyleView
{

    if (self.type == GYHSCardLookStateTypeConfirmed) {
        _cardStyleView = [[UIView alloc] initWithFrame:CGRectMake(16, 44 + 16, kDeviceProportion(kScreenWidth - 32), kDeviceProportion(243))];
    }
    else {
        _cardStyleView = [[UIView alloc] initWithFrame:CGRectMake(16, 44 + 16, kDeviceProportion(kScreenWidth - 32), kDeviceProportion(291))];
    }

    [self.view addSubview:_cardStyleView];
    _cardStyleView.layer.borderColor = kGrayCCCCCC.CGColor;
    _cardStyleView.layer.borderWidth = 1.0f;
    _cardStyleView.backgroundColor = kWhiteFFFFFF;

    _picImg = [[UIImageView alloc] initWithFrame:CGRectMake((self.cardStyleView.frame.size.width - kDeviceProportion(230)) / 2, 30, kDeviceProportion(230), kDeviceProportion(144))];
    [self.picImg setImageWithURL:[NSURL URLWithString:GY_PICTUREAPPENDING(self.model.microPic)] placeholder:[UIImage imageNamed:@"gyhs_placeholder_image"] options:kNilOptions completion:nil];
    self.picImg.contentMode = UIViewContentModeScaleAspectFit;
    [_cardStyleView addSubview:self.picImg];
    self.picImg.userInteractionEnabled = YES;

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImg:)];
    [self.picImg addGestureRecognizer:tap];

    UILabel* showLable = [[UILabel alloc] initWithFrame:CGRectMake((self.cardStyleView.frame.size.width - kDeviceProportion(230)) / 2, CGRectGetMaxY(self.picImg.frame) + 20, kDeviceProportion(230), 42)];
    showLable.text = kLocalized(@"GYHS_HSStore_PerCardCustomization_CardFront");
    showLable.textColor = kGray333333;
    showLable.font = kFont42;
    showLable.textAlignment = NSTextAlignmentCenter;
    [_cardStyleView addSubview:showLable];

    UIButton* selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedButton.frame = CGRectMake((self.cardStyleView.frame.size.width - kDeviceProportion(138)) / 2, CGRectGetMaxY(showLable.frame) + 30, 16, 16);
    [selectedButton setBackgroundImage:[UIImage imageNamed:@"gyhs_check_select"] forState:UIControlStateSelected];
    [selectedButton setBackgroundImage:[UIImage imageNamed:@"gyhs_check_noselect"] forState:UIControlStateNormal];
    [selectedButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    selectedButton.selected = NO;
    [_cardStyleView addSubview:selectedButton];

    UILabel* selectLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectedButton.frame) + 10, CGRectGetMaxY(showLable.frame) + 30, kDeviceProportion(112), kDeviceProportion(16))];
    selectLable.textColor = kGray333333;
    selectLable.font = kFont32;
    selectLable.text = kLocalized(@"GYHS_HSStore_PerCardCustomization_AreYouSureCardFront");
    [_cardStyleView addSubview:selectLable];

    if (self.type == GYHSCardLookStateTypeConfirmed) {
        selectedButton.hidden = YES;
        selectLable.hidden = YES;
    }
    else {
        selectedButton.hidden = NO;
        selectLable.hidden = NO;
    }
}
/**
 *  创建个性卡定制订单的详情视图
 */
- (void)createConfirmView
{
    _confirmView = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_cardStyleView.frame) + 30, kDeviceProportion(kScreenWidth - 32), kDeviceProportion(130))];
    [self.view addSubview:_confirmView];
    _confirmView.layer.borderColor = kGrayCCCCCC.CGColor;
    _confirmView.layer.borderWidth = 1.0f;
    _confirmView.backgroundColor = kBlueF2F2FD;

    UILabel* cardNameLable = [[UILabel alloc] init];
    [cardNameLable initWithText:_model.cardStyleName TextColor:kGray333333 Font:kFont42 TextAlignment:0];
    [_confirmView addSubview:cardNameLable];
    [cardNameLable mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_confirmView.mas_top).offset(29);
        make.left.equalTo(_confirmView.mas_left).offset(110);
        make.width.equalTo(@(kDeviceProportion(300)));
        make.height.equalTo(@(kDeviceProportion(21)));
    }];

    UILabel* feeTitleLable = [[UILabel alloc] init];
    [feeTitleLable initWithText:kLocalized(@"GYHS_HSStore_PerCardCustomization_CustomServiceFee(HSCurrency)") TextColor:kGray666666 Font:kFont32 TextAlignment:0];
    [_confirmView addSubview:feeTitleLable];
    [feeTitleLable mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(cardNameLable.mas_top).offset(21 + 10);
        make.left.equalTo(_confirmView.mas_left).offset(110);
        make.width.equalTo(@(kDeviceProportion(190)));
        make.height.equalTo(@(kDeviceProportion(16)));
    }];

    UIImageView* coinImageView = [[UIImageView alloc] init];
    [coinImageView setImage:[UIImage imageNamed:@"gyhs_HSBCoin"]];
    [_confirmView addSubview:coinImageView];
    [coinImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(cardNameLable.mas_top).offset(21 + 10);
        make.left.equalTo(feeTitleLable.mas_left).offset(190 + 16);
        make.width.equalTo(@(kDeviceProportion(16)));
        make.height.equalTo(@(kDeviceProportion(16)));
    }];

    UILabel* feeLable = [[UILabel alloc] init];
    [feeLable initWithText:[GYUtils formatCurrencyStyle:_model.cardStyleFee.doubleValue] TextColor:kRedE50012 Font:kFont32 TextAlignment:0];
    [_confirmView addSubview:feeLable];
    [feeLable mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(cardNameLable.mas_top).offset(21 + 10);
        make.left.equalTo(coinImageView.mas_left).offset( 16 + 5);
        make.width.equalTo(@(kDeviceProportion(200)));
        make.height.equalTo(@(kDeviceProportion(16)));
    }];

    UILabel* cusTimeTitleLable = [[UILabel alloc] init];
    [cusTimeTitleLable initWithText:kLocalized(@"GYHS_HSStore_PerCardCustomization_OrderdTime") TextColor:kGray666666 Font:kFont32 TextAlignment:0];
    [_confirmView addSubview:cusTimeTitleLable];
    [cusTimeTitleLable mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(feeTitleLable.mas_top).offset(16 + 9);
        make.left.equalTo(_confirmView.mas_left).offset(110);
        make.width.equalTo(@(kDeviceProportion(80)));
        make.height.equalTo(@(kDeviceProportion(16)));
    }];

    UILabel* cusTimeLable = [[UILabel alloc] init];
    [cusTimeLable initWithText:_model.reqTime TextColor:kGray666666 Font:kFont32 TextAlignment:0];
    [_confirmView addSubview:cusTimeLable];
    [cusTimeLable mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(feeTitleLable.mas_top).offset(16 + 9);
        make.left.equalTo(cusTimeTitleLable.mas_left).offset(80 + 16);
        make.width.equalTo(@(kDeviceProportion(170)));
        make.height.equalTo(@(kDeviceProportion(16)));
    }];

    UILabel* stateLable = [[UILabel alloc] init];
    NSString* stateStr;
    if (_model.isConfirm.boolValue) {
        stateStr = kLocalized(@"GYHS_HSStore_PerCardCustomization_AlreadyComfirm");
    }
    else {
        stateStr = kLocalized(@"GYHS_HSStore_PerCardCustomization_ToBeConfirmed");
    }

    [stateLable initWithText:stateStr TextColor:kRedE50012 Font:kFont32 TextAlignment:0];
    [_confirmView addSubview:stateLable];
    [stateLable mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_confirmView.mas_top).offset(29);
        make.right.equalTo(_confirmView.mas_right).offset(-62);
        make.width.equalTo(@(kDeviceProportion(100)));
        make.height.equalTo(@(kDeviceProportion(16)));
    }];
}
/**
 *  创建底部按钮视图（当订单状态为已确认时，则隐藏底部视图；当订单状态为未确认时，则显示底部视图）
 */
- (void)createFooterView
{
    _footerView = [[UIView alloc] init];
    _footerView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:_footerView];
    [_footerView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.layer.borderWidth = 1;
    _confirmButton.layer.borderColor = kRedE50012.CGColor;
    _confirmButton.layer.masksToBounds = YES;
    [_confirmButton setTitle:kLocalized(@"GYHS_HSStore_PerCardCustomization_MakeSure") forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setBackgroundColor:kRedE50012];
    [_confirmButton addTarget:self action:@selector(confimButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(164)));
        make.centerX.centerY.equalTo(_footerView);
    }];
    _footerView.hidden = YES;
}
/**
 *  可以查看个性卡设计稿的大图
 */
#pragma mark - event
- (void)showBigImg:(UIGestureRecognizer*)tap
{

    NSString* url = GY_PICTUREAPPENDING(self.model.microPic);
    GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
    item.largeImageURL = [NSURL URLWithString:url];
    item.thumbView = self.picImg;

    GYPhotoGroupView* photoGroupView = [[GYPhotoGroupView alloc] initWithGroupItems:@[ item ]];
    [photoGroupView presentFromImageView:self.picImg toContainer:self.navigationController.view animated:YES completion:nil];
}
/**
 *  待确认订单时，是否确认设计稿按钮的触发事件
 */
- (void)click:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (btn.selected == YES) {
        _footerView.hidden = NO;
    }
    else {
        _footerView.hidden = YES;
    }
}
/**
 *  待确认订单时，确认按钮的触发事件
 */
- (void)confimButtonAction
{
    [self requestConfirmCardStyle];
}
/**
 *  确认订单的网络请求
 */
#pragma mark - request
- (void)requestConfirmCardStyle
{
    [GYHSStoreHttpTool getConfirmCardStyleWithOrderNo:self.model.orderNo success:^(id responsObject) {
        [GYUtils showToast:kLocalized(@"GYHS_HSStore_PerCardCustomization_confirmCardStyleSuccessful")];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^{

    }];
}

@end
