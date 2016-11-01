//
//  GYAlertShowDataWithOKButtonView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYAlertShowDataWithOKButtonView.h"
#import "GYHSAccountUIFactory.h"

#define kTotalSizeWidth kDeviceProportion(500)
#define kTotalSizeHeight kDeviceProportion(330)
#define kTipsSizeHeight kDeviceProportion(376)
#define kTitleImageHeight kDeviceProportion(30)
#define kButtonHeight kDeviceProportion(33)
#define kButtonWidth kDeviceProportion(90)
#define kLetfwidth kDeviceProportion(80)
#define kLetfSpacewidth kDeviceProportion(10)
#define kTopSpacewidth kDeviceProportion(30)
#define kLabelWidthMax kDeviceProportion(340)
#define kLabelHeightMax kDeviceProportion(45)

@interface GYAlertShowDataWithOKButtonView ()

@property (nonatomic, weak) UIImageView *backImageView;
@property (nonatomic, copy) dispatch_block_t block;

@end

@implementation GYAlertShowDataWithOKButtonView

#pragma mark-----第一种提示框
/**
 *  积分转互生币点OK弹出的列表提示框
 *
 *  @param message  捎带消息
 *  @param topColor 上部分颜色
 *  @param strOne   可用余数
 *  @param strTwo   转出数
 *  @param strThree 转入数
 *  @param block    代码块
 *
 *  @return 返回自身视图对象
 */
+ (GYAlertShowDataWithOKButtonView *)alertWithMessage:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne turnOutNum:(NSString *)strTwo changeCoinNum:(NSString *)strThree comfirmBlock:(dispatch_block_t)block
{
    GYAlertShowDataWithOKButtonView *alert = [[GYAlertShowDataWithOKButtonView alloc] initWithMessage:message
                                                                                             topColor:topColor
                                                                                            canUseNum:strOne
                                                                                           turnOutNum:strTwo
                                                                                        changeCoinNum:strThree
                                                                                         comfirmBlock:block];
    [alert show]; //制作大的透明背景
    return alert;
}

//进行初始配置 消息及确认按钮 //这个message在这里是没有用的
- (instancetype)initWithMessage:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne turnOutNum:(NSString *)strTwo changeCoinNum:(NSString *)strThree comfirmBlock:(dispatch_block_t)block
{
    CGRect frame = CGRectMake(0, 0, kTotalSizeWidth, kTotalSizeHeight); //这个GYHS_Account_Prompt框大小可以修改
    self = [super initWithFrame:frame];
    if (self)
    {
        self.block               = block;
        self.backgroundColor     = kWhiteFFFFFF;
        self.layer.cornerRadius  = 6;
        self.layer.borderWidth   = 1;
        self.layer.masksToBounds = YES;
        self.layer.borderColor   = [UIColor clearColor].CGColor;
        [self setUpViewWithMessage:message
                         canUseNum:strOne
                        turnOutNum:strTwo
                     changeCoinNum:strThree
                          topColor:topColor];
    }
    return self;
}

//生成小提示框
- (void)setUpViewWithMessage:(NSString *)message canUseNum:(NSString *)strOne turnOutNum:(NSString *)strTwo changeCoinNum:(NSString *)strThree topColor:(TopColor)topColor
{
    UIImage *image;
    NSString *title;
    if (topColor == 0)
    {
        image = [UIImage imageNamed:kLocalized(@"gycom_redTop")];
        title = kLocalized(@"GYHS_Account_Prompt");
    }
    else
    {
        image = [UIImage imageNamed:kLocalized(@"gycom_blueTop")];
        title = kLocalized(@"GYHS_Account_Reminder");
    }

    //这个是上面的温馨提示 头标题位置
    UIImageView *hsIconImageView = [[UIImageView alloc] initWithImage:image];
    hsIconImageView.userInteractionEnabled = YES;
    hsIconImageView.multipleTouchEnabled   = YES;
    hsIconImageView.backgroundColor        = kWhiteFFFFFF;
    [self addSubview:hsIconImageView];
    @weakify(self);
    [hsIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self);//测试
        make.height.equalTo(@(kTitleImageHeight + 20)); //???????ui数据有点异常
    }];

    //显示温馨提示 几个字
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text      = title;
    titleLabel.textColor = kWhiteFFFFFF;


    titleLabel.font      = kFont34;
    [hsIconImageView addSubview:titleLabel]; //加在上面的图层上面
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.left.equalTo(hsIconImageView.mas_left).offset(60);
        make.centerY.equalTo(hsIconImageView).offset(-4);
        make.width.equalTo(@(85));
        make.height.equalTo(@(15));
    }];
    //显示小叉叉 表示取消 可以退回去
    UIButton *forkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forkButton.contentMode     = UIViewContentModeCenter;
    forkButton.backgroundColor = [UIColor clearColor];
    [forkButton setImage:[UIImage imageNamed:kLocalized(@"gycom_forkButton")]
                forState:UIControlStateNormal];
    [forkButton addTarget:self
                   action:@selector(cancelAct)
         forControlEvents:UIControlEventTouchUpInside];
    [hsIconImageView addSubview:forkButton];
    [forkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.top.equalTo(hsIconImageView).offset(7);
        make.height.equalTo(@26);
        make.right.equalTo(hsIconImageView.mas_right).offset(-10);
        make.width.equalTo(@26);
    }];

#pragma mark-----自定义修改显示框
    //自定义的第一个
    GYHSAccountUIFactory *firstView = [[GYHSAccountUIFactory alloc] initKVImageViewWithFrame:CGRectMake(kLetfwidth, kTopSpacewidth + hsIconImageView.bounds.size.height, kLabelWidthMax, kLabelHeightMax)
                                                                                   imageName:kLocalized(@"gyhs_point_min")
                                                                                       title:kLocalized(@"GYHS_Account_The_Remainder_Is_Available")
                                                                                       value:strOne
                                                                                  valueColor:kGray333333];

    [self addSubview:firstView];

    //自定义第二个
    GYHSAccountUIFactory *secondView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, firstView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                         title:kLocalized(@"GYHS_Account_Transfer_Product_Score")
                                                                                         value:strTwo
                                                                                    valueColor:kRedFF6235
                                                                                    isOKButton:YES];

    [self addSubview:secondView];

    //自定义第三个
    GYHSAccountUIFactory *thirdView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, secondView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                        title:kLocalized(@"GYHS_Account_Transfer_Into_Account")
                                                                                        value:kLocalized(@"GYHS_Account_HSB_Account")
                                                                                   valueColor:kGray333333
                                                                                   isOKButton:YES];

    [self addSubview:thirdView];

    //自定义第四个
    GYHSAccountUIFactory *fourthView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, thirdView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                         title:kLocalized(@"GYHS_Account_To_Alternate_The_Number_Of_Coins")
                                                                                         value:strThree
                                                                                    valueColor:kRedFF6235
                                                                                    isOKButton:YES];

    [self addSubview:fourthView];

    //下面的 确定按钮
    UIButton *comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButton.backgroundColor = kRedE50012;
    [comfirmButton setTitle:kLocalized(@"GYHS_Account_Confirm_Submission")//GYHS_Account_Confirm_Submission
                   forState:UIControlStateNormal];
    comfirmButton.titleLabel.font    = kFont32;
    comfirmButton.layer.cornerRadius = 6;
    comfirmButton.layer.borderWidth  = 1;
    comfirmButton.layer.borderColor  = kWhiteFFFFFF.CGColor;
    [comfirmButton addTarget:self
                      action:@selector(comfimAct)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:comfirmButton];
    [comfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(fourthView.mas_bottom).offset(kTitleImageHeight);

        make.height.equalTo(@(kButtonHeight));  //确定按钮的大小尺寸 ?????? //@43
        make.width.equalTo(@(kButtonWidth));  //@90
    }];
}

#pragma mark----- 第二种小温馨提示框
/**
 *  积分投资点OK弹出列表提示框
 *
 *  @param message  捎带消息
 *  @param topColor 上部颜色
 *  @param strOne   可用余数
 *  @param strTwo   投资积分数
 *  @param block    代码块
 *
 *  @return 返回自身视图对象
 */
+ (GYAlertShowDataWithOKButtonView *)alertPointInvestment:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne turnOutNum:(NSString *)strTwo comfirmBlock:(dispatch_block_t)block
{
    GYAlertShowDataWithOKButtonView *alertone = [[GYAlertShowDataWithOKButtonView alloc] initWithPointInvestment:message
                                                                                                        topColor:topColor
                                                                                                       canUseNum:(NSString *)strOne
                                                                                                      turnOutNum:(NSString *)strTwo
                                                                                                    comfirmBlock:block];
    [alertone show]; //制作大的透明背景
    return alertone;
}

- (instancetype)initWithPointInvestment:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne turnOutNum:(NSString *)strTwo comfirmBlock:(dispatch_block_t)block
{
    CGRect frame = CGRectMake(0, 0, kTotalSizeWidth, kDeviceProportion(285)); //这个GYHS_Account_Prompt框大小可以修改
    self = [super initWithFrame:frame];
    if (self)
    {
        self.block               = block;
        self.backgroundColor     = kWhiteFFFFFF;
        self.layer.cornerRadius  = 6;
        self.layer.borderWidth   = 1;
        self.layer.masksToBounds = YES;
        self.layer.borderColor   = [UIColor clearColor].CGColor;
        [self setUpPointInvestmentViewWithMessage:message
                                         topColor:topColor
                                        canUseNum:(NSString *)strOne
                                       turnOutNum:(NSString *)strTwo];
    }
    return self;
}

- (void)setUpPointInvestmentViewWithMessage:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne turnOutNum:(NSString *)strTwo
{
    UIImage *image;
    NSString *title;
    if (topColor == 0)
    {
        image = [UIImage imageNamed:kLocalized(@"gycom_redTop")];
        title = kLocalized(@"GYHS_Account_Prompt");
    }
    else
    {
        image = [UIImage imageNamed:kLocalized(@"gycom_blueTop")];
        title = kLocalized(@"GYHS_Account_Reminder");
    }

    //这个是上面的GYHS_Account_Reminder 头标题位置
    UIImageView *hsIconImageView = [[UIImageView alloc] initWithImage:image];
    hsIconImageView.userInteractionEnabled = YES;
    hsIconImageView.multipleTouchEnabled   = YES;
    hsIconImageView.backgroundColor        = kWhiteFFFFFF;
    [self addSubview:hsIconImageView];
    @weakify(self);
    [hsIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self);//测试
        make.height.equalTo(@(kTitleImageHeight + 20)); //???????ui数据有点异常
    }];

    //显示GYHS_Account_Reminder 几个字
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text      = title;
    titleLabel.textColor = kWhiteFFFFFF;

    titleLabel.font      = kFont34;
    [hsIconImageView addSubview:titleLabel]; //加在上面的图层上面
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.left.equalTo(hsIconImageView.mas_left).offset(kDeviceProportion(60));
        make.centerY.equalTo(hsIconImageView).offset(kDeviceProportion(-4));
        make.width.equalTo(@(kDeviceProportion(85)));
        make.height.equalTo(@(kDeviceProportion(15)));
    }];
    //显示小叉叉 表示取消 可以退回去
    UIButton *forkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forkButton.contentMode     = UIViewContentModeCenter;
    forkButton.backgroundColor = [UIColor clearColor];
    [forkButton setImage:[UIImage imageNamed:kLocalized(@"gycom_forkButton")]
                forState:UIControlStateNormal];
    [forkButton addTarget:self
                   action:@selector(cancelAct)
         forControlEvents:UIControlEventTouchUpInside];
    [hsIconImageView addSubview:forkButton];
    [forkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.top.equalTo(hsIconImageView).offset(kDeviceProportion(7));
        make.height.equalTo(@(kDeviceProportion(26)));
        make.right.equalTo(hsIconImageView.mas_right).offset(kDeviceProportion(-10));
        make.width.equalTo(@(kDeviceProportion(26)));
    }];

    //自定义的第一个
    GYHSAccountUIFactory *firstView = [[GYHSAccountUIFactory alloc] initKVImageViewWithFrame:CGRectMake(kLetfwidth, kTopSpacewidth + hsIconImageView.bounds.size.height, kLabelWidthMax, kLabelHeightMax)
                                                                                   imageName:kLocalized(@"gyhs_point_min")
                                                                                       title:kLocalized(@"GYHS_Account_The_Remainder_Is_Available")
                                                                                       value:strOne
                                                                                  valueColor:kGray333333];

    [self addSubview:firstView];

    //自定义第二个
    GYHSAccountUIFactory *secondView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, firstView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                         title:kLocalized(@"GYHS_Account_Points_Of_Investment")
                                                                                         value:strTwo
                                                                                    valueColor:kRedFF6235
                                                                                    isOKButton:YES];
    [self addSubview:secondView];

    //自定义第三个
    GYHSAccountUIFactory *thirdView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, secondView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                        title:kLocalized(@"GYHS_Account_Transfer_Into_Account")
                                                                                        value:kLocalized(@"GYHS_Account_Investment_Account")
                                                                                   valueColor:kGray333333
                                                                                   isOKButton:YES];
    [self addSubview:thirdView];

    //下面的 确定按钮
    UIButton *comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButton.backgroundColor = kRedE50012;
    [comfirmButton setTitle:kLocalized(@"GYHS_Account_Confirm_Submission")
                   forState:UIControlStateNormal];
    comfirmButton.titleLabel.font    = kFont32;
    comfirmButton.layer.cornerRadius = 6;
    comfirmButton.layer.borderWidth  = 1;
    comfirmButton.layer.borderColor  = kWhiteFFFFFF.CGColor;
    [comfirmButton addTarget:self
                      action:@selector(comfimAct)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:comfirmButton];
    [comfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(thirdView.mas_bottom).offset(kTitleImageHeight);
        //make.bottom.equalTo(self).offset(-35);
        make.height.equalTo(@(kButtonHeight));  //确定按钮的大小尺寸 ?????? //@43
        make.width.equalTo(@(kButtonWidth));  //@90
    }];
}

#pragma mark-----第三种小提示框
/**
 *  货币转银行界面点OK弹出的列表提示框
 *
 *  @param message        捎带消息
 *  @param topColor       上部颜色
 *  @param strOne         可用余额
 *  @param strTwo         银行账户名称
 *  @param strThree       银行账户账号
 *  @param strFour        转出数
 *  @param strFive        手续费
 *  @param isValidAccount 是否验证
 *  @param bankAccName    账户名称
 *  @param cityName       开户地区
 *  @param block          代码块
 *
 *  @return 返回自身视图对象
 */
+ (GYAlertShowDataWithOKButtonView *)alertCoinToBank:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne cardName:(NSString *)strTwo cardNum:(NSString *)strThree turnOutNum:(NSString *)strFour turnFee:(NSString *)strFive isValidAccount:(NSString *)isValidAccount bankAccName:(NSString *)bankAccName cityName:(NSString *)cityName comfirmBlock:(dispatch_block_t)block
{
    GYAlertShowDataWithOKButtonView *alerttwo = [[GYAlertShowDataWithOKButtonView alloc] initWithCoinToBank:message
                                                                                                   topColor:topColor
                                                                                                  canUseNum:(NSString *)strOne
                                                                                                   cardName:(NSString *)strTwo
                                                                                                    cardNum:(NSString *)strThree
                                                                                                 turnOutNum:(NSString *)strFour
                                                                                                    turnFee:(NSString *)strFive
                                                                                             isValidAccount:(NSString *)isValidAccount
                                                                                                bankAccName:(NSString *)bankAccName
                                                                                                   cityName:(NSString *)cityName
                                                                                               comfirmBlock:block];
    [alerttwo show]; //制作大的透明背景
    return alerttwo;
}

- (instancetype)initWithCoinToBank:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne cardName:(NSString *)strTwo cardNum:(NSString *)strThree turnOutNum:(NSString *)strFour turnFee:(NSString *)strFive isValidAccount:(NSString *)isValidAccount bankAccName:(NSString *)bankAccName cityName:(NSString *)cityName comfirmBlock:(dispatch_block_t)block
{
    CGRect frame = CGRectMake(0, 0, kTotalSizeWidth, kDeviceProportion(421)); //这个GYHS_Account_Prompt框大小可以修改
    self = [super initWithFrame:frame];
    if (self)
    {
        self.block               = block;
        self.backgroundColor     = kWhiteFFFFFF;
        self.layer.cornerRadius  = 6;
        self.layer.borderWidth   = 1;
        self.layer.masksToBounds = YES;
        self.layer.borderColor   = [UIColor clearColor].CGColor;
        [self setUpCoinToBankViewWithMessage:message
                                    topColor:topColor
                                   canUseNum:(NSString *)strOne
                                    cardName:(NSString *)strTwo
                                     cardNum:(NSString *)strThree
                                  turnOutNum:(NSString *)strFour
                                     turnFee:(NSString *)strFive
                              isValidAccount:(NSString *)isValidAccount
                                 bankAccName:(NSString *)bankAccName
                                    cityName:(NSString *)cityName];
    }
    return self;
}

- (void)setUpCoinToBankViewWithMessage:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne cardName:(NSString *)strTwo cardNum:(NSString *)strThree turnOutNum:(NSString *)strFour turnFee:(NSString *)strFive
                        isValidAccount:(NSString *)isValidAccount
                           bankAccName:(NSString *)bankAccName
                              cityName:(NSString *)cityName
{
    UIImage *image;
    NSString *title;
    if (topColor == 0)
    {
        image = [UIImage imageNamed:kLocalized(@"gycom_redTop")];
        title = kLocalized(@"GYHS_Account_Prompt");
    }
    else
    {
        image = [UIImage imageNamed:kLocalized(@"gycom_blueTop")];
        title = kLocalized(@"GYHS_Account_Reminder");
    }

    //这个是上面的GYHS_Account_Reminder 头标题位置
    UIImageView *hsIconImageView = [[UIImageView alloc] initWithImage:image];
    hsIconImageView.userInteractionEnabled = YES;
    hsIconImageView.multipleTouchEnabled   = YES;
    hsIconImageView.backgroundColor        = kWhiteFFFFFF;
    [self addSubview:hsIconImageView];
    @weakify(self);
    [hsIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self);//测试
        make.height.equalTo(@(kTitleImageHeight + 20)); //
    }];

    //显示GYHS_Account_Reminder 几个字
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text      = title;
    titleLabel.textColor = kWhiteFFFFFF;

    titleLabel.font      = kFont34;//[UIFont boldSystemFontOfSize:16.0f];
    [hsIconImageView addSubview:titleLabel]; //加在上面的图层上面
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.left.equalTo(hsIconImageView.mas_left).offset(kDeviceProportion(60));
        make.centerY.equalTo(hsIconImageView).offset(kDeviceProportion(-4));
        make.width.equalTo(@(kDeviceProportion(85)));
        make.height.equalTo(@(kDeviceProportion(15)));
    }];
    //显示小叉叉 表示取消 可以退回去
    UIButton *forkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forkButton.contentMode     = UIViewContentModeCenter;
    forkButton.backgroundColor = [UIColor clearColor];
    [forkButton setImage:[UIImage imageNamed:kLocalized(@"gycom_forkButton")]
                forState:UIControlStateNormal];
    [forkButton addTarget:self
                   action:@selector(cancelAct)
         forControlEvents:UIControlEventTouchUpInside];
    [hsIconImageView addSubview:forkButton];
    [forkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.top.equalTo(hsIconImageView).offset(kDeviceProportion(7));
        make.height.equalTo(@(kDeviceProportion(26)));
        make.right.equalTo(hsIconImageView.mas_right).offset(kDeviceProportion(-10));
        make.width.equalTo(@(kDeviceProportion(26)));
    }];

    //自定义的第一个显示货币账户的可用余额
    GYHSAccountUIFactory *firstView = [[GYHSAccountUIFactory alloc] initKVImageViewWithFrame:CGRectMake(kLetfwidth, kTopSpacewidth + hsIconImageView.bounds.size.height, kLabelWidthMax, kLabelHeightMax)
                                                                                   imageName:kLocalized(@"gyhs_coinToBank_small_icon")
                                                                                       title:kLocalized(@"GYHS_Account_Available_Balance")
                                                                                       value:strOne
                                                                                  valueColor:kGray333333];

    [self addSubview:firstView];

    //自定义第二个
    NSString *strcom;
    if ([isValidAccount isEqualToString:@"1"])
    {
        strcom = kLocalized(@"GYHS_Account_Verified");
    }
    else
    {
        strcom = kLocalized(@"GYHS_Account_Not_Verified");
    }
    GYHSAccountUIFactory *secondView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, firstView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                         title:[NSString stringWithFormat:@"%@(%@)", strTwo, strThree]
                                                                                         value:strcom
                                                                                    valueColor:kGray333333
                                                                                    isOKButton:YES];

    [self addSubview:secondView];

    //自定义第三个
    GYHSAccountUIFactory *thirdView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, secondView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                        title:kLocalized(@"GYHS_Account_Account_Name")
                                                                                        value:bankAccName
                                                                                   valueColor:kGray333333
                                                                                   isOKButton:YES];

    [self addSubview:thirdView];

    //自定义第四个
    GYHSAccountUIFactory *fourthView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, thirdView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                         title:kLocalized(@"GYHS_Account_Opening_Area")
                                                                                         value:cityName
                                                                                    valueColor:kGray333333
                                                                                    isOKButton:YES];

    [self addSubview:fourthView];

    //自定义第五个
    GYHSAccountUIFactory *fifthView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, fourthView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                        title:kLocalized(@"GYHS_Account_Bank_Account_Amount")
                                                                                        value:strFour
                                                                                   valueColor:kRedFF6235
                                                                                   isOKButton:YES];

    [self addSubview:fifthView];

    //自定义第六个
    GYHSAccountUIFactory *sixthView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, fifthView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                        title:kLocalized(@"GYHS_Account_Budget_Deduction")
                                                                                        value:strFive
                                                                                   valueColor:kRedFF6235
                                                                                   isOKButton:YES];

    [self addSubview:sixthView];

    //下面的 确定按钮
    UIButton *comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButton.backgroundColor = kRedE50012;

    [comfirmButton setTitle:kLocalized(@"GYHS_Account_Confirm_Submission")
                   forState:UIControlStateNormal];
    comfirmButton.titleLabel.font    = kFont32;
    comfirmButton.layer.cornerRadius = 6;
    comfirmButton.layer.borderWidth  = 1;
    comfirmButton.layer.borderColor  = kWhiteFFFFFF.CGColor;
    [comfirmButton addTarget:self
                      action:@selector(comfimAct)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:comfirmButton];
    [comfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(sixthView.mas_bottom).offset(kTitleImageHeight);
        make.height.equalTo(@(kButtonHeight));
        make.width.equalTo(@(kButtonWidth));
    }];
}

#pragma mark-----互生币转货币的OK小方法
/**
 *  互生币转货币点击OK弹出列表框
 *
 *  @param message  捎带消息
 *  @param topColor 上部颜色
 *  @param strOne   可转数量
 *  @param strTwo   转出数
 *  @param strThree 转换费
 *  @param strFour  转入金额
 *  @param block    代码块
 *
 *  @return 自身视图对象
 */
+ (GYAlertShowDataWithOKButtonView *)alertHSBToCoin:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne inputNum:(NSString *)strTwo feeNum:(NSString *)strThree addNum:(NSString *)strFour comfirmBlock:(dispatch_block_t)block
{
    GYAlertShowDataWithOKButtonView *alert = [[GYAlertShowDataWithOKButtonView alloc] initWithHSBToCoinMessage:message
                                                                                                      topColor:topColor
                                                                                                     canUseNum:(NSString *)strOne
                                                                                                      inputNum:(NSString *)strTwo
                                                                                                        feeNum:(NSString *)strThree
                                                                                                        addNum:(NSString *)strFour
                                                                                                  comfirmBlock:block];
    [alert show]; //制作大的透明背景
    return alert;
}

- (instancetype)initWithHSBToCoinMessage:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne inputNum:(NSString *)strTwo feeNum:(NSString *)strThree addNum:(NSString *)strFour comfirmBlock:(dispatch_block_t)block
{
    CGRect frame = CGRectMake(0, 0, kTotalSizeWidth, kTipsSizeHeight); //GYHS_Account_Prompt框大小可以修改
    self = [super initWithFrame:frame];
    if (self)
    {
        self.block               = block;
        self.backgroundColor     = kWhiteFFFFFF;
        self.layer.cornerRadius  = 6;
        self.layer.borderWidth   = 1;
        self.layer.masksToBounds = YES;
        self.layer.borderColor   = [UIColor clearColor].CGColor;
        [self setUpViewWithHSBToCoin:message
                            topColor:topColor
                           canUseNum:(NSString *)strOne
                            inputNum:(NSString *)strTwo
                              feeNum:(NSString *)strThree
                              addNum:(NSString *)strFour];
    }
    return self;
}

- (void)setUpViewWithHSBToCoin:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne inputNum:(NSString *)strTwo feeNum:(NSString *)strThree addNum:(NSString *)strFour
{
    UIImage *image;
    NSString *title;
    if (topColor == 0)
    {
        image = [UIImage imageNamed:kLocalized(@"gycom_redTop")];
        title = kLocalized(@"GYHS_Account_Prompt");
    }
    else
    {
        image = [UIImage imageNamed:kLocalized(@"gycom_blueTop")];
        title = kLocalized(@"GYHS_Account_Reminder");
    }

    //这个是上面的GYHS_Account_Reminder 头标题位置
    UIImageView *hsIconImageView = [[UIImageView alloc] initWithImage:image];
    hsIconImageView.userInteractionEnabled = YES;
    hsIconImageView.multipleTouchEnabled   = YES;
    hsIconImageView.backgroundColor        = kWhiteFFFFFF;
    [self addSubview:hsIconImageView];
    @weakify(self);
    [hsIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self);//
        make.height.equalTo(@(kTitleImageHeight + 20)); //???????ui数据有点异常
    }];

    //显示GYHS_Account_Reminder 几个字
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text      = title;
    titleLabel.textColor = kWhiteFFFFFF;

    titleLabel.font      = kFont34;//[UIFont boldSystemFontOfSize:16.0f];
    [hsIconImageView addSubview:titleLabel]; //加在上面的图层上面
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.left.equalTo(hsIconImageView.mas_left).offset(60);
        make.centerY.equalTo(hsIconImageView).offset(-4);
        make.width.equalTo(@(85));
        make.height.equalTo(@(15));
    }];
    //显示小叉叉 表示取消 可以退回去
    UIButton *forkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forkButton.contentMode     = UIViewContentModeCenter;
    forkButton.backgroundColor = [UIColor clearColor];
    [forkButton setImage:[UIImage imageNamed:kLocalized(@"gycom_forkButton")]
                forState:UIControlStateNormal];
    [forkButton addTarget:self
                   action:@selector(cancelAct)
         forControlEvents:UIControlEventTouchUpInside];
    [hsIconImageView addSubview:forkButton];
    [forkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.top.equalTo(hsIconImageView).offset(7);
        make.height.equalTo(@26);
        make.right.equalTo(hsIconImageView.mas_right).offset(-10);
        make.width.equalTo(@26);
    }];

    //自定义的第一个
    GYHSAccountUIFactory *firstView = [[GYHSAccountUIFactory alloc] initKVImageViewWithFrame:CGRectMake(kLetfwidth, kTopSpacewidth + hsIconImageView.bounds.size.height, kLabelWidthMax, kLabelHeightMax)
                                                                                   imageName:kLocalized(@"gyhs_point_min_coin")
                                                                                       title:kLocalized(@"GYHS_Account_Number_Of_Turns")
                                                                                       value:strOne
                                                                                  valueColor:kGray333333];

    [self addSubview:firstView];

    //自定义第二个
    GYHSAccountUIFactory *secondView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, firstView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                         title:kLocalized(@"GYHS_Account_Number_Of_HSB_Turns")
                                                                                         value:strTwo
                                                                                    valueColor:kRedFF6235
                                                                                    isOKButton:YES];

    [self addSubview:secondView];

    //自定义第三个
    GYHSAccountUIFactory *thirdView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, secondView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                        title:kLocalized(@"GYHS_Account_Transfer_Into_Account")
                                                                                        value:kLocalized(@"GYHS_Account_Cash_Account")
                                                                                   valueColor:kGray999999
                                                                                   isOKButton:YES];
    [self addSubview:thirdView];

    //自定义第四个 //hsbToHbRate

    GYHSAccountUIFactory *fourthView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, thirdView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                         title:[kLocalized(@"GYHS_Account_Currency_Conversion_Fee") stringByAppendingString:[NSString stringWithFormat:@"(%.0f%%)", [globalData.config.hsbToHbRate doubleValue] * 100] ]
                                                                                         value:strThree
                                                                                    valueColor:kRedFF6235
                                                                                    isOKButton:YES];

    [self addSubview:fourthView];

    //自定义第五个
    GYHSAccountUIFactory *fifthView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, fourthView.frame.origin.y + kLabelHeightMax, kLabelWidthMax, kLabelHeightMax)
                                                                                        title:kLocalized(@"GYHS_Account_Amount_Of_Money_Transferred_Into_Account")
                                                                                        value:strFour
                                                                                   valueColor:kRedFF6235
                                                                                   isOKButton:YES];

    [self addSubview:fifthView];

    //下面的 确定按钮
    UIButton *comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButton.backgroundColor = kRedE50012;
    [comfirmButton setTitle:kLocalized(@"GYHS_Account_Confirm_Submission")
                   forState:UIControlStateNormal];
    comfirmButton.titleLabel.font    = kFont32;
    comfirmButton.layer.cornerRadius = 6;
    comfirmButton.layer.borderWidth  = 1;
    comfirmButton.layer.borderColor  = kWhiteFFFFFF.CGColor;
    [comfirmButton addTarget:self
                      action:@selector(comfimAct)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:comfirmButton];
    [comfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(fifthView.mas_bottom).offset(kTitleImageHeight);
        //make.bottom.equalTo(self).offset(-35);
        make.height.equalTo(@(kButtonHeight));
        make.width.equalTo(@(kButtonWidth));
    }];
}

#pragma mark-----有错误的时候进行显示
/**
 *  点OK弹出温馨提示框
 *
 *
 *  @param comfirmTitle 传递标题内容
 *  @param block        代码块
 *
 *  @return 返回自身视图对象
 */
+ (GYAlertShowDataWithOKButtonView *)oneTipAlertWithComfirmTitle:(NSString *)comfirmTitle isBlueTopColor:(BOOL)isBlue comfirmBlock:(dispatch_block_t)block
{
    GYAlertShowDataWithOKButtonView *alert = [[GYAlertShowDataWithOKButtonView alloc] initWithIsBlueTopColor:(BOOL)isBlue
                                                                                              comfirmTitle:comfirmTitle
                                                                                              comfirmBlock:block];
    [alert show]; //制作大的透明背景
    return alert;
}

- (instancetype)initWithIsBlueTopColor:(BOOL)isBlue comfirmTitle:(NSString *)comfirmTitle comfirmBlock:(dispatch_block_t)block
{
    CGRect frame = CGRectMake(0, 0, kTotalSizeWidth - 100, kTipsSizeHeight - 3 * kLabelHeightMax -50); //GYHS_Account_Prompt框大小可以修改
    self = [super initWithFrame:frame];
    if (self)
    {
        self.block               = block;
        self.backgroundColor     = kWhiteFFFFFF;
        self.layer.cornerRadius  = 6;
        self.layer.borderWidth   = 1;
        self.layer.masksToBounds = YES;
        self.layer.borderColor   = [UIColor clearColor].CGColor;
        [self setUpViewIsBlueTopColor:(BOOL)isBlue
                    comfirmTitle:comfirmTitle];
    }
    return self;
}

- (void)setUpViewIsBlueTopColor:(BOOL)isBlue comfirmTitle:(NSString *)comfirmTitle
{
    UIImage *image;
    NSString *title;
    if (!isBlue) {
        image = [UIImage imageNamed:kLocalized(@"gycom_redTop")];
    }
    else
    {
    image = [UIImage imageNamed:kLocalized(@"gycom_blueTop")];
    }
    
    title = kLocalized(@"GYHS_Account_Reminder");

    //这个是上面的GYHS_Account_Reminder 头标题位置
    UIImageView *hsIconImageView = [[UIImageView alloc] initWithImage:image];
    hsIconImageView.userInteractionEnabled = YES;
    hsIconImageView.multipleTouchEnabled   = YES;
    hsIconImageView.backgroundColor        = kWhiteFFFFFF;
    [self addSubview:hsIconImageView];
    @weakify(self);
    [hsIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self);//测试
        make.height.equalTo(@(kTitleImageHeight + 10)); //???????ui数据有点异常
    }];

    //显示GYHS_Account_Reminder 几个字
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text      = title;
    titleLabel.textColor = kWhiteFFFFFF;

    titleLabel.font      = kFont34;
    [hsIconImageView addSubview:titleLabel]; //加在上面的图层上面
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.left.equalTo(hsIconImageView.mas_left).offset(60);
        make.centerY.equalTo(hsIconImageView).offset(-4);
        make.width.equalTo(@(85));
        make.height.equalTo(@(15));
    }];
    //显示小叉叉 表示取消 可以退回去
    UIButton *forkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forkButton.contentMode     = UIViewContentModeCenter;
    forkButton.backgroundColor = [UIColor clearColor];
    [forkButton setImage:[UIImage imageNamed:kLocalized(@"gycom_forkButton")]
                forState:UIControlStateNormal];
    [forkButton addTarget:self
                   action:@selector(cancelAct)
         forControlEvents:UIControlEventTouchUpInside];
    [hsIconImageView addSubview:forkButton];
    [forkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.top.equalTo(hsIconImageView).offset(7);
        make.height.equalTo(@26);
        make.right.equalTo(hsIconImageView.mas_right).offset(-10);
        make.width.equalTo(@26);
    }];

    //自定义的第一个
    UIView *errorView = [[UIView alloc] init];//WithFrame:CGRectMake(kLetfwidth, kTopSpacewidth + hsIconImageView.bounds.size.height, kLabelWidthMax, kLabelHeightMax)]
    [self addSubview:errorView];
    
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(hsIconImageView.mas_bottom);
    }];
    
    
    UILabel *textLabel = [[UILabel alloc] init];
    [errorView addSubview:textLabel];
    textLabel.text            = comfirmTitle;
    textLabel.textColor       = kGray333333;
    textLabel.font            = kFont32;
    textLabel.backgroundColor = [UIColor clearColor];
    CGSize textLabelSize = [self giveLabelWith:textLabel.font
                                      nsstring:textLabel.text];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(textLabelSize.height));
        make.width.equalTo(@(textLabelSize.width + 1));
        make.top.equalTo(hsIconImageView.mas_bottom).offset(kDeviceProportion(30));
        make.centerX.equalTo(errorView.mas_centerX);

    }];

    //下面的 确定按钮
    UIButton *comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButton.backgroundColor = kRedE50012;
    [comfirmButton setTitle:kLocalized(@"GYHS_Account_Determine")
                   forState:UIControlStateNormal];
    comfirmButton.titleLabel.font    = kFont32;
    comfirmButton.layer.cornerRadius = 6;
    comfirmButton.layer.borderWidth  = 1;
    comfirmButton.layer.borderColor  = kWhiteFFFFFF.CGColor;
    [comfirmButton addTarget:self
                      action:@selector(comfimAct)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:comfirmButton];
    [comfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
        make.centerX.equalTo(errorView.mas_centerX);
        make.top.equalTo(textLabel.mas_bottom).offset(kDeviceProportion(30));

        make.height.equalTo(@(kButtonHeight));
        make.width.equalTo(@(kButtonWidth));
    }];
}

#pragma mark-----其他自定义方法
//点击小叉叉 回到原来的视图
- (void)cancelAct
{
    [self disMiss];
}

//点击确定提交后的动作
- (void)comfimAct
{
    if (self.block)
    {
        self.block();  //从block中去执行
        [self disMiss];
    }
}

//显示透明大背景
- (void)show
{
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMainHeadHeight, kScreenWidth, kScreenHeight - kMainHeadHeight)];
    backImageView.userInteractionEnabled = YES;

    backImageView.backgroundColor = kMaskViewColor;

    self.backImageView = backImageView;
    CGPoint point = backImageView.center;
    point.y    -= 120;
    self.center = point;
    [backImageView addSubview:self];
    [[UIApplication sharedApplication].keyWindow
     addSubview:backImageView];
    ;
}

//返回前界面
- (void)disMiss
{
    if (self.backImageView)
    {
        [self.backImageView removeFromSuperview];
    }
}

- (void)dealloc
{
    DDLogInfo(@"dealloc");
}

#pragma mark-----自定义的方法
//给一个label的字符串 返回自适应文本宽高
- (CGSize)giveLabelWith:(UIFont *)fnt nsstring:(NSString *)string
{
    UILabel *label = [[UILabel alloc] init];
    label.text = string;
    return [label.text
            sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil]];
}

@end
