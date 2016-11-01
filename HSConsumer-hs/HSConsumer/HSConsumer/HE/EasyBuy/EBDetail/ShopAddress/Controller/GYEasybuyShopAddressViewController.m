//
//  GYEasybuyShopAddressViewController.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyShopAddressViewController.h"
#import "GYEasybuyShopAddressCell.h"
#import "JSONModel+ResponseObject.h"
#import "GYNetRequest.h"
#import "GYEasybuyShopAddressModel.h"
#import "GYHEUtil.h"
#import "GYAlertView.h"

#define kGYEasybuyShopAddressCell @"GYEasybuyShopAddressCell"

@interface GYEasybuyShopAddressViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tabView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, copy) __block NSString* phoneStr;

@end

@implementation GYEasybuyShopAddressViewController

#pragma mark - 生命周期
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = kLocalized(@"GYHE_Easybuy_chooseArea");
    
    UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBut setImage:[UIImage imageNamed:@"gycommon_nav_back"] forState:UIControlStateNormal];
    backBut.frame = CGRectMake(0, 0, 40, 40);
    backBut.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBut addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:backBut];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYEasybuyShopAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYEasybuyShopAddressCell forIndexPath:indexPath];
    if(self.dataArray.count > indexPath.row) {
        cell.model = self.dataArray[indexPath.row];
    }
    
    WS(weakSelf);
    cell.block = ^(NSString* phoneStr) {
        weakSelf.phoneStr = phoneStr;
        
        [GYAlertView showMessage:phoneStr cancleButtonTitle:kLocalized(@"GYHE_Easybuy_cancel") confirmButtonTitle:kLocalized(@"GYHE_Easybuy_call") cancleBlock:nil confirmBlock:^{
 
            //拨号
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _phoneStr]]];
        }];
        
    };
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(self.dataArray.count <= indexPath.row) {
        return ;
    }
    _blockAddress([self.dataArray[indexPath.row] addr]);
    [self.navigationController popViewControllerAnimated:YES];
    _blockAddress = nil;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dataArray.count > indexPath.row) {
        GYEasybuyShopAddressModel *model = self.dataArray[indexPath.row];
        return model.cellHeight;
    }
    return 0;
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    if([responseObject[@"retCode"] isEqualToNumber:@200]) {
        NSArray *dataArray = responseObject[@"data"];
        if(![GYUtils checkArrayInvalid:dataArray]) {
            for (NSDictionary *dic in dataArray) {
                GYEasybuyShopAddressModel *model = [[GYEasybuyShopAddressModel alloc] initWithDic:dic];
                [self.dataArray addObject:model];
            }
        }
        
    }
    [self.tabView reloadData];
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - 自定义方法
- (void)requestData
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetShopsByItemIdUrl parameters:@{ @"itemId" : _itemId } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request start];
}
- (void)pushBack {
    
    [self.tabView removeFromSuperview];
    self.tabView = nil;
    _blockAddress = nil;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 懒加载
- (NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UITableView*)tabView
{
    if (!_tabView) {

        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tabView.backgroundColor = kDefaultVCBackgroundColor;
        _tabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tabView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
        _tabView.rowHeight = 90;
        _tabView.dataSource = self;
        _tabView.delegate = self;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tabView];

        [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYEasybuyShopAddressCell class]) bundle:nil] forCellReuseIdentifier:kGYEasybuyShopAddressCell];
    }
    return _tabView;
}


@end
