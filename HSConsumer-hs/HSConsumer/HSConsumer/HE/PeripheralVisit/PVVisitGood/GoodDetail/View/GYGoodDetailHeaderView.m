//
//  GYShopDetailHeaderView.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYGoodDetailHeaderView.h"

@implementation GYGoodDetailHeaderView

- (id)initWithShopModel:(SearchGoodModel*)model WithFrame:(CGRect)frame WithOwer:(id)ower
{
    self = [super initWithFrame:frame];
    if (self) {

        self.superFrame = frame;
        CGRect tempRect = frame;
        self.ower = ower;

        tempRect.size.height = frame.size.height - 115;
        self.imgvGoodPicture = [[UIImageView alloc] initWithFrame:tempRect];
        self.imgvGoodPicture.contentMode = UIViewContentModeScaleAspectFit;
        // add by songjk
        UIImageView* ivIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_hsbcoin.png"]];
        ivIcon.frame = CGRectMake(kCellDefaultMarginToBounds, 15, 30, 30);
        self.lbGoodPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ivIcon.frame) + 10, 15, 250, 30)];
        self.lbGoodPrice.textColor = kCellItemTitleColor;
        self.lbGoodPrice.backgroundColor = [UIColor clearColor];
        // add by songjk
        CGFloat fPrice = [model.price floatValue];
        NSString* strPrice = [NSString stringWithFormat:@"%.02f", fPrice];
        self.lbGoodPrice.text = [NSString stringWithFormat:@"%@", strPrice]; // modify by songjk
        self.lbGoodPrice.textColor = kNavigationBarColor;
        self.lbGoodPrice.font = kCellTitleFont;

        self.imgvPointIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kCellDefaultMarginToBounds, self.lbGoodPrice.frame.origin.y + self.lbGoodPrice.frame.size.height + 10, 30, 30)];
        self.imgvPointIcon.image = [UIImage imageNamed:@"gyhe_about_pv_image"];

        self.lbPoint = [[UILabel alloc] initWithFrame:CGRectMake(self.imgvPointIcon.frame.origin.x + self.imgvPointIcon.frame.size.width + 10, self.lbGoodPrice.frame.origin.y + self.lbGoodPrice.frame.size.height + 10, 100, 20)];
        self.lbPoint.text = [NSString stringWithFormat:@"%.02f", [model.goodsPv doubleValue]];
        self.lbPoint.font = kGYTitleDescriptionFont;
        self.lbPoint.backgroundColor = [UIColor clearColor];
        self.lbPoint.textColor = kCorlorFromRGBA(0, 143, 215, 1);

        self.imgvPointIcon.center = CGPointMake(self.imgvPointIcon.center.x, self.lbPoint.center.y);

        // add by songjk 月销量
        self.lbMonthSale = [[UILabel alloc] init];
        if (model.saleCount == nil || [model.saleCount isKindOfClass:[NSNull class]]) {
            self.lbMonthSale.text = kLocalized(@"GYHE_SurroundVisit_TotalSalesZero");
        }
        else {
            self.lbMonthSale.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHE_SurroundVisit_TotalSales"), model.saleCount];
        }
        self.lbMonthSale.textColor = kCellItemTextColor;
        self.lbMonthSale.font = kGYTitleDescriptionFont;
        self.lbMonthSale.backgroundColor = [UIColor clearColor];
        self.lbMonthSale.frame = CGRectMake(CGRectGetMaxX(self.lbPoint.frame) + 5, self.lbPoint.frame.origin.y, 200, 20);
        [self.vBottomBackground addSubview:self.lbMonthSale];

        _btnAttention = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAttention.frame = CGRectMake(kScreenWidth - kCellDefaultMarginToBounds - 40, 15, 60, 50);
        [_btnAttention setImage:[UIImage imageNamed:@"gyhe_btn_colection"] forState:UIControlStateNormal];
        [_btnAttention setImage:[UIImage imageNamed:@"gyhe_collect_yes"] forState:UIControlStateSelected];

        _btnAttention.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _btnAttention.titleLabel.font = kGYOtherDescriptionFont;
        _btnAttention.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_btnAttention setTitleColor:kNavigationBarColor forState:UIControlStateNormal];

        _btnAttention.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 15, 20);
        _btnAttention.titleEdgeInsets = UIEdgeInsetsMake(43, -self.btnAttention.frame.size.width - 10, 5, -20);

        [_btnAttention setTitle:kLocalized(@"GYHE_SurroundVisit_Collection") forState:UIControlStateNormal];
        [_btnAttention setTitle:kLocalized(@"GYHE_SurroundVisit_HaveCollection") forState:UIControlStateSelected];

        //        [_btnEnterVShop setTitle:@"商铺" forState:UIControlStateNormal];

        [self.mainScrollView addSubview:self.imgvGoodPicture];
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
        //        [self addSubview:self.imgvGoodPicture];
        [self addSubview:self.mainScrollView];
        //        [self addSubview:self.pageControl];

        // add bysongjk 快递信息
        CGFloat lbExpressTitleX = self.imgvPointIcon.frame.origin.x;
        CGFloat lbExpressTitleY = CGRectGetMaxY(self.imgvPointIcon.frame) + 10;
        CGFloat lbExpressTitleW = 46;
        CGFloat lbExpressTitleH = 15;
        UILabel* lbExpressTitle = [[UILabel alloc] initWithFrame:CGRectMake(lbExpressTitleX, lbExpressTitleY, lbExpressTitleW, lbExpressTitleH)];
        lbExpressTitle.font = [UIFont systemFontOfSize:15];
        lbExpressTitle.textColor = kCellItemTextColor;
        lbExpressTitle.text = kLocalized(@"GYHE_SurroundVisit_ExpressFee");
        self.lbExpressTitle = lbExpressTitle;

        CGFloat ivExpressIconX = CGRectGetMaxX(lbExpressTitle.frame) + 10;
        CGFloat ivExpressIconY = lbExpressTitleY - 1;
        CGFloat ivExpressIconW = 17;
        CGFloat ivExpressIconH = 17;
        UIImageView* ivExpressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_hsbcoin.png"]];
        ivExpressIcon.frame = CGRectMake(ivExpressIconX, ivExpressIconY, ivExpressIconW, ivExpressIconH);
        self.mvExpressCoin = ivExpressIcon;

        CGFloat lbExpressFeeX = CGRectGetMaxX(ivExpressIcon.frame) + 8;
        CGFloat lbExpressFeeY = lbExpressTitleY;
        CGFloat lbExpressFeeW = 60;
        CGFloat lbExpressFeeH = 15;
        UILabel* lbExpressFee = [[UILabel alloc] initWithFrame:CGRectMake(lbExpressFeeX, lbExpressFeeY, lbExpressFeeW, lbExpressFeeH)];
        lbExpressFee.font = [UIFont systemFontOfSize:15];
        lbExpressFee.textColor = kCellItemTextColor;
        self.lbExpressFee = lbExpressFee;

        CGFloat lbExpressInfoX = CGRectGetMaxX(lbExpressFee.frame) + 10;
        CGFloat lbExpressInfoY = lbExpressTitleY;
        CGFloat lbExpressInfoW = kScreenWidth - lbExpressInfoX;
        CGFloat lbExpressInfoH = 15;
        UILabel* lbExpressInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbExpressInfoX, lbExpressInfoY, lbExpressInfoW, lbExpressInfoH)];
        lbExpressInfo.font = [UIFont systemFontOfSize:15];
        lbExpressInfo.textColor = kCellItemTextColor;
        self.lbExpressInfo = lbExpressInfo;

        [self.vBottomBackground addSubview:self.lbExpressTitle];
        [self.vBottomBackground addSubview:self.mvExpressCoin];
        [self.vBottomBackground addSubview:self.lbExpressFee];
        [self.vBottomBackground addSubview:self.lbExpressInfo];

        [self.vBottomBackground addSubview:ivIcon]; // add by songjk
        [self.vBottomBackground addSubview:self.lbGoodPrice];
        [self.vBottomBackground addSubview:self.imgvPointIcon];
        //        [self.vBottomBackground addSubview:self.btnEnterVShop];
        [self.vBottomBackground addSubview:self.btnAttention];
        [self.vBottomBackground addSubview:self.lbPoint];

        [self addSubview:self.vBottomBackground];
    }
    return self;
}

- (void)setInfoForHeaderView:(GYSurrondGoodsDetailModel*)model
{
    // add by songjk
    NSString* lowPv = [NSString stringWithFormat:@"%.02f", [model.lowPv doubleValue]];
    NSString* pv = [NSString stringWithFormat:@"%.02f", [model.goodsPv doubleValue]];
    if (![lowPv isEqualToString:pv]) {
        self.lbPoint.text = [NSString stringWithFormat:kLocalized(@"GYHE_SurroundVisit_%@Get"), lowPv];
    }
    else {
        self.lbPoint.text = pv;
    }
    if (model.bigPrice.length > 0 && model.lowPrice.length > 0) {
        NSString* bigPrice = [NSString stringWithFormat:@"%.02f", [model.bigPrice doubleValue]];
        NSString* lowPrice = [NSString stringWithFormat:@"%.02f", [model.lowPrice doubleValue]];
        if (![bigPrice isEqualToString:lowPrice]) {
            self.lbGoodPrice.text = [NSString stringWithFormat:@"%@~%@", lowPrice, bigPrice];
        }
        else {
            self.lbGoodPrice.text = bigPrice;
        }
    }
    self.lbExpressFee.text = [NSString stringWithFormat:@"%.02f", [model.postage floatValue]];
    self.lbExpressInfo.text = model.postageMsg;
    if ([model.postage integerValue] == 0) {
        self.lbExpressTitle.hidden = YES;
        self.mvExpressCoin.hidden = YES;
        self.lbExpressFee.hidden = YES;
        self.lbExpressInfo.text = kLocalized(@"GYHE_SurroundVisit_FreeShipping");
        self.lbExpressInfo.frame = CGRectMake(self.lbExpressTitle.frame.origin.x, self.lbExpressInfo.frame.origin.y, self.lbExpressInfo.frame.size.width, self.lbExpressInfo.frame.size.height);
    }

    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth - 50) * 0.5, CGRectGetMaxY(self.mainScrollView.frame) - 25, 50, 15)];
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    //    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    //    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0 green:107/255.0 blue:183/255.0 alpha:1];
    [self addSubview:_pageControl];
    if (model.shopUrl.count > 0) {
        WS(weakSelf);
        [self.imgvGoodPicture setImageWithURL:[NSURL URLWithString:model.shopUrl[0][@"url"]] placeholder:nil options:kNilOptions completion:^(UIImage* _Nullable image, NSURL* _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError* _Nullable error) {
            if (image) {

//                image =[GYUtils imageCompressForWidth:image targetWidth:kScreenWidth];
                weakSelf.imgvGoodPicture.image = image;
      

            }

        }];

        _pageControl.numberOfPages = model.shopUrl.count;

        CGSize sizeForMainScr = self.mainScrollView.contentSize;
        self.mainScrollView.contentSize = CGSizeMake(kScreenWidth * model.shopUrl.count, sizeForMainScr.height);
    }
    // add by songjk
    if (model.saleCount && ![model.saleCount isKindOfClass:[NSNull class]]) {
        self.lbMonthSale.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHE_SurroundVisit_TotalSales"), model.saleCount];
    }
    else {
        self.lbMonthSale.text = kLocalized(@"GYHE_SurroundVisit_TotalSalesZero");
    }
}

- (UIPageControl*)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mainScrollView.frame) - 20, CGRectGetWidth(self.mainScrollView.frame), 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 1;
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (UIScrollView*)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.imgvGoodPicture.frame.size.height)];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth, self.imgvGoodPicture.frame.size.height);
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.delegate = self.ower;
    }
    return _mainScrollView;
}

- (UIView*)vBottomBackground
{
    if (!_vBottomBackground) {
        _vBottomBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.imgvGoodPicture.frame.origin.y + self.imgvGoodPicture.frame.size.height, kScreenWidth, 60)];
        _vBottomBackground.backgroundColor = [UIColor whiteColor];
    }
    return _vBottomBackground;
}

@end
