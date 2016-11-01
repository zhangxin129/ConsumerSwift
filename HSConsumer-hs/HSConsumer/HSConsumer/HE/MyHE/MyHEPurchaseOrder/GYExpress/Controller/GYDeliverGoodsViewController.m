//
//  GYDeliverGoodsViewController.m
//  HSConsumer
//
//  Created by apple on 16/3/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYDeliverGoodsViewController.h"
#import "GYExpressModel.h"
#import "GYExpressListCell.h"
#import "GYGIFHUD.h"
@interface GYDeliverGoodsViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) UITableView* expressTableView; //快递列表
@property (nonatomic, strong) NSMutableArray* expressDatas; //数据源
@property (nonatomic, strong) UILabel* expressNumLabel; //快递单号
@property (nonatomic, strong) UILabel* remarksLabel; //备注
@property (nonatomic, strong) UITextField* expressNumTextField; //输入快递号
@property (nonatomic, strong) UITextView* remarksTextView; //输入备注信息
@property (nonatomic, copy) NSString* logisticId; //记录物流id
@property (nonatomic, copy) NSString* logisticName; //记录物流名称
@property (nonatomic, strong) UILabel* textViewHolder;
@end

@implementation GYDeliverGoodsViewController

- (NSMutableArray*)expressDatas
{

    if (!_expressDatas) {

        _expressDatas = [NSMutableArray array];
    }
    return _expressDatas;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHE_MyHE_DeliverGoods");

    self.view.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1.0];

    [self initExpressUI];

    [self loadExpressData];
}

- (void)initExpressUI
{

    self.expressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight * 1 / 2) style:UITableViewStylePlain];

    self.expressTableView.delegate = self;
    self.expressTableView.dataSource = self;

    self.expressTableView.rowHeight = 44;

    [self.expressTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYExpressListCell class]) bundle:nil] forCellReuseIdentifier:@"GYExpressListCellId"];

    [self.view addSubview:self.expressTableView];

    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.expressTableView.frame) + 20, kScreenWidth, 90)];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    self.expressNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 40)];
    self.expressNumLabel.text = kLocalized(@"GYHE_MyHE_ExpressNumber");
    self.expressNumLabel.textAlignment = NSTextAlignmentLeft;
    self.expressNumLabel.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:self.expressNumLabel];

    self.expressNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.expressNumLabel.frame) + 2, 5, kScreenWidth - 20 - self.expressNumLabel.frame.size.width, 40)];
    self.expressNumTextField.placeholder = kLocalized(@"GYHE_MyHE_InputExpressNumber");
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.expressNumLabel.frame), kScreenWidth - 20, 1)];
    lineView.backgroundColor = kCellItemTextColor;
    [bgView addSubview:lineView];
    [bgView addSubview:self.expressNumTextField];

    self.remarksLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 2, 80, 40)];
    self.remarksLabel.font = kCellTitleFont;
    self.remarksLabel.text = kLocalized(@"GYHE_MyHE_Remarks");
    self.remarksLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:self.remarksLabel];

    self.remarksTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.remarksLabel.frame) + 1, CGRectGetMaxY(lineView.frame) + 2, kScreenWidth - 20 - self.remarksLabel.frame.size.width, 40)];
    self.remarksTextView.font = kCellTitleFont;
    self.textViewHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.remarksTextView.frame.size.width, self.remarksTextView.frame.size.height)];
    self.remarksTextView.delegate = self;
    self.textViewHolder.backgroundColor = [UIColor clearColor];
    [self.remarksTextView addSubview:self.textViewHolder];
    self.textViewHolder.textColor = [UIColor colorWithRed:195 / 255.0 green:195 / 255.0 blue:198 / 255.0 alpha:1];
    self.textViewHolder.font = kCellTitleFont;
    self.textViewHolder.text = kLocalized(@"GYHE_MyHE_InputRemarks");

    [bgView addSubview:self.remarksTextView];

    UIButton* comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmBtn.frame = CGRectMake(10, kScreenHeight - 50 - 64, kScreenWidth - 20, 40);
    [comfirmBtn setTitle:kLocalized(@"GYHE_MyHE_Confirms") forState:UIControlStateNormal];
    [comfirmBtn setBackgroundColor:kNavigationBarColor];
    [comfirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comfirmBtn];
}

#pragma mark - 加载快递数据
- (void)loadExpressData
{
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyExpressUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        if ([responseObject[@"retCode"] integerValue] == 200) {
            
            NSArray *arr = responseObject[@"data"];
            
            for (NSDictionary *dic in arr) {
                
                GYExpressModel *model = [[GYExpressModel alloc] init];
                [model loadModelDataWithDictionary:dic];
                [self.expressDatas addObject:model];
            }
        } else {

            [GYUtils showToast:kLocalized(@"GYHE_MyHE_ExpressListFiald")];
        }
        [self.expressTableView reloadData];
    }];
    [request start];
}

#pragma mark - uitableView代理方法

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.expressDatas.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYExpressListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYExpressListCellId"];
    GYExpressModel* model = nil;
    if (self.expressDatas.count > 0) {
        model = self.expressDatas[indexPath.row];
    }

    [cell refreshUIWithModel:model];
    if (!model.isSelect) {

        cell.isSelectImageView.hidden = YES;
    }
    else {

        cell.isSelectImageView.hidden = NO;
    }

    cell.selectionStyle = 0;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //    重置所有cell状态
    for (GYExpressModel* model in self.expressDatas) {

        model.isSelect = NO;
    }
    //   获取选中的cell状态
    GYExpressModel* model = nil;
    if (self.expressDatas.count > indexPath.row) {
        model = self.expressDatas[indexPath.row];
    }

    self.logisticId = model.expressId;
    self.logisticName = model.name;

    model.isSelect = YES;

    [self.expressTableView reloadData];
}

#pragma mark - 发货
- (void)confirmClick
{
    if (self.logisticName == nil || self.logisticId == nil) {

        [GYUtils showToast:kLocalized(@"GYHE_MyHE_PleaseSelectExpressCompany")];
        return;
    }
    if (self.expressNumTextField.text == nil || self.expressNumTextField.text.length <= 0) {
        
        [GYUtils showToast:kLocalized(@"GYHE_MyHE_PleaseSelectExpressNumber")];
        return;
    }

    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:kSaftToNSString(globalData.loginModel.token) forKey:@"key"];
    [dict setValue:kSaftToNSString(self.applyId) forKey:@"refId"];
    [dict setValue:kSaftToNSString(self.logisticId) forKey:@"logisticId"];
    [dict setValue:kSaftToNSString(self.logisticName) forKey:@"logisticName"];
    [dict setValue:kSaftToNSString(self.expressNumTextField.text) forKey:@"logisticCode"];
    [dict setValue:kSaftToNSString(self.remarksTextView.text) forKey:@"userNote"];
    [GYGIFHUD show];
    
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyBuyersDeliveryUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        if ([responseObject[@"retCode"] integerValue] == 200) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll)stringValue]] object:nil userInfo:nil];
            [GYUtils showToast:kLocalized(@"GYHE_MyHE_ExpressSendSuccess")];
            [self.navigationController popViewControllerAnimated:YES];

        } else {
            
            [GYUtils showToast:kLocalized(@"GYHE_MyHE_ExpressListFiald")];
        }
        [self.expressTableView reloadData];
    }];
    [request start];
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{

    NSString* toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容

    if (toBeString.length > 0) {
        self.textViewHolder.hidden = YES;
    }
    else {
        self.textViewHolder.hidden = NO;
    }

    return YES;
}

- (void)textViewDidChange:(UITextView*)textView
{

    if (textView.text.length > 0) {
        self.textViewHolder.hidden = YES;
    } else {
        self.textViewHolder.hidden = NO;
    }

}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
