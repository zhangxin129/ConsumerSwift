//
//  GYHSPersonalityCardListVC.m
//
//  Created by apple on 16/8/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  个性卡定制服务
 *  当托管企业需要个性卡定制服务时使用
 */
#import "GYHSPersonalityCardListVC.h"
#import "GYHSPerCardListCell.h"
#import "GYHSListSpecCardStyleModel.h"
#import "GYHSStoreHttpTool.h"
#import "GYHSCardConfirmVC.h"
#import "GYHSCardSubmitVC.h"
#import "GYHSPublicMethod.h"
#define kRemoveNoMessage 1233
static NSString *perCardListCellId = @"GYHSPerCardListCell";

@interface GYHSPersonalityCardListVC ()<UITableViewDataSource, UITableViewDelegate, GYHSLookSelectCellDelegate,GYNetworkReloadDelete>

@property (nonatomic, strong) UIView *listView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *applyButton;
@property (nonatomic, strong) NSMutableArray *listDataArray;

@end

@implementation GYHSPersonalityCardListVC
/**
 *  懒加载个性卡列表的数据源
 *
 */
#pragma mark - lazy load
- (NSMutableArray *)listDataArray{
    if (!_listDataArray) {
        _listDataArray = [[NSMutableArray alloc] init];
    }
    return _listDataArray;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self loadInitViewType:GYStopTypeStopPointAct :^{
        @strongify(self);
        [self initView];
        [self createListView];
        [self createFooterView];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestCardList];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_HSStore_PerCardCustomization_PersonalizedCardCustomization");
    self.view.backgroundColor = kWhiteFFFFFF;
}
/**
 *  创建个性卡的列表视图
 */
- (void)createListView{
    _listView = [[UIView alloc] initWithFrame:CGRectMake(16, 44 + 16, kDeviceProportion(kScreenWidth - 32), kDeviceProportion(536))];
    [self.view addSubview:_listView];
    self.listView.layer.borderColor = kGrayCCCCCC.CGColor;
    self.listView.layer.borderWidth = 1.0f;
    self.listView.backgroundColor = kWhiteFFFFFF;
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSPerCardListCell class]) bundle:nil] forCellReuseIdentifier:perCardListCellId];
    [_listView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_listView.mas_top).offset(0);
        make.left.equalTo(_listView.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(kDeviceProportion(kScreenWidth - 32))));
        make.height.equalTo(@(kDeviceProportion(536)));
    }];
    
}
/**
 *  创建底部按钮视图
 */
- (void)createFooterView{
    
    _footerView = [[UIView alloc] init];
    _footerView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:_footerView];
    [_footerView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _applyButton.layer.cornerRadius = 5;
    _applyButton.layer.borderWidth = 1;
    _applyButton.layer.borderColor = kRedE50012.CGColor;
    _applyButton.layer.masksToBounds = YES;
    [_applyButton setTitle:kLocalized(@"GYHS_HSStore_PerCardCustomization_ApplyPersonalizedCardCustomization") forState:UIControlStateNormal];
    [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_applyButton setBackgroundColor:kRedE50012];
    [_applyButton addTarget:self action:@selector(applyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_applyButton];
    [_applyButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(164)));
        make.centerX.centerY.equalTo(_footerView);
    }];

}
/**
 *  底部申请个性卡定制服务按钮的触发时间
 */
#pragma mark - event
- (void)applyButtonAction{
    GYHSCardSubmitVC *submitVC = [[GYHSCardSubmitVC alloc] init];
    [self.navigationController pushViewController:submitVC animated:YES];
}
/**
 *  查询个个性卡列表的网络请求
 */
#pragma mark - request
- (void)requestCardList{
    [GYNetwork sharedInstance].delegate = self;
    [GYHSStoreHttpTool getListSpecCardStylePageSize:@"10000" curPage:@"1" success:^(id responsObject) {
        self.listDataArray = responsObject;
        [self.tableView reloadData];
    } failure:^{
        
    }];
}
/**
 *  没有网络上盖视图点击重新加载
 */
- (void)gyNetworkDidTapReloadBtn
{
    [self requestCardList];
}
/**
 *  TableView 的代理方法
 */
#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    UIView* view = [self.view viewWithTag:kRemoveNoMessage];
    if (view) {
        [view removeFromSuperview];
    }
    if (self.listDataArray.count == 0) {
       
        
        UIView* viewC = [GYHSPublicMethod addNoDataTipViewWithSuperView:_listView];
        viewC.tag = kRemoveNoMessage;
        [viewC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_listView.mas_top).offset(0);
            make.left.equalTo(_listView.mas_left).offset(0);
            make.width.equalTo(@(kDeviceProportion(kDeviceProportion(kScreenWidth - 32))));
            make.height.equalTo(@(kDeviceProportion(536)));
        }];
        
    }
    return  self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYHSPerCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:perCardListCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.listDataArray[indexPath.row];
    cell.numLable.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kDeviceProportion(130);
}
/**
 *  查看定制个性卡的状态
 */
#pragma mark -- GYHSLookSelectCellDelegate
- (void)lookSelectCell:(GYHSListSpecCardStyleModel *)model{
    GYHSCardConfirmVC *HSCardConfirmVC = [[GYHSCardConfirmVC alloc] init];
    if (model.isConfirm.boolValue) {
        HSCardConfirmVC.type = GYHSCardLookStateTypeConfirmed;
    }else{
        HSCardConfirmVC.type = GYHSCardLookStateTypeToConfirm;
    }
    HSCardConfirmVC.model = model;
    [self.navigationController pushViewController:HSCardConfirmVC animated:YES];
}
@end
