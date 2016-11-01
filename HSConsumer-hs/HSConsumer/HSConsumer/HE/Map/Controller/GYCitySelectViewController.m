//
//  GYCitySelectViewController.m
//  HSConsumer
//
//  Created by apple on 15-2-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "GYMapLocationViewController.h"
#import "GYCitySelectViewController.h"
#import "GYCityInfo.h"

#import "GYCitySelectTvHeader.h"
#import "GYPinYinConvertTool.h"
#import "GYseachhistoryModel.h"
#import "ChineseStringModel.h"
#import "GYGIFHUD.h"
#import "GYLocationManager.h"

#define kKeyForsearchHistoryCity @"searchHistoryCity"
@interface GYCitySelectViewController () <GYMapLocationViewControllerDelegate>

@end

@implementation GYCitySelectViewController

    {

    __weak IBOutlet UIView* vTopView; //顶端View

    // __weak IBOutlet UITableView *tvCityTableView; //城市tableview

    IBOutlet UITableView* tvCityTableView;
    __weak IBOutlet UIButton* btnSearch;

    __weak IBOutlet UITextField* tfInputCityName;

    GYCitySelectTvHeader* header;

    UIView* vTemp;

    UISearchBar* mySearchBar;

    UISearchDisplayController* searchDisplayController;

    NSMutableArray* searchResults;

    NSArray* arr;
    NSMutableArray* mutabArrhisty;
    //    //字母
    //    NSArray *letterArr;
    NSMutableDictionary* dichity;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //      mutabArrhisty=[[NSMutableArray alloc]init];
    //    mutabArrhisty =[self loadBrowsingHistoryandType];
    //
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dichity = [NSMutableDictionary dictionary];
    //    [self deleteBrowsingHistory:nil andForKey:kKeyForsearchHistoryCity andAll:YES];
    mutabArrhisty = [[NSMutableArray alloc] init];
    //数组初始化
    self.indexMarr = [[NSMutableArray alloc] init];
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        tvCityTableView.frame = CGRectMake(0, 55, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 55 - 30 - 30 - 10);
    }
    else {
        tvCityTableView.frame = CGRectMake(0, 55, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 55);
    }

    self.view.backgroundColor = kDefaultVCBackgroundColor;
    //self.title=@"选择城市";
    arr = [NSMutableArray array];
    self.marrDatasource = [NSMutableArray array];
    header = [GYCitySelectTvHeader headerView];
    mutabArrhisty = [self loadBrowsingHistoryandType];
    header.histyArry = mutabArrhisty;
    tvCityTableView.tableHeaderView = header;

    vTopView.hidden = YES;
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];

    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:kLocalized(@"GYHE_SurroundVisit_PleaseInputCityOrPinYin")];

    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    if (kIS_IOS8ORLATER) {
        searchDisplayController.active = NO;
    }

    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mySearchBar];
    NSArray* arrBtn = [NSArray arrayWithObjects:header.btn1, header.Btn2, header.Btn3, header.Btn4, header.Btn5, header.Btn6, header.Btn7, header.Btn8, header.Btn9, header.BtnLocationCity, nil];
    for (int i = 0; i < 10; i++) {
        [arrBtn[i] addTarget:self action:@selector(btnHotCity:) forControlEvents:UIControlEventTouchUpInside];
    }
    /////循环
    NSArray* arrhithBtn = [NSArray arrayWithObjects:header.Btn10, header.Btn11, header.Btn12, header.Btn13, header.Btn14, nil];
    if (mutabArrhisty.count > 0) {
        for (int j = 0; j < mutabArrhisty.count; j++) {
            [arrhithBtn[j] addTarget:self action:@selector(btnHotCity:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    [GYGIFHUD show];

    [[GYLocationManager sharedInstance] reverseAdress:^(NSString* cityName, NSString* address) {
        [GYGIFHUD dismiss];
        
        if ([cityName hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
            cityName = [cityName substringToIndex:cityName.length-1];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:16.0],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            CGSize sizeToFit = [cityName boundingRectWithSize:CGSizeMake(69, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
            CGRect btnFrame = header.BtnLocationCity.frame;
            btnFrame.size.width = sizeToFit.width > 69 ? sizeToFit.width : 69;
            header.BtnLocationCity.frame = btnFrame;
        }
        
        if ([cityName hasSuffix:kLocalized(@"GYHE_SurroundVisit_CityAndArea")]) {
            NSRange range = [cityName rangeOfString:kLocalized(@"GYHE_SurroundVisit_City")];
            if (range.location != NSNotFound) {
                cityName = [cityName substringToIndex:range.location];
            }
        }
        [header setLocationBtn:cityName];
    }];

    [self modifyName];
    [self readLocalData];
}

- (void)modifyName
{
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"gycommon_search_gray"] forState:UIControlStateNormal];
    tfInputCityName.placeholder = kLocalized(@"GYHE_SurroundVisit_PleaseInputCityOrPinYin");
}

- (void)setBtnWithTitle:(NSString*)titile WithBackgroundColor:(UIColor*)color WithBoderWidth:(CGFloat)width WithButton:(UIButton*)sender
{
    [sender setTitle:titile forState:UIControlStateNormal];
    [sender setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];

    sender.layer.masksToBounds = YES;
    sender.layer.borderWidth = width;
    sender.layer.cornerRadius = 1.0;
    sender.layer.borderColor = kCellItemTitleColor.CGColor;
}

- (void)readLocalData
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"cityLists" ofType:@"txt"];

    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary* tempDic in dict[@"data"]) {
        GYCityInfo* cityModel = [[GYCityInfo alloc] init];
        cityModel.strAreaName = tempDic[@"areaName"];
        cityModel.strAreaCode = tempDic[@"areaCode"];
        cityModel.strAreaType = tempDic[@"areaType"];
        cityModel.strAreaParentCode = tempDic[@"parentCode"];
        cityModel.strAreaSortOrder = tempDic[@"sortOrder"];
        cityModel.strEnName = tempDic[@"enName"];
        cityModel.strEnName = [cityModel.strEnName lowercaseString];
        [self.marrDatasource addObject:cityModel];
    }

    //获取索引
    NSMutableArray* result = [[NSMutableArray alloc] initWithArray:[self getIndexArr:self.marrDatasource]];
    [self.marrDatasource removeAllObjects];
    self.marrDatasource = result;
}

//返回索引数组
- (NSArray*)getIndexArr:(NSArray*)marr
{
    // modify songjk 改变左边索引取值为 strEnName的首字母
    NSMutableArray* nameMarr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < marr.count; i++) {
        GYCityInfo* cityModel = marr[i];
        [nameMarr addObject:cityModel];
        //        [nameMarr addObject:cityModel.strAreaName];
    }
    NSMutableArray* stringsToSort = [[NSMutableArray alloc] initWithArray:nameMarr];

    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray* chineseStringsArray = [NSMutableArray array];
    for (int i = 0; i < [stringsToSort count]; i++) {
        GYCityInfo* cityModel = stringsToSort[i];
        ChineseStringModel* chineseString = [[ChineseStringModel alloc] init];
        //        chineseString.string=[NSString stringWithString:[stringsToSort objectAtIndex:i]];
        chineseString.string = cityModel.strAreaName;
        chineseString.pinYin = [cityModel.strEnName substringToIndex:1];
        if (chineseString.string == nil) {
            chineseString.string = @"";
            chineseString.pinYin = @"";
        }

        //        if(![chineseString.string isEqualToString:@""]){
        //            NSString *pinYinResult=[NSString string];
        //            for(int j=0;j<chineseString.string.length;j++){
        //                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
        //
        //                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
        //            }
        //            chineseString.pinYin=pinYinResult;
        //        }else{
        //            chineseString.pinYin=@"";
        //        }
        [chineseStringsArray addObject:chineseString];
    }

    //按照拼音首字母对这些Strings进行排序
    NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];

    //
    self.chineseString = [NSMutableArray arrayWithArray:chineseStringsArray];

    NSString* firstLetter;
    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableArray* section;
    for (NSInteger i = 0; i < chineseStringsArray.count; i++) {
        NSString* string = [[chineseStringsArray[i] pinYin] substringToIndex:1];
        if ([firstLetter isEqualToString:string]) {
            if (section == nil) {
                section = [[NSMutableArray alloc] init];
            }
            else {
            }
            [section addObject:[chineseStringsArray[i] string]];
        }
        else {
            if (section != nil && section.count != 0) {
                [data addObject:section];
            }
            else {
            }
            section = [[NSMutableArray alloc] init];
            firstLetter = string;
            [section addObject:[chineseStringsArray[i] string]];
            [self.indexMarr addObject:string];
        }
        if (i == chineseStringsArray.count - 1) {
            [data addObject:section];
        }
        else {
        }
    }
    for (NSInteger i = 0; i < data.count; i++) {
        for (NSInteger j = 0; j < [data[i] count]; j++) {
            for (NSInteger m = 0; m < marr.count; m++) {
                GYCityInfo* cityModel = marr[m];
                if ([data[i][j] isEqualToString:cityModel.strAreaName]) {
                    data[i][j] = cityModel;
                    break;
                }
            }
        }
    }

    return data;
}

- (void)getCity:(NSString*)CityTitle getIsLocation:(NSString*)location
{
    if (_delegate && [_delegate respondsToSelector:@selector(getCity:WithType:)]) {
        NSString* city = CityTitle;
        if (![city hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
            city = [city stringByAppendingString:kLocalized(@"GYHE_SurroundVisit_City")];
        }
        //add by zhangqy 保存用户选择的城市
        GlobalData* data = globalData;
        data.selectedCityName = city;
        data.selectedCityCoordinate = location;
        [_delegate getCity:city WithType:1];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)btnHotCity:(id)sender
{
    UIButton* btnTemp = (UIButton*)sender;
    [self goMap:btnTemp.titleLabel.text];
}

////跳转新的地图页面
- (void)goMap:(NSString*)city
{
    GYMapLocationViewController* mapview = [[GYMapLocationViewController alloc] init];
    mapview.delegate = self;
    mapview.city = city;
    mapview.isCao = NO;
    [self presentViewController:mapview animated:YES completion:nil];
}

#pragma mark DataSourceDelegate
//添加
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return self.marrDatasource.count;
}

//索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    return self.indexMarr;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }
    return [self.marrDatasource[section] count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    }
    return 30;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    }
    return self.indexMarr[section];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0f;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        }
        GYCityInfo* cityModel = nil;
        if (searchResults.count > indexPath.row) {
            cityModel = searchResults[indexPath.row];
        }
        cell.textLabel.text = cityModel.strAreaName;
    }
    else {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        }
        GYCityInfo* cityModel = self.marrDatasource[indexPath.section][indexPath.row];
        cell.textLabel.text = cityModel.strAreaName;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == tvCityTableView) {
        GYCityInfo* cityModel = self.marrDatasource[indexPath.section][indexPath.row];
        [self saveBrowsingHistory:cityModel.strAreaName];
        if (_delegate && [_delegate respondsToSelector:@selector(getCity:WithType:)]) {
            [_delegate getCity:cityModel.strAreaName WithType:1];
            //add by zhangqy 保存用户选择的城市
            [self goMap:cityModel.strAreaName];
            //            GlobalData *data = globalData;
            //            data.selectedCityName = cityModel.strAreaName;
            //            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        GYCityInfo* cityModel = nil;
        if (searchResults.count > indexPath.row) {
            cityModel = searchResults[indexPath.row];
        }
        [self saveBrowsingHistory:cityModel.strAreaName];
        if (_delegate && [_delegate respondsToSelector:@selector(getCity:WithType:)]) {
            [_delegate getCity:cityModel.strAreaName WithType:1];
            [self goMap:cityModel.strAreaName];
            //add by zhangqy 保存用户选择的城市
            //            GlobalData *data = globalData;
            //            data.selectedCityName = cityModel.strAreaName;
            //            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark 查询所有的历史记录
- (NSMutableArray*)loadBrowsingHistoryandType
{
    NSString* key = kKeyForsearchHistoryCity;
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    dichity = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
    DDLogDebug(@"%@", dichity);
    NSMutableArray* arrgg = [[NSMutableArray alloc] init];
    for (NSString* key in [dichity allKeys]) {
        NSDictionary* dic = dichity[key];
        GYseachhistoryModel* model = [[GYseachhistoryModel alloc] init];
        model.name = [dic objectForKey:@"name"];
        model.time = [dic objectForKey:@"time"];
        [arrgg addObject:model];
    }
    NSMutableArray* sortedArray = (NSMutableArray*)[arrgg sortedArrayUsingComparator:^NSComparisonResult(GYseachhistoryModel* p1, GYseachhistoryModel* p2) { //倒序
        return [p2.time compare:p1.time];
    }];
    return sortedArray;
}

#pragma mark 保存搜索历史记录
- (void)saveBrowsingHistory:(NSString*)name
{
    if ([name isEqualToString:@""] || [name isKindOfClass:[NSNull class]]) {
    }
    else {
        NSString* key = kKeyForsearchHistoryCity;
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        dichity = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
        /////先查询当前的值是否已存在
        //        NSDictionary *dicname = [userDefault objectForKey:key];
        for (NSString* keyname in [dichity allKeys]) {
            if ([keyname isEqualToString:name]) {
                [self deleteBrowsingHistory:keyname andForKey:key andAll:NO];
            }
        }
        if (mutabArrhisty.count == 3) {
            GYseachhistoryModel* model = [[GYseachhistoryModel alloc] init];
            model = [mutabArrhisty lastObject];
            NSString* keyname = model.name;
            [self deleteBrowsingHistory:keyname andForKey:key andAll:NO];
        }

        GYseachhistoryModel* model = [[GYseachhistoryModel alloc] init];
        model.time = @([[NSDate date] timeIntervalSince1970]);
        model.name = name;
        NSDictionary* dictype = @{ @"name" : model.name,
            @"time" : model.time };
        [dichity setObject:dictype forKey:name];
        [userDefault setObject:dichity forKey:key];
        [userDefault synchronize];
        mutabArrhisty = [self loadBrowsingHistoryandType];
        [tvCityTableView reloadData];
    }
}

#pragma mark 删除历史记录
- (void)deleteBrowsingHistory:(NSString*)string andForKey:(NSString*)key andAll:(BOOL)cler;
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    dichity = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
    if (cler) {
        [dichity removeAllObjects];
    }
    else {
        [dichity removeObjectForKey:string];
    }
    [userDefault setObject:dichity forKey:key];
    [userDefault synchronize];
    mutabArrhisty = [self loadBrowsingHistoryandType];
}

#pragma mark textfield代理方法。
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    return YES;
}

//

#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField*)textField;
{

    vTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    vTemp.backgroundColor = [UIColor colorWithRed:192.0 / 255 green:192.0 / 255 blue:192.0 / 255 alpha:0.3];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenTempView)];
    [vTemp addGestureRecognizer:tap];
    [self.view addSubview:vTemp];
}

- (void)hidenTempView
{
    if (vTemp) {
        [vTemp removeFromSuperview];
    }

    [tfInputCityName resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    [self hidenTempView];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{

    //    if (!searchResults) {
    searchResults = [[NSMutableArray alloc] init];
    //    }

    if ([GYUtils isBlankString:searchText]) {
        return;
    }
    NSMutableArray* resultArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.marrDatasource.count; i++) {
        for (NSInteger j = 0; j < [self.marrDatasource[i] count]; j++) {
            [resultArr addObject:self.marrDatasource[i][j]];
        }
    }

    if (mySearchBar.text.length > 0) {
        for (GYCityInfo* model in resultArr) {

            if ([GYUtils isIncludeChineseInString:searchText]) {
                //把中文转换为拼音
                //                NSString *searchBarPinYinStr = [GYPinYinConvertTool chineseConvertToPinYinHead:mySearchBar.text];
                //                NSString *datasourcePinYinStr = [GYPinYinConvertTool chineseConvertToPinYinHead:model.strAreaName];
                NSString* datasourcePinYinStr = model.strAreaName;
                if (datasourcePinYinStr.length >= 2) {
                    //                    NSRange titleResult=[[datasourcePinYinStr substringToIndex:2 ] rangeOfString:searchBarPinYinStr options:NSCaseInsensitiveSearch];
                    NSRange titleResult = [[datasourcePinYinStr substringFromIndex:0] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length > 0) {
                        [searchResults addObject:model];
                    }
                }

            } //没有中文来到这里
            else {
                mySearchBar.text = [mySearchBar.text lowercaseString]; // 改成小写
                //                NSString *datasourcePinYinStr = [GYPinYinConvertTool chineseConvertToPinYinHead:model.strAreaName];
                NSString* datasourcePinYinStr = [GYPinYinConvertTool chineseConvertToPinYin:model.strAreaName];
                //add by songjk 拼音的头字母
                NSString* datasourcePinYinHeadStr = [GYPinYinConvertTool chineseConvertToPinYinHead:model.strAreaName];
                //                NSRange titleResult=[[datasourcePinYinStr substringToIndex:1 ] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                //                NSRange titleResult=[[datasourcePinYinStr substringFromIndex:0] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                // modify by songjk 重第一个字符开始查
                //                NSRange titleResult=[[datasourcePinYinStr substringFromIndex:0] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                BOOL isHave = [[datasourcePinYinStr substringFromIndex:0] hasPrefix:mySearchBar.text];
                if (isHave) {
                    [searchResults addObject:model];
                }
                else {
                    isHave = [[datasourcePinYinHeadStr substringFromIndex:0] hasPrefix:mySearchBar.text];
                    if (isHave) {
                        [searchResults addObject:model];
                    }
                }
                NSString* strPin = datasourcePinYinStr;
                if (!isHave) {
                    NSString* firstPin = [mySearchBar.text substringToIndex:1];
                    if ([model.strEnName rangeOfString:firstPin].location != NSNotFound) {
                        NSRange range = NSMakeRange(0, 1);
                        datasourcePinYinHeadStr = [datasourcePinYinHeadStr stringByReplacingCharactersInRange:range withString:model.strEnName];
                        isHave = [[datasourcePinYinHeadStr substringFromIndex:0] hasPrefix:mySearchBar.text];
                        if (isHave) {
                            [searchResults addObject:model];
                        }
                        else {
                            strPin = [strPin stringByReplacingCharactersInRange:range withString:model.strEnName];
                        }
                    }
                }
                if (!isHave) {
                    isHave = [[strPin substringFromIndex:0] hasPrefix:mySearchBar.text];
                    if (isHave) {
                        [searchResults addObject:model];
                    }
                }
                if (!isHave) {
                    strPin = datasourcePinYinStr;
                    if ([strPin rangeOfString:@"shamen"].location != NSNotFound) {
                        strPin = [strPin stringByReplacingOccurrencesOfString:@"shamen" withString:@"xiamen"];
                    }
                    isHave = [[strPin substringFromIndex:0] hasPrefix:mySearchBar.text];
                    if (isHave) {
                        [searchResults addObject:model];
                    }
                }
            }

        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {

    if (searchBar.text.length > 0) {
        [self.searchDisplayController.searchResultsTableView reloadData];

        [self.searchDisplayController.searchBar resignFirstResponder];
    }


}

@end
