//
//  
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopDetailHotGoodTableViewCell.h"

@implementation GYShopDetailHotGoodTableViewCell

- (void)awakeFromNib
{
    self.btnRightCover.backgroundColor = [UIColor clearColor];
    self.btnLeftCover.backgroundColor = [UIColor clearColor];
    self.lbLeftGoodName.backgroundColor = [UIColor clearColor];
    self.lbRightGoodName.backgroundColor = [UIColor clearColor];

    [self sendSubviewToBack:self.btnLeftCover];
    [self sendSubviewToBack:self.btnRightCover];

    //    [self.contentView addTopBorder];
    //设置字体颜色
    self.lbLeftGoodName.textColor = kCellItemTitleColor;
    self.lbRightGoodName.textColor = kCellItemTitleColor;

    //    [self.imgLeftImage addAllBorder];
    //    [self.imgRightImage addAllBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUIWithModel:(GYHotItemGoods*)model WithSecondModel:(GYHotItemGoods*)rightModel
{
    //    @property (weak, nonatomic) IBOutlet UIImageView *imgLeftImage;//左边图片imgview
    //    @property (weak, nonatomic) IBOutlet UIImageView *imgRightImage;//右边图片imgview
    //    @property (weak, nonatomic) IBOutlet UILabel *lbLeftGoodName;//左边商品名称
    //    @property (weak, nonatomic) IBOutlet UILabel *lbLeftGoodPrice;//左边商品价格
    //    @property (weak, nonatomic) IBOutlet UILabel *lbLeftGoodPv;//左边商品积分
    //    @property (weak, nonatomic) IBOutlet UILabel *lbRightGoodName;//右边商品名称
    //    @property (weak, nonatomic) IBOutlet UILabel *lbRightGoodPrice;//右边商品价格
    //    @property (weak, nonatomic) IBOutlet UILabel *lbRightGoodPv;//右边商品积分
    //    @property (weak, nonatomic) IBOutlet UIButton *btnLeftCover;//左边覆盖BTN
    //    @property (weak, nonatomic) IBOutlet UIButton *btnRightCover;//右边覆盖BTN
    //    [self.imgLeftImage sd_setImageWithURL:[NSURL URLWithString:model.strImgUrl]];
    //    [self.imgRightImage sd_setImageWithURL:[NSURL URLWithString:rightModel.strImgUrl]];
    //
    //    self.lbLeftGoodName.text=model.strItemName;

    [self.imgLeftImage setBackgroundColor:[UIColor whiteColor]];
    [self.imgLeftImage setContentMode:UIViewContentModeScaleToFill];

    [self.imgRightImage setBackgroundColor:[UIColor whiteColor]];
    [self.imgRightImage setContentMode:UIViewContentModeScaleToFill];
    if (model) {
        self.lbLeftGoodName.hidden = NO;
        self.imgLeftImage.hidden = NO;
        self.lbLeftGoodName.text = model.strItemName;
        [self.imgLeftImage setImageWithURL:[NSURL URLWithString:model.strImgUrl] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];

        // adde by songjk
        self.vBackLeft.hidden = NO;

        self.lbPriceLeft.text = [NSString stringWithFormat:@"%.2f", model.strPrice.floatValue];
        self.lbPriceLeft.textColor = kNavigationBarColor;
        self.lbPvLeft.text = [NSString stringWithFormat:@"%.2f", model.strPV.floatValue];
        self.lbPvLeft.textColor = kCorlorFromRGBA(0, 143, 215, 1);

        CGFloat y = self.vBackLeft.frame.origin.y;
        CGSize pvSize = [GYUtils sizeForString:self.lbPvLeft.text font:[UIFont systemFontOfSize:13] width:100];
        CGSize priceSize = [GYUtils sizeForString:self.lbPriceLeft.text font:[UIFont systemFontOfSize:13] width:100];

        // 长度不大于图片长度
        if (self.imgCoinLeft.frame.size.width + self.imgPvLeft.frame.size.width + pvSize.width + priceSize.width + 2 <= self.imgLeftImage.frame.size.width) {
            self.vBackLeft.frame = CGRectMake(32, y, self.imgLeftImage.frame.size.width, 18);
            self.vBackLeft.center = CGPointMake(self.imgLeftImage.center.x, self.vBackLeft.center.y);
            DDLogDebug(@"vLeftbackframe1 = %@", NSStringFromCGRect(self.vBackLeft.frame));
            CGFloat maxX = self.vBackLeft.frame.size.width;
            self.lbPvLeft.frame = CGRectMake(maxX - pvSize.width, self.lbPvLeft.frame.origin.y, pvSize.width, self.lbPvLeft.frame.size.height);
            self.imgPvLeft.frame = CGRectMake(maxX - pvSize.width - self.imgPvLeft.frame.size.width - 1, self.imgPvLeft.frame.origin.y, self.imgPvLeft.frame.size.width, self.imgPvLeft.frame.size.height);
            self.lbPriceLeft.frame = CGRectMake(self.lbPriceLeft.frame.origin.x, self.lbPriceLeft.frame.origin.y, priceSize.width, 18);
            DDLogDebug(@"lbPvLeftFrame1 = %@", NSStringFromCGRect(self.lbPvLeft.frame));
        }
        else {
            CGFloat fWidth = self.imgCoinLeft.frame.size.width + self.imgPvLeft.frame.size.width + pvSize.width + priceSize.width + 2 + 2;
            if (fWidth > kScreenWidth * 0.5 - 10) {
                fWidth = kScreenWidth * 0.5 - 10;
            }
            self.vBackLeft.frame = CGRectMake(self.imgLeftImage.frame.origin.x, y, fWidth, 18);
            self.vBackLeft.center = CGPointMake(self.imgLeftImage.center.x, self.vBackLeft.center.y);
            DDLogDebug(@"vLeftbackframe2 = %@", NSStringFromCGRect(self.vBackLeft.frame));
            CGFloat maxX = self.vBackLeft.frame.size.width;
            self.lbPvLeft.frame = CGRectMake(maxX - pvSize.width, self.lbPvLeft.frame.origin.y, pvSize.width, self.lbPvLeft.frame.size.height);
            self.imgPvLeft.frame = CGRectMake(maxX - pvSize.width - self.imgPvLeft.frame.size.width - 1, self.imgPvLeft.frame.origin.y, self.imgPvLeft.frame.size.width, self.imgPvLeft.frame.size.height);
            self.lbPriceLeft.frame = CGRectMake(self.lbPriceLeft.frame.origin.x, self.lbPriceLeft.frame.origin.y, priceSize.width, 18);
        }
    }
    else {
        self.lbLeftGoodName.hidden = YES;
        self.imgLeftImage.hidden = YES;
        self.vBackLeft.hidden = YES;
    }

    if (rightModel) {
        self.lbRightGoodName.hidden = NO;
        self.imgRightImage.hidden = NO;
        [self.imgRightImage setImageWithURL:[NSURL URLWithString:rightModel.strImgUrl] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];

        self.lbRightGoodName.text = rightModel.strItemName;
        // adde by songjk
        self.vBackRight.hidden = NO;
        // adde by songjk
        self.lbPriceRight.text = [NSString stringWithFormat:@"%.2f", rightModel.strPrice.floatValue];
        self.lbPriceRight.textColor = kNavigationBarColor;
        self.lbPvRight.text = [NSString stringWithFormat:@"%.2f", rightModel.strPV.floatValue];
        self.lbPvRight.textColor = kCorlorFromRGBA(0, 143, 215, 1);

        CGFloat y = self.vBackRight.frame.origin.y;
        CGFloat imgWith = self.imgRightImage.image.size.width;
        DDLogDebug(@"imgSize = %f", imgWith);
        CGSize pvSize = [GYUtils sizeForString:self.lbPvRight.text font:[UIFont systemFontOfSize:13] width:100];
        CGSize priceSize = [GYUtils sizeForString:self.lbPriceRight.text font:[UIFont systemFontOfSize:13] width:100];

        // 长度不大于图片长度
        if (self.imgCoinRight.frame.size.width + self.imgPvRight.frame.size.width + pvSize.width + priceSize.width + 2 <= self.imgRightImage.frame.size.width) {
            self.vBackRight.frame = CGRectMake(32, y, self.imgRightImage.frame.size.width, 18);
            self.vBackRight.center = CGPointMake(self.imgRightImage.center.x, self.vBackRight.center.y);
            CGFloat maxX = self.vBackRight.frame.size.width;
            self.lbPvRight.frame = CGRectMake(maxX - pvSize.width, self.lbPvRight.frame.origin.y, pvSize.width, self.lbPvRight.frame.size.height);
            self.imgPvRight.frame = CGRectMake(maxX - pvSize.width - self.imgPvRight.frame.size.width - 1, self.imgPvRight.frame.origin.y, self.imgPvRight.frame.size.width, self.imgPvRight.frame.size.height);
            self.lbPriceRight.frame = CGRectMake(self.lbPriceRight.frame.origin.x, self.lbPriceRight.frame.origin.y, priceSize.width, 18);
        }
        else {
            CGFloat fWidth = self.imgCoinRight.frame.size.width + self.imgPvRight.frame.size.width + pvSize.width + priceSize.width + 2 + 2;
            if (fWidth > kScreenWidth * 0.5 - 10) {
                fWidth = kScreenWidth * 0.5 - 10;
            }
            self.vBackRight.frame = CGRectMake(self.imgRightImage.frame.origin.x, y, fWidth, 18);
            self.vBackRight.center = CGPointMake(self.imgRightImage.center.x, self.vBackRight.center.y);
            CGFloat maxX = self.vBackRight.frame.size.width;
            self.lbPvRight.frame = CGRectMake(maxX - pvSize.width, self.lbPvRight.frame.origin.y, pvSize.width, self.lbPvRight.frame.size.height);
            self.imgPvRight.frame = CGRectMake(maxX - pvSize.width - self.imgPvRight.frame.size.width - 1, self.imgPvRight.frame.origin.y, self.imgPvRight.frame.size.width, self.imgPvRight.frame.size.height);
            self.lbPriceRight.frame = CGRectMake(self.lbPriceRight.frame.origin.x, self.lbPriceRight.frame.origin.y, priceSize.width, 18);
        }
    }
    else {
        self.lbRightGoodName.hidden = YES;
        self.imgRightImage.hidden = YES;
        self.vBackRight.hidden = YES;
    }

//    self.lbRightGoodName.text=rightModel.strItemName;


    // self.lbPoints.text=model.strRightGoodPoints;


}

@end
