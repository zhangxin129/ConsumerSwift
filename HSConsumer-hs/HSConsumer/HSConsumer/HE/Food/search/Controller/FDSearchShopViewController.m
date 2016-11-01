//
//  FDSearchShopResultViewController.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define FDSearchFoodHistoryUserDefaultsKey @"GYSearchFoodHistoryUserDefaultsKey"
#define FDTakeawayCellReuseId @"FDSearchTakeawayCellReuseId"
#define HistoryCellReuseId @"historyCellReuseId"
#define FDMainCellReuseId @"FDMainCellReuseId"
#import "FDTakeawayMainCell.h"
#import "FDSearchShopViewController.h"
#import "FDShopModel.h"
#import "IQKeyboardManager.h"
#import "FDSelectFoodViewController.h"
#import "FDMainShopCell.h"
#import "GYGIFHUD.h"
@interface FDSearchShopViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView* noResultView;
@property (weak, nonatomic) IBOutlet UILabel* searchHistoryTipLabel;

@property (weak, nonatomic) IBOutlet UIView* clearView;
@property (weak, nonatomic) IBOutlet UITextField* searchTextField;
@property (weak, nonatomic) IBOutlet UIButton* searchBtn;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UITableView* historyTableView;
@property (strong, nonatomic) NSMutableArray* dataSource;
@property (strong, nonatomic) NSMutableArray* historyDataSource;
@property (copy, nonatomic) NSString* keyword;
//@property (assign, nonatomic)CGRect keyboardFrame;
@property (strong, nonatomic) NSMutableDictionary* params;
@property (assign, nonatomic) NSInteger currentPageIndex;
//国际化 add zhangx
@property (weak, nonatomic) IBOutlet UILabel* clearSearchDataLabel; //清空搜索记录
@property (weak, nonatomic) IBOutlet UILabel* searchNoShopsLabel; //未搜到餐厅信息

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* distanceTopConstraint;

@end

@implementation FDSearchShopViewController

- (void)initParams
{
    _currentPageIndex = 1;
    _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@(_currentPageIndex).stringValue forKey:@"currentPageIndex"];
    [_params setObject:@"10" forKey:@"pageSize"];
    [_params setObject:@"" forKey:@"keyword"];
    [_params setObject:_landmark forKey:@"landmark"];
    if (self.isTakeaway) {
        [_params setObject:@"2" forKey:@"type"];
    }
    else {
        [_params setObject:@"1" forKey:@"type"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[IQKeyboardManager sharedManager] setEnable:YES];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initParams];

    self.clearSearchDataLabel.text = kLocalized(@"GYHE_Food_ClearSearchHistory");
    self.searchHistoryTipLabel.text = kLocalized(@"GYHE_Food_SearchHistory");
    self.searchNoShopsLabel.text = kLocalized(@"GYHE_Food_NoSearchRestaurantInfomation");

    _backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.isTakeaway) {
        [_backBtn setTitle:kLocalized(@"GYHE_Food_TakeAway") forState:UIControlStateNormal];
    }
    else {
        [_backBtn setTitle:kLocalized(@"GYHE_Food_Restaurant") forState:UIControlStateNormal];
    }
    [self.searchBtn setTitle:kLocalized(@"GYHE_Food_Search") forState:UIControlStateNormal];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBtn];

    _searchTextField.placeholder = kLocalized(@"GYHE_Food_HSNumberRestaurant");
    [_searchTextField setValue:kCorlorFromRGBA(230, 230, 230, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_searchTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _searchTextField.textColor = [UIColor whiteColor];
    UIImageView* leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 14, 14)];
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    leftImageView.image = [UIImage imageNamed:@"gycommon_nav_search"];
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [leftView addSubview:leftImageView];
    _searchTextField.leftView = leftView;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.layer.cornerRadius = 5.f;
    _searchTextField.delegate = self;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    [_searchTextField becomeFirstResponder];
    _clearView.backgroundColor = [UIColor whiteColor];

    self.navigationItem.titleView = _searchTextField;
    _dataSource = [[NSMutableArray alloc] init];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;

    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FDTakeawayMainCell class]) bundle:nil] forCellReuseIdentifier:FDTakeawayCellReuseId];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FDMainShopCell class]) bundle:nil] forCellReuseIdentifier:FDMainCellReuseId];

    [self.view addSubview:_tableView];
    _tableView.hidden = YES;

    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf initParams];
        NSString *keyword = weakSelf.searchTextField.text;
        [weakSelf.params setObject:keyword forKey:@"keyword"];
        [weakSelf loadData];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.currentPageIndex++;
        [weakSelf.params setObject:@(weakSelf.currentPageIndex).stringValue forKey:@"currentPageIndex"];
        [weakSelf loadData];
    }];

    _historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)]; //_historyDataSource.count
    _historyTableView.dataSource = self;
    _historyTableView.delegate = self;
//    _historyTableView.scrollEnabled = NO;
    [self.view addSubview:_historyTableView];
    _historyTableView.hidden = YES;
    NSArray* history = [[NSUserDefaults standardUserDefaults] objectForKey:FDSearchFoodHistoryUserDefaultsKey];
    if (history) {
        _clearView.hidden = NO;
        _historyDataSource = [NSMutableArray arrayWithArray:history];
        if (_historyDataSource.count > 5) {
            _historyTableView.frame = CGRectMake(0, 0, kScreenWidth, 200);
        } else {
            _historyTableView.frame = CGRectMake(0, 0, kScreenWidth, _historyDataSource.count * 40);
        }
        
        self.distanceTopConstraint.constant = CGRectGetMaxY(_historyTableView.frame);
    }
    else {
        _historyDataSource = [NSMutableArray array];
    }
    [_historyTableView reloadData];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearBtnClicked:)];
    [_clearView addGestureRecognizer:tap];

    NSNotificationCenter* defaultCenter = [NSNotificationCenter defaultCenter];
    //    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //    [defaultCenter addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

    [defaultCenter addObserver:self selector:@selector(searchTextFieldTextChange) name:UITextFieldTextDidChangeNotification object:nil];
}

//- (void)showHistoryTable
//{
//    NSInteger count = _historyDataSource.count;
//    if (count>0) {
//        [_historyTableView reloadData];
//        _clearView.hidden = NO;
//        _searchHistoryTipLabel.hidden = NO;
//        _historyTableView.hidden = NO;
//        _historyTableView.frame = CGRectMake(0, 24, kScreenWidth, 40*count);
//        if (_historyTableView.frame.size.height+24+40>_keyboardFrame.origin.y) {
//            _historyTableView.frame = CGRectMake(0, 24, kScreenWidth, _keyboardFrame.origin.y-64-40-24);
//        }
//        _clearView.center = CGPointMake(kScreenWidth/2, _historyTableView.frame.origin.y+_historyTableView.frame.size.height+20);
//    }
//}
- (void)hiddenHistoryTable
{
    _historyTableView.hidden = YES;
    _clearView.hidden = YES;
    _searchHistoryTipLabel.hidden = YES;
}

- (void)clearBtnClicked:(UIButton*)btn
{
    [_historyDataSource removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FDSearchFoodHistoryUserDefaultsKey];
    [self hiddenHistoryTable];
}

- (void)dealloc
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)keyboardWillShow:(NSNotification*)noti
//{
//    _keyboardFrame = [[noti.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//    [self showHistoryTable];
//}

//- (void)keyboardWillHidden:(NSNotification*)noti
//{
//    [self hiddenHistoryTable];
//}

- (void)loadData
{

    [_searchTextField resignFirstResponder];
    self.tableView.hidden = NO;
    [self hiddenHistoryTable];
    [GYGIFHUD show];
    [FDShopModel modelArrayNetURL:FoodSearchShopsUrl parameters:_params option:GYM_GetJson completion:^(NSArray* modelArray, id responseObject, NSError* error) {


        [GYGIFHUD dismiss];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:modelArray];
        [_tableView reloadData];
        if (modelArray.count > 0) {
            _tableView.tableFooterView = [[UIView alloc] init];
            _tableView.mj_footer.hidden = NO;
        } else {
            _tableView.tableFooterView = _noResultView;
            _tableView.mj_footer.hidden = YES;
        }
        [_searchTextField resignFirstResponder];

        if (_currentPageIndex >= [[responseObject objectForKey:@"totalPage"] integerValue]) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [_tableView.mj_footer resetNoMoreData];
        }

    }];
}

- (IBAction)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchBtnClicked:(id)sender
{
    [_searchTextField resignFirstResponder];
    self.tableView.hidden = NO;
    [self hiddenHistoryTable];
    NSString* keyword = [_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [_params setObject:keyword forKey:@"keyword"];

    self.searchNoShopsLabel.text = [NSString stringWithFormat:kLocalized(@"GYHE_Food_NoSearchRelatedRestaurantInfo"), keyword];

    if (keyword && keyword.length > 0) {
        int k = 0;
        for (; k < _historyDataSource.count; k++) {
            NSString* str = _historyDataSource[k];
            if ([str isEqualToString:keyword]) {
                break;
            }
        }
        if (k >= _historyDataSource.count) {
            [_historyDataSource addObject:keyword];
            [[NSUserDefaults standardUserDefaults] setObject:_historyDataSource forKey:FDSearchFoodHistoryUserDefaultsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView reloadData];
        }
    }

    [self loadData];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return _dataSource.count;
    }
    else {
        return _historyDataSource.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == _tableView) {
        if (self.isTakeaway) {

            FDTakeawayMainCell* cell = [tableView dequeueReusableCellWithIdentifier:FDTakeawayCellReuseId];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FDTakeawayMainCell class]) owner:self options:nil] lastObject];
            }
            if (_dataSource.count > indexPath.row) {

                cell.model = _dataSource[indexPath.row];
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            FDMainShopCell* cell = [tableView dequeueReusableCellWithIdentifier:FDMainCellReuseId forIndexPath:indexPath];
            if (_dataSource.count > indexPath.row) {
                cell.model = _dataSource[indexPath.row];
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HistoryCellReuseId];
        NSInteger count = _historyDataSource.count;
        cell.textLabel.text = _historyDataSource[count - indexPath.row - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == _tableView) {

        return 90;
    }
    else {
        return 40;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        FDSelectFoodViewController* chooseVC = [[FDSelectFoodViewController alloc] init];        
        if (_dataSource.count > indexPath.row) {
            chooseVC.shopModel = _dataSource[indexPath.row];
        }
        chooseVC.isTakeaway = self.isTakeaway;
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
    else if (tableView == _historyTableView) {
        NSInteger count = _historyDataSource.count;
        NSString* keyword = _historyDataSource[count - indexPath.row - 1];
        [_params setObject:keyword forKey:@"keyword"];
        _searchTextField.text = keyword;

        self.searchNoShopsLabel.text = [NSString stringWithFormat:kLocalized(@"GYHE_Food_NoSearchRelatedRestaurantInfo"), _searchTextField.text];
        [self loadData];
    }
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    NSArray* history = [[NSUserDefaults standardUserDefaults] objectForKey:FDSearchFoodHistoryUserDefaultsKey];
    
    if (history) {
        [self resetFrameWithHistoryTableView];
        [self.historyTableView reloadData];
        _clearView.hidden = NO;
        self.distanceTopConstraint.constant = CGRectGetMaxY(_historyTableView.frame);
    }
    self.tableView.hidden = YES;
    _historyTableView.hidden = NO;
//    [self showHistoryTable];
}

//- (void)textFieldDidEndEditing:(UITextField*)textField
//{
//    self.tableView.hidden = NO;
//    [self hiddenHistoryTable];
//}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self searchBtnClicked:nil];
    return YES;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* toBeStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeStr.length > 100) {
        [self.view endEditing:YES];
        [GYUtils showToast:kLocalized(@"GYHE_Food_MaximumLengthLimit")];

        return NO;
    }
    return YES;
}

//如果搜索框大于100则只截取到100，防止联想输入不进去到textfield的代理
- (void)searchTextFieldTextChange
{
    if (_searchTextField.text.length > 100) {
        _searchTextField.text = [_searchTextField.text substringToIndex:100];
        [self.view endEditing:YES];
    }


}

- (void)resetFrameWithHistoryTableView {
    if (self.historyDataSource.count > 5) {
        self.historyTableView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    } else {
        self.historyTableView.frame = CGRectMake(0, 0, kScreenWidth, self.historyDataSource.count * 40);
    }
}

@end
