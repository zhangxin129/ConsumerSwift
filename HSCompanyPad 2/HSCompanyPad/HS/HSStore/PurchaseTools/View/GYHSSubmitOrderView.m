//
//  GYHSSubmitOrderView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  互生Store申购工具和资源申购的生成订单界面
 */
#import "GYHSSubmitOrderView.h"
#import "GYHSPurchaseAddressCell.h"
#import "GYHSPurchaseToolCell.h"
#import "UILabel+Category.h"
#import "GYHSAddressListModel.h"
#import "GYHSEditAddressVC.h"
#import "GYHSResSegCell.h"
#import "GYHSResSegmentModel.h"
#import "GYHSToolPurchaseModel.h"

#define kViewWidth self.frame.size.width

static NSString *purchaseAddressCellID = @"GYHSPurchaseAddressCell";
static NSString *purchaseToolCellID = @"GYHSPurchaseToolCell";
static NSString *resSegCellID = @"GYHSResSegCell";

@interface GYHSSubmitOrderView()<UITableViewDataSource, UITableViewDelegate, GYHSOperateAddressDelegate>

@property (nonatomic, strong) UITableView *addTableView;
@property (nonatomic, strong) UITableView *toolTableView;
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) GYHSAddressListModel *selectModel;
@property (nonatomic, strong) UILabel *totalAccountLable;
@property (nonatomic, assign) double sum;


@end

@implementation GYHSSubmitOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
/**
 *  set方法获取传过来的数据源
 */
#pragma mark -- 懒加载
- (void)setAddrDataArray:(NSMutableArray *)addrDataArray {
    _addrDataArray = addrDataArray;
    [_addTableView reloadData];
    [_addrDataArray enumerateObjectsUsingBlock:^(GYHSAddressListModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isDefault.boolValue ) {
            obj.isSelected = YES;
            _addrDataArray[idx] = obj;
            if ([self.delegate respondsToSelector:@selector(transSelectedMode:)]) {
                [self.delegate transSelectedMode:obj];
                
            }
        }
    }];
    
    
    
    
}

- (void)setResSegArray:(NSMutableArray *)resSegArray{
    _resSegArray = resSegArray;
    [_toolTableView reloadData];
}
- (void)setToolPurArray:(NSMutableArray *)toolPurArray{
    _toolPurArray = toolPurArray;
    self.sum = 0;
    for (GYHSToolPurchaseModel* model in self.toolPurArray) {
        self.sum += model.price.doubleValue * model.quanilty.intValue;
    }
    [_toolTableView reloadData];
}

- (void)setUI{
    [self setAddresssUI];
    [self setToolUI];
    [self setTotalUI];
}
/**
 *  创建收货地址视图
 */
- (void)setAddresssUI{

    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 16, kViewWidth - 16, 181)];
    [self addSubview:addressView];
    self.addressView = addressView;
    self.addressView.layer.borderColor = kGrayCCCCCC.CGColor;
    self.addressView.layer.borderWidth = 1.0f;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kGreenF4F4F4;
    headerView.userInteractionEnabled = YES;
    [self.addressView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_top).offset(0);
        make.left.equalTo(self.addressView.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(self.addressView.frame.size.width)));
        make.height.equalTo(@(kDeviceProportion(45)));
    }];
    
    UILabel *addLable = [[UILabel alloc] init];
    [addLable initWithText:kLocalized(@"GYHS_HSStore_PurchaseTools_ReceiveAddress") TextColor:kGray333333 Font:kFont42 TextAlignment:0];
    [headerView addSubview:addLable];
    [addLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(11);
        make.left.equalTo(headerView.mas_left).offset(16);
        make.width.equalTo(@(kDeviceProportion(100)));
        make.height.equalTo(@(kDeviceProportion(21)));
    }];
    
    _addTableView = [[UITableView alloc] init];
    _addTableView.delegate = self;
    _addTableView.dataSource = self;
    [_addTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSPurchaseAddressCell class]) bundle:nil] forCellReuseIdentifier:purchaseAddressCellID];
    [addressView addSubview:_addTableView];
    
    [_addTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(45);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(addressView.frame.size.width)));
        make.height.equalTo(@(kDeviceProportion(135)));
    }];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"gyhs_add_address"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addButton];
    self.addButton = addButton;
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(10);
        make.right.equalTo(headerView.mas_right).offset(- 16);
        make.width.equalTo(@(kDeviceProportion(26)));
        make.height.equalTo(@(kDeviceProportion(26)));
    }];
   
    UILabel *addAddLable = [[UILabel alloc] init];
    [addAddLable initWithText:kLocalized(@"GYHS_HSStore_PurchaseTools_Add") TextColor:kBlue0A59C2 Font:kFont42 TextAlignment:2];
    addAddLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTap)];
    [addAddLable addGestureRecognizer:tap];
    [headerView addSubview:addAddLable];
    [addAddLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(12);
        make.right.equalTo(addButton.mas_right).offset(- 26 - 10);
        make.width.equalTo(@(kDeviceProportion(42)));
        make.height.equalTo(@(kDeviceProportion(21)));
    }];
    
    
}
/**
 *  新增收货地址的触发事件
 */
- (void)addTap{
    [self addAction:self.addButton];
}
/**
 *  创建申购工具、资源申购的详情界面
 */
- (void)setToolUI{
    _toolView = [[UIView alloc] init];
    [self addSubview:_toolView];
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_top).offset(181 + 16);
        make.left.equalTo(self.addressView.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(kViewWidth - 16)));
        make.height.equalTo(@(kDeviceProportion(284)));
    }];
    _toolView.layer.borderColor = kGrayCCCCCC.CGColor;
    _toolView.layer.borderWidth = 1.0f;
    _toolTableView = [[UITableView alloc] init];
    _toolTableView.delegate = self;
    _toolTableView.dataSource = self;
   
    [_toolView addSubview:_toolTableView];
    [_toolTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_toolView.mas_top).offset(0);
        make.left.equalTo(_toolView.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(kViewWidth - 16)));
        make.height.equalTo(@(kDeviceProportion(284)));
    }];

}
/**
 *  注册tableViewCell
 */
- (void)setType:(GYHSSubmitType)type
{
    _type = type;
    if (_type == GYHSSubmitTypeToolPurchase) {
        [_toolTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSPurchaseToolCell class]) bundle:nil] forCellReuseIdentifier:purchaseToolCellID];
    }else if (_type == GYHSSubmitTypeResourceSegment){
        [_toolTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSResSegCell class]) bundle:nil] forCellReuseIdentifier:resSegCellID];
    }
}
/**
 *  创建总的订单详情界面
 */
- (void)setTotalUI{

    UIView *totalView = [[UIView alloc] init];
    [self addSubview:totalView];
    [totalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_toolView.mas_top).offset(284 + 16);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(kViewWidth - 16)));
        make.height.equalTo(@(kDeviceProportion(45)));
    }];
    
    UILabel *totalAccountLable = [[UILabel alloc] init];
    totalAccountLable.textColor = kRedE50012;
    totalAccountLable.font = kFont48;
    totalAccountLable.textAlignment = NSTextAlignmentLeft;
    [totalView addSubview:totalAccountLable];
    [totalAccountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalView.mas_top).offset(10);
        make.right.equalTo(totalView.mas_right).offset(-16);
        make.width.equalTo(@(kDeviceProportion(120)));
        make.height.equalTo(@(kDeviceProportion(24)));
    }];
    self.totalAccountLable = totalAccountLable;
    
    UIImageView *coinImageView = [[UIImageView alloc] init];
    [coinImageView setImage:[UIImage imageNamed:@"gyhs_HSBCoin"]];
    [totalView addSubview:coinImageView];
    [coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalView.mas_top).offset(16);
        make.right.equalTo(totalAccountLable.mas_right).offset(-120 - 5);
        make.width.equalTo(@(kDeviceProportion(16)));
        make.height.equalTo(@(kDeviceProportion(16)));
    }];
    
    UILabel *totalTitleLable = [[UILabel alloc] init];
    [totalTitleLable initWithText:kLocalized(@"GYHS_HSStore_PurchaseTools_HSCurrencyAmountPayable") TextColor:kGray999999 Font:kFont48 TextAlignment:2];
    [totalView addSubview:totalTitleLable];
    [totalTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalView.mas_top).offset(10);
        make.right.equalTo(coinImageView.mas_right).offset(-16 - 10);
        make.width.equalTo(@(kDeviceProportion(180)));
        make.height.equalTo(@(kDeviceProportion(24)));
    }];
}
/**
 *  UITableViewDelegate，UITableViewDataSource
 */
#pragma mark -- UITableViewDataSource, UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _addTableView) {
        return _addrDataArray.count;
    }else{
        return  self.type == GYHSSubmitTypeToolPurchase ? _toolPurArray.count : _resSegArray.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _addTableView) {
        GYHSPurchaseAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:purchaseAddressCellID  forIndexPath:indexPath];
        GYHSAddressListModel *addressModel = _addrDataArray[indexPath.row];
        cell.model = addressModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else{
        if (self.type == GYHSSubmitTypeToolPurchase) {
            GYHSPurchaseToolCell *ToolCell = [tableView dequeueReusableCellWithIdentifier:purchaseToolCellID forIndexPath:indexPath];
            ToolCell.model = _toolPurArray[indexPath.row];
            ToolCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _totalAccountLable.text = [GYUtils formatCurrencyStyle:self.sum];
            return ToolCell;
        }else{
            GYHSResSegCell *resSegCell = [tableView dequeueReusableCellWithIdentifier:resSegCellID forIndexPath:indexPath];
            resSegCell.model = self.resSegArray[indexPath.row];
            resSegCell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSInteger totalAccount = [resSegCell.model.segmentPrice integerValue] * _resSegArray.count;
            _totalAccountLable.text = [NSString stringWithFormat:@"%ld",(long)totalAccount];
            if ([self.delegate respondsToSelector:@selector(transPriceStr:)]) {
                [self.delegate transPriceStr:_totalAccountLable.text];
            }
            return resSegCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _addTableView) {

        [_addrDataArray enumerateObjectsUsingBlock:^(__kindof GYHSAddressListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelected = NO;
            
            if (indexPath.row == idx) {
                obj.isSelected = YES;
            }
            _addrDataArray[idx] = obj;
        }];
        
         GYHSAddressListModel *listModel = _addrDataArray[indexPath.row];
     
            if ([self.delegate respondsToSelector:@selector(transSelectedMode:)]) {
                [self.delegate transSelectedMode:listModel];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _addTableView) {
        return 45;
    }else{
     return self.type == GYHSSubmitTypeToolPurchase ? 142 : 141;
    }
}
/**
 *  新增、修改、删除收货地址的代理
 */
#pragma mark -- GYHSOperateAddressDelegate
- (void)deleteAction:(GYHSAddressListModel *)model{
    if ([self.delegate respondsToSelector:@selector(deleteAddress:)]) {
        [self.delegate deleteAddress:model];
    }
    
}
- (void)changeAction:(GYHSAddressListModel *)model{
    if ([self.delegate respondsToSelector:@selector(changeAddress:)]) {
        [self.delegate changeAddress:model];
    }
}
- (void)addAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(addAddress)]) {
        [self.delegate addAddress];
    }
}
@end
