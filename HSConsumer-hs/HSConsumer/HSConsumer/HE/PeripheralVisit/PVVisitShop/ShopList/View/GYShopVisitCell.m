//
//  GYShopVisitCell.m
//  HSConsumer
//
//  Created by apple on 15/11/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopVisitCell.h"
#import "GYShowShopsCell.h"
#import "GYAppDelegate.h"
#import "GYEasyBuyModel.h"
@implementation GYShopVisitCell

- (void)awakeFromNib
{
    _shopVisitTableView.delegate = self;
    _shopVisitTableView.dataSource = self;
    _shopVisitTableView.showsHorizontalScrollIndicator = NO;
    _shopVisitTableView.showsVerticalScrollIndicator = NO;
    _shopVisitTableView.scrollEnabled = NO;
    _shopVisitTableView.tableFooterView = [[UIView alloc] init];
    [_shopVisitTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYShowShopsCell class]) bundle:nil] forCellReuseIdentifier:@"visitCell"];

    self.visitLabel.text = kLocalized(@"GYHE_SurroundVisit_Patronize");
    _visitArr = [NSMutableArray array];
}

- (void)setVisitArr:(NSMutableArray*)visitArr
{
    if (visitArr.count > 0) {
        _visitArr = visitArr;
    }

    [self.shopVisitTableView reloadData];
}

#pragma mark - uitableview 的代理方法

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _visitArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellID = @"visitCell";
    GYShowShopsCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(_visitArr.count > indexPath.row) {
        ShopModel* model = _visitArr[indexPath.row];
        
        [cell refreshUIWith:model];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.tag = 112 + indexPath.row;
    cell.telBtn.tag = indexPath.row + 1000;
    [cell.telBtn addTarget:self action:@selector(phoneNumberCall:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 100;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(_visitArr.count > indexPath.row) {
        ShopModel* model = _visitArr[indexPath.row];
        
        if (_block) {
            _block(model);
        }

    }
}

#pragma mark - 打电话
- (void)phoneNumberCall:(UIButton*)sender
{
    NSInteger index = sender.tag - 1000;
    if(_visitArr.count > index) {
        ShopModel* model = _visitArr[index];
        
        if (model.strShopTel.length > 0) {
            [GYUtils callPhoneWithPhoneNumber:model.strShopTel showInView:kAppDelegate.window];
        }
    }
    
}

@end
