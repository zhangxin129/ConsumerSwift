//
//  GYHSSelectBankListViewController.m
//
//  Created by lizp on 16/9/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define DEFAULTKEYS [self.nameDictionary.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
#define ALPHA_ARRAY [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil]

#import "GYHSSelectBankListViewController.h"
#import "YYKit.h"
#import "GYHSSelectBankListCell.h"
#import "GYHSRequestData.h"
#import "GYHSBankListModel.h"
#import "GYPinYinConvertTool.h"
#import "IQKeyboardManager.h"
#import "GYHSTools.h"

@interface GYHSSelectBankListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;//数据源
@property (nonatomic,strong) UITextField *searchTextField;//输入框
@property (nonatomic,strong) UIView *overView;//背景
@property (nonatomic,strong) UIView *headerView;//头部
@property (nonatomic,strong) NSMutableDictionary* nameDictionary;
@property (nonatomic,strong) NSMutableArray *indexMarr;//索引数组
@property (nonatomic,strong) UIButton *dismissBtn;//取消按钮
@property (nonatomic,strong) NSMutableArray *searchResults;//搜索结果

@property (nonatomic, strong) GYHSRequestData* requestData;


@end

@implementation GYHSSelectBankListViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - SystemDelegate 
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}
#pragma mark TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if(self.searchTextField.text.length == 0) {
        return DEFAULTKEYS.count;
    }else {
        return 1;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(self.searchTextField.text.length == 0) {
        NSArray* arr = [self.nameDictionary objectForKey:DEFAULTKEYS[section]];
        if (arr) {
            return arr.count;
        }
        else {
            return 0;
        }
    }else {
        return self.searchResults.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GYHSSelectBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSSelectBankListCellIdentifier];
    if(!cell) {
        cell = [[GYHSSelectBankListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSSelectBankListCellIdentifier];
    }
    
    if(self.searchTextField.text.length == 0) {
        NSArray* arr = [self.nameDictionary objectForKey:DEFAULTKEYS[indexPath.section]];
        if (indexPath.row < arr.count) {
            
            GYHSBankListModel* mod = arr[indexPath.row];
            cell.titleLabel.text = mod.bankName;
        }
    }else {
        GYHSBankListModel* mod = self.searchResults[indexPath.row];
        cell.titleLabel.text = mod.bankName;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GYHSBankListModel* mod;
    if(self.searchTextField.text.length == 0) {
        NSArray* arr = [self.nameDictionary objectForKey:DEFAULTKEYS[indexPath.section]];
        if (indexPath.row < arr.count) {
            
            mod = arr[indexPath.row];
        }
    }else {
        mod = self.searchResults[indexPath.row];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectBank:)]) {
        
        [self.delegate didSelectBank:mod];
        [self dismiss];
        
    }
    
}


//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

//段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

//段头
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(self.searchTextField.text.length == 0) {
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
    }else {
        return nil;
    }
    
    
}

//索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    if(self.searchTextField.text.length == 0) {
        return self.indexMarr;
    }else {
        return nil;
    }
    
}


// #pragma mark - CustomDelegate
#pragma mark - event response 

//获取开户银行列表
-(void)loadNetWorkForBankList {
    
    WS(weakSelf)
    self.requestData = [[GYHSRequestData alloc] init];
    [GYGIFHUD show];
    [self.requestData queryBankList:^(NSArray* resultArray) {
        [GYGIFHUD dismiss];
        [weakSelf.dataSource addObjectsFromArray:resultArray];
        [weakSelf addDataWithSouces:weakSelf.dataSource withDic:weakSelf.nameDictionary ];
        [self.tableView reloadData];
    }];
}

//搜索框输入中
-(void)searchTextFieldEdting {
    
    self.searchResults = [[NSMutableArray alloc] init];
    if (self.searchTextField.text.length > 0) {
        
        NSMutableArray* marrtest = [NSMutableArray array];
        [marrtest addObjectsFromArray:[self.nameDictionary allValues]];
        for (NSArray* arr in marrtest) {
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                GYHSBankListModel *model = obj;
                if([GYUtils isIncludeChineseInString:self.searchTextField.text]) {
                    if([model.bankName containsString:self.searchTextField.text]) {
                        [self.searchResults addObject:model];
                    }
                }else {
                    
                    NSMutableString *allPinYin = [[NSMutableString alloc] initWithString:[GYPinYinConvertTool chineseConvertToPinYin:model.bankName]];
                    NSMutableString *headPinYin =[[NSMutableString alloc] initWithString:[GYPinYinConvertTool chineseConvertToPinYinHead:model.bankName]];
                    [allPinYin lowercaseString];
                    [headPinYin lowercaseString];
                    NSString *searchStr = [self.searchTextField.text lowercaseString];
                    if([allPinYin hasSuffix:@"xing"]) {
                        NSRange range = NSMakeRange(allPinYin.length-4, 4);
                        [allPinYin replaceCharactersInRange:range withString:@"hang"];
                    }
                    
                    if([headPinYin hasSuffix:@"x"]) {
                        NSRange range = NSMakeRange(headPinYin.length-1, 1);
                        [headPinYin replaceCharactersInRange:range withString:@"h"];
                    }
                    
                    if([model.bankName hasPrefix:kLocalized(@"GYHS_Cash_Chong")]) {
                        NSRange range = NSMakeRange(0, 5);
                        [allPinYin replaceCharactersInRange:range withString:@"chong"];
                        range = NSMakeRange(0, 1);
                        [headPinYin replaceCharactersInRange:range withString:@"c"];
                    }else if ([model.bankName hasPrefix:kLocalized(@"GYHS_Cash_Chang")]) {
                        NSRange range = NSMakeRange(0, 5);
                        [allPinYin replaceCharactersInRange:range withString:@"chang"];
                        range = NSMakeRange(0, 1);
                        [headPinYin replaceCharactersInRange:range withString:@"c"];
                    }else if ([model.bankName hasPrefix:kLocalized(@"GYHS_Cash_Xia")]) {
                        NSRange range = NSMakeRange(0, 3);
                        [allPinYin replaceCharactersInRange:range withString:@"xia"];
                        range = NSMakeRange(0, 1);
                        [headPinYin replaceCharactersInRange:range withString:@"x"];
                    }
                    
                    if([allPinYin containsString:searchStr] || [headPinYin containsString:searchStr]) {
                        [self.searchResults addObject:model];
                    }
                    
                }
                
            }];
        }
    }
    
    [self.tableView reloadData];

}

-(void)dismiss {

    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    [self addOverView];
   
    [self loadNetWorkForBankList];
    
    
    
}

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
                if([mod.bankName hasPrefix:kLocalized(@"GYHS_Cash_Chong")]||[mod.bankName hasPrefix:kLocalized(@"GYHS_Cash_Chang")]) {
                    tempStr = @"c";
                }else if ([mod.bankName hasPrefix:kLocalized(@"GYHS_Cash_Xia")]) {
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
            if(![self.indexMarr containsObject:string]) {
                [self.indexMarr addObject:string];
            }
        }
    }
    
}


-(void)addOverView {

    self.overView = [[UIView alloc] initWithFrame:CGRectMake(10, 64, kScreenWidth -20, kScreenHeight - 64-49 - 50)];
    self.overView.layer.cornerRadius = 5;
    self.overView.clipsToBounds = YES;
    self.overView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.overView];
    
    //叉叉按钮
    self.dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissBtn.frame = CGRectMake(kScreenWidth/2 -20, self.overView.bottom +20, 40, 40);
    [self.dismissBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_account_delete_view"] forState:UIControlStateNormal];
    [self.dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissBtn];
    
    [self addHeaderView];
}

//头部
-(void)addHeaderView {
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.overView.bounds.size.width, 87)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.overView.bounds.size.width, 30)];
    titleLabel.text = kLocalized(@"GYHS_Cash_Select_Open_Bank");
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:titleLabel];
    
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, titleLabel.width, 57)];
    backgroundView.backgroundColor = kDefaultVCBackgroundColor;
    [self.headerView addSubview:backgroundView];
    
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, titleLabel.width - 30, 40)];
    layerView.backgroundColor = UIColorFromRGB(0xffffff);
    layerView.layer.cornerRadius = 20;
    layerView.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    layerView.layer.borderWidth = 0.5;
    layerView.clipsToBounds = YES;
    [backgroundView addSubview:layerView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"gycommon_search_gray"];
    [layerView addSubview:imageView];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(imageView.right + 5, 0, titleLabel.width - imageView.right - 5 -15-20, 40)];
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.placeholder   = kLocalized(@"GYHS_Cash_Search_Bank");
    self.searchTextField.font = kSelectBankListCell;
    self.searchTextField.backgroundColor = UIColorFromRGB(0xffffff);
    [self.searchTextField addTarget:self action:@selector(searchTextFieldEdting) forControlEvents:UIControlEventEditingChanged];
    [layerView addSubview:self.searchTextField];
    
    [self.overView addSubview:self.headerView];
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.overView.width, self.overView.height-self.headerView.bottom) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[GYHSSelectBankListCell class] forCellReuseIdentifier:kGYHSSelectBankListCellIdentifier];
        [self.overView addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource {

    if(!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableDictionary*)nameDictionary
{
    if (!_nameDictionary) {
        _nameDictionary = [[NSMutableDictionary alloc] init];
    }
    return _nameDictionary;
}

-(NSMutableArray *)indexMarr {

    if(!_indexMarr) {
        _indexMarr = [[NSMutableArray alloc] init];
    }
    return _indexMarr ;
}

@end
