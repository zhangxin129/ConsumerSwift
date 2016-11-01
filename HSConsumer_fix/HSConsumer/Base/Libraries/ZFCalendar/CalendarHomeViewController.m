//
//  CalendarHomeViewController.m
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

#import "CalendarHomeViewController.h"
#import "Color.h"

@interface CalendarHomeViewController () {

    int daynumber; //天数
    int optiondaynumber; //选择日期数量
    //    NSMutableArray *optiondayarray;//存放选择好的日期对象数组
}

@end

@implementation CalendarHomeViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置方法

//飞机初始化方法
- (void)setAirPlaneToDay:(int)day ToDateforString:(NSArray*)noclickdates andbegDate:(NSString*)beging andEnddate:(NSString*)end andClickDate:(NSString*)clickDate
{
    daynumber = day;
    optiondaynumber = 1; //选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:noclickdates andbegin:beging andend:end andClickDate:clickDate];
    [super.collectionView reloadData]; //刷新
}

//酒店初始化方法
- (void)setHotelToDay:(int)day ToDateforString:(NSString*)todate
{

    //    daynumber = day;
    //    optiondaynumber = 2;//选择两个后返回数据对象
    //    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    //    [super.collectionView reloadData];//刷新
}

//火车初始化方法
- (void)setTrainToDay:(int)day ToDateforString:(NSString*)todate
{
    //    daynumber = day;
    //    optiondaynumber = 1;//选择一个后返回数据对象
    //    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    //    [super.collectionView reloadData];//刷新
}

#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray*)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSArray*)noclicksDate andbegin:(NSString*)begin andend:(NSString*)end andClickDate:(NSString*)clickDate
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [formatter dateFromString:begin];
    NSDate* selectdate = [formatter dateFromString:clickDate];

    //    if (noclicksDate) {
    //
    //        selectdate = [selectdate dateFromString:noclicksDate];
    //
    //    }

    super.Logic = [[CalendarLogic alloc] init];

    return [super.Logic reloadCalendarView:date selectDate:selectdate needDays:day andClickdates:noclicksDate];
}

#pragma mark - 设置标题

- (void)setCalendartitle:(NSString *)calendartitle {

    [self.navigationItem setTitle:calendartitle];

}

@end
