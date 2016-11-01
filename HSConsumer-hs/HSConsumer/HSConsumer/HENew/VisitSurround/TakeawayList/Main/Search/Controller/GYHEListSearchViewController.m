//
//  GYHEListSearchViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEListSearchViewController.h"
#import "UIView+CustomBorder.h"
#import "GYEasybuySearchDetailViewController.h"
#import "MJRefresh.h"
#import "PopoverView.h"
#import "Masonry.h"
#import "GYAlertView.h"

#define kSearchCell @"searchCell"
#define kGoodsUserDefault @"searchGoodsHistoryArray"
#define kShopsUserDefault @"searchShopsHistoryArray"

@interface GYHEListSearchViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tabView;
@property (nonatomic, strong) NSMutableArray* searchHistoryArray;

@property (nonatomic, copy) NSString* keyUserDefault;
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) UIButton* changeSearchTypeBtn;

@end

@implementation GYHEListSearchViewController

#pragma mark - 生命周期
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"互生" forKey:@"vshopName"];
    [dict setObject:@"1" forKey:@"currentPageIndex"];
    [dict setObject:@"10" forKey:@"pageSize"];
    if (globalData.selectedCityCoordinate) {
        [dict setObject:globalData.selectedCityCoordinate forKey:@"landmark"];
    } else {
        [dict setObject:[NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude] forKey:@"landmark"];
    }
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kshopControllerFindVShopsUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject[@"data"];
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self pushToNextVCWithSave];
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    CGRect rect = self.tabView.frame;
    rect.size.height = self.searchHistoryArray.count * 40 + 40;
    if (rect.size.height > kScreenHeight - 64) {
        rect.size.height = kScreenHeight - 64;
    }
    self.tabView.frame = rect;
    return self.searchHistoryArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSearchCell forIndexPath:indexPath];
    if (self.searchHistoryArray.count > indexPath.row) {
        cell.textLabel.text = self.searchHistoryArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.searchHistoryArray.count > indexPath.row) {
        self.textField.text = self.searchHistoryArray[indexPath.row];
        [self pushToNextVCWithSave];
    }
}

#pragma mark - 点击事件
- (void)back:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)keyboardDone
{
    [self.view endEditing:YES];
}

//清空历史记录
- (void)clearHistory
{
    [self.searchHistoryArray removeAllObjects];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.searchHistoryArray forKey:self.keyUserDefault];
    [ud synchronize];
    [self.tabView reloadData];
}

//商铺商品
- (void)changSearchType:(UIButton*)sender
{
    CGPoint point = CGPointMake(100, 65);
    NSArray* titles = @[ kLocalized(@"GYHE_Easybuy_goods"), kLocalized(@"GYHE_Easybuy_shops") ];
    NSArray* images = @[ @"gyhe_prow_shop", @"gyhe_prow_goods" ];
    PopoverView* pop = [[PopoverView alloc] initWithPoint:point titles:titles images:images];
    WS(weakSelf);
    pop.selectRowAtIndex = ^(NSInteger index) {
        weakSelf.searchType = index == 0 ? kGoods : kShops;
        weakSelf.textField.placeholder = (weakSelf.searchType == kGoods) ? kLocalized(@"GYHE_Easybuy_pleaseEnterSearchGoods") : kLocalized(@"GYHE_Easybuy_pleaseEnterSearchShops");
        if (kScreenWidth < 325 && [weakSelf.textField.placeholder isEqualToString:kLocalized(@"GYHE_Easybuy_pleaseEnterSearchShops")]) {
            [self.textField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        }
        weakSelf.searchHistoryArray = nil;
        if(titles.count <= index) {
            return ;
        }
        [weakSelf.changeSearchTypeBtn setTitle:titles[index] forState:UIControlStateNormal];
        [weakSelf.tabView reloadData];
    };
    [pop show];
}

- (void)tfEditing:(UITextField*)sender
{
    if (sender.text.length > 100) {
        [GYUtils showToast:kLocalized(@"GYHE_Easybuy_maxLengthIs100")];
        sender.text = [sender.text substringToIndex:100];
    }
}

//跳转下个控制器，并将搜索数据存到本地
- (void)pushToNextVCWithSave
{
    NSCharacterSet* doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSString* str = [[self.textField.text componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString:@""];
    if (self.textField.text.length == 0 || str.length == 0) {
        NSString* msg = _searchType == kGoods ? kLocalized(@"GYHE_Easybuy_pleaseEnterSearchGoods") : kLocalized(@"GYHE_Easybuy_pleaseEnterSearchShop");
        [self.textField resignFirstResponder];
        [GYUtils showMessage:msg];
        return;
    }
    [self saveData];
    [self.view endEditing:YES];
    GYEasybuySearchDetailViewController* vc = [[GYEasybuySearchDetailViewController alloc] init];
    vc.keyWord = self.textField.text;
    vc.searchType = _searchType;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

//存数据
- (void)saveData
{
    for (int i = 0; i < self.searchHistoryArray.count; i++) {
        if ([self.searchHistoryArray[i] isEqualToString:self.textField.text]) {
            [self.searchHistoryArray removeObject:self.searchHistoryArray[i]];
        }
    }
    [self.searchHistoryArray insertObject:self.textField.text atIndex:0];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.searchHistoryArray forKey:self.keyUserDefault];
    [ud synchronize];
    [self.tabView reloadData];
}

#pragma mark - 自定义方法
- (void)setNav
{
    UIButton* btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 30);
    btnBack.imageEdgeInsets = UIEdgeInsetsMake(6, 5, 6, 23);
    btnBack.backgroundColor = [UIColor clearColor];
    [btnBack setImage:[UIImage imageNamed:@"gyhe_nav_btn_redback"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    UIButton* btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, 40, 30);
    btnSearch.imageEdgeInsets = UIEdgeInsetsMake(6, 5, 6, 23);
    btnSearch.backgroundColor = [UIColor clearColor];
    [btnSearch setTitle:kLocalized(@"GYHE_Easybuy_search") forState:UIControlStateNormal];
    [btnSearch setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(pushToNextVCWithSave) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    self.navigationItem.titleView = [self titleView];
}
- (UIView*)titleView
{
    UIView* vHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    vHead.backgroundColor = [UIColor whiteColor];
    UIView* vTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, kScreenWidth - 130, 32)];
    vTitleView.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    UIButton* btnChooseType = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChooseType.frame = CGRectMake(0, 0, 50, 32);
    btnChooseType.backgroundColor = [UIColor clearColor];
    btnChooseType.titleLabel.textColor = [UIColor colorWithRed:160.0 / 255.0F green:160.0 / 255.0F blue:160.0 / 255.0F alpha:1.0f];
    btnChooseType.titleLabel.font = [UIFont systemFontOfSize:14];
    NSString* str = _searchType == kGoods ? kLocalized(@"GYHE_Easybuy_goods") : kLocalized(@"GYHE_Easybuy_shops");
    [btnChooseType setTitle:str forState:UIControlStateNormal];
    [btnChooseType setImage:[UIImage imageNamed:@"gyhe_prow_trigon.png"] forState:UIControlStateNormal];
    [btnChooseType setImageEdgeInsets:UIEdgeInsetsMake(13, 44, 13, -6)];
    [btnChooseType setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnChooseType.frame.size.width + 32, 0, 5)];
    [btnChooseType setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnChooseType addTarget:self action:@selector(changSearchType:) forControlEvents:UIControlEventTouchUpInside];
    self.changeSearchTypeBtn = btnChooseType;
    UITextField* tfInputSearchText = [[UITextField alloc] initWithFrame:CGRectMake(60, 4, CGRectGetWidth(vTitleView.frame) - 60, 25)];
    tfInputSearchText.contentMode = UIViewContentModeScaleToFill;
    tfInputSearchText.returnKeyType = UIReturnKeySearch;
    tfInputSearchText.delegate = self;
    tfInputSearchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfInputSearchText.enablesReturnKeyAutomatically = YES;
    tfInputSearchText.textColor = [UIColor colorWithRed:95.0 / 255.0f green:95.0 / 255.0f blue:95.0 / 255.0f alpha:1.0f];
    tfInputSearchText.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    [tfInputSearchText addTarget:self action:@selector(tfEditing:) forControlEvents:UIControlEventEditingChanged];
    [vTitleView addSubview:btnChooseType];
    [vTitleView addSubview:tfInputSearchText];
    tfInputSearchText.placeholder = kLocalized(@"GYHE_Easybuy_pleaseEnterSearchGoods");
    tfInputSearchText.font = [UIFont systemFontOfSize:14];
    self.textField = tfInputSearchText;
    [vHead addSubview:vTitleView];
    return vHead;
}

- (void)addClearView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_food_clearHistory"]];
    UILabel* lab = [[UILabel alloc] init];
    lab.text = kLocalized(@"GYHE_Easybuy_clearSearchHistory");
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor grayColor];
    UIButton* btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:imgView];
    [view addSubview:lab];
    [view addSubview:btn];
    [imgView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(view);
        make.centerX.equalTo(view).with.offset(-50);
        make.width.height.mas_equalTo(20);
    }];
    [lab mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(view);
        make.left.mas_equalTo(imgView.mas_right).with.offset(15);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.bottom.equalTo(view);
    }];
    [view addTopBorder];
    _tabView.tableFooterView = view;
}
- (void)setUp
{
    [self.view addSubview:self.tabView];
    [self addClearView];
    [_tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSearchCell];
    [_tabView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray*)searchHistoryArray
{
    if (!_searchHistoryArray) {
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        NSArray* arr = [ud objectForKey:self.keyUserDefault];
        _searchHistoryArray = [[NSMutableArray alloc] initWithArray:arr];
    }
    return _searchHistoryArray;
}

- (NSString*)keyUserDefault
{
    if (_searchType == kGoods) {
        return kGoodsUserDefault;
    }
    else if (_searchType == kShops) {
        return kShopsUserDefault;
    }
    return nil;
}
- (UITableView*)tabView
{
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.rowHeight = 40;
    }
    return _tabView;
}

@end
