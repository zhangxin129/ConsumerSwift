//
//  ViewForRefundDetailsLeft.m
//  HSConsumer
//
//  Created by liangzm on 15-2-27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewForRefundDetailsLeft.h"

@interface ViewForRefundDetailsLeft ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* distanceTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* distanceTopLines;
@property (weak, nonatomic) IBOutlet UILabel* instructionLabel;

@end

@implementation ViewForRefundDetailsLeft

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_viewLine0 setBackgroundColor:kCorlorFromRGBA(70, 70, 70, 1)];
    UILabel* label;
    for (UIView* v in self.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            label = (UILabel*)v;
            [label setTextColor:kCellItemTitleColor];
            label.font = [UIFont systemFontOfSize:13];
        }
    }
}

- (void)setValues:(NSArray*)arrValues
{
    // if (arrValues.count < 6)return;
    //arrValues[2] : 1 退货，2 仅退款， 3换货
    NSString* strRefundType = @"";
    if ([arrValues[2] isEqualToString:@"2"]) { //仅退款
        strRefundType = kLocalized(@"GYHE_MyHE_OnlyRefuseReturnMoney");
        [_instructionLabel setText:kLocalized(@"GYHE_MyHE_RefundInstructions")];
        [_createRequestLab setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@ReturnBackRequest"), kLocalized(@"GYHE_MyHE_Create")]];
    }
    else if ([arrValues[2] isEqualToString:@"1"]) { //退货
        strRefundType = kLocalized(@"GYHE_MyHE_RetunGoods");
        [_instructionLabel setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@Instructions:"), strRefundType]];
        [_createRequestLab setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@le%@Request"), kLocalized(@"GYHE_MyHE_Create"), strRefundType]];
    }
    else if ([arrValues[2] isEqualToString:@"3"]) { //换货
        strRefundType = kLocalized(@"GYHE_MyHE_ChangeGoods");
        [_instructionLabel setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@Instructions:"), strRefundType]];
        [_createRequestLab setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@le%@Request"), kLocalized(@"GYHE_MyHE_Create"), strRefundType]];
    }
    if ([arrValues[2] isEqualToString:@"1"]) { //退货
        [_buyerAskLab setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@ReturnMoneyAndPV"), kLocalized(@"GYHE_MyHE_BuyerRequirements")]];
    }
    else {
        [_buyerAskLab setText:[NSString stringWithFormat:@"%@:   %@", kLocalized(@"GYHE_MyHE_BuyerRequirements"), strRefundType]];
    }

    if ([arrValues[2] isEqualToString:@"2"]) { //仅退款 要去掉仅字
        [_backMoneyLab setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_BackMoney%@"), [arrValues[4] doubleValue]]];
        [_backPVLab setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_BackPV%@"), [arrValues[5] doubleValue]]];
    }
    else { //换货，退货
        [_backMoneyLab setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@Money%@"), strRefundType, [GYUtils formatCurrencyStyle:[arrValues[4] doubleValue]]]];
        [_backPVLab setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@PV%@"), strRefundType, [GYUtils formatCurrencyStyle:[arrValues[5] doubleValue]]]];
    }
    [_instructionReasonLab setText:[NSString stringWithFormat:@"%@", arrValues[6]]]; //售后说明原因
    if ([arrValues[2] isEqualToString:@"3"]) { //换货  不显示退货积分，退货金额
        [_buyerAskLab setHidden:NO];
        [_backMoneyLab setHidden:YES];
        [_backPVLab setHidden:YES];
        [_instructionReasonLab setHidden:NO];
        self.distanceTopLine.constant = -40;
        self.distanceTopLines.constant = -40;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, kDefaultVCBackgroundColor.CGColor); //填充色设置成灰色
    CGContextFillRect(context, self.bounds); //把整个空间用刚设置的颜色填充
    CGContextSetFillColorWithColor(context, kCorlorFromRGBA(145, 208, 243, 1).CGColor); //气泡的填充色设置为白色
    CGRect rrect = rect;
    rrect.origin.x = 10;
    rrect.size.width -= 20;
    CGFloat radius = 6.0; //圆角的弧度
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    CGFloat arrowY = 10; //设置箭头的位置
    // 画一下小箭头
    CGContextMoveToPoint(context, minx, arrowY - 3);
    CGContextAddLineToPoint(context, minx - 5, arrowY);
    CGContextAddLineToPoint(context, minx, arrowY + 3);
    //添加四个角的圆角弧度
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    //结束绘制
    CGContextClosePath(context);//完成整个path
    CGContextFillPath(context);//把整个path内部填充
}

@end
