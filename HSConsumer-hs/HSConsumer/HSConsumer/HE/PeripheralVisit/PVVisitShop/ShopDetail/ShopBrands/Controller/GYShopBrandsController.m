//
//  GYShopBrandsController.m
//  HSConsumer
//
//  Created by apple on 15/11/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopBrandsController.h"
#import "GYGIFHUD.h"
#import "GYShopBrandModel.h"
#import "GYShopBrandsCell.h"
#import "ViewTipBkgView.h"
@interface GYShopBrandsController () <UITableViewDataSource, UITableViewDelegate> {

    __weak IBOutlet UITableView* brandTableView; //主视图

    NSMutableArray* _brandArr; //品牌数据源

    NSMutableArray* _brandGroupName; //品牌组名

    NSMutableArray* _brandList; //品牌清单

    //   BOOL _isElected;//判断cell点击

    NSString* _brandStr; //表格头部字段

    UILabel* _lab; //表头

    NSMutableArray* _brandNames; //品牌名数组

    NSMutableArray* datas;

    ViewTipBkgView* viewTipBkg;
}
@property (strong, nonatomic) NSMutableArray* brandDataSource;
@property (weak, nonatomic) IBOutlet UIButton* confirmBtn; //确定
@property (weak, nonatomic) IBOutlet UIButton* returnBtn; //重选
@property (assign, nonatomic) BOOL isPoped;
@property (nonatomic, strong) NSArray* indexArray;

@end

@implementation GYShopBrandsController

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.confirmBtn setTitle:kLocalized(@"GYHE_SurroundVisit_Confirm") forState:UIControlStateNormal];
    [self.returnBtn setTitle:kLocalized(@"GYHE_SurroundVisit_AllSelect") forState:UIControlStateNormal];

    _brandArr = [NSMutableArray array];
    _brandDataSource = [[NSMutableArray alloc] init];
    _brandGroupName = [NSMutableArray array];
    _brandList = [NSMutableArray array];
    _brandNames = [NSMutableArray array];
    datas = [NSMutableArray array];
    brandTableView.dataSource = self;
    brandTableView.delegate = self;
    brandTableView.sectionIndexColor = kCorlorFromHexcode(0xFF0000);
    brandTableView.sectionIndexBackgroundColor = kCorlorFromHexcode(0xEEEEEE);

    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 60)];
    _lab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, bgView.frame.size.width - 45, 60)];
    _lab.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    _lab.text = kLocalized(@"GYHE_SurroundVisit_AllBrand");
    [bgView addSubview:_lab];

    UIImageView* tipView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 30 - 10, 20, 12, 20)];
    tipView.image = [UIImage imageNamed:@"hs_cell_btn_right_arrow"];
    [bgView addSubview:tipView];
    bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myGes)];

    [bgView addGestureRecognizer:tap];
    bgView.backgroundColor = [UIColor whiteColor];

    brandTableView.tableHeaderView = bgView;
    brandTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [brandTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYShopBrandsCell class]) bundle:nil] forCellReuseIdentifier:@"brandCell"];
    self.title = kLocalized(@"GYHE_SurroundVisit_Brandzone");
    [self httpRequestForShopInfo];
}


#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _brandGroupName.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* arr = _brandList[section];
    return arr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPathP
{
    static NSString* cellID = @"brandCell";
    GYShopBrandsCell* brandCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSArray* tempArr = nil;
    if (_brandArr.count > indexPathP.section) {
        tempArr = _brandList[indexPathP.section];
    }
    GYShopBrandModel* model = nil;
    if (tempArr.count > indexPathP.row) {
        model = tempArr[indexPathP.row];
    }
    brandCell.brandLabel.text = model.brandName;
    brandCell.isSelect = model.isSelect;

   

    if (!brandCell.isSelect) {
        [brandCell.stateBtn setImage:[UIImage imageNamed:@"gyhe_brand_unselect"] forState:0];
        brandCell.brandLabel.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    }
    else {
        [brandCell.stateBtn setImage:[UIImage imageNamed:@"gyhe_brand_select"] forState:0];
        brandCell.brandLabel.textColor = kNavigationBarColor;
    }

    brandCell.selectionStyle = 0;
    return brandCell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    DDLogDebug(@"section=%ld row=%ld", indexPath.section, indexPath.row);
    NSArray* tempArr = _brandList[indexPath.section];
    GYShopBrandModel* model = tempArr[indexPath.row];
    //     点击判定按钮状态
    if (!model.isSelect) {
        model.isSelect = YES;
        [_brandNames addObject:model.brandName];
    }
    else {
        model.isSelect = NO;
        [_brandNames removeObject:model.brandName];
    }
    //    刷新行
    [brandTableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headView"];
    if (!headView) {
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headView"];
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 20, 20)];
        lab.tag = 1010;
        [headView.contentView addSubview:lab];
    }

    UILabel* lab = (UILabel*)[headView viewWithTag:1010];
    lab.text = _brandGroupName[section];
    lab.textColor = kCorlorFromHexcode(0x808080);
    headView.contentView.backgroundColor = kCorlorFromHexcode(0xEEEEEE);
    return headView;
}

// 返回索引的文字
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    self.indexArray = @[ @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#" ];
    return self.indexArray;
}

// 索引对应的下标
- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    for (NSInteger i = 0; i < _brandGroupName.count; i++) {
        if ([self.indexArray[index] isEqualToString:_brandGroupName[i]]) {
            return i;
        }
    }
    return -1;
}

#pragma mark - 点击事件
//点击确定
- (IBAction)comfirmAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(ShopBrandDidChooseBrand:)]) {
        [self.delegate ShopBrandDidChooseBrand:_brandNames];
    }
    _isPoped = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!_isPoped) {
        if ([self.delegate respondsToSelector:@selector(ShopBrandDidChooseBrand:)]) {

            [self.delegate ShopBrandDidChooseBrand:_brandNames];
        }
        _isPoped = YES;
    }
}

//点击全部重选
- (IBAction)reelectAciton:(id)sender
{
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
    GYShopBrandsCell* cell;
    for (NSInteger i = 0; i < _brandList.count; i++) {
        for (NSInteger j = 0; j < [_brandList[i] count]; j++) {
            path = [NSIndexPath indexPathForRow:j inSection:i];
            cell = [brandTableView cellForRowAtIndexPath:path];
            cell.isSelect = NO;
            GYShopBrandModel* model = _brandList[i][j];

            model.isSelect = NO;
        }
    }
    [_brandNames removeAllObjects];
    [brandTableView reloadData];
}

#pragma mark - 自定义方法
//加载店铺品牌
- (void)httpRequestForShopInfo
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.strShopID forKey:@"vShopId"];
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetVShopBrandNameUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            
            if (!error) {
                NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"]) {
                    NSArray *arrData = ResponseDic[@"data"];
                    for (NSDictionary *dict in arrData) {
                        NSString *str = dict.allValues.firstObject;
                        if (![str isEqualToString:@"@"] && str.length > 0) {
                            [_brandDataSource addObject:dict.allValues.firstObject];
                        }
                        
                    }
                    
                    for (NSInteger i = 0; i < arrData.count; i++) {
                        NSDictionary *dict = arrData[i];
                        [_brandArr addObject:dict[@"brandName"]];
                    }
                    _brandGroupName = [GYUtils IndexArray:_brandDataSource];
                    if (_brandGroupName.count == 0) {

                        viewTipBkg = [[ViewTipBkgView alloc] init];
                        [viewTipBkg setFrame:brandTableView.frame];
                        [viewTipBkg.lbTip setText:kLocalized(@"GYHE_SurroundVisit_NoBrandInformations")];
                        [self.view addSubview:viewTipBkg];
                    }
                    _brandList = [GYUtils LetterSortArray:_brandDataSource];
                }
            } else {
                WS(weakSelf)
                [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_LoaddataFailure") confirm:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
        } else {
            [GYUtils parseNetWork:error resultBlock:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [brandTableView reloadData];
    }];
    [request start];
}

//点击全部品牌返回
- (void)myGes
{
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
    GYShopBrandsCell* cell;
    for (NSInteger i = 0; i < _brandList.count; i++) {
        for (NSInteger j = 0; j < [_brandList[i] count]; j++) {
            path = [NSIndexPath indexPathForRow:j inSection:i];
            cell = [brandTableView cellForRowAtIndexPath:path];
            cell.isSelect = YES;
            GYShopBrandModel* model = _brandList[i][j];
            [_brandNames addObject:model.brandName];
            model.isSelect = YES;
        }
    }
    [brandTableView reloadData];
}

@end
