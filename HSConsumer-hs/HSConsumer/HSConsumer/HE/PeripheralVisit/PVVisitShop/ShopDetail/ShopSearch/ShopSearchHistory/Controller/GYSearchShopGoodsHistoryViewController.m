//
//  GYSearchShopGoodsHistoryViewController.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//
#define GYSearchShopGoodsHistoryUserDefaultsKey @"GYSearchShopGoodsHistoryUserDefaultsKey"
#import "GYSearchShopGoodsHistoryViewController.h"
#import "UIButton+GYExtension.h"

// songjk cell大小可变
#import "GYsearchHistoryCell.h"
#import "GYsearchHistoryFrameModel.h"
#import "GYseachhistoryModel.h"

@interface GYSearchShopGoodsHistoryViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) UITextField* searchField;
@property (strong, nonatomic) UIBarButtonItem* leftBtn;
@property (strong, nonatomic) NSMutableArray* searchHistory;
@property (strong, nonatomic) UIButton* clearBtn;
@property (assign, nonatomic) CGRect keyboardFrame;

// songjk
@property (strong, nonatomic) NSMutableArray* marrHistory;
@end

@implementation GYSearchShopGoodsHistoryViewController

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNav];
    [_searchField becomeFirstResponder];
    NSArray* history = [[NSUserDefaults standardUserDefaults] objectForKey:GYSearchShopGoodsHistoryUserDefaultsKey];
    if (history) {
        _searchHistory = [NSMutableArray arrayWithArray:history];
        for (int i = 0; i < _searchHistory.count; i++) {
            GYseachhistoryModel* historyModel = [[GYseachhistoryModel alloc] init];
            historyModel.name = _searchHistory[i];
            GYsearchHistoryFrameModel* model = [[GYsearchHistoryFrameModel alloc] init];
            model.model = historyModel;
            [self.marrHistory addObject:model];
        }
    }
    else {
        _searchHistory = [NSMutableArray array];
    }
    NSNotificationCenter* defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _clearBtn.frame = CGRectMake(kScreenWidth / 2 - 50, 0, 100, 30);
    _clearBtn.layer.cornerRadius = 2;
    _clearBtn.layer.borderWidth = 1;
    _clearBtn.layer.borderColor = [UIColor redColor].CGColor;
    _clearBtn.clipsToBounds = YES;
    [_clearBtn setTitle:kLocalized(@"GYHE_SurroundVisit_ClearHistory") forState:UIControlStateNormal];
    [_clearBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clearBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_clearBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [_clearBtn setBorderWithWidth:1 / [UIScreen mainScreen].scale andRadius:5.0f andColor:kNavigationBarColor];

    UIView* clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    clearView.backgroundColor = [UIColor whiteColor];
    CGPoint center = clearView.center;
    _clearBtn.center = center;
    [clearView addSubview:self.clearBtn];
    self.tableView.tableFooterView = clearView;
    [self.tableView registerClass:[GYsearchHistoryCell class] forCellReuseIdentifier:kGYsearchHistoryCell];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (kSystemVersionLessThan(@"7.0")) { //ios < 7.0
        //设置Navigation颜色
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    else {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (kSystemVersionLessThan(@"7.0")) { //ios < 7.0
        //设置Navigation颜色
        self.navigationController.navigationBar.tintColor = kNavigationBarColor;
    }
    else {
        self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (str.length > 100) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self searchBtnClicked:nil];
    return YES;
}

- (void)searchBtnClicked:(UIBarButtonItem*)btn
{
    [_searchField resignFirstResponder];
    NSString* keyword = _searchField.text;
    if (keyword && keyword.length > 0) {
        int k = 0;
        for (; k < _searchHistory.count; k++) {
            NSString* str = _searchHistory[k];
            if ([str isEqualToString:keyword]) {
                break;
            }
        }
        if (k >= _searchHistory.count) {
            [_searchHistory addObject:keyword];
            [[NSUserDefaults standardUserDefaults] setObject:_searchHistory forKey:GYSearchShopGoodsHistoryUserDefaultsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];

            for (int i = 0; i < _searchHistory.count; i++) {
                GYseachhistoryModel* historyModel = [[GYseachhistoryModel alloc] init];
                historyModel.name = _searchHistory[i];
                GYsearchHistoryFrameModel* model = [[GYsearchHistoryFrameModel alloc] init];
                model.model = historyModel;
                [self.marrHistory addObject:model];
            }
            
            [self.tableView reloadData];
        }
        [[self.delegate params] setObject:keyword forKey:@"keyword"];
    }
    else {
        [[self.delegate params] setObject:@"" forKey:@"keyword"];
    }
    
    [[self.delegate params] setObject:@"" forKey:@"categoryName"];
    if(self.delegate) {
        [self.delegate loadDataAll];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 40; //暂时统一返回40的高度 孙秋明
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrHistory.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    int row = (int)indexPath.row;
    int count = (int)self.marrHistory.count;
    GYsearchHistoryCell* cell = [GYsearchHistoryCell cellWithTableView:tableView];
    GYsearchHistoryFrameModel* model = self.marrHistory[count - row - 1];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = (int)indexPath.row;
    int count = (int)self.marrHistory.count;
    GYsearchHistoryFrameModel* model = self.marrHistory[count - row - 1];
    _searchField.text = model.model.name;
    
    [self searchButtonClick];
}

- (void)clearBtnClicked:(UIButton*)btn
{
    [_searchHistory removeAllObjects];
    [self.marrHistory removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GYSearchShopGoodsHistoryUserDefaultsKey];
    [self.tableView reloadData];
}

- (void)tfEditing:(UITextField*)sender
{
    if (sender.text.length > 100) {
        sender.text = [sender.text substringToIndex:100];
    }
}


#pragma mark 事件
- (void)keyboardWillShow:(NSNotification*)noti
{
    _keyboardFrame = [[noti.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, _keyboardFrame.origin.y - 40 - 64);
}

- (void)keyboardWillHidden:(NSNotification*)noti
{
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 180);
}

- (void)backBtnClicked:(UIButton*)btn
{
    [_searchField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 自定义方法
- (void)setupNav
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"gyhd_nav_leftView_back"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 20, 20);
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    _leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = _leftBtn;
    [btn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalized(@"GYHE_SurroundVisit_Search") style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonClick)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 38)];
    _searchField.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1.0f];
    UIImageView* leftSearchIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 12)];
    leftSearchIV.image = [UIImage imageNamed:@"gycommon_search_gray"];
    leftSearchIV.contentMode = UIViewContentModeScaleAspectFit;
    _searchField.leftView = leftSearchIV;
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    _searchField.font = [UIFont systemFontOfSize:16.0];
    
    _searchField.textColor = [UIColor grayColor];
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.placeholder = kLocalized(@"GYHE_SurroundVisit_SearchStoreGoods");
    _searchField.keyboardType = UIKeyboardTypeDefault;
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.delegate = self;
    [_searchField addTarget:self action:@selector(tfEditing:) forControlEvents:UIControlEventEditingChanged];
    [self.navigationItem.leftBarButtonItem setTintColor:kNavigationTitleColor];
    self.navigationItem.titleView = _searchField;
    
}

- (void)searchButtonClick
{
    [self searchBtnClicked:nil];
}

#pragma mark 懒加载
- (NSMutableArray*)marrHistory
{
    if (!_marrHistory) {
        _marrHistory = [NSMutableArray array];
    }
    return _marrHistory;
}


@end
