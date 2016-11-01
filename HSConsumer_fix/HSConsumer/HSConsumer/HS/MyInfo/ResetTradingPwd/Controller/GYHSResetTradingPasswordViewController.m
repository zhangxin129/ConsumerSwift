//
//  GYHSResetTradingPasswordViewController.m
//
//  Created by lizp on 16/8/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//


#import "GYHSResetTradingPasswordViewController.h"
#import "GYHSResetTradingTableViewCell.h"
#import "GYHSResetTradingFooterView.h"
#import "GYHSResetRradingAuthcodeTableViewCell.h"
#import "GYHSResetTradingPasswordCommitViewController.h"

@interface GYHSResetTradingPasswordViewController ()<UITableViewDataSource,UITableViewDelegate,GYHSResetTradingFooterViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleData;
@property (nonatomic,strong) NSArray *placeHolderData;


@end

@implementation GYHSResetTradingPasswordViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

 #pragma mark - SystemDelegate   
 #pragma mark TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.titleData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row !=3) {
        GYHSResetTradingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSResetTradingTableViewCellIdentifier];
        [cell refreshDataWithTitle:self.titleData[indexPath.row] placeHolder:self.placeHolderData[indexPath.row] indexPaht:indexPath];
        return cell;
    }else {
        GYHSResetRradingAuthcodeTableViewCell *authcodeCell = [tableView dequeueReusableCellWithIdentifier:kGYHSResetRradingAuthcodeTableViewCellIdentifier];
        [authcodeCell refreshDataWithTitle:self.titleData[indexPath.row] placeHolder:self.placeHolderData[indexPath.row]];
        return authcodeCell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50.0f;
}

#pragma mark - CustomDelegate

#pragma mark - GYHSResetTradingFooterViewDelegate
-(void)footerConfirmClick {
    [self commitData];
}

#pragma mark - GYHSResetRradingAuthcodeTableViewCellDelegate 
-(void)authcodeDidChange:(NSString *)code {

}

#pragma mark - event response
-(void)commitData {
    
    [self.view endEditing:YES];
    if([self cheakValid]) {
        
    }
    
    GYHSResetTradingPasswordCommitViewController *commitVC = [[GYHSResetTradingPasswordCommitViewController alloc] init];
    [self.navigationController  pushViewController:commitVC animated:YES];
}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"GYHS_Pwd_Reset_Trading_Password");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.tableView];
    
    GYHSResetTradingFooterView *footerView = [[GYHSResetTradingFooterView alloc ] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.delegate = self;
    footerView.tipStr = @"GYHS_Pwd_Tip_Business_Is_Dealt_With_By_Real_Name_Authentication";
    self.tableView.tableFooterView = footerView;
}

-(BOOL)cheakValid {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    GYHSResetTradingTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if([GYUtils checkStringInvalid:cell.value.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_Enter_Names_Of_Real_Name_Authentication")];
        return NO;
    }
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if([GYUtils checkStringInvalid:cell.value.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_Enter_Real_Name_Authentication_Certificate_Number")];
        return NO;
    }
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if([GYUtils checkStringInvalid:cell.value.text] || cell.value.text.length != 6) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_EnterPassword6Number")];
        return NO;
    }
    
    indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    GYHSResetRradingAuthcodeTableViewCell *authcodeCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if([GYUtils checkStringInvalid:authcodeCell.value.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_Input_Validation_Code")];
        return NO;
    }
    
    if(![authcodeCell.authcodeStr isEqualToString:authcodeCell.value.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_ValidationError")];
        return NO;
    }
    
    return YES;
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, kScreenHeight -64-15) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSResetTradingTableViewCell" bundle:nil] forCellReuseIdentifier:kGYHSResetTradingTableViewCellIdentifier];
        [_tableView registerClass:[GYHSResetRradingAuthcodeTableViewCell class] forCellReuseIdentifier:kGYHSResetRradingAuthcodeTableViewCellIdentifier];
    }
    return _tableView;
}

-(NSArray *)titleData {
    
    if (!_titleData) {
        _titleData = @[kLocalized(@"GYHS_Pwd_Real_Name"),kLocalized(@"GYHS_Pwd_Papers_Number"),kLocalized(@"GYHS_Pwd_Login_Pwd"),kLocalized(@"GYHS_Pwd_Verification_Code")];
    }
    return _titleData;
}

-(NSArray *)placeHolderData {
    
    if(!_placeHolderData) {
        _placeHolderData   = @[kLocalized(@"GYHS_Pwd_Enter_Names_Of_Real_Name_Authentication"),kLocalized(@"GYHS_Pwd_Enter_Real_Name_Authentication_Certificate_Number"),kLocalized(@"GYHS_Pwd_EnterPassword6Number"),kLocalized(@"GYHS_Pwd_Input_Validation_Code")];
    }
    return _placeHolderData ;
}




@end
