//
//  GYHSReturnsHistogramVC.m
//
//  Created by 吴文超 on 16/8/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSReturnsHistogramVC.h"

//投资回报率
#import "GYHSAccountHttpTool.h"
#import "GYHSInvestDividendModel.h"
#import <MJExtension/MJExtension.h>
#import "HSCompanyPad-Bridging-Header.h"
#import "HScompanyPad-Swift.h"
#import <YYKit/NSArray+YYAdd.h>
#import "GYAlertShowDataWithOKButtonView.h"
#import "GYHSPublicMethod.h"
#define kCommonOffset kDeviceProportion(55) //下面的底部要减掉的
//首段的空白高度按150来
#define kFirstHeight kDeviceProportion(75)
//开始画线的左边间距200
#define kLeftDistance kDeviceProportion(100)
#define kRightDistance kDeviceProportion(20)



#define kEachHistogramFillColor kGreen008C00 //全部方柱的颜色
#define kRemoveNoMessage 1233
@interface GYHSReturnsHistogramVC ()<ChartViewDelegate,GYNetworkReloadDelete>

@property (nonatomic, strong) NSMutableArray *xArrM;
@property (nonatomic, strong) NSMutableArray *yArrM;
@property (nonatomic, strong)  BarChartView *chartView;
@end

@implementation GYHSReturnsHistogramVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - private methods
- (void)gyNetworkDidTapReloadBtn
{
    [self initView];
}
/**
 *  投资账户下画柱状图
 */
- (void)initView
{
    self.title                = kLocalized(@"GYHS_Account_Return_Over_The_Years");
    self.view.backgroundColor = kDefaultVCBackgroundColor;


    _chartView = [[BarChartView alloc]init];
    [self.view
     addSubview:_chartView];
    @weakify(self);
    [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(self.view).offset(80);
        make.bottom.right.equalTo(self.view).offset(-40);
    }];



    _chartView.descriptionText           = @"";
    _chartView.pinchZoomEnabled          = NO;
    _chartView.drawBarShadowEnabled      = NO;
    _chartView.drawGridBackgroundEnabled = NO;



    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition        = XAxisLabelPositionBottom;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.drawAxisLineEnabled  = NO;
    xAxis.labelTextColor       = kGray333333;
    xAxis.labelFont            = kFont32;



    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter)
    {
        barChartFormatter                       = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle           = NSNumberFormatterPercentStyle;
        barChartFormatter.allowsFloats          = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    _chartView.leftAxis.drawGridLinesEnabled  = YES;
    _chartView.leftAxis.spaceTop              = 30;
    _chartView.rightAxis.drawGridLinesEnabled = NO;
    _chartView.rightAxis.drawLabelsEnabled    = NO;
    _chartView.leftAxis.axisMinValue          = 0;
    _chartView.leftAxis.axisMaxValue          = 2;
    _chartView.leftAxis.labelCount            = 11;
    _chartView.leftAxis.labelTextColor        = kGray333333;
    _chartView.leftAxis.valueFormatter        = barChartFormatter;
    _chartView.leftAxis.labelFont             = kFont32;
    _chartView.dragEnabled                    = NO;
    _chartView.legend.enabled                 = NO;
    _chartView.scaleXEnabled                  = NO;
    _chartView.scaleYEnabled                  = NO;
    _chartView.dragDecelerationEnabled        = NO;



    [GYNetwork sharedInstance].delegate = self;
    [GYHSAccountHttpTool getDividendRateListWithTime:@""
                                            pageSize:@"100"
                                             curPage:@"1"
                                             success:^(id responsObject) {
        for (NSDictionary *d in responsObject)
        {
            GYHSInvestDividendModel *model = [GYHSInvestDividendModel mj_objectWithKeyValues:d];
            [self.xArrM
             addObject:model.dividendYear];
            [self.yArrM
             addObject:model.dividendRate];
        }
        [self.xArrM reverse];
        [self.yArrM reverse];
        [self setData];

    }
                                             failure:^{
    }];
}

/**
 *  数据设置
 */
- (void)setData
{
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    [self.yArrM
     enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:obj.doubleValue
                                                           xIndex:idx]];
    }];

    NSMutableArray *xVals  = @[].mutableCopy;
    NSMutableArray *colors = @[].mutableCopy;
    [self.xArrM
     enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [colors addObject:kGreen48d78c];
        [xVals addObject:obj];
    }];
//显示没有数据的提示
    UIView *view = [self.view
                    viewWithTag:kRemoveNoMessage];
    if (view)
    {
        [view removeFromSuperview];
    }
    if (self.xArrM.count == 0)
    {
        UIView *viewC = [GYHSPublicMethod addNoDataTipViewWithSuperView:_chartView];
        viewC.frame = _chartView.frame;
        @weakify(self);
        [viewC mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.view).offset(40);
            make.top.equalTo(self.view).offset(80);
            make.bottom.right.equalTo(self.view).offset(-40);
        }];
        viewC.tag = kRemoveNoMessage;
    }

    if (xVals.count < 7)
    {
        for (int i = 0; i < 7 - xVals.count; i++)
        {
            [xVals addObject:@""];
            [colors addObject:kGreen48d78c];
        }
    }
    BarChartDataSet *set1 = nil;
    set1                   = [[BarChartDataSet alloc] initWithYVals:yVals];
    set1.drawValuesEnabled = YES;
    set1.highlightEnabled  = NO;
    set1.colors            = colors;
    set1.valueFont         = kFont24;
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter)
    {
        barChartFormatter                       = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle           = NSNumberFormatterPercentStyle;
        barChartFormatter.allowsFloats          = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    set1.valueTextColor = kBlue0A59C1;
    set1.valueFormatter = barChartFormatter;
    set1.barBorderColor = [UIColor redColor];
    set1.barSpace       = 0.9;

    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];

    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals
                                                    dataSets:dataSets];


    _chartView.data = data;

    UILabel *xTip = [[UILabel alloc]init];
    xTip.backgroundColor = kClearColor;
    xTip.text            = kLocalized(@"GYHS_Account_Year_Sample");
    xTip.textColor       = kGray999999;
    xTip.font            = kFont32;

    [_chartView addSubview:xTip];
    [xTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(_chartView);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
    }];


    UILabel *yTip = [[UILabel alloc]init];
    yTip.backgroundColor = kClearColor;
    yTip.text            = kLocalized(@"GYHS_Account_Return_Sample");
    yTip.textColor       = kGray999999;
    yTip.font            = kFont32;
    [_chartView addSubview:yTip];
    [yTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_chartView);
        make.top.equalTo(_chartView).offset(-20);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];





    [_chartView setNeedsDisplay];
}

#pragma mark - lazy load


- (NSMutableArray *)xArrM
{
    if (!_xArrM)
    {
        _xArrM = @[].mutableCopy;
    }

    return _xArrM;
}

- (NSMutableArray *)yArrM
{
    if (!_yArrM)
    {
        _yArrM = @[].mutableCopy;
    }

    return _yArrM;
}

@end
