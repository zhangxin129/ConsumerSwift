//
//  GYSurroundGoodsListDetailCell.m
//  GYHSConsumer_SurroundVisit
//
//  Created by apple on 16/3/22.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurroundGoodsListDetailCell.h"
#import "UIView+CustomBorder.h"

@interface GYSurroundGoodsListDetailCell ()

//设置图片
@property (weak, nonatomic) IBOutlet UIImageView* coinImgView;
@property (weak, nonatomic) IBOutlet UIImageView* pvImgView;
@property (weak, nonatomic) IBOutlet UIImageView* phoneImgView;
//需请求数据
@property (weak, nonatomic) IBOutlet UIImageView* goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* sellCountLabel;
@property (weak, nonatomic) IBOutlet UILabel* priceLabel;
@property (weak, nonatomic) IBOutlet UILabel* pvLabel;
@property (weak, nonatomic) IBOutlet UILabel* factoryLabel;
@property (weak, nonatomic) IBOutlet UIView* typeView;

@end

@implementation GYSurroundGoodsListDetailCell

- (void)awakeFromNib
{
    _phoneImgView.image = [UIImage imageNamed:@"gycommon_btn_phone"];
    _pvImgView.image = [UIImage imageNamed:@"gyhe_food_pv"];
    _coinImgView.image = [UIImage imageNamed:@"gycommon_hscoin"];
    [self.contentView addBottomBorder];
}

- (void)refreshUI:(GYSurroundGoodsModel*)model
{

    [self.goodsImgView setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];

    NSString* strGoodName = model.itemName;
    if (!strGoodName || [strGoodName isEqualToString:@""]) {
        strGoodName = kLocalized(@"GYHE_SurroundVisit_Goods");
    }

    self.sellCountLabel.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHE_SurroundVisit_TotalSalesZero"), model.salesCount];
    self.nameLabel.text = [NSString stringWithFormat:@"%@", strGoodName]; // 改为显商品名称
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", model.price.doubleValue];
    self.pvLabel.text = [NSString stringWithFormat:@"%.2f", model.pv.doubleValue];
    self.factoryLabel.text = [NSString stringWithFormat:@"%@", model.factoryName]; //品牌

    //设置“卷”，“即”，“卖”，“现”，“提”
    NSArray* arrData = [NSArray arrayWithObjects:
                                    model.beTicket,
                                model.beReach,
                                model.beSell,
                                model.beCash,
                                model.beTake,
                                nil];
    NSArray* imageNames = @[ @"gyhe_good_detail5", @"gyhe_good_detail1", @"gyhe_good_detail2", @"gyhe_good_detail3", @"gyhe_good_detail4" ];
    CGFloat width = 15;
    for (UIView* view in self.typeView.subviews) {
        [view removeFromSuperview];
    }

    NSInteger index = arrData.count;
    CGFloat border = 2;
    for (NSInteger i = 0, j = 0; i < index; i++) {
        UIImageView* imageView = [[UIImageView alloc] init];
        
        if(arrData.count > i) {
            if ([arrData[i] isEqualToString:@"1"]) {
                CGFloat imgX = (i - j) * (width + border);
                imageView.frame = CGRectMake(imgX, 0, width, width);
                if(imageNames.count > i)
                    imageView.image = [UIImage imageNamed:imageNames[i]];
                [self.typeView addSubview:imageView];
            }
            else {
                j++;
            }
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

@end
