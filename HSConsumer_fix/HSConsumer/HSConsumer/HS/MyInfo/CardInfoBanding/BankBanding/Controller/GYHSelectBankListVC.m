//
//  GYBankListViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSelectBankListVC.h"
#import "GYPinYinConvertTool.h"
#import "GYHSRequestData.h"
#import "GYHSConstant.h"

#define DEFAULTKEYS [self.nameDictionary.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
#define ALPHA_ARRAY [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil]



@interface GYHSelectBankListVC ()

@property (nonatomic, strong) GYHSRequestData* requestData;

@end

#pragma mark - life cycle
@implementation GYHSelectBankListVC {
    __weak IBOutlet UITableView* tvBankList;
    UISearchBar* mySearchBar;
    UISearchDisplayController* searchDisplayController;
    NSMutableArray* searchResults;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = kLocalized(@"GYHS_Banding_ChooseBank");
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    searchResults = [NSMutableArray array];

    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:kLocalized(@"GYHS_Banding_SearchBank")];
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    
    if (kIS_IOS8ORLATER) {
        searchDisplayController.active = NO;
    }
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    tvBankList.tableHeaderView = mySearchBar;
    tvBankList.dataSource = self;
    tvBankList.delegate = self;
    if ([self.marrBankList count] <= 0) {
        WS(weakSelf)
        self.requestData = [[GYHSRequestData alloc] init];
        [GYGIFHUD show];
        [self.requestData queryBankList:^(NSArray* resultArray) {
            [GYGIFHUD dismiss];
            [weakSelf.marrBankList addObjectsFromArray:resultArray];
            [weakSelf addDataWithSouces:weakSelf.marrBankList withDic:weakSelf.nameDictionary ];
            [tvBankList reloadData];
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }

    return DEFAULTKEYS.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }
    else {
        NSArray* arr = [self.nameDictionary objectForKey:DEFAULTKEYS[section]];

        if (arr) {
            return arr.count;
        }
        else {
            return 0;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (indexPath.row < searchResults.count) {
            GYHSBankListModel* mod = searchResults[indexPath.row];
            cell.textLabel.text = mod.bankName;
        }
    }
    else {
        NSArray* arr = [self.nameDictionary objectForKey:DEFAULTKEYS[indexPath.section]];
        if (indexPath.row < arr.count) {

            GYHSBankListModel* mod = arr[indexPath.row];
            cell.textLabel.text = mod.bankName;
        }
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1.0;
    }

    return 30.0;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == tvBankList) {
        NSArray* arr = [self.nameDictionary objectForKey:DEFAULTKEYS[section]];

        if (arr) {
            if (section == 0) {
                DDLogDebug(@"%lu=bbbbb", (unsigned long)arr.count);
            }
            return DEFAULTKEYS[section];
        }
        else {
            return nil;
        }
    }

    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView  {

    if(tvBankList == tableView) {
        return DEFAULTKEYS;
    }
    return nil;
}

#pragma UISearchDisplayDelegate
- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    searchResults = [[NSMutableArray alloc] init];

    if ([GYUtils checkStringInvalid:searchText]) {
        return;
    }
    
    if (mySearchBar.text.length > 0) {
        
        NSMutableArray* marrtest = [NSMutableArray array];
        [marrtest addObjectsFromArray:[self.nameDictionary allValues]];
        for (NSArray* arr in marrtest) {
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                GYHSBankListModel *model = obj;
                
                
                if([GYUtils isIncludeChineseInString:searchText]) {
                    if([model.bankName containsString:searchText]) {
                        [searchResults addObject:model];
                    }
                }else {
                    
                    NSMutableString *allPinYin = [[NSMutableString alloc] initWithString:[GYPinYinConvertTool chineseConvertToPinYin:model.bankName]];
                    NSMutableString *headPinYin =[[NSMutableString alloc] initWithString:[GYPinYinConvertTool chineseConvertToPinYinHead:model.bankName]];
                    [allPinYin lowercaseString];
                    [headPinYin lowercaseString];
                    NSString *searchStr = [searchText lowercaseString];
                    if([allPinYin hasSuffix:@"xing"]) {
                        NSRange range = NSMakeRange(allPinYin.length-4, 4);
                        [allPinYin replaceCharactersInRange:range withString:@"hang"];
                    }
                    
                    if([headPinYin hasSuffix:@"x"]) {
                        NSRange range = NSMakeRange(headPinYin.length-1, 1);
                        [headPinYin replaceCharactersInRange:range withString:@"h"];
                    }
                    
                    if([model.bankName hasPrefix:@"重"]) {
                        NSRange range = NSMakeRange(0, 5);
                        [allPinYin replaceCharactersInRange:range withString:@"chong"];
                        range = NSMakeRange(0, 1);
                        [headPinYin replaceCharactersInRange:range withString:@"c"];
                    }else if ([model.bankName hasPrefix:@"长"]) {
                        NSRange range = NSMakeRange(0, 5);
                        [allPinYin replaceCharactersInRange:range withString:@"chang"];
                        range = NSMakeRange(0, 1);
                        [headPinYin replaceCharactersInRange:range withString:@"c"];
                    }else if ([model.bankName hasPrefix:@"厦"]) {
                        NSRange range = NSMakeRange(0, 3);
                        [allPinYin replaceCharactersInRange:range withString:@"xia"];
                        range = NSMakeRange(0, 1);
                        [headPinYin replaceCharactersInRange:range withString:@"x"];
                    }
                    
                    if([allPinYin containsString:searchStr] || [headPinYin containsString:searchStr]) {
                        [searchResults addObject:model];
                    }
                    
                }
                
            }];
        }
    }

}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {

        GYHSBankListModel* mod = nil;
        if (searchResults.count > indexPath.row) {
            mod = searchResults[indexPath.row];
        }

        if (_delegate && [_delegate respondsToSelector:@selector(getSelectBank:selectIndexPath:)]) {
            [_delegate getSelectBank:mod selectIndexPath:self.selectIndexPath];
        }
    }
    else {
        NSArray* arr = [self.nameDictionary objectForKey:DEFAULTKEYS[indexPath.section]];

        if (_delegate && [_delegate respondsToSelector:@selector(getSelectBank:selectIndexPath:)]) {
            GYHSBankListModel* mod = nil;
            if (arr.count > indexPath.row) {
                mod = arr[indexPath.row];
            }
            [_delegate getSelectBank:mod selectIndexPath:self.selectIndexPath];
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - private methods
- (void)addDataWithSouces:(NSArray*)array withDic:(NSMutableDictionary*)dictionary
{
    if ([dictionary.allKeys count] != 0) {
        [dictionary removeAllObjects];
    }
    
    
    for (NSString* string in ALPHA_ARRAY) {
        NSMutableArray* temp = [[NSMutableArray alloc] init];
        BOOL realExist = NO;
        
        for (GYHSBankListModel* mod in array) {
            
            NSString* tempStr = [NSString string];
            
            if ([GYUtils isIncludeChineseInString:mod.bankName]) {
                if([mod.bankName hasPrefix:@"重"]||[mod.bankName hasPrefix:@"长"]) {
                    tempStr = @"c";
                }else if ([mod.bankName hasPrefix:@"厦"]) {
                    tempStr = @"x";
                }else {
                    tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:mod.bankName];
                }
                
                if ([tempStr hasPrefix:string] || [tempStr hasPrefix:[string lowercaseString]]) {
                    [temp addObject:mod];
                    realExist = YES;
                }
            }
            else {
                tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:mod.bankName];
                
                if ([tempStr hasPrefix:string] || [tempStr hasPrefix:[string lowercaseString]]) {
                    [temp addObject:mod];
                    
                    realExist = YES;
                }
            }
        }
        if (realExist) {
            [dictionary setObject:temp forKey:string];
        }
    }

}

#pragma mark - getter and setter
- (NSMutableArray*)marrBankList
{
    if (!_marrBankList) {
        _marrBankList = [[NSMutableArray alloc] init];
    }
    return _marrBankList;
}

- (NSMutableDictionary*)nameDictionary
{
    if (!_nameDictionary) {
        _nameDictionary = [[NSMutableDictionary alloc] init];
    }
    return _nameDictionary;
}

@end
