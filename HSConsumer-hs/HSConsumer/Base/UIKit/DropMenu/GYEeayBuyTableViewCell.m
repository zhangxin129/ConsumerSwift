//
//  GYEeayBuyTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEeayBuyTableViewCell.h"

#define KdetailFont [UIFont systemFontOfSize:10]
#define KpriceFont [UIFont systemFontOfSize:12]
@implementation GYEeayBuyTableViewCell

- (void)awakeFromNib
{
    self.btnRightCover.backgroundColor = [UIColor clearColor];
    self.btnLeftCover.backgroundColor = [UIColor clearColor];
    self.lbLeftGoodName.backgroundColor = [UIColor clearColor];
    self.lbRightGoodName.backgroundColor = [UIColor clearColor];
    self.lbLeftGoodPrice.backgroundColor = [UIColor clearColor];
    self.lbRightGoodPrice.backgroundColor = [UIColor clearColor];
    self.lbLeftGoodPv.backgroundColor = [UIColor clearColor];
    self.lbRightGoodPv.backgroundColor = [UIColor clearColor];
    self.lbRightSellCount.backgroundColor = [UIColor clearColor];
    self.lbRightHscompany.backgroundColor = [UIColor clearColor];
    self.lbRightCity.backgroundColor = [UIColor clearColor];
    self.lbLeftCity.backgroundColor = [UIColor clearColor];
    self.lbLeftHScompany.backgroundColor = [UIColor clearColor];
    self.lbLeftSellCount.backgroundColor = [UIColor clearColor];
    [self sendSubviewToBack:self.btnLeftCover];
    [self sendSubviewToBack:self.btnRightCover];

    //设置字体颜色
    self.lbRightGoodPrice.textColor = kNavigationBarColor;
    self.lbLeftGoodPrice.textColor = kNavigationBarColor;
    self.lbLeftGoodName.textColor = kCellItemTitleColor;
    self.lbRightGoodName.textColor = kCellItemTitleColor;
    //self.lbLeftGoodPv.textColor = kCellItemTextColor;
    //self.lbRightGoodPv.textColor = kCellItemTextColor;
    self.lbLeftSellCount.textColor = kCellItemTextColor;
    self.lbLeftHScompany.textColor = kCellItemTextColor;
    self.lbLeftCity.textColor = kCellItemTextColor;
    self.lbRightCity.textColor = kCellItemTextColor;
    self.lbRightHscompany.textColor = kCellItemTextColor;
    self.lbRightSellCount.textColor = kCellItemTextColor;
    [self.vLine addRightBorder];

    [self.lbLeftGoodPv addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{

    if ([keyPath isEqualToString:@"text"] && object == self.lbLeftGoodPv) {

        [self setHsbLogoOffsetX:self.lbLeftGoodPv.text from:160 withType:1];
    }
    if ([keyPath isEqualToString:@"text"] && object == self.lbRightGoodPv) {

        [self setHsbLogoOffsetX:self.lbLeftGoodPv.text from:290 withType:1];
    }
}

- (void)setHsbLogoOffsetX:(NSString*)text from:(CGFloat)fromX withType:(int)sourceType
{

    switch (sourceType) {
    case 1: {
        NSString* str = text;
        CGSize strSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, self.lbLeftGoodPv.frame.size.width) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.lbLeftGoodPv.font } context:nil].size;

        CGRect iconRect = self.imgvPointIcon.frame;

        if (strSize.width <= self.lbLeftGoodPv.frame.size.width) {

            iconRect.origin.x = self.frame.size.width - kDefaultMarginToBounds - fromX - strSize.width - iconRect.size.width - 5; //距离文字5

            self.imgvPointIcon.frame = iconRect;

        } //else使用xib的布局

    } break;
    default:
        break;
    }
}

- (void)refreshUIWithModel:(GYEasyBuyModel*)model WithSecondModel:(GYEasyBuyModel*)rightModel
{
    for (int i = 125; i < 130; i++) {
        UIView* view = [self viewWithTag:i];
        if (view != nil) {
            [view removeFromSuperview];
        }
    }
#pragma mark 左右都有
    if (model != nil && rightModel != nil) {

        ///// 右边

        //        NSString *str = rightModel.strGoodPoints;
        //        CGSize strSize = [str sizeWithFont:self.lbRightGoodPv.font
        //                         constrainedToSize:CGSizeMake(MAXFLOAT, self.lbRightGoodPv.frame.size.width)];
        //        CGRect iconRect = self.imgvRightPointIcon.frame;
        //        if (strSize.width <= self.lbRightGoodPv.frame.size.width)
        //        {
        //            iconRect.origin.x = self.frame.size.width - kDefaultMarginToBounds - strSize.width - iconRect.size.width -15;//距离文字5
        //            self.imgvRightPointIcon.frame = iconRect;
        //        }

        //        [self setIconCout:kScreenWidth/2-8 withType:100 andModel:rightModel];
        [self setIconCout:0 withType:100 andModel:rightModel];
        self.lbRightGoodName.text = rightModel.strGoodName;
        self.lbRightGoodPrice.text = [NSString stringWithFormat:@"%.2f", rightModel.strGoodPrice.floatValue];
        ;
        self.lbRightGoodPv.text = [NSString stringWithFormat:@"%.2f", rightModel.strGoodPoints.floatValue];
        ;
        self.lbRightCity.text = rightModel.city;
        self.lbRightHscompany.text = rightModel.companyName;
        //monthlySales 换成 saleCount
        self.lbRightSellCount.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_Base_totalsales"), rightModel.saleCount];
        [self.imgRightImage setImageWithURL:[NSURL URLWithString:rightModel.strGoodPictureURL] placeholder:kLoadPng(@"gycommon_image_placeholder") options:kNilOptions completion:nil];

        // add by songjk 计算位置
        CGFloat maxWidth = self.vRight.frame.size.width;
        CGSize priceSize = [GYUtils sizeForString:self.lbRightGoodPrice.text font:KpriceFont width:100];
        CGRect priceFrame = self.lbRightGoodPrice.frame;
        priceFrame.size.width = priceSize.width;
        self.lbRightGoodPrice.frame = priceFrame;

        CGSize pvSize = [GYUtils sizeForString:self.lbRightGoodPv.text font:KpriceFont width:100];
        CGRect pvFrame = self.lbRightGoodPv.frame;
        pvFrame.size.width = pvSize.width;
        pvFrame.origin.x = maxWidth - pvSize.width;
        self.lbRightGoodPv.frame = pvFrame;
        CGRect pvImgFrame = self.imgvRightPointIcon.frame;
        pvImgFrame.origin.x = pvFrame.origin.x - pvImgFrame.size.width - 2;
        self.imgvRightPointIcon.frame = pvImgFrame;
        self.lbRightGoodPv.adjustsFontSizeToFitWidth = NO;

        if (CGRectGetMaxX(priceFrame) > pvImgFrame.origin.x) {
            pvImgFrame.origin.x = CGRectGetMaxX(priceFrame) + 1;
            self.imgvRightPointIcon.frame = pvImgFrame;
            pvFrame.origin.x = CGRectGetMaxX(pvImgFrame);
            pvFrame.size.width = maxWidth - pvFrame.origin.x;
            self.lbRightGoodPv.frame = pvFrame;
            self.lbRightGoodPv.adjustsFontSizeToFitWidth = YES;
        }

        CGSize saleSize = [GYUtils sizeForString:self.lbRightSellCount.text font:KdetailFont width:150];
        CGRect saleFrame = self.lbRightSellCount.frame;
        saleFrame.size.width = saleSize.width;
        saleFrame.origin.x = maxWidth - saleSize.width;
        self.lbRightSellCount.frame = saleFrame;

        CGSize citySize = [GYUtils sizeForString:self.lbRightCity.text font:KdetailFont width:150];
        CGRect cityFrame = self.lbRightCity.frame;
        cityFrame.size.width = citySize.width;
        cityFrame.origin.x = maxWidth - citySize.width;
        self.lbRightCity.frame = cityFrame;

        CGRect companyFrame = self.lbRightHscompany.frame;
        companyFrame.size.width = cityFrame.origin.x - 2;
        companyFrame.origin.x = 0;
        self.lbRightHscompany.frame = companyFrame;
    }
    else {
#pragma mark 如果右边没有
        self.lbRightGoodName.hidden = YES;
        self.lbRightGoodPrice.hidden = YES;
        self.lbRightGoodPv.hidden = YES;
        self.imgRightImage.hidden = YES;
        self.btnRightCover.hidden = YES;
        self.imgvRightCoinIcon.hidden = YES;
        self.imgvRightPointIcon.hidden = YES;
        self.lbRightCity.hidden = YES;
        self.lbRightHscompany.hidden = YES;
        self.lbRightSellCount.hidden = YES;
    }

    [self setIconCout:0 withType:0 andModel:model];
    [self.imgLeftImage setImageWithURL:[NSURL URLWithString:model.strGoodPictureURL] placeholder:kLoadPng(@"gycommon_image_placeholder") options:kNilOptions completion:nil];

    self.lbLeftGoodName.text = model.strGoodName;
    self.lbLeftGoodPrice.text = [NSString stringWithFormat:@"%.2f", model.strGoodPrice.floatValue];
    self.lbLeftGoodPv.text = [NSString stringWithFormat:@"%.2f", model.strGoodPoints.floatValue];
    self.lbLeftHScompany.text = model.companyName;
    //monthlySales 换成 saleCount
    self.lbLeftSellCount.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_Base_totalsales"), model.saleCount];
    self.lbLeftCity.text = model.city;

    // add by songjk 计算位置
    CGFloat maxWidth = self.vRight.frame.size.width;
    CGSize priceSize = [GYUtils sizeForString:self.lbLeftGoodPrice.text font:KpriceFont width:100];
    CGRect priceFrame = self.lbLeftGoodPrice.frame;
    priceFrame.size.width = priceSize.width;
    self.lbLeftGoodPrice.frame = priceFrame;

    CGSize pvSize = [GYUtils sizeForString:self.lbLeftGoodPv.text font:KpriceFont width:100];
    CGRect pvFrame = self.lbLeftGoodPv.frame;
    pvFrame.size.width = pvSize.width;
    pvFrame.origin.x = maxWidth - pvSize.width;
    self.lbLeftGoodPv.frame = pvFrame;
    CGRect pvImgFrame = self.imgvPointIcon.frame;
    pvImgFrame.origin.x = pvFrame.origin.x - pvImgFrame.size.width - 2;
    self.imgvPointIcon.frame = pvImgFrame;
    self.lbLeftGoodPv.adjustsFontSizeToFitWidth = NO;

    if (CGRectGetMaxX(priceFrame) > pvImgFrame.origin.x) {
        pvImgFrame.origin.x = CGRectGetMaxX(priceFrame) + 1;
        self.imgvPointIcon.frame = pvImgFrame;
        pvFrame.origin.x = CGRectGetMaxX(pvImgFrame);
        pvFrame.size.width = maxWidth - pvFrame.origin.x;
        self.lbLeftGoodPv.frame = pvFrame;
        self.lbLeftGoodPv.adjustsFontSizeToFitWidth = YES;
    }

    CGSize saleSize = [GYUtils sizeForString:self.lbLeftSellCount.text font:KdetailFont width:150];
    CGRect saleFrame = self.lbLeftSellCount.frame;
    saleFrame.size.width = saleSize.width;
    saleFrame.origin.x = maxWidth - saleSize.width;
    self.lbLeftSellCount.frame = saleFrame;

    CGSize citySize = [GYUtils sizeForString:self.lbLeftCity.text font:KdetailFont width:150];
    CGRect cityFrame = self.lbLeftCity.frame;
    cityFrame.size.width = citySize.width;
    cityFrame.origin.x = maxWidth - citySize.width;
    self.lbLeftCity.frame = cityFrame;

    CGRect companyFrame = self.lbLeftHScompany.frame;
    companyFrame.size.width = cityFrame.origin.x - 2;
    companyFrame.origin.x = 0;
    self.lbLeftHScompany.frame = companyFrame;
}

- (void)setIconCout:(CGFloat)Xstart withType:(int)type andModel:(GYEasyBuyModel*)model
{
    self.beReach = [NSString stringWithFormat:@"%d", model.beReach];
    self.beCash = [NSString stringWithFormat:@"%d", model.beCash];
    self.beSell = [NSString stringWithFormat:@"%d", model.beSell];
    self.beTake = [NSString stringWithFormat:@"%d", model.beTake];
    self.beTicket = [NSString stringWithFormat:@"%d", model.beTicket];

//modify by zhangqy 9224 iOS消费者--轻松购--商品展示列表中特色服务排列建议与安卓（UI）一致
#if 0
    // add by songjk
    NSArray *arrData = [NSArray arrayWithObjects:
                        self.beReach,
                        self.beSell,
                        self.beCash,
                        self.beTake,
                        self.beTicket,
                        nil];


    NSMutableArray *marrUseData = [NSMutableArray array];
    for (int i = (arrData.count - 1); i > -1; i--) {
        NSString *str = arrData[i];
        if ([str isEqualToString:@"1"]) {
            NSNumber *num = [NSNumber numberWithInt:i+1];
            [marrUseData addObject:num];
        }
    }
    CGFloat iconWith = 15;
    // add bysongjk

    for (int i = 0; i < marrUseData.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 25+i+type;
        //        imageView.frame=CGRectMake(Xstart+iconWith*(i+1), 208, iconWith, iconWith);
        imageView.frame = CGRectMake(Xstart+iconWith*(i), 193, iconWith, iconWith);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_good_detail%ld", (long)[marrUseData[i] integerValue]]];
        [self addSubview:imageView];
        [self bringSubviewToFront:imageView];
    }
#endif

    //add by zhnagqy  iOS消费者--轻松购--商品展示列表中特色服务排列建议与安卓（UI）一致
    NSArray* arrData = [NSArray arrayWithObjects:
                                    self.beTicket,
                                self.beReach,
                                self.beSell,
                                self.beCash,
                                self.beTake,
                                nil];
    NSArray* imageNames = @[ @"gyhe_good_detail5", @"gyhe_good_detail1", @"gyhe_good_detail2", @"gyhe_good_detail3", @"gyhe_good_detail4" ];
    CGFloat iconWith = 15;
    for (int i = 0, j = 0; i < arrData.count; i++, j++) {
        UIImageView* imageView = [[UIImageView alloc] init];
        if ([arrData[i] isEqualToString:@"1"]) {
            imageView.tag = 25 + j + type;
            //            imageView.frame=CGRectMake(Xstart+iconWith*(j+1), 208, iconWith, iconWith);
            imageView.frame = CGRectMake(Xstart + iconWith * (j), 198, iconWith, iconWith);
            imageView.image = [UIImage imageNamed:imageNames[i]];
            if (type == 0) {

                [self.vLeft addSubview:imageView];
                [self.vLeft bringSubviewToFront:imageView];
            }
            else {

                [self.vRight addSubview:imageView];
                [self.vRight bringSubviewToFront:imageView];
            }
        } else {
            j--;
        }

    }
}

- (void)dealloc {
    [self.lbLeftGoodPv removeObserver:self forKeyPath:@"text"];

}

@end
