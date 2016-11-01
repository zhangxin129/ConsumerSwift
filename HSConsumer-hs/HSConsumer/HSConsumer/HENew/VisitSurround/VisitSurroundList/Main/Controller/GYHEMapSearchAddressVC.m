//
//  GYHEMapSearchAddressVC.m
//
//  Created by apple on 16/10/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEMapSearchAddressVC.h"
#import <Masonry/Masonry.h>
#import "GYHEMapSearchAddressCell.h"
#import "GYHEMapSearchAddressModel.h"
#import "UIView+Extension.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface GYHEMapSearchAddressVC ()<UITableViewDelegate,UITableViewDataSource,BMKSuggestionSearchDelegate,BMKPoiSearchDelegate>
@property (nonatomic,weak)  UIView * heardVIew;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) UIView * noDataView;
@property (nonatomic,strong) BMKSuggestionSearch * sugSearch;
@property (nonatomic,strong) NSString * keyString;
@property (nonatomic,strong) NSMutableArray * array;
@property (nonatomic,strong) BMKPoiSearch *poiSearch;
@end

@implementation GYHEMapSearchAddressVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}


- (void)dealloc
{
    self.sugSearch.delegate = nil;
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = [UIColor clearColor];
    //返回按钮
    UIButton * returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.size = CGSizeMake(10, 20);
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_main_leftArrow"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    
    //搜索框
    self.navigationItem.titleView = [self setNavTitleView];
    //搜索按钮
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.size = CGSizeMake(35, 20);
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
 
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    
    self.sugSearch = [[BMKSuggestionSearch alloc]init];
    self.sugSearch.delegate = self;
   
    self.poiSearch = [[BMKPoiSearch alloc] init];
    self.poiSearch.delegate = self;
}

- (void)viewDidLayoutSubviews
{
    if (!self.noDataView) {
        UIView * noDataView = [self addNoDataTipViewWithSuperView:self.tableView];
        noDataView.hidden = YES;
        self.noDataView = noDataView;
    }
}

#pragma mark - navTitleview
- (UIView *)setNavTitleView
{
    UITextField * searchField = [[UITextField alloc]init];
    searchField.size = CGSizeMake(kScreenWidth, 30);
    searchField.backgroundColor = kCorlorFromRGBA(232, 237, 238, 1);
    searchField.layer.cornerRadius = 15;
    searchField.placeholder = @"请输入地址";
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView* searchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_searchview"]];
    searchImage.frame = CGRectMake(0, 0, 15, 15);
    searchImage.center = leftView.center;
    [leftView addSubview:searchImage];
    searchField.leftView = leftView;
    [searchField becomeFirstResponder];
    [searchField addTarget:self action:@selector(searchTextChange:) forControlEvents:UIControlEventEditingChanged];
    return searchField;
}
#pragma mark - 返回
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索
- (void)searchClick
{
     [self requestSearch];
}

#pragma mark - searchTextFieldAction
- (void)searchTextChange:(UITextField*)textField
{
    if (textField.text.length) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        self.keyString = textField.text;
        BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
        option.keyword = textField.text;
        option.cityname = @"深圳";//设置搜索城市
        BOOL flag = [self.sugSearch suggestionSearch:option];
        if(flag)
        {
            NSLog(@"建议检索发送成功");
        }
        else
        {
            NSLog(@"建议检索发送失败");  
        }
    }else {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        self.noDataView.hidden = NO;
    }
}

#pragma mark - 搜索请求
- (void)requestSearch
{
    
}

- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error;
{
    [self.array removeAllObjects];
    if (error == BMK_SEARCH_NO_ERROR)
    {
        [self getDetailWithPoidList:result.poiIdList];
//        NSMutableArray * array = [NSMutableArray array];
//        for (int i = 0; i < result.keyList.count; i++) {
//            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//            [dic setValue:result.keyList[i] forKey:@"cityName"];
//            [dic setValue:result.districtList[i] forKey:@"detailAddressName"];
//            [array addObject:dic];
//        }
//
//        for (NSDictionary * temp in array) {
//            GYHEMapSearchAddressModel * model = [[GYHEMapSearchAddressModel alloc]initWithDictionary:temp error:nil];
//            [self.dataArray addObject:model];
//        }
//        [self.tableView reloadData];
    }
        if (result.poiIdList.count < 1) {
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            NSString * tipString = [NSString stringWithFormat:@"%@ %@",@"未能找到",self.keyString];
            [GYUtils showMessage:tipString  confirm:nil withColor:kCorlorFromRGBA(249, 125, 0, 1)];
        }
        self.noDataView.hidden = result.poiIdList.count > 0?YES:NO;

}

- (void)getDetailWithPoidList:(NSArray *)poidList
{
    for (int i = 0; i < poidList.count; i++) {
        BMKPoiSearch * poid = [[BMKPoiSearch alloc]init];
        poid.delegate = self;
        BMKPoiDetailSearchOption* option = [[BMKPoiDetailSearchOption alloc] init];
        option.poiUid = poidList[i];//POI搜索结果中获取的uid
        BOOL flag = [poid poiDetailSearch:option];
        if(flag)
        {
            NSLog(@"成功%d",i);
        }
        else
        {
            NSLog(@"失败%d",i);
        }
    }
}

-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    if(errorCode == BMK_SEARCH_NO_ERROR){
        //在此处理正常结果
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:poiDetailResult.name forKey:@"cityName"];
        [dic setValue:poiDetailResult.address forKey:@"detailAddressName"];
        GYHEMapSearchAddressModel * model = [[GYHEMapSearchAddressModel alloc]initWithDictionary:dic error:nil];
        [self.dataArray addObject:model];
        if (self.dataArray.count > 1) {
            for (int i = 1; i<self.dataArray.count; i++) {
                GYHEMapSearchAddressModel * model1 = self.dataArray[i-1];
                GYHEMapSearchAddressModel * model2 = [self.dataArray lastObject];
                if ([model1.cityName isEqualToString:model2.cityName]&&[model1.detailAddressName isEqualToString:model2.detailAddressName]) {
                    [self.dataArray removeLastObject];
                }
            }

        }
        [self.tableView reloadData];
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.dataArray.count < 1) {
//            NSString * tipString = [NSString stringWithFormat:@"%@ %@",@"未能找到",self.keyString];
//            [GYUtils showMessage:tipString  confirm:nil withColor:kCorlorFromRGBA(249, 125, 0, 1)];
//        }
//        self.noDataView.hidden = self.dataArray.count > 0?YES:NO;
//    });

}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
//    self.noDataView.hidden = self.dataArray.count > 0?YES:NO;
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHEMapSearchAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:GYHEMapSearchCell forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //iOS7
    GYHEMapSearchAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:GYHEMapSearchCell];
    
    
    cell.model = self.dataArray[indexPath.row];
    
    CGFloat contentViewWidth = CGRectGetWidth(self.tableView.frame);
    [cell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(contentViewWidth));
    }];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - 无数据蒙版
- (UIView*)addNoDataTipViewWithSuperView:(UIView*)superView
{
    
    UIView* vBack = [[UIView alloc] initWithFrame:superView.bounds];
    [superView addSubview:vBack];
    
    UILabel* lbTip = [[UILabel alloc] init];
    lbTip.text = @"无结果";
    lbTip.font = [UIFont systemFontOfSize:16.0f];
    lbTip.textColor = [UIColor blackColor];
    lbTip.textAlignment = NSTextAlignmentCenter;
    CGSize tipSize = [lbTip.text boundingRectWithSize:CGSizeMake(vBack.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f], NSFontAttributeName, nil] context:nil].size;
    lbTip.size = tipSize;
    lbTip.centerX = vBack.centerX;
    lbTip.y = 100;
    [vBack addSubview:lbTip];
    
    return vBack;
}

#pragma mark - lazy load
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEMapSearchAddressCell class]) bundle:nil] forCellReuseIdentifier:GYHEMapSearchCell];
    }
    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)array
{
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
