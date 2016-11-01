//
//  GYAroundGoodsListCell.m
//  HSConsumer
//
//  Created by Apple03 on 15/11/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAroundGoodsListCell.h"
#import "SearchGoodModel.h"

#define KDetailFont [UIFont systemFontOfSize:13]
#define KTitleFont [UIFont systemFontOfSize:15]

// 积分字体颜色
#define KPointNumColor kCorlorFromRGBA(0, 143, 215, 1)

@interface GYAroundGoodsListCell ()
@property (weak, nonatomic) IBOutlet UILabel* lbGoodName;
@property (weak, nonatomic) IBOutlet UILabel* lbMonthSale;
@property (weak, nonatomic) IBOutlet UILabel* lbConpanyName;
@property (weak, nonatomic) IBOutlet UILabel* lbDistance;
@property (weak, nonatomic) IBOutlet UIButton* btnCall;
@property (weak, nonatomic) IBOutlet UILabel* lbPoint;
@property (weak, nonatomic) IBOutlet UILabel* lbPrice;

@property (weak, nonatomic) IBOutlet UIImageView* imgGood;
@property (weak, nonatomic) IBOutlet UIView* vSpecial;

@end

@implementation GYAroundGoodsListCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.lbGoodName.textColor = kCellItemTitleColor;
    self.lbConpanyName.textColor = kCellItemTextColor;
    self.lbPrice.textColor = kNavigationBarColor;
    self.lbPoint.textColor = KPointNumColor;
    self.lbDistance.textColor = kCellItemTextColor;

    self.lbMonthSale.textColor = kCellItemTextColor;

    self.lbGoodName.font = KTitleFont;
    self.lbConpanyName.font = KDetailFont;
    self.lbPrice.font = KTitleFont;
    self.lbPoint.font = KDetailFont;
    //    lbLocationDistance.font = KDetailFont;
    self.lbMonthSale.font = KDetailFont;
}

+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    GYAroundGoodsListCell* cell = [tableView dequeueReusableCellWithIdentifier:KGYAroundGoodsListCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GYAroundGoodsListCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)seCellWithModel:(SearchGoodModel*)model
{
    if (model.shopUrl.length > 0) {
        [self.imgGood setImageWithURL:[NSURL URLWithString:model.shopUrl] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder.png"] options:kNilOptions completion:nil];
    }
    NSString* strGoodName = model.name;
    if (!strGoodName || [strGoodName isEqualToString:@""]) {
        strGoodName = kLocalized(@"GYHE_SurroundVisit_Goods");
    }
    // modify by songjk
    self.lbMonthSale.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHE_SurroundVisit_TotalSales"), model.saleCount];
    self.lbGoodName.text = [NSString stringWithFormat:@"%@", strGoodName]; // modify by songjk 改为显商品名称
    self.lbPrice.text = [NSString stringWithFormat:@"%@", model.price];
    self.lbPoint.text = [NSString stringWithFormat:@"%@", model.goodsPv];
    self.lbConpanyName.text = [NSString stringWithFormat:@"%@", model.factoryName]; // modify by songjk 改为产地
    //    [self.btnShopTel setTitle:model.shopTel forState:UIControlStateNormal];
    //    self.lbDistance.text = [NSString stringWithFormat:@"%.1fkm",model.shopDistance.floatValue];
    [self setTopIconWithModel:model];
}

- (void)setTopIconWithModel:(SearchGoodModel*)model
{
    //add by zhnagqy  iOS消费者--轻松购--商品展示列表中特色服务排列建议与安卓（UI）一致
    NSArray* arrData = [NSArray arrayWithObjects:
                                    model.beTicket,
                                model.beReach,
                                model.beSell,
                                model.beCash,
                                model.beTake,
                                nil];
    NSArray* imageNames = @[ @"gyhe_good_detail5", @"gyhe_good_detail1", @"gyhe_good_detail2", @"gyhe_good_detail3", @"gyhe_good_detail4" ];
    CGFloat iconWith = 15;
    for (UIView* view in self.vSpecial.subviews) {
        [view removeFromSuperview];
    }

    NSInteger index = arrData.count;
    CGFloat border = 2;
    for (NSInteger i = 0, j = 0; i < index; i++) {
        UIImageView* imageView = [[UIImageView alloc] init];

        if(arrData.count > i) {
            if ([arrData[i] isEqualToString:@"1"]) {
                CGFloat imgX = (i - j) * (iconWith + border);
                imageView.frame = CGRectMake(imgX, 0, iconWith, iconWith);
                if(imageNames.count > i)
                    imageView.image = [UIImage imageNamed:imageNames[i]];
                [self.vSpecial addSubview:imageView];
            }
            else {
                j++;
            }
        }
        
    }
}

- (IBAction)callClick
{
    if ([self.delegate respondsToSelector:@selector(AroundGoodsListCellDidCallWithIndexPath:)]) {
        [self.delegate AroundGoodsListCellDidCallWithIndexPath:self.indexPath];
    }
}

@end
