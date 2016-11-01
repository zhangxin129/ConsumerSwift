//
//  UITextField+GYHSPointTextField.m
//  HSCompanyPad
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "UITextField+GYHSPointTextField.h"
#import "GYHSPublicMethod.h"
#import "GYHSEdgeLabel.h"
#import <objc/runtime.h>
#import <GYKit/CALayer+Transition.h>
#define kShowTime 2.5
static const char associatedLabelKey;

@implementation UITextField (GYHSPointTextField)

#pragma mark - 输入金额格式化（如1,000）
- (NSString*)inputEditField
{
    self.text = [self.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSRange rangePoint = [self.text rangeOfString:@"."];
    if (rangePoint.location != NSNotFound) {
        NSString* strdecimal = [self.text substringFromIndex:rangePoint.location + 1];
        if (rangePoint.location == 0) {
            self.text = [NSString stringWithFormat:@"%@%@", @"0", self.text];
        }
        if ([strdecimal rangeOfString:@"."].location != NSNotFound) {
            self.text = [self.text substringToIndex:self.text.length - 1];
        } else if (strdecimal.length > 2) {
            self.text = [self.text substringToIndex:self.text.length - 1];
        }
    }
    if (self.text.length > 10) {
        self.text = [self.text substringToIndex:10];
        [self tipWithContent:@"输入金额不能超过10位数" animated:YES];
    }
    return [self formatCurrencyStyle:self.text];
}

- (NSString*)formatCurrencyStyle:(NSString*)string
{
    if (string == nil || string.length == 0) {
        return @"";
    }
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,###"];
    
    NSString* formattedNumberString = [numberFormatter stringFromNumber:[NSDecimalNumber numberWithLongLong:string.longLongValue]];
    //补上输入的小数位
    NSRange rangePoint = [string rangeOfString:@"."];
    if (rangePoint.location != NSNotFound) {
        formattedNumberString = [NSString stringWithFormat:@"%@%@", formattedNumberString, [string substringFromIndex:rangePoint.location]];
    }
    return formattedNumberString;
}

#pragma mark - 输入整数金额格式化（如1,000）
- (NSString*)inputIntegerField
{
    self.text = [self.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSRange rangePoint = [self.text rangeOfString:@"."];
    if (rangePoint.location != NSNotFound) {
        self.text = [self.text substringToIndex:self.text.length - 1];
    }
    if (self.text.length > 10) {
        self.text = [self.text substringToIndex:10];
        [self tipWithContent:@"输入金额不能超过10位整数" animated:YES];

    }
    return [self formatCurrencyStyle:self.text];
}
#pragma mark -不可编辑输入框格式化保留两位小数
+ (NSString*)keepTwoDeciaml:(NSString*)string
{
    if (string == nil || string.length == 0) {
        return @"";
    }
    string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0.00"];
    
    NSString* formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:string.doubleValue]];
    
    return formattedNumberString;
}

#pragma mark - 去除格式化的金额（如1,000转1000）
- (NSString*)deleteFormString
{
    return [self.text stringByReplacingOccurrencesOfString:@"," withString:@""];
}

#pragma mark -  输入互生卡的格式化（如06 032 12 0000）
- (NSString*)inputCardField
{
    self.text = [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //去除“.”
    NSRange rangePoint = [self.text rangeOfString:@"."];
    if (rangePoint.location != NSNotFound) {
        self.text = [self.text substringToIndex:self.text.length - 1];
    }
    if (self.text.length >= 11) {
        self.text = [self.text substringToIndex:11];
        if (![GYUtils isHSCardNo:self.text]) {
            [self tipWithContent:@"输入卡号有误，请重新输入" animated:YES];
        }
    }
    NSInteger length = self.text.length;
    if (length > 2 && length < 6) {
        NSString* cardNo1 = [self.text substringWithRange:NSMakeRange(0, 2)];
        NSString* cardNo2 = [self.text substringWithRange:NSMakeRange(2, length - 2)];
        return [NSString stringWithFormat:@"%@ %@", cardNo1, cardNo2];
    }
    
    if (length >= 6 && length < 8) {
        NSString* cardNo1 = [self.text substringWithRange:NSMakeRange(0, 2)];
        NSString* cardNo2 = [self.text substringWithRange:NSMakeRange(2, 3)];
        NSString* cardNo3 = [self.text substringWithRange:NSMakeRange(5, length - 5)];
        return [NSString stringWithFormat:@"%@ %@ %@", cardNo1, cardNo2, cardNo3];
    }
    if (length >= 8) {
        NSString* cardNo1 = [self.text substringWithRange:NSMakeRange(0, 2)];
        NSString* cardNo2 = [self.text substringWithRange:NSMakeRange(2, 3)];
        NSString* cardNo3 = [self.text substringWithRange:NSMakeRange(5, 2)];
        NSString* cardNo4 = [self.text substringWithRange:NSMakeRange(7, length - 7)];
        return [NSString stringWithFormat:@"%@ %@ %@ %@", cardNo1, cardNo2, cardNo3, cardNo4];
    }
    return self.text;
}

#pragma mark - 移除空格
- (NSString*)deleteSpaceField
{
    NSString* str;
    str = [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}

#pragma mark - 交易密码限制8位数
- (NSString*)subPassField
{
    //去除“.”
    NSRange rangePoint = [self.text rangeOfString:@"."];
    if (rangePoint.location != NSNotFound) {
        self.text = [self.text substringToIndex:self.text.length - 1];
    }
    if (self.text.length > 8) {
        self.text = [self.text substringToIndex:8];
        [self tipWithContent:@"交易密码为8位数" animated:YES];
    }
    return self.text;
}

#pragma mark - 登录密码6位数
- (NSString*)subLoginField
{
    //去除“.”
    NSRange rangePoint = [self.text rangeOfString:@"."];
    if (rangePoint.location != NSNotFound) {
        self.text = [self.text substringToIndex:self.text.length - 1];
    }
    if (self.text.length > 6) {
        self.text = [self.text substringToIndex:6];
        [self tipWithContent:@"登录密码为6位数" animated:YES];

    }
    return self.text;
}
#pragma mark - 金额
- (NSString*)moneyField
{
    return self.text;
}


#pragma mark - 截取UITextField的text的长度
- (NSString*)subTextToLength:(NSInteger)length
{
    NSRange rangePoint = [self.text rangeOfString:@"." options:NSCaseInsensitiveSearch];
    if (rangePoint.location != NSNotFound) {
        NSString* strdecimal = [self.text substringFromIndex:rangePoint.location + 1];
        if (rangePoint.location == 0) {
            self.text = [NSString stringWithFormat:@"%@%@", @"0", self.text];
        }
        if ([strdecimal rangeOfString:@"."].location != NSNotFound) {
            self.text = [self.text substringToIndex:self.text.length - 1];
        } else if (strdecimal.length > length - 2) {
            self.text = [self.text substringToIndex:self.text.length - 1];
        }
    } else {
        if (self.text.length > length) {
            self.text = [self.text substringToIndex:length];
        }
    }
    return self.text;
}

#pragma mark - 输入有误提示内容
- (void)tipWithContent:(NSString *)content animated:(BOOL)animated
{
    //获取上次出现的视图
    GYHSEdgeLabel * lastLabel = objc_getAssociatedObject(self, &associatedLabelKey);
    //获得父视图
    UIView * view = [self superview];
    if (lastLabel) {
        return;
    }
    UIViewController * controller = [GYHSPublicMethod viewControllerWithView:self];
    NSLog(@"控制器名称------%@",[controller class]);
    CGFloat edgeFloat = 8;
    CGFloat fieldWidth = self.width/2 > 80 ? self.width/2:self.width;
    GYHSEdgeLabel * label = [[GYHSEdgeLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.frame) + self.width/2, CGRectGetMaxY(self.frame),fieldWidth, 40)];    label.text = content;
    label.edgeInsets = UIEdgeInsetsMake(edgeFloat, edgeFloat, edgeFloat, edgeFloat);
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.numberOfLines = 0;
    label.backgroundColor = kRedE50012;
    label.layer.cornerRadius = 6;
    label.clipsToBounds = YES;
    label.textColor = [UIColor whiteColor];
    CGSize labSize = [label.text boundingRectWithSize:CGSizeMake(label.width , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font, NSFontAttributeName, nil] context:nil].size;
    [label sizeToFit];
    labSize.width = fieldWidth;//宽度保存不变
    labSize.height = labSize.height < label.height?label.height:labSize.height;
    label.size = labSize;
    //记录显示的视图
    objc_setAssociatedObject(self, &associatedLabelKey, label,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [controller.view addSubview:label];
    CGRect rect = [view convertRect:label.frame toView:controller.view];
    if (CGRectGetMaxY(rect) < controller.view.height) {
        //显示在输入框下面
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(self.height);
            make.right.mas_equalTo(self.mas_right);
            make.size.mas_equalTo(labSize);
        }];
    }else {
        //提示内容超出屏幕范围,提示位置改为输入框上面
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-self.height);
            make.right.mas_equalTo(self.mas_right);
            make.size.mas_equalTo(labSize);
        }];
        
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if (animated) {
            [label.layer shakeAnimation];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kShowTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [label removeFromSuperview];
                objc_setAssociatedObject(self, &associatedLabelKey, nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kShowTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [label removeFromSuperview];
                objc_setAssociatedObject(self, &associatedLabelKey, nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);

            });

        }

    });
}


@end
