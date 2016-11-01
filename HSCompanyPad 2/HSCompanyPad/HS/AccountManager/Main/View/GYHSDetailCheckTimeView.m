//
//  GYHSDetailCheckTimeView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSDetailCheckTimeView.h"
#import <GYKit/UIView+Extension.h>

#import "GYDatePickView.h"
#define kTopHeight kDeviceProportion(12)
#define kLeftWidth kDeviceProportion(10)
#define kCardWidth kDeviceProportion(160)
#define kCommonHeight kDeviceProportion(25)
#define kButtonWidth kDeviceProportion(60)
#define kTimeFieldWidth kDeviceProportion(130)
#define kImageSize kDeviceProportion(14)
#define kBtnWidth kDeviceProportion(40)
#define kBackViewHeight kDeviceProportion(36)

@interface GYHSDetailCheckTimeView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *todayButton;
@property (nonatomic, strong) UIButton *weekButton;
@property (nonatomic, strong) UIButton *yearButton;
@property (nonatomic, strong) UIView *backview;
//UIView * backview
@end



@implementation GYHSDetailCheckTimeView


#pragma mark-----今天和最近一周
/**
 *  今天 和 最近一周
 */
- (void)setCommonUI
{
    UIView *backview = [[UIView alloc]init];
    backview.y      = kTopHeight;
    backview.height = kBackViewHeight;
    [self addSubview:backview];
    self.backview = backview;



    //GYHS_Account_Today 按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame              = CGRectMake(kLeftWidth, 0, kButtonWidth, kCommonHeight);
    button.centerY            = kBackViewHeight / 2;
    button.backgroundColor    = kBlue0A59C2;
    button.layer.cornerRadius = 3;
    [button setTitle:kLocalized(@"GYHS_Account_Today")
            forState:UIControlStateNormal];
    button.titleLabel.font = kFont24;

    [button setTitleColor:kWhiteFFFFFF
                 forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(click)
     forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:button];
    self.todayButton = button;

    //GYHS_Account_Next_Week按钮
    UIButton *buttonW = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonW.titleLabel.font = kFont24;
    CGSize buttonSize = [self giveLabelWith:[UIFont systemFontOfSize:21.0f]
                                   nsstring:kLocalized(@"GYHS_Account_Next_Week")];//GYHS_Account_Next_Week
    buttonW.frame              = CGRectMake((CGRectGetMaxX(button.frame) + kLeftWidth), 0, buttonSize.width, buttonSize.height);
    buttonW.centerY            = kBackViewHeight / 2;
    buttonW.backgroundColor    = [UIColor clearColor];
    buttonW.layer.cornerRadius = 3;
    [buttonW setTitle:kLocalized(@"GYHS_Account_Next_Week")
             forState:UIControlStateNormal];
    buttonW.titleLabel.font = kFont24;
    [buttonW setTitleColor:kBlue0A59C2
                  forState:UIControlStateNormal];
    [buttonW addTarget:self
                action:@selector(clickWeek)
      forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:buttonW];
    self.weekButton = buttonW;


    GYHSCunsumeTextField *begainField = [[GYHSCunsumeTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buttonW.frame) + kLeftWidth, 0, kTimeFieldWidth, kCommonHeight)];
    begainField.centerY           = kBackViewHeight / 2;
    begainField.placeholder       = kLocalized(@"GYHS_Account_Start_Date");//
    begainField.layer.borderWidth = 1;
    begainField.layer.borderColor = kDefaultVCBackgroundColor.CGColor;
    [self setRightViewWithTextField:begainField
                          imageName:kLocalized(@"gyhs_point_date")];
    begainField.delegate = self;
    [backview addSubview:begainField];
    self.begainField = begainField;

    GYHSCunsumeTextField *endTextfield = [[GYHSCunsumeTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(begainField.frame) + kLeftWidth, 0, kTimeFieldWidth, kCommonHeight)];
    endTextfield.centerY           = kBackViewHeight / 2;
    endTextfield.placeholder       = kLocalized(@"GYHS_Account_End_Date");
    endTextfield.layer.borderWidth = 1;
    endTextfield.layer.borderColor = kDefaultVCBackgroundColor.CGColor;
    [self setRightViewWithTextField:endTextfield
                          imageName:kLocalized(@"gyhs_point_date")];
    endTextfield.delegate = self;
    [backview addSubview:endTextfield];
    self.endTextfield = endTextfield;

    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(endTextfield.frame) + kLeftWidth, 0, kButtonWidth, kCommonHeight)];
    checkBtn.centerY = kBackViewHeight / 2;
    [checkBtn setTitle:kLocalized(@"GYHS_Account_CheckList")
              forState:UIControlStateNormal];
    [checkBtn setTitleColor:[UIColor redColor]
                   forState:UIControlStateNormal];
    [checkBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [checkBtn setImage:[UIImage imageNamed:kLocalized(@"gyhs_point_check")]
              forState:UIControlStateNormal];
    [backview addSubview:checkBtn];
    checkBtn.userInteractionEnabled = YES;
    backview.userInteractionEnabled = YES;
    [checkBtn addTarget:self
                 action:@selector(clickCheckBtn)
       forControlEvents:UIControlEventTouchUpInside];
    backview.width   = CGRectGetMaxX(checkBtn.frame) + 2 * kLeftWidth;
    backview.centerX = self.centerX;

    NSDate *senddate = [NSDate date];

    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];

    [dateformatter setDateFormat:kLocalized(@"YYYY-MM-dd")];

    NSString *locationString = [dateformatter stringFromDate:senddate];
    self.begainField.text  = locationString;
    self.endTextfield.text = locationString;
}

#pragma mark-----设置今年数据查询
/**
 *  带今年的框框
 */
- (void)setThisYearHeadUI
{
    UIView *backview = [[UIView alloc]init];
    backview.y      = kTopHeight;
    backview.height = kBackViewHeight;
    [self addSubview:backview];


    //今年 按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame              = CGRectMake(kLeftWidth, 0, kButtonWidth, kCommonHeight);
    button.centerY            = kBackViewHeight / 2;
    button.backgroundColor    = kBlue0A59C2;
    button.layer.cornerRadius = 3;
    button.titleLabel.font    = kFont24;
    [button setTitle:kLocalized(@"GYHS_Account_This_Year")
            forState:UIControlStateNormal];
    [button setTitleColor:kWhiteFFFFFF
                 forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(clickYear)
     forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:button];
    self.yearButton = button;




    GYHSCunsumeTextField *endTextfield = [[GYHSCunsumeTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame) + kLeftWidth, 0, kTimeFieldWidth, kCommonHeight)];
    endTextfield.centerY           = kBackViewHeight / 2;
    endTextfield.placeholder       = kLocalized(@"GYHS_Account_End_Date");
    endTextfield.layer.borderWidth = 1;
    endTextfield.layer.borderColor = kDefaultVCBackgroundColor.CGColor;
    [self setRightViewWithTextField:endTextfield
                          imageName:kLocalized(@"gyhs_point_date")];
    endTextfield.delegate = self;
    [backview addSubview:endTextfield];
    self.endYearTextfield = endTextfield;

    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(endTextfield.frame) + kLeftWidth, 0, kButtonWidth, kCommonHeight)];
    checkBtn.centerY = kBackViewHeight / 2;
    [checkBtn setTitle:kLocalized(@"GYHS_Account_CheckList")
              forState:UIControlStateNormal];
    [checkBtn setTitleColor:[UIColor redColor]
                   forState:UIControlStateNormal];
    [checkBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [checkBtn setImage:[UIImage imageNamed:kLocalized(@"gyhs_point_check")]
              forState:UIControlStateNormal];
    [backview addSubview:checkBtn];
    checkBtn.userInteractionEnabled = YES;
    backview.userInteractionEnabled = YES;
    [checkBtn addTarget:self
                 action:@selector(clickCheckBtn)
       forControlEvents:UIControlEventTouchUpInside];
    backview.width   = CGRectGetMaxX(checkBtn.frame) + 2 * kLeftWidth;
    backview.centerX = self.centerX;
}

/**
 *  点击今天
 */
- (void)click
{
    NSDate *senddate = [NSDate date];

    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];

    [dateformatter setDateFormat:kLocalized(@"YYYY-MM-dd")];

    NSString *locationString = [dateformatter stringFromDate:senddate];
    self.begainField.text  = locationString;
    self.endTextfield.text = locationString;
    //点击了今天 那么最近一周的按钮就要变化
    self.todayButton.backgroundColor = kBlue0A59C2;
    //self.todayButton.layer.cornerRadius = 3;
    [self.todayButton
     setTitleColor:kWhiteFFFFFF
          forState:UIControlStateNormal];

    self.weekButton.backgroundColor = [UIColor clearColor];
    [self.weekButton
     setTitleColor:kBlue0A59C2
          forState:UIControlStateNormal];
    if ([self.delegate
         respondsToSelector:@selector(clickToday:)])
    {
        [self.delegate
         clickToday:self];
    }
}

/**
 *  点击最近一周
 */
- (void)clickWeek//把起始的时间推前 结束的时间放在GYHS_Account_Today
{
    NSDate *senddate               = [NSDate date];
    NSDate *befordate              = [NSDate dateWithTimeIntervalSinceNow:-24 * 7 * 60 * 60];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];

    [dateformatter setDateFormat:kLocalized(@"YYYY-MM-dd")];

    NSString *locationStringBefore = [dateformatter stringFromDate:befordate];
    NSString *locationString       = [dateformatter stringFromDate:senddate];
    self.begainField.text  = locationStringBefore;
    self.endTextfield.text = locationString;

    self.todayButton.backgroundColor = [UIColor clearColor];
    //self.todayButton.layer.cornerRadius = 3;
    [self.todayButton
     setTitleColor:kBlue0A59C2
          forState:UIControlStateNormal];

    self.weekButton.backgroundColor = kBlue0A59C2;
    [self.weekButton
     setTitleColor:kWhiteFFFFFF
          forState:UIControlStateNormal];
    if ([self.delegate
         respondsToSelector:@selector(clickWeek:)])
    {
        [self.delegate
         clickWeek:self];
    }
}

/**
 *  点击今年
 */
- (void)clickYear
{
    NSDate *senddate = [NSDate date];

    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];

    [dateformatter setDateFormat:kLocalized(@"YYYY")];

    NSString *locationString = [dateformatter stringFromDate:senddate];

    self.endYearTextfield.text = locationString;
    //点击了GYHS_Account_Today 那么GYHS_Account_Next_Week的按钮就要变化
    self.yearButton.backgroundColor = kBlue0A59C2;
    //self.todayButton.layer.cornerRadius = 3;
    [self.yearButton
     setTitleColor:kWhiteFFFFFF
          forState:UIControlStateNormal];
}

/**
 *  点击查询按钮
 */
- (void)clickCheckBtn
{
    [self.delegate
     clickCheckBtn:self];
}

/**
 *  输入框右边添加内容
 *
 *  @param textField 输入框
 *  @param imageName 图片名字
 */
- (void)setRightViewWithTextField:(GYHSCunsumeTextField *)textField imageName:(NSString *)imageName
{
    UIImageView *rightView = [[UIImageView alloc]init];
    rightView.image         = [UIImage imageNamed:imageName];
    rightView.size          = CGSizeMake(kImageSize, kImageSize);
    rightView.contentMode   = UIViewContentModeCenter;
    textField.rightView     = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;
}

#pragma mark-UITextField
/**
 *  输入框代理方法 开始编辑
 *
 *  @param textField 输入框
 *
 *  @return 布尔值
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.begainField)
    {
        GYDatePickView *dateView = [[GYDatePickView alloc]initWithDatePickViewType:DatePickViewTypeDate];
        [dateView show];
        @weakify(self);
        dateView.dateBlcok = ^(NSString *dateString){
            @strongify(self);
            self.begainField.text = dateString;
            [self.begainField resignFirstResponder];

            self.todayButton.backgroundColor = [UIColor clearColor];
            [self.todayButton
             setTitleColor:kBlue0A59C2
                  forState:UIControlStateNormal];

            self.weekButton.backgroundColor = [UIColor clearColor];
            [self.weekButton
             setTitleColor:kBlue0A59C2
                  forState:UIControlStateNormal];
        };
    }
    if (textField == self.endTextfield)
    {
        GYDatePickView *dateEndView = [[GYDatePickView alloc]initWithDatePickViewType:DatePickViewTypeDate];
        [dateEndView show];
        @weakify(self);
        dateEndView.dateBlcok = ^(NSString *dateString){
            @strongify(self);
            self.endTextfield.text = dateString;
            [self.endTextfield resignFirstResponder];

            self.todayButton.backgroundColor = [UIColor clearColor];
            [self.todayButton
             setTitleColor:kBlue0A59C2
                  forState:UIControlStateNormal];

            self.weekButton.backgroundColor = [UIColor clearColor];
            [self.weekButton
             setTitleColor:kBlue0A59C2
                  forState:UIControlStateNormal];
        };
    }

    if (textField == self.endYearTextfield)  //如果是点了今年后面的日期按钮
    {
        GYDatePickView *dateEndView = [[GYDatePickView alloc]initWithDatePickViewType:DatePickViewTypeYear];
        [dateEndView show];
        @weakify(self);
        dateEndView.dateBlcok = ^(NSString *dateString){
            @strongify(self);
            self.endYearTextfield.text = dateString;
            [self.endYearTextfield resignFirstResponder];

            self.yearButton.backgroundColor = [UIColor clearColor];
            [self.yearButton
             setTitleColor:kBlue0A59C2
                  forState:UIControlStateNormal];

        };
    }
    return NO;
}

//得到label尺寸(根据内容字体)
- (CGSize)giveLabelWith:(UIFont *)fnt nsstring:(NSString *)string
{
    UILabel *label = [[UILabel alloc] init];

    label.text = string;


    return [label.text
            sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil]];
}

@end
