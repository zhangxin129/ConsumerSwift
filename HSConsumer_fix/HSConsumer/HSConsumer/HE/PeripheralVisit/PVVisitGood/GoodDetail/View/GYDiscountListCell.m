//
//  GYDiscountListCell.m
//  HSConsumer
//
//  Created by Apple03 on 15/10/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYDiscountListCell.h"

@interface GYDiscountListCell ()
@property (nonatomic, weak) UIView* vList;
@end

@implementation GYDiscountListCell

- (void)awakeFromNib
{
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView*)tableVeiw
{
    GYDiscountListCell* cell = [tableVeiw dequeueReusableCellWithIdentifier:kGYDiscountListCell];
    if (!cell) {
        cell = [[GYDiscountListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYDiscountListCell];
    }
    [cell setup];
    return cell;
}

- (void)setup
{
    UIView* vList = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    vList.backgroundColor = [UIColor whiteColor];
    self.vList = vList;
    [self.contentView addSubview:self.vList];
}

//-(void)setArryData:(NSArray *)arryData
//{
//    for (UIView * v in self.vList.subviews)
//    {
//        [v removeFromSuperview];
//    }
//    if (arryData.count>0)
//    {
//        _arryData = arryData;
//        for ( int i = 0; i<self.arryData.count; i++)
//        {
//            [self setListWithInfo:self.arryData[i] index:i];
//        }
//    }
//}
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView* v in self.vList.subviews) {
        [v removeFromSuperview];
    }
    if (self.arryData.count > 0) {
        for (int i = 0; i < self.arryData.count; i++) {
            [self setListWithInfo:self.arryData[i] index:i];
        }
    }
}

- (void)setListWithInfo:(NSString*)info index:(NSInteger)index
{
    CGFloat margin = 10;
    CGFloat backH = 20;
    CGFloat backX = 35;
    CGFloat backW = self.frame.size.width - backX;
    CGFloat backY = (20 + margin) * index;
    UIView* vBack = [[UIView alloc] initWithFrame:CGRectMake(backX, backY, backW, backH)];
    vBack.backgroundColor = [UIColor whiteColor];
    [self.vList addSubview:vBack];

    CGFloat lbHeight = 14;
    CGFloat lbY = (backH - lbHeight) * 0.5;

    UILabel* lbNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, lbY, lbHeight, lbHeight)];
    lbNumber.textAlignment = NSTextAlignmentCenter;
    lbNumber.backgroundColor = kNavigationBarColor;
    lbNumber.textColor = [UIColor whiteColor];
    lbNumber.font = kGYDiscountFont;
    lbNumber.text = [NSString stringWithFormat:@"%zi", index + 1];
    [vBack addSubview:lbNumber];

    CGFloat infoX = CGRectGetMaxX(lbNumber.frame) + 2;
    CGFloat infoW = backW - infoX;
    UILabel* lbInfo = [[UILabel alloc] initWithFrame:CGRectMake(infoX, lbY, infoW, lbHeight)];
    lbInfo.textAlignment = NSTextAlignmentLeft;
    lbInfo.backgroundColor = [UIColor clearColor];
    lbInfo.textColor = kDetailGrayColor;
    lbInfo.font = kGYDiscountFont;
    lbInfo.text = info;
    [vBack addSubview:lbInfo];
    CGRect frame = self.vList.frame;
    frame.size.height = CGRectGetMaxY(vBack.frame);
    self.vList.frame = frame;
}

@end
