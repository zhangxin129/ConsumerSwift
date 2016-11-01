//
//  GYHESCCartTableViewCell.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/18.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#import "GYHESCCartTableViewCell.h"
#import "GYHESCCartAlertView.h"
#import "GYHESCDiscountInfoView.h"
#import "GYAlertView.h"

@interface GYHESCCartTableViewCell () <GYHESCCartAlertViewDelegate, GYNetRequestDelegate, GYHESCDiscountInfoViewDelegate>

@property (weak, nonatomic) IBOutlet UIView* chooseView;
@property (weak, nonatomic) IBOutlet UIView* detailView;
@property (nonatomic, copy) NSString* priceString;
@property (nonatomic, copy) NSString* pvString;
@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) GYHESCCartAlertView* alertView;
@property (nonatomic, strong) GYHESCDiscountInfoView* discountView;
@end

@implementation GYHESCCartTableViewCell

- (void)awakeFromNib
{
    // Initialization code

    self.operatingPointLabel.text = kLocalized(@"HE_SC_CartChooseAreaTitle");
    self.totalLabel.text = kLocalized(@"HE_SC_CartTotal");
    [self addSubLayerForLabel];
    //添加手势
    UITapGestureRecognizer* detailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTapClick:)];
    [self.pictureImageView addGestureRecognizer:detailTap];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTapClick:)];
    [self.chooseView addGestureRecognizer:tap];

    UITapGestureRecognizer* labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertTapClick:)];
    [self.numberLabel addGestureRecognizer:labelTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - custom methods
- (void)detailTapClick:(UITapGestureRecognizer*)sender
{
    if ([self.delegate respondsToSelector:@selector(pushToItemDetailWithIndexPath:)]) {
        [self.delegate pushToItemDetailWithIndexPath:self.indexPath];
    }
}

- (void)chooseTapClick:(UITapGestureRecognizer*)sender
{
    if ([self.delegate respondsToSelector:@selector(pushToChooseAreaWithIndexPath:)]) {
        [self.delegate pushToChooseAreaWithIndexPath:self.indexPath];
    }
}

- (void)alertTapClick:(UITapGestureRecognizer*)sender
{
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];

    self.alertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHESCCartAlertView class]) owner:self options:nil] firstObject];
    self.alertView.delegate = self;
    self.alertView.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    self.alertView.maxNumber = self.maxNumber;
    self.alertView.numberTextField.text = self.numberLabel.text;
    [self.bgView addSubview:self.alertView];
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self.bgView];
    [self.alertView.numberTextField becomeFirstResponder]; //成为第一响应者
}

- (void)refreshDataWithModel:(GYHESCCartListModel*)model
{
    self.priceString = model.price;
    self.pvString = model.pv;
    self.shopNameLabel.text = model.vShopName;
    [self.pictureImageView setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
    self.describleLabel.text = model.title;
    self.skuLabel.text = model.sku;
    self.moneyNumLabel.text = [NSString stringWithFormat:@"%.2f", [model.price doubleValue]];
    self.numberLabel.text = model.count;
    self.storeLabel.text = model.shopName;
    self.goodsNumLabel.text = [NSString stringWithFormat:kLocalized(@"HE_SC_CartTotalGoods"),1];
    self.totalCoinNumLabel.text = [self mutiplyWithString:model.count otherString:model.price];
    self.pvNumLabel.text = [self mutiplyWithString:model.count otherString:model.pv];
    self.selectButton.selected = model.isSelect;
    //如果有消费券信息就加上显示信息的view
    if (self.listModel.couponDesc && self.listModel.couponDesc.length > 0) {
        self.discountView.indexPath = self.indexPath;
        self.discountView.listModel = self.listModel;
        self.discountView.detailLabel.text = self.listModel.couponDesc;

        CGRect rect = self.discountView.frame;
        rect.origin.y = CGRectGetMaxY(self.detailView.frame); //修改view的y值
        rect.size.width = kScreenWidth;
        if (self.listModel.isShowMore) {
            rect.size.height = 55.0f;
            self.discountView.detailView.hidden = NO;
        }
        else {
            rect.size.height = 30.0f;
            self.discountView.detailView.hidden = YES;
        }
        self.discountView.frame = rect;
        self.discountView.hidden = NO;
    }
    else {
        self.discountView.hidden = YES;
    }
    self.discountView.isShowMore = model.isShowMore;
}

- (GYHESCDiscountInfoView*)discountView
{
    if (!_discountView) {
        _discountView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHESCDiscountInfoView class]) owner:self options:nil] firstObject];
        _discountView.delegate = self;
        _discountView.isShowMore = self.listModel.isShowMore;
        [self.contentView addSubview:_discountView];
    }
    return _discountView;
}

#pragma mark - GYHESCCartAlertViewDelegate
- (void)cancleButtonClicked
{
    [self.alertView removeFromSuperview];
    [self.bgView removeFromSuperview];
}

- (void)confirmButtonClicked
{
    self.listModel.count = self.alertView.numberTextField.text;
    [self.alertView removeFromSuperview];
    [self.bgView removeFromSuperview];
    
    if (self.listModel.isSelect) {
        self.accountBlock();
    }
    [self calculateTotalMoneyAndPvWithCount:[self.listModel.count integerValue]];
    [self networkRequestData];
}

#pragma mark - GYHESCDiscountInfoViewDelegate
- (void)resetDiscountInfoView:(NSIndexPath*)indexPath
{

    self.listModel.isShowMore = !self.listModel.isShowMore;
    if ([self.delegate respondsToSelector:@selector(resetCartCell:)]) {
        [self.delegate resetCartCell:self.indexPath];
    }
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"------success----");
}

#pragma mark - custom methods
- (void)networkRequestData
{
    NSDictionary* parameterDic = @{ @"number" : self.numberLabel.text,
        @"cartId" : self.listModel.cartId,
        @"key" : globalData.loginModel.token };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:EasyBuyUpdateCartNumberUrl parameters:parameterDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//两字符串相乘
- (NSString*)mutiplyWithString:(NSString*)oneString otherString:(NSString*)otherString
{
    return [NSString stringWithFormat:@"%.2lf", [oneString doubleValue] * [otherString doubleValue]];
}

//精度较高的乘法计算
- (NSString*)decimalNumberMutiplyWithString:(NSString*)multiplierValue othersString:(NSString*)multiplicandValue
{
    NSDecimalNumber* multiplierNumber = [NSDecimalNumber decimalNumberWithString:multiplierValue];
    NSDecimalNumber* multiplicandNumber = [NSDecimalNumber decimalNumberWithString:multiplicandValue];
    NSDecimalNumberHandler* roundBanker = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES]; //四舍五入保留小数点后两位
    NSDecimalNumber* totalValueNumber = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber withBehavior:roundBanker];
    return [NSString stringWithFormat:@"%@", totalValueNumber];
}

- (void)calculateTotalMoneyAndPvWithCount:(NSInteger)count
{
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", count];
    self.goodsNumLabel.text = [NSString stringWithFormat:kLocalized(@"HE_SC_CartTotalGoods"),1];
    self.totalCoinNumLabel.text = [self mutiplyWithString:[NSString stringWithFormat:@"%ld", count] otherString:self.priceString];
    self.pvNumLabel.text = [self mutiplyWithString:[NSString stringWithFormat:@"%ld", count] otherString:self.pvString];
}

//两字符串相加
- (NSString*)addWithString:(NSString*)oneString otherString:(NSString*)otherString
{
    return [NSString stringWithFormat:@"%.2lf", [oneString doubleValue] + [otherString doubleValue]];
}

- (void)addSubLayerForLabel
{

    CALayer* topBorder = [CALayer layer];
    float width = self.numberLabel.frame.size.width;
    topBorder.frame = CGRectMake(0, 0, width, 1 / [UIScreen mainScreen].scale);
    topBorder.backgroundColor = kCorlorFromRGBA(201, 202, 202, 1).CGColor;
    [self.numberLabel.layer addSublayer:topBorder];

    CALayer* bottomBorder = [CALayer layer];
    float height = self.numberLabel.frame.size.height - 1 / [UIScreen mainScreen].scale;
    bottomBorder.frame = CGRectMake(0, height, width, 1 / [UIScreen mainScreen].scale);
    bottomBorder.backgroundColor = kCorlorFromRGBA(201, 202, 202, 1).CGColor;
    [self.numberLabel.layer addSublayer:bottomBorder];
}

#pragma mark - xib event response
//删除按钮
- (IBAction)deleteButtonClick:(UIButton*)sender
{
    [GYAlertView showMessage:kLocalized(@"HE_SC_CartConfirmDeleteGood") cancleBlock:nil confirmBlock:^{
        if ([self.delegate respondsToSelector:@selector(deleteCartCell:)]) {
            [self.delegate deleteCartCell:self.indexPath];
        }
    }];
}

//选中button
- (IBAction)isChooseButtonClick:(UIButton*)sender
{
    self.listModel.isSelect = !self.listModel.isSelect;
    sender.selected = self.listModel.isSelect;
    self.accountBlock();
}

//减按钮
- (IBAction)subtractButtonClick:(UIButton*)sender
{
    NSInteger count = kSaftToNSInteger(self.numberLabel.text);
    if (count > 1) {
        count--;
        self.listModel.count = [NSString stringWithFormat:@"%ld", count];
        if (self.listModel.isSelect) {
            self.accountBlock();
        }
        [self calculateTotalMoneyAndPvWithCount:count];
        [self networkRequestData];
    }
    else {
        [GYUtils showToast:kLocalized(@"HE_SC_CartMinGoodsNumber")];
    }
}

//加按钮
- (IBAction)addButtonClick:(UIButton*)sender
{
    NSInteger count = kSaftToNSInteger(self.numberLabel.text);
    if (count < self.maxNumber) {
        count++;
        self.listModel.count = [NSString stringWithFormat:@"%ld", count];
        if (self.listModel.isSelect) {
            self.accountBlock();
        }
        [self calculateTotalMoneyAndPvWithCount:count];
        [self networkRequestData];
    }
    else {
        [GYUtils showToast:[NSString stringWithFormat:kLocalized(@"HE_SC_CartMaxGoodsNumber"), self.maxNumber]];
    }
}

@end
