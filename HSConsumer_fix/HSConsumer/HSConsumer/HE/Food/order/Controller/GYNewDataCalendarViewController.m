//
//  ViewController.m
//  Newdate
//
//  Created by appleliss on 15/12/14.
//  Copyright © 2015年 appleliss. All rights reserved.
//

#define COLOR_THEME1 (kNavigationBarColor) //大红色
#define COLOR_THEME ([UIColor colorWithRed:26 / 256.0 green:168 / 256.0 blue:186 / 256.0 alpha:1]) //去哪儿绿
#import "GYNewDataCalendarViewController.h"
#import "GYDateCollectionViewCell.h"
#import "GYTimeDate.h"
#import "GYTimes.h"
#import "GYTimeCollectionViewCell.h"
#import "CalendarHomeViewController.h"
#import "CalendarViewController.h"
@interface GYNewDataCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) NSInteger* index1;
@property (nonatomic, strong) GYDateCollectionViewCell* myCo;
@property (nonatomic, strong) NSMutableArray* selectArray;
@property (nonatomic, strong) CalendarHomeViewController* chvc;
@property (nonatomic, strong) NSDictionary* dic;
@property (nonatomic, strong) NSMutableArray* dateNewArray;
@property (nonatomic, strong) NSMutableArray* dateNewArrayNoShop;
@property (nonatomic, assign) int days; ////计算出有多少天
@property (nonatomic, strong) NSString* selectDate; ////计算出有多少天
@property (nonatomic, strong) NSString* selectTime; ///得到当前选中的具体时间
@property (nonatomic, strong) NSString* updateSelectDate; ///最后确认的时间
@property (nonatomic, strong) NSDateFormatter* inputFormatter;
@property (nonatomic, strong) NSDateFormatter* nowinputFormatter;
@property (nonatomic, strong) NSMutableArray* dataMArr;
@property (nonatomic, strong) NSMutableArray* dataMArrShop;
@property (weak, nonatomic) IBOutlet UICollectionView* topDateCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView* TimesCollectionView;
//国际化
@property (weak, nonatomic) IBOutlet UILabel* moreLabel; //更多
@property (weak, nonatomic) IBOutlet UIButton* confirmSelectBtn; //确认选择

@end

@implementation GYNewDataCalendarViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = kLocalized(@"GYHE_Food_SelectTime");
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.moreLabel.text = kLocalized(@"GYHE_Food_More");
    [self.confirmSelectBtn setTitle:kLocalized(@"GYHE_Food_ConfirmSelect") forState:UIControlStateNormal];

    [self timeTurner];
    self.topDateCollectionView.backgroundColor = [UIColor whiteColor];
    [self.topDateCollectionView registerNib:[UINib nibWithNibName:@"GYDateCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"GYDateCollectionViewCell"];
    [self.TimesCollectionView registerNib:[UINib nibWithNibName:@"GYTimeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"GYTimeCollectionViewCell"];
    self.TimesCollectionView.showsVerticalScrollIndicator = NO;
}

#pragma mark 数据解析 时间
/**
 *  时间数据解析
 */
- (void)timeTurner
{
    _dataMArr = [NSMutableArray array];
    _selectArray = [NSMutableArray array];
    /////循环时间 将时间转换成两个数组
    _inputFormatter = [[NSDateFormatter alloc] init];
    [_inputFormatter setDateFormat:@"EEEE"];
    _nowinputFormatter = [[NSDateFormatter alloc] init];
    [_nowinputFormatter setDateFormat:@"yyyy-MM-dd"];
    /////取出时间放在一个字典里 然后再将时间进行一次排序
    _dic = self.dataTimes[0];
    NSDictionary* dicNoShop = self.dataTimesNoShop.count > 0 ? self.dataTimesNoShop[0] : nil;
    _dateNewArray = [NSMutableArray array];
    _dateNewArrayNoShop = [NSMutableArray array];
    if (dicNoShop != nil && dicNoShop.allKeys.count > 0) {
        for (NSString* dateNoShop in dicNoShop.allKeys) {
            [_dateNewArrayNoShop addObject:dateNoShop];
        }
    }
    for (int i = 0; i < _dic.allKeys.count; i++) {
        [_dateNewArray addObject:_dic.allKeys[i]];
    }
    _dateNewArray = (NSMutableArray*)[_dateNewArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (obj1 == [NSNull null]) {
            obj1 = @"0000-00-00";
        }
        if (obj2 == [NSNull null]) {
            obj2 = @"0000-00-00";
        }
        NSDate *date1 = [_nowinputFormatter dateFromString:obj1];
        NSDate *date2 = [_nowinputFormatter dateFromString:obj2];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedDescending;
    }];
    ///这里 排序出日期跟星期
    for (int i = 0; i < _dateNewArray.count; i++) {
        NSString* date = _dateNewArray[i];
        NSDate* inputdate = [_nowinputFormatter dateFromString:date];
        NSString* week = [_inputFormatter stringFromDate:inputdate];
        GYTimeDate* data = [[GYTimeDate alloc] init];
        data.date = date;
        data.week = week;

        if (i == self.datemark) {
            _selectDate = data.date;
            self.datemark = i;
            data.b = 100;
        }
        else
            data.b = 10;
        [_dataMArr addObject:data];
    }
    /// 这里得出最前一天的时间
    NSArray* timearr = _dic[_dateNewArray[0]];
    for (int index = 0; index < timearr.count; index++) {
        GYTimes* tb = [[GYTimes alloc] init];
        tb.time = timearr[index];
        if (index == self.timemark) {
            _selectTime = tb.time;
            self.timemark = index;
            tb.click = YES;
        }
        else
            tb.click = NO;
        [_selectArray addObject:tb];
    }
}

/**
 *  拿出两个日期之间的相隔的天数
 */
- (void)intervalSinceNow
{
    //创建日期格式化对象
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //创建了两个日期对象
    NSDate* date1 = [dateFormatter dateFromString:[_dateNewArray firstObject]];
    NSDate* date2 = [dateFormatter dateFromString:[_dateNewArray lastObject]];

    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval
    // 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    _days = ((int)time) / (3600 * 24);
}

- (IBAction)confirmSelectDate:(UIButton*)sender
{
    _updateSelectDate = [NSString stringWithFormat:@"%@ %@", _selectDate, _selectTime];
    if ([_gynewDataCalendarDelegate respondsToSelector:@selector(updateDate:andDatemark:andTimemark:)]) {
        [_gynewDataCalendarDelegate updateDate:_updateSelectDate andDatemark:self.datemark andTimemark:self.timemark];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 点击更多
- (IBAction)moreDate:(UITapGestureRecognizer*)sender
{
    [self click];
}

- (void)click
{
    [self intervalSinceNow];
    if (!_chvc) {
        _chvc = nil;
    }
    _chvc = [[CalendarHomeViewController alloc] init];
    _chvc.calendartitle = kLocalized(@"GYHE_Food_SelectDate");
    [_chvc setAirPlaneToDay:_days + 1 ToDateforString:_dateNewArrayNoShop andbegDate:[_dateNewArray firstObject] andEnddate:[_dateNewArray lastObject] andClickDate:_selectDate]; //飞机初始化方法

    __weak id SAFESELF = self;
    __block NSMutableArray* datem = [NSMutableArray arrayWithArray:_dataMArr];
    _chvc.calendarblock = ^(CalendarDayModel* model) {
        DDLogDebug(@"1星期 %@", [model getWeek]);
        DDLogDebug(@"2字符串 %@", [model toString]);
        DDLogDebug(@"3节日  %@", model.holiday);
        /////这里刷新控件
        //        NSString *date = [[model toString] substringFromIndex:5];
        int row = 0;
        for (int i = 0; i < datem.count; i++) {
            GYTimeDate *te = datem[i];
            te.b = 10;
            NSString *st = te.date;
            if ([st isEqualToString:[model toString]]) {
                te.b = 100;
                row = i;
            }
        }
        [SAFESELF clickDateUpdateTime:row];
        NSString *bu = @"";
        if (model.holiday) {
            bu = [NSString stringWithFormat:@"%@ %@ %@", [model toString], [model getWeek], model.holiday];
        } else {
            bu = [NSString stringWithFormat:@"%@ %@  ", [model toString], [model getWeek] ];
        }
    };
    [self.navigationController pushViewController:_chvc animated:YES];
}

/**
 *  选择的日期 去得到对应的时间
 *
 *  @param row 点击了行
 */
- (void)clickDateUpdateTime:(int)row
{
    [self.topDateCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [_selectArray removeAllObjects];
    GYTimeDate* dict = _dataMArr[row];
    DDLogDebug(@"%@", dict.date);
    for (int i = 0; i < _dataMArr.count; i++) {
        GYTimeDate* d = _dataMArr[i];
        if (i == row) {
            NSArray* newarr = _dic[d.date];

            for (int index = 0; index < newarr.count; index++) {
                GYTimes* tb = [[GYTimes alloc] init];
                tb.time = newarr[index];
                if (index == 0) {
                    tb.click = YES;
                    _selectTime = tb.time;
                    self.timemark = index;
                    DDLogDebug(@"%@", tb.time);
                }
                else {
                    tb.click = NO;
                }
                [_selectArray addObject:tb];
            }
            [_TimesCollectionView reloadData];
            d.b = 100;
            self.datemark = i;
            _selectDate = d.date;
        }
        else {
            d.b = 10;
        }
        [_dataMArr replaceObjectAtIndex:i withObject:d];
    }
    [_topDateCollectionView reloadData];
}

#pragma mark collection delegat
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    if (collectionView == _topDateCollectionView) {
        return 1;
    }
    else if (collectionView == _TimesCollectionView)
        return 1;
    else
        return 0;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _topDateCollectionView)
        return _dataMArr.count;
    else if (collectionView == _TimesCollectionView)
        return _selectArray.count;
    else
        return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (collectionView == _topDateCollectionView) {
        static NSString* CellIdentifier = @"GYDateCollectionViewCell";
        GYDateCollectionViewCell* cell = (GYDateCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        GYTimeDate* data = nil;
        if (_dataMArr.count > indexPath.row) {
            data = _dataMArr[indexPath.row];
        }
        if (data.b == 100) {
            cell.weekLabel.textColor = kNavigationBarColor;
            cell.dateLabel.textColor = kNavigationBarColor;
            cell.labline.hidden = NO;
        }
        else {
            cell.weekLabel.textColor = [UIColor colorWithRed:160.0 / 255 green:160.0 / 255 blue:160.0 / 255 alpha:1];
            cell.dateLabel.textColor = [UIColor colorWithRed:160.0 / 255 green:160.0 / 255 blue:160.0 / 255 alpha:1];
            cell.labline.hidden = YES;
        }
        cell.weekLabel.text = data.week;
        cell.dateLabel.text = [data.date substringFromIndex:5];
        return cell;
    }
    else if (collectionView == _TimesCollectionView) {
        static NSString* timeCell = @"GYTimeCollectionViewCell";
        GYTimeCollectionViewCell* cell = (GYTimeCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:timeCell forIndexPath:indexPath];
        GYTimes* tb = nil;
        if (_selectArray.count > indexPath.row) {
            tb = _selectArray[indexPath.row];
        }
        if (tb.click == YES) {
            cell.timeLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = kNavigationBarColor;
        }
        else {
            cell.timeLabel.textColor = [UIColor colorWithRed:160.0 / 255 green:160.0 / 255 blue:160.0 / 255 alpha:1];
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.timeLabel.text = tb.time;
        return cell;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == _TimesCollectionView)
        return UIEdgeInsetsMake(4, 4, 4, 4);
    else
        return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (collectionView == _topDateCollectionView) {
        [self clickDateUpdateTime:(int)indexPath.row];
    }
    else if (collectionView == _TimesCollectionView) {
        for (int i = 0; i < _selectArray.count; i++) {
            GYTimes* tb = _selectArray[i];
            if (i == indexPath.row) {
                tb.click = YES;
                _selectTime = tb.time;
                self.timemark = i;
                DDLogDebug(@"%@", tb.time);
            }
            else {
                tb.click = NO;
            }
            [_selectArray replaceObjectAtIndex:i withObject:tb];
        }
        [_TimesCollectionView reloadData];
    }
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
