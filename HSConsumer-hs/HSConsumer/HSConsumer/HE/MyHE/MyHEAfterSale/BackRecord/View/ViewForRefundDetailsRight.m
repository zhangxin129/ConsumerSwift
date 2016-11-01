//
//  ViewForRefundDetailsRight.m
//  HSConsumer
//
//  Created by liangzm on 15-2-27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewForRefundDetailsRight.h"

@interface ViewForRefundDetailsRight ()

@property (nonatomic, strong) NSArray* dataArry;

@end

@implementation ViewForRefundDetailsRight

- (void)awakeFromNib
{
    [super awakeFromNib];
    _complaintBtn.layer.cornerRadius = 5;
    _complaintBtn.layer.masksToBounds = YES;
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

- (void)setShowTypeIsResult:(BOOL)isResult
{
    [_viewLine0 setBackgroundColor:[UIColor lightGrayColor]];
    [_viewLine1 setBackgroundColor:[UIColor lightGrayColor]];
    UILabel* label;
    for (UIView* v in self.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            label = (UILabel*)v;
            [GYUtils setFontSizeToFitWidthWithLabel:label labelLines:1];
            [label setTextColor:kCellItemTitleColor];
        }
    }
    [_lbRow5 setTextColor:kCorlorFromRGBA(54, 166, 82, 1)];
    [_lbRow5 setFont:[UIFont systemFontOfSize:15]];
    CGRect rect = self.frame;
    if (isResult) { //第三个cell
        if ([_dataArry[2] isEqualToString:@"3"]) { //换货
            _ivTitle.hidden = NO;
            _lbRow3.hidden = NO;
            _viewLine1.hidden = YES;
            _lab1.hidden = YES;
            _lab2.hidden = YES;
            _lab3.hidden = YES;
            _lab4.hidden = YES;
            _lbRow5.hidden = NO;
            self.distanceLine0Top.constant = 5;
        }
        else { //非换货
            _ivTitle.hidden = NO;
            _lbRow3.hidden = NO;
            _viewLine1.hidden = NO;
            _lab1.hidden = NO;
            _lab2.hidden = NO;
            _lab3.hidden = NO;
            _lab4.hidden = NO;
            _lbRow5.hidden = NO;
            self.distanceLine0Top.constant = 49;
        }
    }
    else { //第二个cell
        _ivTitle.hidden = YES;
        _lbRow3.hidden = YES;
        _viewLine1.hidden = YES;
        _lab1.hidden = YES;
        _lab2.hidden = YES;
        _lab3.hidden = YES;
        _lab4.hidden = YES;
        _lbRow5.hidden = YES;
        rect.size.height = 60.f;
    }
    self.frame = rect;
}

- (void)setValues:(NSArray*)arrValues
{
    _dataArry = arrValues;
    [self.complaintBtn addTarget:self action:@selector(complaintClick) forControlEvents:UIControlEventTouchUpInside];
    //    if (arrValues.count < 6)return;
    //arrValues[2] : 1 退货，2 仅退款， 3换货
    NSString* strRefundType = @"";
    if ([arrValues[2] isEqualToString:@"2"]) {
        strRefundType = kLocalized(@"GYHE_MyHE_Refund");
    }
    else if ([arrValues[2] isEqualToString:@"1"]) {
        strRefundType = kLocalized(@"GYHE_MyHE_RetunGoods");
    }
    else if ([arrValues[2] isEqualToString:@"3"]) {
        strRefundType = kLocalized(@"GYHE_MyHE_ChangeGoods");
    }
    if (arrValues.count == 5) { //确认  有2个cell才调用
        if ([arrValues[3] isEqualToString:@"1"]) { //拒绝
            NSString* strConfirmResult = kLocalized(@"GYHE_MyHE_Refuse");
            [_lbRow0 setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_CompanyAlready%@le%@request"), strConfirmResult, strRefundType]];
            _complaintBtn.hidden = NO;
        }
        else { //同意
            [self.complaintBtn removeFromSuperview];
            NSString* strConfirmResult = kLocalized(@"GYHE_MyHE_Agree");
            [_lbRow0 setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_CompanyAlready%@le%@request"), strConfirmResult, strRefundType]];
            _lbRow1.text = [NSString stringWithFormat:kLocalized(@"GYHE_MyHE_requestAlreadyComplete"), strRefundType];
            CGRect rect = _lbRow1.frame;
            rect.size.height += 6; //rect.size.height;
            _lbRow1.frame = rect;
            [GYUtils setFontSizeToFitWidthWithLabel:_lbRow1 labelLines:2];
            self.diatanceLineTop.constant = 5;
        }
    }
    else if (arrValues.count == 8) { //有3个cell才调用
        [self.complaintBtn removeFromSuperview];
        NSString* strRefundResult = kLocalized(@"GYHE_MyHE_StatusUnknown");
        if ([arrValues[3] isEqualToString:@"6"]) { //成功
            strRefundResult = kLocalized(@"GYHE_MyHE_Success");
            _ivTitle.image = kLoadPng(@"gyhe_myhe_select_green");
            NSString* amount = [GYUtils formatCurrencyStyle:[arrValues[4] doubleValue]];
            NSString* pv = [GYUtils formatCurrencyStyle:[arrValues[5] doubleValue]];
            if ([arrValues[2] isEqualToString:@"3"]) { //换货不显示金额、积分
                [_lab1 setText:[NSString stringWithFormat:@"%@:", kLocalized(@"GYHE_MyHE_RefundPrice")]];
                [_lab3 setText:[NSString stringWithFormat:@"%@:", kLocalized(@"GYHE_MyHE_ReturnBusinessPV")]];
                [_lab2 setText:[NSString stringWithFormat:@"0.00"]];
                [_lab4 setText:[NSString stringWithFormat:@"0.00"]];
                [_lab2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
                [_lab4 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
            }
            else {
                if ([arrValues[2] isEqualToString:@"2"]) { //退款
                    [_lab1 setText:[NSString stringWithFormat:@"%@:", kLocalized(@"GYHE_MyHE_RefundPrice")]];
                }
                else if ([arrValues[2] isEqualToString:@"1"]) { //退货
                    [_lab1 setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_BackMoneys")]];
                }
                [_lab3 setText:[NSString stringWithFormat:@"%@:", kLocalized(@"GYHE_MyHE_ReturnBusinessPV")]];
                [_lab2 setText:[NSString stringWithFormat:@"%@", amount]];
                [_lab4 setText:[NSString stringWithFormat:@"%@", pv]];
                [_lab2 setTextColor:[UIColor blackColor]];
                [_lab4 setTextColor:[UIColor blackColor]];
                [_lab2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
                [_lab4 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
            }
        }
        else if ([arrValues[3] isEqualToString:@"7"]) {
            strRefundResult = kLocalized(@"GYHE_MyHE_Faild");
            _ivTitle.image = kLoadPng(@"gyhe_myhe_select_green");
            [_lbRow1 setText:arrValues[6]];
            CGRect rect = _lbRow1.frame;
            rect.size.height += rect.size.height;
            _lbRow1.frame = rect;
            [GYUtils setFontSizeToFitWidthWithLabel:_lbRow1 labelLines:2];
        }
        [_lbRow5 setText:[NSString stringWithFormat:@"%@%@", strRefundType, strRefundResult]];
        [_lbRow5 setTextColor:[UIColor greenColor]];
        CGRect rect = _lbRow0.frame;
        rect.size.width = rect.size.width - CGRectGetMaxX(_ivTitle.frame) - 3;
        rect.origin.x = CGRectGetMaxX(_ivTitle.frame) + 3;
        _lbRow0.frame = rect;

//        [_lbRow3 setText:[NSString stringWithFormat:@"%@编号: %@", strRefundType, arrValues[7]]];
        
        [_lbRow3 setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@Number:%@"), strRefundType, arrValues[7]]];

        
        _lbRow3.font = [UIFont systemFontOfSize:10];
        _lbRow3.textColor = [UIColor colorWithRed:161 / 255.0f green:161 / 255.0f blue:161 / 255.0f alpha:1];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, kDefaultVCBackgroundColor.CGColor); //填充色设置成灰色
    CGContextFillRect(context, self.bounds); //把整个空间用刚设置的颜色填充
    // CGContextSetRGBStrokeColor(context, 100.0f/255.0, 100.0f/255.0, 100.0f/255.0, 1);//画线
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor); //气泡的填充色设置为白色
    CGRect rrect = rect;
    rrect.size.width -= 10;
    CGFloat radius = 6.0; //圆角的弧度
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    CGFloat arrowY = 10; //设置箭头的位置
    // 画一下小箭头
    CGContextMoveToPoint(context, maxx, arrowY - 3);
    CGContextAddLineToPoint(context, maxx + 5, arrowY);
    CGContextAddLineToPoint(context, maxx, arrowY + 3);
    //添加四个角的圆角弧度
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    //结束绘制
    CGContextClosePath(context);//完成整个path
//    CGContextStrokePath(context);//画线
    CGContextFillPath(context);//把整个path内部填充
}

- (void)complaintClick { //跳转投诉页面
    if ([self.delegate respondsToSelector:@selector(complaintBtnClickDelegate)]) {
        [self.delegate complaintBtnClickDelegate];
    }
}

@end
