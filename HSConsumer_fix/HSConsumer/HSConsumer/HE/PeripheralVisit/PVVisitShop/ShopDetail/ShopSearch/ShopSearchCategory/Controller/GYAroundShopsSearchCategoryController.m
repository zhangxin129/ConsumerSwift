//
//  GYAroundShopsSearchCategoryController.m
//  HSConsumer
//
//  Created by Apple03 on 15/11/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAroundShopsSearchCategoryController.h"
#import "GYAroundShopsCategoryModel.h"
#import "GYAroundShopsCategorySectionView.h"
#import "GYAroundShopsCategoryCell.h"
#import "MJExtension.h"

#import "GYAroundSearchShopGoodsViewController.h"

@interface GYAroundShopsSearchCategoryController () <UITableViewDataSource, UITableViewDelegate, GYAroundShopsCategoryCellDelegate>
@property (nonatomic, strong) NSMutableArray* marrData;

@property (nonatomic, strong) NSMutableArray* marrSection;
@property (nonatomic, strong) NSMutableArray* marrShowAll;
@property (nonatomic, strong) NSMutableArray* marrRows;
@property (nonatomic, weak) UITableView* tableView;
@end

@implementation GYAroundShopsSearchCategoryController

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

#pragma mark GYAroundShopsCategoryCellDelegate
- (void)AroundShopsCategoryCellDidChooseItemWith:(NSIndexPath*)indexP index:(NSInteger)index
{
    [self toSearchGoodsWithIndex:index cellIndexPath:indexP type:1];
}

- (void)toSearchGoodsWithIndex:(NSInteger)index cellIndexPath:(NSIndexPath*)indexPath type:(NSInteger)type
{
    GYAroundShopsCategoryModel* model = nil;
    if (type == 1) {
        if(self.marrRows.count > indexPath.section) {
            NSMutableArray* arry = self.marrRows[indexPath.section];
            if(arry.count > indexPath.row) {
                NSMutableArray* arrCell = arry[indexPath.row];
                if(arrCell.count > index)
                    model = arrCell[index];

            }
        }
        
    }
    else {
        if(self.marrSection.count >index)
            model = self.marrSection[index];
    }
    NSString* strcategoryName = model.categoryName;
    NSString* strCID = model.cid;
    strcategoryName = [strcategoryName stringByAppendingString:@"*"];
    if ([strcategoryName rangeOfString:kLocalized(@"GYHE_SurroundVisit_All")].location != NSNotFound) {
        strcategoryName = @"";
    }
    if (!strCID || strCID.length == 0) {
        strCID = @"";
    }
    self.CompletionBlock(strcategoryName, strCID);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.marrSection.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.marrRows.count > 0) {
        NSMutableArray* arry = self.marrRows[section];
        NSString* strSHow = self.marrShowAll[section];
        if ([strSHow isEqualToString:@"0"] && arry.count > 2) {
            return 2;
        }
        return arry.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView*)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.marrSection.count > section) {
        GYAroundShopsCategorySectionView* view = [[GYAroundShopsCategorySectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        __block GYAroundShopsCategoryModel* model = self.marrSection[section];
        __weak GYAroundShopsSearchCategoryController* vcSelf = self;
        view.chooseBlock = ^(NSInteger secton) {
            [vcSelf toSearchGoodsWithIndex:section cellIndexPath:nil type:0];
        };
        view.ShowBlock = ^(NSInteger section) {
            if (section == 0) {
                [vcSelf toSearchGoodsWithIndex:section cellIndexPath:nil type:0];
            } else {
                model.isShowAll = !model.isShowAll;
                [vcSelf.marrShowAll removeObjectAtIndex:section];
                if (model.isShowAll) {
                    [vcSelf.marrShowAll insertObject:@"1" atIndex:section];
                } else {
                    [vcSelf.marrShowAll insertObject:@"0" atIndex:section];
                }
                [vcSelf.tableView reloadData];
            }
        };
        view.index = section;
        [view setViewWithData:model];
        return view;
    }
    else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYAroundShopsCategoryCell* cell = [tableView dequeueReusableCellWithIdentifier:KAroundShopsCategoryCell forIndexPath:indexPath];
    cell.indexP = indexPath;
    cell.delegate = self;
    if(self.marrRows.count > indexPath.section) {
        NSMutableArray* arry = self.marrRows[indexPath.section];
        if(arry.count > indexPath.row) {
            NSMutableArray* arrCell = arry[indexPath.row];
            [cell setCellDetailWithArray:arrCell];
        }
        
    }
    
    return cell;
}

#pragma mark 自定义方法
- (void)setup
{
    self.title = kLocalized(@"GYHE_SurroundVisit_GoodsCategory");
    [self.tableView registerClass:[GYAroundShopsCategoryCell class] forCellReuseIdentifier:KAroundShopsCategoryCell];
    [self getData];
}

- (void)reMakeData
{
    int count = 3;
    for (int i = 0; i < self.marrData.count; i++) {
        GYAroundShopsCategoryModel* categoryModel = self.marrData[i];
        GYAroundShopsCategoryModel* reCategoryModel = [[GYAroundShopsCategoryModel alloc] init];
        reCategoryModel.categoryId = kSaftToNSString(categoryModel.categoryId);
        reCategoryModel.categoryName = kSaftToNSString(categoryModel.categoryName);
        reCategoryModel.cid = kSaftToNSString(categoryModel.cid);
        [self.marrSection addObject:reCategoryModel];
        [self.marrShowAll addObject:@"0"];
        NSMutableArray* marrRowInSection = [NSMutableArray array];
        NSMutableArray* marrRow = [NSMutableArray array];
        for (int j = 0; j < categoryModel.listMap.count; j++) {
            GYAroundShopsCategorySubModel* subModel = categoryModel.listMap[j];
            [marrRow addObject:subModel];
            if ((j + 1) % count == 0) {
                [marrRowInSection addObject:marrRow];
                marrRow = [NSMutableArray array];
            }
            else {
                if (categoryModel.listMap.count == j + 1) {
                    [marrRowInSection addObject:marrRow];
                }
            }
        }
        [self.marrRows addObject:marrRowInSection];
    }
}

- (void)getData
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.strShopID forKey:@"vShopId"];
    
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetVShopCategoryUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            if(responseObject) {
                NSArray *arryData = responseObject[@"data"];
                for (int i = 0; i < arryData.count; i++) {
                    GYAroundShopsCategoryModel *categoryModel = [GYAroundShopsCategoryModel mj_objectWithKeyValues:arryData[i]];
                    [self.marrData addObject:categoryModel];
                }
                [self reMakeData];
                [self.tableView reloadData];
            }
        }
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}


#pragma mark 懒加载
- (NSMutableArray*)marrData
{
    if (!_marrData) {
        _marrData = [NSMutableArray array];
    }
    return _marrData;
}

- (NSMutableArray*)marrShowAll
{
    if (!_marrShowAll) {
        _marrShowAll = [NSMutableArray array];
    }
    return _marrShowAll;
}

- (NSMutableArray*)marrSection
{
    if (!_marrSection) {
        _marrSection = [NSMutableArray array];
    }
    return _marrSection;
}

- (NSMutableArray*)marrRows
{
    if (!_marrRows) {
        _marrRows = [NSMutableArray array];
    }
    return _marrRows;
}

- (UITableView*)tableView
{
    if (!_tableView) {
        UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        tableView.backgroundColor = kCorlorFromRGBA(238, 238, 238, 1);
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}


@end
