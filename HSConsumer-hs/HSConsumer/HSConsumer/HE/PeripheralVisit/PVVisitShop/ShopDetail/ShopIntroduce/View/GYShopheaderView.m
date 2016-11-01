//
//  GYShopheaderViewController.m
//  HSConsumer
//
//  Created by appleliss on 15/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopheaderView.h"

#define KShopNameFont [UIFont systemFontOfSize:18]

@implementation GYShopheaderView

- (id)initWithShopModel:(CGRect)frame WithOwer:(id)ower
{
    self = [super initWithFrame:frame];
    if (self) {

        self.superframe = frame;
        self.Ower = ower;
        CGRect tempRect = frame;
        tempRect.size.height = frame.size.height - 40;

        self.imgvShopPicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        self.imgvShopPicture.contentMode = UIViewContentModeScaleAspectFit;
        [self.imgvShopPicture setBackgroundColor:[UIColor whiteColor]];

        self.srcView = [[UIScrollView
                alloc] initWithFrame:CGRectMake(0, self.imgvShopPicture.frame.origin.y, kScreenWidth, self.imgvShopPicture.frame.size.height)];
        self.srcView.backgroundColor = [UIColor whiteColor];
        self.srcView.pagingEnabled = YES;
        self.srcView.delegate = self.Ower;
        self.srcView.showsHorizontalScrollIndicator = NO;

        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.srcView.frame.origin.y + self.srcView.frame.size.height, kScreenWidth, 60)];

        self.btnAttention = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnAttention.frame = CGRectMake(kScreenWidth - kDefaultMarginToBounds - 40, 0, 55, 68);
        [self.btnAttention setImage:[UIImage imageNamed:@"gyhe_no_collocate_shop"] forState:UIControlStateNormal];
        [self.btnAttention setImage:[UIImage imageNamed:@"gyhe_btn_shop_alrealy_attion.png"] forState:UIControlStateSelected];
        self.btnAttention.imageEdgeInsets = UIEdgeInsetsMake(2, 5, 30, 15);
        [self.btnAttention setTitleEdgeInsets:UIEdgeInsetsMake(25 + 2, -self.btnAttention.frame.size.width + 12, 0.0, 0)];
        self.btnAttention.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [self.btnAttention setTitle:kLocalized(@"GYHE_SurroundVisit_FocusOn") forState:UIControlStateNormal];
        [self.btnAttention setTitle:kLocalized(@"GYHE_SurroundVisit_AlreadyConcerned") forState:UIControlStateSelected]; // songjk
        //        [self.btnAttention setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [self.btnAttention setTitleColor:kCellItemTextColor forState:UIControlStateNormal];

        self.btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnCollect.frame = CGRectMake(self.btnAttention.frame.origin.x - 50, 0, 55, 68);
        self.btnCollect.imageEdgeInsets = UIEdgeInsetsMake(2, 8, 28, 15);
        [self.btnCollect setTitleEdgeInsets:UIEdgeInsetsMake(25 + 2, -40, 0.0, 0.0)];
        [self.btnCollect setImage:[UIImage imageNamed:@"gycommon_contact_shop"] forState:UIControlStateNormal];
        self.btnCollect.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.btnCollect setTitle:kLocalized(@"GYHE_SurroundVisit_ContactShop") forState:UIControlStateNormal];
        //        [self.btnCollect setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [self.btnCollect setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
        self.lbShopName = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultMarginToBounds, 0, self.btnCollect.frame.origin.x - kDefaultMarginToBounds - 5, 20)];

        self.lbShopName.textColor = kCellItemTitleColor;
        self.lbShopName.backgroundColor = [UIColor clearColor];
        self.lbShopName.font = [UIFont boldSystemFontOfSize:18];
        self.lbShopName.numberOfLines = 0;
        self.lbShopName.lineBreakMode = NSLineBreakByCharWrapping;
        self.gradeLabel = [[UILabel alloc] init];
        self.gradeLabel.textColor = [UIColor colorWithRed:239 / 255.0 green:138 / 255.0 blue:43 / 255.0 alpha:1];

        self.gradeLabel.backgroundColor = [UIColor clearColor];
        self.gradeLabel.font = [UIFont systemFontOfSize:13];

        [self.bottomView addSubview:self.gradeLabel];
        [self.srcView addSubview:self.imgvShopPicture];
        [self.bottomView addSubview:self.btnAttention];
        [self.bottomView addSubview:self.btnCollect];
        [self.bottomView addSubview:self.lbShopName];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bottomView];
        [self addSubview:self.srcView];
    }
    return self;
}

- (void)setShopInfo:(ShopModel*)model
{

    self.gradeLabel.text = model.strRate != [NSNull class] ? model.strRate : @"";
    self.PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth - 50) * 0.5, CGRectGetMaxY(self.srcView.frame) * 0.95, 50, 15)];
    self.PageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    self.PageControl.pageIndicatorTintColor = [UIColor lightGrayColor];

    [self addSubview:self.PageControl];
    if (model.marrShopImages.count > 0) {
        NSString* imageURL = model.marrShopImages[0][@"url"];
        WS(weakSelf);
        [self.imgvShopPicture setImageWithURL:[NSURL URLWithString:imageURL] placeholder:nil options:kNilOptions completion:^(UIImage* _Nullable image, NSURL* _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError* _Nullable error) {
            if (image) {
                weakSelf.imgvShopPicture.image = image;
            }
        }];
        self.srcView.contentSize = CGSizeMake(kScreenWidth * model.marrShopImages.count, 0);
        self.PageControl.numberOfPages = model.marrShopImages.count;
    }
    self.lbShopName.text = model.strShopName;
    CGSize shopNameSize = [GYUtils sizeForString:self.lbShopName.text font:KShopNameFont width:self.lbShopName.frame.size.width];
    //    self.lbShopName.frame = CGRectMake(self.lbShopName.frame.origin.x, 5, shopNameSize.width, shopNameSize.height);
    self.lbShopName.frame = CGRectMake(self.lbShopName.frame.origin.x, 5, self.lbShopName.frame.size.width, shopNameSize.height);
    if (shopNameSize.height > self.bottomView.frame.size.height) {
        self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y, kScreenWidth, shopNameSize.height + 25);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, kScreenWidth, CGRectGetMaxY(self.bottomView.frame));
    }

    //////循环灰色的图片
    for (int i = 0; i < 5; i++) {
        self.gradeView = [[UIImageView alloc] initWithFrame:CGRectMake(kDefaultMarginToBounds + (13 * i), self.lbShopName.frame.size.height + self.lbShopName.frame.origin.y + 5, 10, 10)];
        self.gradeView.image = [UIImage imageNamed:@"gyhe_collocate_star_gray"];
        [self.bottomView addSubview:self.gradeView];
    }
    //////循环亮色的图片
    for (int i = 0; i < model.strRate.integerValue; i++) {
        self.gradeView = [[UIImageView alloc] initWithFrame:CGRectMake(kDefaultMarginToBounds + (13 * i), self.lbShopName.frame.size.height + self.lbShopName.frame.origin.y + 5, 10, 10)];
        self.gradeView.image = [UIImage imageNamed:@"gyhe_collocate_star_yellow"];
        [self.bottomView addSubview:self.gradeView];
    }
    self.gradeLabel.frame = CGRectMake(kDefaultMarginToBounds + (13 * 5) + 10, self.gradeView.frame.origin.y, 30, 10);
}

- (UIPageControl*)PageControl
{
    if (!_PageControl) {
        _PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.srcView.frame) - 20, CGRectGetWidth(self.srcView.frame), 20)];
        _PageControl.currentPage = 0;
        _PageControl.backgroundColor = [UIColor clearColor];
        _PageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _PageControl;

}

@end
