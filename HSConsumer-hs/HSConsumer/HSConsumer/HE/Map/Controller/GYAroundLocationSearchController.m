//
//  GYAroundLocationSearchController.m
//  HSConsumer
//
//  Created by Apple03 on 15/11/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAroundLocationSearchController.h"
#import "GYCityInfo.h"
#import "GYPinYinConvertTool.h"
#import "GYMapLocationViewController.h"

@interface GYAroundLocationSearchController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GYMapLocationViewControllerDelegate>
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* marrDatasource;
@property (nonatomic, strong) NSMutableArray* marrHistory;
@property (nonatomic, strong) NSMutableArray* marrData;
@property (nonatomic, weak) UITextField* tfSearch;
@property (nonatomic, strong) NSOperationQueue* opQueue;
@end

@implementation GYAroundLocationSearchController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (NSOperationQueue*)opQueue
{
    if (!_opQueue) {
        _opQueue = [[NSOperationQueue alloc] init];
        _opQueue.maxConcurrentOperationCount = 1;
    }
    return _opQueue;
}

- (NSMutableArray*)marrData
{
    if (!_marrData) {
        _marrData = [NSMutableArray array];
    }
    return _marrData;
}

- (NSMutableArray*)marrDatasource
{
    if (!_marrDatasource) {
        _marrDatasource = [NSMutableArray array];
    }
    return _marrDatasource;
}

- (NSMutableArray*)marrHistory
{
    if (!_marrHistory) {
        _marrHistory = [NSMutableArray array];
    }
    return _marrHistory;
}

- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self getHistory];
    if (globalData.selectedCityName) {
        self.title = globalData.selectedCityName;
    }
    else {
        self.title = globalData.locationCity;
    }

    CGFloat vsearchH = 106; //75
    UIView* vSearch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, vsearchH)];
    vSearch.backgroundColor = kCorlorFromHexcode(0xEEEEEE); //kBackGroundColor
    [self.view addSubview:vSearch];
    //gycommon_nav_search
    UITextField* tfSearch = [[UITextField alloc] init];
    tfSearch.textAlignment = NSTextAlignmentLeft;
    tfSearch.placeholder = kLocalized(@"GYHE_SurroundVisit_EnterCityName_OrPinYinQuery");
    tfSearch.frame = CGRectMake(15, 15, kScreenWidth - 30, 44);
    tfSearch.font = [UIFont systemFontOfSize:17];
    tfSearch.textColor = kCorlorFromHexcode(0xD2D2D2);
    tfSearch.enabled = YES;
    tfSearch.userInteractionEnabled = YES;
    tfSearch.delegate = self;
    tfSearch.backgroundColor = [UIColor whiteColor];
    tfSearch.returnKeyType = UIReturnKeySearch;
    tfSearch.enablesReturnKeyAutomatically = YES;
    tfSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfSearch.borderStyle = UITextBorderStyleRoundedRect;
    tfSearch.leftViewMode = UITextFieldViewModeAlways;
    tfSearch.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIImageView* imgSearch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_search_gray"]];
    imgSearch.frame = CGRectMake(20, 0, 15, 15);
    UIView* searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 15)];
    [searchView addSubview:imgSearch];
    tfSearch.leftView = searchView;
    [tfSearch addTarget:self action:@selector(seachChange:) forControlEvents:UIControlEventEditingChanged];
    [vSearch addSubview:tfSearch];
    self.tfSearch = tfSearch;

    UILabel* lbResult = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tfSearch.frame) + 20, 100, 17)];
    lbResult.backgroundColor = [UIColor clearColor];
    lbResult.textColor = kCellItemTextColor;
    lbResult.font = [UIFont systemFontOfSize:17];
    lbResult.text = kLocalized(@"GYHE_SurroundVisit_SearchResult");
    [vSearch addSubview:lbResult];

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(vSearch.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(vSearch.frame) - 64)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;

    [self readLocalData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tfSearch becomeFirstResponder];
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
}

#pragma mark UITextFieldDelegate
- (void)seachChange:(UITextField*)sender
{
    if (sender.text.length > 0) {
        [self searchWihtName:sender.text];
    }
    else {
        [self.marrData removeAllObjects];
        [self.tableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    DDLogDebug(@"return");
    [textField resignFirstResponder];
    [self searchWihtName:textField.text];
    return YES;
}

- (void)searchWihtName:(NSString*)strName
{
    if ([GYUtils isBlankString:strName]) {
        return;
    }
    if (strName.length > 0) {
        [self.opQueue cancelAllOperations];
        NSBlockOperation* bo = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_sync(dispatch_get_main_queue(), ^{
//
//                [GYGIFHUD show];
                [self.marrData removeAllObjects];
                [self.tableView reloadData];
            });
            for (GYCityInfo *model in self.marrDatasource) {
                if ([GYUtils isIncludeChineseInString:model.strAreaName]) {
                    if ([GYUtils isIncludeChineseInString:strName]) {
                        NSString *datasourcePinYinStr = model.strAreaName;
                        if (datasourcePinYinStr.length >= 2) {
                            //                    NSRange titleResult=[[datasourcePinYinStr substringToIndex:2 ] rangeOfString:searchBarPinYinStr options:NSCaseInsensitiveSearch];
                            NSRange titleResult = [[datasourcePinYinStr substringFromIndex:0] rangeOfString:strName options:NSCaseInsensitiveSearch];
                            if (titleResult.length > 0) {
                                if (![self.marrData containsObject:model]) {
                                    [self.marrData addObject:model];
                                }
                            }
                        }


                    } //没有中文来到这里
                    else {
                        NSString *name = [strName lowercaseString]; // 改成小写
                        NSString *datasourcePinYinStr = [GYPinYinConvertTool chineseConvertToPinYin:model.strAreaName];
                        //add by songjk 拼音的头字母
                        NSString *datasourcePinYinHeadStr = [GYPinYinConvertTool chineseConvertToPinYinHead:model.strAreaName];
                        BOOL isHave = [[datasourcePinYinStr substringFromIndex:0] hasPrefix:name ];
                        if (isHave) {
                            if (![self.marrData containsObject:model]) {
                                [self.marrData addObject:model];
                            }
                        } else {
                            isHave = [[datasourcePinYinHeadStr substringFromIndex:0] hasPrefix:name ];
                            if (isHave) {
                                if (![self.marrData containsObject:model]) {
                                    [self.marrData addObject:model];
                                }
                            }
                        }
                        NSString *strPin = datasourcePinYinStr;
                        if (!isHave) {
                            NSString *firstPin = [name substringToIndex:1];
                            if ([model.strEnName rangeOfString:firstPin].location != NSNotFound) {
                                NSRange range = NSMakeRange(0, 1);
                                datasourcePinYinHeadStr = [datasourcePinYinHeadStr stringByReplacingCharactersInRange:range withString:model.strEnName];
                                isHave = [[datasourcePinYinHeadStr substringFromIndex:0] hasPrefix:name ];
                                if (isHave) {
                                    if (![self.marrData containsObject:model]) {
                                        [self.marrData addObject:model];
                                    }
                                } else {
                                    strPin = [strPin stringByReplacingCharactersInRange:range withString:model.strEnName];
                                }
                            }
                        }
                        if (!isHave) {
                            isHave = [[strPin substringFromIndex:0] hasPrefix:name ];
                            if (isHave) {
                                if (![self.marrData containsObject:model]) {
                                    [self.marrData addObject:model];
                                }
                            }
                        }
                        if (!isHave) {
                            strPin = datasourcePinYinStr;
                            if ([strPin rangeOfString:@"shamen"].location != NSNotFound) {
                                strPin = [strPin stringByReplacingOccurrencesOfString:@"shamen" withString:@"xiamen"];
                            }
                            isHave = [[strPin substringFromIndex:0] hasPrefix:name];
                            if (isHave) {
                                if (![self.marrData containsObject:model]) {
                                    [self.marrData addObject:model];
                                }
                            }
                        }
                    }

                }
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
//                [GYGIFHUD dismiss];
            });
        }];
        [self.opQueue addOperation:bo];
        //        dispatch_queue_t queue = dispatch_queue_create("searchLocation", DISPATCH_QUEUE_SERIAL);
        //        dispatch_async(queue, ^{
        //        });
    }
}

#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrData.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 45;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    if (indexPath.row < [self.marrData count]) {
        GYCityInfo* cityModel = self.marrData[indexPath.row];

        NSMutableAttributedString* attString = [self getAttstringWithString:cityModel];
        if (attString && attString.length > 0) {
            cell.textLabel.attributedText = attString;
        }
        else {

            cell.textLabel.textColor = kCellItemTitleColor;
            cell.textLabel.text = cityModel.strAreaName;
        }
    }

    cell.textLabel.font = [UIFont systemFontOfSize:17];
    return cell;
}

- (NSMutableAttributedString*)getAttstringWithString:(GYCityInfo*)cityModel
{
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:cityModel.strAreaName];
    NSRange range = [cityModel.strAreaName rangeOfString:self.tfSearch.text];
    if (range.location == NSNotFound) {
        NSString* name = [self.tfSearch.text lowercaseString];
        //add by songjk 拼音的头字母
        NSString* datasourcePinYinHeadStr = [GYPinYinConvertTool chineseConvertToPinYinHead:cityModel.strAreaName];
        datasourcePinYinHeadStr = [datasourcePinYinHeadStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[cityModel.strEnName substringToIndex:1]];
        range = [datasourcePinYinHeadStr rangeOfString:name];
        if (range.location == NSNotFound) {
            NSInteger length = 0;
            for (int i = 0; i < cityModel.strAreaName.length; i++) {
                NSString* oneStr = [cityModel.strAreaName substringWithRange:NSMakeRange(i, 1)];
                NSString* pinYinOne = [GYPinYinConvertTool chineseConvertToPinYin:oneStr];
                length += pinYinOne.length;
                if (name.length <= length) {
                    range = NSMakeRange(0, i + 1);
                    break;
                }
            }
        }
    }
    // 改变匹配的颜色
    NSRange rangeALL = NSMakeRange(0, cityModel.strAreaName.length);
    [attString addAttribute:NSForegroundColorAttributeName value:kCellItemTitleColor range:rangeALL];
    [attString addAttribute:NSForegroundColorAttributeName value:kNavigationBarColor range:range];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rangeALL];
    return attString;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (([self.marrData count] <= 0) || (indexPath.row > [self.marrData count])) {
        DDLogDebug(@"The indexPath row:%ld is more than dataAry count:%ld", indexPath.row, [self.marrData count]);
        return;
    }

    GYCityInfo* cityModel = nil;
    if (self.marrData.count > indexPath.row) {
        cityModel = self.marrData[indexPath.row];
    }
    [self saveHistoryWithCity:cityModel.strAreaName];

    GYMapLocationViewController* newview = [[GYMapLocationViewController alloc] init];
    newview.delegate = self;
    newview.city = cityModel.strAreaName;
    [self saveHistoryWithCity:newview.city];
    newview.isLocagtion = NO;
    newview.isCao = NO;
    [self presentViewController:newview animated:YES completion:nil];
}

#pragma mark - GYMapLocationViewControllerDelegate
- (void)getCity:(NSString*)CityTitle getIsLocation:(NSString*)location
{
    globalData.selectedCityName = CityTitle;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 保存历史
- (void)saveHistoryWithCity:(NSString*)city
{
    if (kSaftToNSString(city).length == 0) {
        return;
    }

    GlobalData* data = globalData;
    data.selectedCityName = city;
    for (NSString* strCity in self.marrHistory) {
        if ([strCity isEqualToString:city]) {
            return;
        }
    }
    if (self.marrHistory.count < kHistoryCount) {
        [self.marrHistory addObject:city];
        [[NSUserDefaults standardUserDefaults] setObject:self.marrHistory forKey:kHistoryKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [self.marrHistory removeObjectAtIndex:0];
        [self.marrHistory addObject:city];
        [[NSUserDefaults standardUserDefaults] setObject:self.marrHistory forKey:kHistoryKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)getHistory
{
    self.marrHistory = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kHistoryKey]];
}

@end
