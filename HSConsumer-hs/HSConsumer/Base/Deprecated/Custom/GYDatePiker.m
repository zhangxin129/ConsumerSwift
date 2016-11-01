//
//  GYDatePiker.m
//  Buding
//
//  Created by 00 on 14-11-3.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import "GYDatePiker.h"

@implementation GYDatePiker {
    UIDatePicker* globelDp;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize screenSize = CGSizeMake(kScreenWidth, kScreenHeight);
        self.frame = CGRectMake(0, -350, screenSize.width, screenSize.height + 350);
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePiker:)];
        [self addGestureRecognizer:tap];

        UIDatePicker* dp = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenSize.width + 100, kScreenWidth, 100)];
        dp.alpha = 1.0;
        dp.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0f];
        dp.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];
        dp.minimumDate = [NSDate dateWithTimeIntervalSinceNow:5 * 365 * 24 * 60 * 60 * -1]; // 设置最小时间
        dp.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0]; // 设置最大时间
        dp.datePickerMode = UIDatePickerModeDate;
        [dp setDate:[NSDate dateWithTimeIntervalSinceNow:48 * 20 * 18] animated:YES];
        [dp addTarget:self action:@selector(DatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:dp];
        self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.1];

        self.selectDate = [NSDate date];
        if (_delegate && [_delegate respondsToSelector:@selector(getDate:WithDate:)]) {
            NSString* strDate = [self formateDate:self.selectDate];
            [self.delegate getDate:strDate WithDate:self.selectDate];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame date:(NSDate*)date
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectDate = [NSDate date];
        if (date) {
            self.selectDate = date;
        }

        CGSize screenSize = CGSizeMake(kScreenWidth, kScreenHeight);
        
        self.frame = CGRectMake(0, -350, screenSize.width, screenSize.height + 350);

        UIDatePicker* dp = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenSize.width+100, kScreenWidth, 100)];
        
        
        dp.alpha = 1.0;
        dp.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0f];
        dp.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];
        //        dp.minimumDate = [NSDate dateWithTimeIntervalSinceNow:5 * 365 * 24 * 60 * 60 * -1]; // 设置最小时间
        dp.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0]; // 设置最大时间
        dp.datePickerMode = UIDatePickerModeDate;
        [dp setDate:self.selectDate];
        [dp addTarget:self action:@selector(DatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        globelDp = dp;
        [self addSubview:dp];

        self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.1];
        NSArray* title = @[ kLocalized(@"GYHS_Base_cancel"), kLocalized(@"GYHS_Base_confirm") ];
        for (NSInteger i = 0; i < 2; i++) {


            UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(i* kScreenWidth/ 2 , CGRectGetMaxY(dp.frame),kScreenWidth / 2, 40)];
            [confirmBtn setTitle:title[i] forState:UIControlStateNormal];
            [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            confirmBtn.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0f];
            confirmBtn.tag = i + 10;

            if (i == 1) {

                [confirmBtn addLeftBorderWithBorderWidth:1 andBorderColor:[UIColor blackColor]];

                if (_delegate && [_delegate respondsToSelector:@selector(getDate:WithDate:)]) {
                    NSString* strDate = [self formateDate:self.selectDate];
                    [self.delegate getDate:strDate WithDate:self.selectDate];
                }
            }
            [confirmBtn addTarget:self action:@selector(dismissDatePiker:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:confirmBtn];
        }
    }
    return self;
}

- (void)noMaxTime
{
    globelDp.maximumDate = nil;
}

- (void)DatePickerValueChanged:(UIDatePicker*)sender
{
    self.selectDate = [sender date]; // 获取被选中的时间
    if (_delegate && [_delegate respondsToSelector:@selector(getDate:WithDate:)]) {
        NSString* strDate = [self formateDate:self.selectDate];
        [self.delegate getDate:strDate WithDate:self.selectDate];
    }
}

- (NSString*)formateDate:(NSDate*)date
{
    NSDateFormatter* selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd";
    return [selectDateFormatter stringFromDate:date];
}

- (void)dismissDatePiker:(UIButton*)btn
{
    if (btn.tag == 11) {
        if (_delegate && [_delegate respondsToSelector:@selector(getDate:WithDate:)]) {
            NSString* strDate = [self formateDate:self.selectDate];
            [self.delegate getDate:strDate WithDate:self.selectDate];
        }
    }

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + 100);
    //动画
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+350, self.frame.size.width, self.frame.size.height);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
