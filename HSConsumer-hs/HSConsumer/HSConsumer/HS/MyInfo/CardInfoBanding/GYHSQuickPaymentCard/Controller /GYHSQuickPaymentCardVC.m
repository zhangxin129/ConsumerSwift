//
//  GYHSQuickPaymentCardVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/28.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSQuickPaymentCardVC.h"
#import "GYNetRequest.h"
#import "GYHSQuickPaymentCardTableCell.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginModel.h"
#import "GYHSNetworkAPI.h"
#import "GYHSQuickPayModel.h"
#import "GYHSConstant.h"
#import "GYHSNonQuickBankBindingView.h"
#import "NSMutableArray+SWUtilityButtons.h" 
#import "SWCellScrollView.h"

#define kGYHSQuickPaymentCardVC_CellIdentify  @"kGYHSQuickPaymentCardVC_CellIdentify"

#define kQueryQuickPayBanksList_Tag  100
#define kUnBindQuickPayBank_Tag      101


@interface GYHSQuickPaymentCardVC()<UITableViewDelegate, UITableViewDataSource, GYNetRequestDelegate,SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) GYHSNonQuickBankBindingView *tipsView;
@property (nonatomic, assign) NSInteger cellindex;

@end

@implementation GYHSQuickPaymentCardVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self queryQuickBankList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view delegate
- (NSInteger ) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    GYHSQuickPaymentCardTableCell *cell = (GYHSQuickPaymentCardTableCell*)[tableView dequeueReusableCellWithIdentifier:kGYHSQuickPaymentCardVC_CellIdentify];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:80.0f];
    cell.delegate = self;
    cell.tag = indexPath.section;
    cell.cellScrollView.tag = indexPath.section;
    GYHSQuickPayModel *model = nil;
    if (self.dataArray.count > indexPath.row) {
        model = self.dataArray[indexPath.section];
    }
    [cell setCellValue:model];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}
- (NSArray*)rightButtons
{
    NSMutableArray* rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] icon:[UIImage imageNamed:@"gyhs_delete_image"]];
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell*)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSArray* cells = [self.tableView visibleCells];
    NSInteger delIndex = -1;
    
    for (UITableViewCell* cel in cells) {
        if (cel.tag == cell.cellScrollView.tag) {
            self.cellindex = cel.tag;
            delIndex = self.cellindex;
            break;
        }
    }
    
    if (delIndex >= 0 &&  (delIndex < [self.dataArray count])) {
        GYHSQuickPayModel* model = self.dataArray[delIndex];
        [self gotoQuitBanding:model];
    }
}

- (void)gotoQuitBanding:(GYHSQuickPayModel *)model {
    
    [GYUtils showMessge:kLocalized(@"GYHS_Banding_Sure_Delete_Binding_Account") confirm:^{
        NSDictionary* dictParams = @{ @"accId" : kSaftToNSString(model.accId),
                                      @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard };
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlUnBindQkBank parameters:dictParams requestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerJSON];
        request.tag = kUnBindQuickPayBank_Tag;
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [request start];
        [GYGIFHUD show];
    } cancleBlock:^{
        
    }];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest *)netRequest didSuccessWithData:(NSDictionary *)responseObject {
    
    [GYGIFHUD dismiss];
    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Business_Resport_Lost_Card_Error_For_Respond_Data") confirm:nil];
        return;
    }
    
    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
    if(netRequest.tag == kQueryQuickPayBanksList_Tag) {
        [self parsequeryQuickBankList:returnCode responseObject:responseObject];
    }
    else if(netRequest.tag == kUnBindQuickPayBank_Tag) {
        [self parseUnBindQuickPayBank:returnCode responseObject:responseObject];
    }
}

- (void)netRequest:(GYNetRequest *)netRequest didFailureWithError:(NSError *)error {
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - private methods
-(void) initView {
    self.title = kLocalized(@"GYHS_Banding_MyQuickPaymentCard");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.tableView];
}

- (void) queryQuickBankList {
    GYHSLoginModel *model = [self loginModel];
    BOOL isCardUser = [[GYHSLoginManager shareInstance] loginModuleObject].cardHolder;
    NSDictionary *paramDic = @{@"custId" : model.custId,
                               @"userType" : isCardUser ? kUserTypeCard : kUserTypeNoCard,
                               @"bindingChannel" : @"P"};
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlListQkBanks parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    request.tag = kQueryQuickPayBanksList_Tag;
    [request start];
    [GYGIFHUD show];
}

- (void) parsequeryQuickBankList:(NSInteger)returnCode responseObject:(NSDictionary *)responseObject {
    
    if (returnCode != 200) {
        NSLog(@"The returnCode:%ld is not 200.", returnCode);
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Quick_Payment_List_Fail")];
        return;
    }
    
    [self.dataArray removeAllObjects];
    NSArray *serverAry = responseObject[@"data"];
    if ([GYUtils checkArrayInvalid:serverAry]) {
        NSLog(@"The serverAry:%@ is invalid.", serverAry);
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Quick_Payment_List_Fail")];
        return;
    }
    
    for (NSDictionary *tempDic in serverAry) {
        GYHSQuickPayModel *model = [[GYHSQuickPayModel alloc] initWithDictionary:tempDic error:nil];
        
        [self.dataArray addObject:model];
    }
    
    if (self.dataArray.count > 0) {
        if (self.tipsView) {
            [self.tipsView removeFromSuperview];
        }
    } else {
        self.tipsView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSNonQuickBankBindingView class]) owner:self options:nil] lastObject];
        [self.view addSubview:self.tipsView];
        return;
    }
    
    [self.tableView reloadData];
}
- (void) parseUnBindQuickPayBank:(NSInteger)returnCode responseObject:(NSDictionary *)responseObject {
    
    if (returnCode != 200) {
        NSLog(@"The returnCode:%ld is not 200.", returnCode);
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Remove_Binding_Quick_Payment_Card_Failure")];
        return;
    }
    [self.dataArray removeObjectAtIndex:self.cellindex];
    WS(weakSelf)
    [GYUtils showMessage:kLocalized(@"GYHS_Banding_Bank_Card_Removed_Successfully") confirm:^{
        
        [weakSelf queryQuickBankList];
        if(self.dataArray == nil ||   self.dataArray.count == 0) {
            globalData.loginModel.isBindBank = @"0";
            [self.navigationController popViewControllerAnimated:YES];
        }
       [self.tableView reloadData];
    }];
}

- (GYHSLoginModel *) loginModel {
    return [[GYHSLoginManager shareInstance] loginModuleObject];
}

#pragma mark - getter and setter
- (UITableView *) tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSQuickPaymentCardTableCell class]) bundle:nil] forCellReuseIdentifier:kGYHSQuickPaymentCardVC_CellIdentify];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

@end
