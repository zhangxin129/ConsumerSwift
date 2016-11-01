//
//  GYDatePickView.m
//  HSCompanyPad
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYDatePickView.h"

@interface GYDatePickView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIImageView* lineImageView;
@property (nonatomic, strong) UILabel* todayShowLabel;
@property (nonatomic, strong) UIPickerView* datePickUpView;
@property (nonatomic, weak) UIImageView* underlyingImageView;
@property (nonatomic, weak) UIViewController* vc;
@property (nonatomic, assign) DatePickViewType type;

@property (nonatomic, strong) NSMutableArray *yearArray, *monthArray, *dayArray, *hourArray, *minuteArray;
@end

@implementation GYDatePickView

- (NSMutableArray*)yearArray
{
    if (!_yearArray) {
        _yearArray = [[NSMutableArray alloc] init];
        for (int i = 1900; i < 3000; i++) {
            NSString* year = [NSString stringWithFormat:@"%d", i];
            [_yearArray addObject:year];
        }
    }
    return _yearArray;
}
- (NSMutableArray*)monthArray
{
    if (!_monthArray) {
        _monthArray = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 12; i++) {
            NSString* year = [NSString stringWithFormat:@"%d", i];
            [_monthArray addObject:year];
        }
    }
    return _monthArray;
}

- (NSMutableArray*)dayArray
{
    if (!_dayArray) {
        _dayArray = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 31; i++) {
            NSString* year = [NSString stringWithFormat:@"%d", i];
            [_dayArray addObject:year];
        }
    }
    return _dayArray;
}

- (NSMutableArray*)hourArray
{
    if (!_hourArray) {
        _hourArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 24; i++) {
            NSString* year = [NSString stringWithFormat:@"%d", i];
            [_hourArray addObject:year];
        }
    }
    return _hourArray;
}

- (NSMutableArray*)minuteArray
{
    if (!_minuteArray) {
        _minuteArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 60; i++) {
            NSString* year = [NSString stringWithFormat:@"%d", i];
            [_minuteArray addObject:year];
        }
    }
    return _minuteArray;
}

- (instancetype)initWithDatePickViewType:(DatePickViewType)type
{
    CGRect rect;
    if (type == DatePickViewTypeYear) {
        rect = CGRectMake(0, 0, 160, 222);
    } else if (type == DatePickViewTypeDate) {
        rect = CGRectMake(0, 0, 285, 222);
    } else {
        rect = CGRectMake(0, 0, 385, 222);
    }
    self = [super initWithFrame:rect];
    if (self) {
        self.type = type;
        self.backgroundColor = [UIColor whiteColor];
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25].CGColor;
    self.layer.shadowRadius = 20;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(0, 10);
    
    UIImageView* backImageView = [[UIImageView alloc] init];
    backImageView.backgroundColor = kBlue0A59C2;
    [self addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.equalTo(self);
        make.height.equalTo(@40);
        make.right.equalTo(self.mas_right).offset(-75);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = kFont32;
    [backImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(backImageView.mas_centerY);
        make.left.equalTo(@10);
        make.height.equalTo(@30);
        make.width.lessThanOrEqualTo(@150);
    }];
    
    if (self.type == DatePickViewTypeDate || self.type == DatePickViewTypeDateAndTime) {
        
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_line"]];
        [backImageView addSubview:_lineImageView];
        [_lineImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(_titleLabel.mas_right).offset(10);
            make.width.equalTo(@1);
            make.height.equalTo(@10);
            make.centerY.equalTo(_titleLabel.mas_centerY);
        }];
        
        _todayShowLabel = [[UILabel alloc] init];
        _todayShowLabel.text = kLocalized(@"今天");
        _todayShowLabel.textColor = [UIColor whiteColor];
        _todayShowLabel.font = kFont32;
        [backImageView addSubview:_todayShowLabel];
        [_todayShowLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(_lineImageView.mas_right).offset(10);
            make.height.equalTo(@30);
            make.centerY.equalTo(_lineImageView.mas_centerY);
            make.width.greaterThanOrEqualTo(@70);
        }];
    }
    
    UIButton* comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [comfirmButton setTitle:kLocalized(@"确定") forState:UIControlStateNormal];
    comfirmButton.titleLabel.font = kFont36;
    [comfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfirmButton addTarget:self action:@selector(comfirmAction) forControlEvents:UIControlEventTouchUpInside];
    comfirmButton.backgroundColor = kRedE50012;
    [self addSubview:comfirmButton];
    [comfirmButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.right.equalTo(self);
        make.height.equalTo(@40);
        make.width.equalTo(@75);
    }];
    
    _datePickUpView = [[UIPickerView alloc] init];
    _datePickUpView.backgroundColor = [UIColor whiteColor];
    _datePickUpView.alpha = 1;
    _datePickUpView.delegate = self;
    _datePickUpView.dataSource = self;
    _datePickUpView.showsSelectionIndicator = YES;
    [self addSubview:_datePickUpView];
    [_datePickUpView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(10);
        make.top.equalTo(backImageView.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    
    [self initViewDate];
}

- (void)hideToday:(BOOL)hide
{
    if (hide) {
        _todayShowLabel.hidden = YES;
        _lineImageView.hidden = YES;
    } else {
        _todayShowLabel.hidden = NO;
        _lineImageView.hidden = NO;
    }
}

- (void)initViewDate
{
    NSDateComponents* dateComponent = [self getCurrentDateComponents];
    [self setData:self.yearArray component:0 curruent:dateComponent.year];
    if (self.type == DatePickViewTypeDate || self.type == DatePickViewTypeDateAndTime) {
        [self setData:self.monthArray component:1 curruent:dateComponent.month];
        [self setData:self.dayArray component:2 curruent:dateComponent.day];
        if (self.type == DatePickViewTypeDateAndTime) {
            [self setData:self.hourArray component:3 curruent:dateComponent.hour];
            [self setData:self.minuteArray component:4 curruent:dateComponent.minute];
        }
        
        _titleLabel.text = [NSString stringWithFormat:@"%d年%d月%d日", dateComponent.year, dateComponent.month, dateComponent.day];
    } else {
        _titleLabel.text = [NSString stringWithFormat:@"%d年", dateComponent.year];
    }
}

- (void)setData:(NSMutableArray*)array component:(NSInteger)component curruent:(NSInteger)dateComponents
{
    
    for (NSString* year in array) {
        if (year.integerValue == dateComponents) {
            [_datePickUpView selectRow:[array indexOfObject:year] inComponent:component animated:YES];
        }
    }
}

- (void)comfirmAction
{
    NSInteger yearRow, monthRow, dayRow, hourRow, minuteRow;
    NSString* dateString;
    yearRow = [_datePickUpView selectedRowInComponent:0];
    
    if (self.type == DatePickViewTypeDateAndTime || self.type == DatePickViewTypeDate) {
        monthRow = [_datePickUpView selectedRowInComponent:1];
        
        dayRow = [_datePickUpView selectedRowInComponent:2];
        
        //4,6,9,11,12月份只有30天
        if (monthRow == 3 || monthRow == 5 || monthRow == 8 || monthRow == 10) {
            
            if (dayRow >= 29) {
                //选择大于等于实际最后一天的时候，显示实际最后一天
                dayRow = 29;
            }
            
        }
        
        else if (monthRow == 1) {
            //2月份判断是否闰年
            //判断闰年
            if (([self.yearArray[yearRow] integerValue] % 4 == 0 && [self.yearArray[yearRow] integerValue] % 100 != 0) || [self.yearArray[yearRow] integerValue] % 400 == 0) {
                
                if (dayRow >= 28) {
                    dayRow = 28; //闰年,29天
                }
                
            } else {
                
                if (dayRow >= 27) {
                    dayRow = 27; //非闰年,28天
                }
            }
        }
        
        if (self.type == DatePickViewTypeDateAndTime) {
            hourRow = [_datePickUpView selectedRowInComponent:3];
            minuteRow = [_datePickUpView selectedRowInComponent:4];
            
            NSString* month = [self formatNumber:self.monthArray[monthRow]];
            NSString* day = [self formatNumber:self.dayArray[dayRow]];
            NSString* hour = [self formatNumber:self.hourArray[hourRow]];
            NSString* minute = [self formatNumber:self.minuteArray[minuteRow]];
            dateString = [NSString stringWithFormat:@"%@-%@-%@-%@-%@", self.yearArray[yearRow], month, day, hour, minute];
        } else {
            NSString* month = [self formatNumber:self.monthArray[monthRow]];
            NSString* day = [self formatNumber:self.dayArray[dayRow]];
            dateString = [NSString stringWithFormat:@"%@-%@-%@", self.yearArray[yearRow], month, day];
        }
    } else {
        dateString = [NSString stringWithFormat:@"%@", self.yearArray[yearRow]];
    }
    
    if (_dateBlcok) {
        _dateBlcok(dateString);
    }
    [self disMiss];
}

- (NSString*)formatNumber:(NSString*)num
{
    NSString* string;
    if ([num integerValue] < 10) {
        string = [NSString stringWithFormat:@"0%@", num];
    } else {
        string = num;
    }
    return string;
}

- (NSDateComponents*)getCurrentDateComponents
{
    NSDateComponents* dateCompoents = [[NSCalendar currentCalendar] components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute fromDate:[NSDate date]];
    return dateCompoents;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    if (self.type == DatePickViewTypeDateAndTime) {
        return 5;
    } else if (self.type == DatePickViewTypeYear) {
        return 1;
    } else {
        return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearArray.count;
    } else if (component == 1) {
        return self.monthArray.count;
    } else if (component == 2) {
        return self.dayArray.count;
    } else if (component == 3) {
        return self.hourArray.count;
    } else {
        return self.minuteArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component
{
    if (self.type == DatePickViewTypeYear) {
        return 140.0f;
    } else if (self.type == DatePickViewTypeDate) {
        return 85.0f;
    } else {
        if (component == 0) {
            return 85.0f;
        } else {
            return 65.0f;
        }
    }
}

- (CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component
{
    return 43.4;
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.type != DatePickViewTypeYear) {
        if (component == 0) {
            ;
            if (([self.yearArray[row] integerValue] % 4 == 0 && [self.yearArray[row] integerValue] % 100 != 0) || [self.yearArray[row] integerValue] % 400 == 0) {
                if ([pickerView selectedRowInComponent:1]) {
                    if (([pickerView selectedRowInComponent:2] == 30 || [pickerView selectedRowInComponent:2] == 29)) {
                        [pickerView selectRow:28 inComponent:2 animated:YES];
                    }
                }
            } else {
                if ([pickerView selectedRowInComponent:1]) {
                    if ([pickerView selectedRowInComponent:1] == 1 && ([pickerView selectedRowInComponent:2] == 30 || [pickerView selectedRowInComponent:2] == 29 || [pickerView selectedRowInComponent:2] == 28)) {
                        [pickerView selectRow:27 inComponent:2 animated:YES];
                    }
                }
            }
        } else if (component == 1) {
            switch (row) {
                case 1: {
                    NSInteger theRow = [pickerView selectedRowInComponent:0];
                    if (([self.yearArray[theRow] integerValue] % 4 == 0 && [self.yearArray[theRow] integerValue] % 100 != 0) || [self.yearArray[theRow] integerValue] % 400 == 0) {
                        if ([pickerView selectedRowInComponent:2] == 30 || [pickerView selectedRowInComponent:2] == 29) {
                            [pickerView selectRow:28 inComponent:2 animated:YES];
                        }
                    } else {
                        if ([pickerView selectedRowInComponent:2] == 30 || [pickerView selectedRowInComponent:2] == 29 || [pickerView selectedRowInComponent:2] == 28) {
                            [pickerView selectRow:27 inComponent:2 animated:YES];
                        }
                    }
                    
                } break;
                    
                case 3:
                case 5:
                case 8:
                case 10: {
                    if ([pickerView selectedRowInComponent:2] == 30) {
                        [pickerView selectRow:29 inComponent:2 animated:YES];
                    }
                } break;
                    
                default:
                    break;
            }
        } else if (component == 2) {
            switch ([pickerView selectedRowInComponent:1]) {
                case 3:
                case 5:
                case 8:
                case 10: {
                    if ([pickerView selectedRowInComponent:component] == 30) {
                        [pickerView selectRow:29 inComponent:component animated:YES];
                    }
                } break;
                case 1: {
                    NSInteger theRow = [pickerView selectedRowInComponent:0];
                    if (([self.yearArray[theRow] integerValue] % 4 == 0 && [self.yearArray[theRow] integerValue] % 100 != 0) || [self.yearArray[theRow] integerValue] % 400 == 0) {
                        if ([pickerView selectedRowInComponent:2] == 30 || [pickerView selectedRowInComponent:2] == 29) {
                            [pickerView selectRow:28 inComponent:2 animated:YES];
                            
                            // curDayString = self.dayArray[28];
                        }
                    } else {
                        if ([pickerView selectedRowInComponent:2] == 30 || [pickerView selectedRowInComponent:2] == 29 || [pickerView selectedRowInComponent:2] == 28) {
                            [pickerView selectRow:27 inComponent:2 animated:YES];
                        }
                    }
                } break;
                    
                default:
                    break;
            }
        }
        
        NSInteger yearRow = [pickerView selectedRowInComponent:0];
        NSInteger monthRow = [pickerView selectedRowInComponent:1];
        NSInteger dayRow = [pickerView selectedRowInComponent:2];
        NSDateComponents* dateComponents = [self getCurrentDateComponents];
        if ([self.yearArray[yearRow] integerValue] == dateComponents.year && [self.monthArray[monthRow] integerValue] == dateComponents.month && [self.dayArray[dayRow] integerValue] == dateComponents.day) {
            [self hideToday:NO];
        } else {
            [self hideToday:YES];
        }
        _titleLabel.text = [NSString stringWithFormat:@"%@年%@月%@日", self.yearArray[yearRow], self.monthArray[monthRow], self.dayArray[dayRow]];
    } else {
        NSInteger yearRow = [pickerView selectedRowInComponent:0];
        _titleLabel.text = [NSString stringWithFormat:@"%@年", self.yearArray[yearRow]];
    }
}

- (nullable NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearArray[row];
    } else if (component == 1) {
        return self.monthArray[row];
    } else if (component == 2) {
        return self.dayArray[row];
        ;
    } else if (component == 3) {
        return self.hourArray[row];
        ;
    } else {
        return self.minuteArray[row];
        ;
    }
}

- (void)show
{
    UIViewController* fatherVC = [self appRootViewController];
    UIImageView* backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backImageView.userInteractionEnabled = YES;
    backImageView.backgroundColor = [UIColor clearColor];
    backImageView.alpha = 1;
    self.underlyingImageView = backImageView;
    self.center = backImageView.center;
    [backImageView addSubview:self];
    [fatherVC.view addSubview:backImageView];
    ;
}

- (UIViewController*)appRootViewController
{
    
    UIViewController* appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController* topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)disMiss
{
    if (self.underlyingImageView) {
        [self.underlyingImageView removeFromSuperview];
    }
}

- (void)dealloc
{
    DDLogInfo(@"dealloc");
}



@end
