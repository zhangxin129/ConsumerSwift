//
//  GYHSScoreWealQueryDetailViewController.m
//
//  Created by lizp on 16/10/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSScoreWealQueryDetailViewController.h"
#import "YYKit.h"
#import "CheckModel.h"
#import "WealCheckDetailCell.h"
#import "GYHSTools.h"

@interface GYHSScoreWealQueryDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *overlay;//背景
@property (nonatomic,strong) UIButton *dismissBtn;//取消叉叉
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;//数据源
@property (nonatomic, copy) NSString* approvalStatus;

@end

@implementation GYHSScoreWealQueryDetailViewController

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

// #pragma mark - SystemDelegate   
#pragma mark TableView Delegate    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WealCheckDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    CheckItem* item = nil;
    if (self.dataSource.count > indexPath.row) {
        item = self.dataSource[indexPath.row];
    }
    cell.lbTitle.text = item.itemName;
    cell.lbContent.text = item.itemValue;
    cell.nc = self.navigationController;
    cell.vc = self;
    if (item.imgUrlArr) {
        cell.arrImg = item.imgUrlArr;
        cell.btn.hidden = NO;
        [cell.btn setTitleColor:kBtnBlue forState:UIControlStateNormal];
        [cell.btn setTitle:item.imgTitle forState:UIControlStateNormal];
        cell.lbContent.hidden = YES;
    }
    else {
        cell.btn.hidden = YES;
        cell.lbContent.hidden = NO;
    }
    
    if (indexPath.row == self.dataSource.count - 3) {
        if ([self.approvalStatus isEqualToString:kLocalized(@"GYHS_BP_Rejected")]) {
            cell.lbContent.text = @"";
        }
        else {
            cell.lbContent.textColor = kNavigationBarColor;
            cell.lbContent.text = item.itemValue;
        }
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    CheckItem* item = nil;
    if (self.dataSource.count > indexPath.row) {
        item = self.dataSource[indexPath.row];
    }
    return item.height;
}
// #pragma mark - CustomDelegate
#pragma mark - event response  
#pragma mark - 取消叉叉点击
-(void)dismissBtnClick {
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark -接口重构 by zxm 20160105
- (void)getPointWelfareDetailFromNetWork
{
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(self.applyId) forKey:@"applyWelfareNo"];
    
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kPointWelfareDetailUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
            
        }
        [self.dataSource removeAllObjects];
        NSDictionary *dicData = responseObject[@"data"];
        
        [self addItem:kLocalized(@"GYHS_BP_Apply_Order_Number") itemValue:kSaftToNSString(dicData[@"applyWelfareNo"]) ];
        [self addItem:kLocalized(@"GYHS_BP_Apply_For_Time") itemValue:kSaftToNSString(dicData[@"applyDate"]) ];
        if ([dicData[@"welfareType"] integerValue] == [kWelfareTypeHealthBenefitsDetail integerValue]) { //免费医疗
            
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Welfare_Category") itemValue:kLocalized(@"GYHS_BP_Health_Benefits") ];
            [self addItem:kLocalized(@"GYHS_BP_Medicare_Number") itemValue:kSaftToNSString(dicData[@"healthCardNo"]) ];
            [self addItem:kLocalized(@"GYHS_BP_Medical_Start_Time") itemValue:[GYUtils separatedStringByFlag:dicData[@"startDate"] flag:@" "] ];
            [self addItem:kLocalized(@"GYHS_BP_Medical_End_Time") itemValue:[GYUtils separatedStringByFlag:dicData[@"endDate"] flag:@" "] ];
            [self addItem:kLocalized(@"GYHS_BP_Local_City") itemValue:kSaftToNSString(dicData[@"city"]) ];
            [self addItem:kLocalized(@"GYHS_BP_Local_Hospital") itemValue:kSaftToNSString(dicData[@"hospital"]) ];
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Operation_People") itemValue:kSaftToNSString(dicData[@"proposerName"]) ];
            
            //以下是申请附件列表
            
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_The_Attachment_List"):nil:dicData[@"hscPositivePath"]:kLocalized(@"GYHS_BP_Points_Card_Positive")];
            [self addItem:@"":nil:dicData[@"hscReversePath"]:kLocalized(@"GYHS_BP_Points_Card_Back")];
            [self addItem:@"":nil:dicData[@"cerPositivePath"]:kLocalized(@"GYHS_BP_Id_Card_Positive")];
            [self addItem:@"":nil: dicData[@"cerReversePath"]:kLocalized(@"GYHS_BP_Id_Card_Back")];
            [self addItem:@"":nil: dicData[@"sscPath"]:kLocalized(@"GYHS_BP_Own_Social_Security_Card_Copy")];
            [self addItem:@"":nil: dicData[@"ofrPath"]:kLocalized(@"GYHS_BP_Photocopy_Of_The_Original_Fee_Receipt")];
            [self addItem:@"":nil: dicData[@"cdlPath"]:kLocalized(@"GYHS_BP_Cost_List")];
            [self addItem:@"":nil: dicData[@"omrPath"]:kLocalized(@"GYHS_BP_Outpatient_Records_Copy")];
            if ([dicData[@"imrPath"] isKindOfClass:[NSArray class]]) {
                [self addItem:@"" :nil : dicData[@"imrPath"] :kLocalized(@"GYHS_BP_Hospital_Medical_RecordsCopy")];
            }
            [self addItem:@"":nil: dicData[@"ddcPath"]:kLocalized(@"GYHS_BP_Disease_Diagnosis_Certificate_Copy")];
            if ([dicData[@"medicalAcceptPath"] isKindOfClass:[NSArray class]]) {
                [self addItem:@"":nil: dicData[@"medicalAcceptPath"]:kLocalized(@"GYHS_BP_Health_Center_Accept_Return_ReceiptCopy")];
            }
            if ([dicData[@"costCountPath"] isKindOfClass:[NSArray class]]) {
                [self addItem:@"":nil: dicData[@"costCountPath"]:kLocalized(@"GYHS_BP_Medical_Expenses_Calculation_SheetCopy")];
            }
            if ([dicData[@"otherProvePath"] isKindOfClass:[NSArray class]]) {
                [self addItem:@"":nil: dicData[@"otherProvePath"]:kLocalized(@"GYHS_BP_Other_Attachments_Upload")];
            }
            
        } else if ([dicData[@"welfareType"] integerValue] == [kWelfareTypeAccidentHarmSecurityDetail integerValue]) { //意外伤害
            
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Welfare_Category") itemValue:kLocalized(@"GYHS_BP_Accident_Harm_Security") ];
            [self addItem:kLocalized(@"GYHS_BP_Medicare_Number") itemValue:kSaftToNSString(dicData[@"healthCardNo"]) ];
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Operation_People") itemValue:kSaftToNSString(dicData[@"proposerName"]) ];
            //以下是申请附件列表
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_The_Attachment_List"):nil: dicData[@"hscPositivePath"]:kLocalized(@"GYHS_BP_Points_Card_Positive")];
            [self addItem:@"":nil: dicData[@"hscReversePath"]:kLocalized(@"GYHS_BP_Points_Card_Back")];
            [self addItem:@"":nil: dicData[@"cerPositivePath"]:kLocalized(@"GYHS_BP_Id_Card_Positive")];
            [self addItem:@"":nil: dicData[@"cerReversePath"]:kLocalized(@"GYHS_BP_Id_Card_Back")];
            if ([dicData[@"sscPath"] isKindOfClass:[NSArray class]]) {
                [self addItem:@"" :nil : dicData[@"sscPath"] :kLocalized(@"GYHS_BP_Own_Social_Security_Card_Copy")];
            }
            [self addItem:@"" :nil : dicData[@"ofrPath"] :kLocalized(@"GYHS_BP_Photocopy_Of_The_Original_Fee_Receipt")];
            [self addItem:@"" :nil : dicData[@"cdlPath"] :kLocalized(@"GYHS_BP_Cost_List")];
            [self addItem:@"" :nil : dicData[@"ddcPath"] :kLocalized(@"GYHS_BP_The_Diagnosis_Certificate_Copy")];
            if ([dicData[@"imrPath"] isKindOfClass:[NSArray class]]) {
                [self addItem:@"" :nil : dicData[@"imrPath"] :kLocalized(@"GYHS_BP_Hospital_Medical_RecordsCopy")];
            }
            [self addItem:@"":nil: dicData[@"medicalProvePath"]:kLocalized(@"GYHS_BP_Medical_Papers")];
            
            if ([dicData[@"medicalAcceptPath"] isKindOfClass:[NSArray class]]) {
                
                [self addItem:@"" :nil : dicData[@"medicalAcceptPath"] :kLocalized(@"GYHS_BP_Health_Center_Accept_Return_ReceiptCopy")];
            }
            if ([dicData[@"costCountPath"] isKindOfClass:[NSArray class]]) {
                
                [self addItem:@"" :nil : dicData[@"costCountPath"] :kLocalized(@"GYHS_BP_Medical_Expenses_Calculation_SheetCopy")];
            }
            if ([dicData[@"otherProvePath"] isKindOfClass:[NSArray class]]) {
                
                [self addItem:@"" :nil : dicData[@"otherProvePath"] :kLocalized(@"GYHS_BP_Other_Attachments_Upload")];
            }
            
        } else if ([dicData[@"welfareType"] integerValue] == [kWelfareTypeSubstituteApplyDieSecurityDetail integerValue]) { //身故保障
            
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Welfare_Category") itemValue:kLocalized(@"GYHS_BP_Others_Application_Security_Accident") ];
            [self addItem:kLocalized(@"GYHS_BP_By_Security_People_HSNumber") itemValue:kSaftToNSString(dicData[@"deathResNo"]) ];
            [self addItem:kLocalized(@"GYHS_BP_By_Safeguard_People's_Name") itemValue:kSaftToNSString(dicData[@"diePeopleName"]) ];
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Operation_People") itemValue:kSaftToNSString(dicData[@"proposerName"]) ];
            //以下是申请附件列表
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_The_Attachment_List"):nil: dicData[@"deathProvePath"]:kLocalized(@"GYHS_BP_Die_Death_Certificate_In_The_Attachment")];
            [self addItem:@"":nil:  dicData[@"ifpPath"]:kLocalized(@"GYHS_BP_Agent_Accredit_Power_Of_Attorney")];
            [self addItem:@"":nil: dicData[@"hrcPath"]:kLocalized(@"GYHS_BP_Household_Register_Certification")];
            [self addItem:@"":nil: dicData[@"aipPath"]:kLocalized(@"GYHS_BP_Agent_Legal_Proof_Of_Identity")];
            if ([dicData[@"diePeopleCerPath"] isKindOfClass:[NSArray class]]) {
                [self addItem:@"" :nil : dicData[@"diePeopleCerPath"] :kLocalized(@"GYHS_BP_By_Guaranteed_Legal_Proof_Identity")];
            }
            if ([dicData[@"otherProvePath"] isKindOfClass:[NSArray class]] ) {
                [self addItem:@"" :nil : dicData[@"otherProvePath"] :kLocalized(@"GYHS_BP_Other_Documents")];
            }
        }
        
        self.approvalStatus = @"";
        if ([dicData[@"approvalStatus"] integerValue] == 0) {
            self.approvalStatus = kLocalized(@"GYHS_BP_To_Accept_The");
        }
        if ([dicData[@"approvalStatus"] integerValue] == 1) {
            self.approvalStatus = kLocalized(@"GYHS_BP_To_Accept_The_Success");
        }
        if ([dicData[@"approvalStatus"] integerValue] == 2) {
            self.approvalStatus = kLocalized(@"GYHS_BP_Rejected");
        }
        
        [self addItem:kLocalized(@"GYHS_BP_Review_The_Result_status") itemValue:self.approvalStatus ];
        
        
        
        [self addItem:kLocalized(@"GYHS_BP_Approval_Amount") itemValue:[GYUtils formatCurrencyStyle:[kSaftToNSString(dicData[@"replyAmount"]) doubleValue]]];
        
        [self addItem:kLocalized(@"GYHS_BP_Audit_Information") itemValue:kSaftToNSString(dicData[@"approvalReason"]) ];
        [self addItem:kLocalized(@"GYHS_BP_Audit_Time") itemValue:kSaftToNSString(dicData[@"approvalDate"]) ];

        //刷新表格
        [self.tableView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}



#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    [self addOverlayView];
}


//背景
-(void)addOverlayView {
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 64, kScreenWidth -20, kScreenHeight - 64 -49 - 60)];
    backgroundView.layer.cornerRadius = 12;
    backgroundView.clipsToBounds = YES;
    backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backgroundView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backgroundView.width, 30)];
    titleLabel.text = self.navTitle;
    titleLabel.backgroundColor = kDefaultVCBackgroundColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0x000000);
    titleLabel.font = kScoreWealQueryDetailTitleFont;
    [backgroundView addSubview:titleLabel];
    
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(10, titleLabel.bottom, kScreenWidth -20, kScreenHeight - titleLabel.bottom -49 - 60)];
    self.overlay.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:self.overlay];
    [self.overlay  addSubview:self.tableView];
    
    //叉叉按钮
    self.dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissBtn.frame = CGRectMake(kScreenWidth/2 -20, self.overlay.bottom +20, 40, 40);
    
    [self.dismissBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_account_delete_view"] forState:UIControlStateNormal];
    [self.dismissBtn addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissBtn];
    
    
    [self setUp];
}

-(void)setUp {

    [self getPointWelfareDetailFromNetWork];
}

- (void)addItem:(NSString*)itemName itemValue:(NSString*)itemValue
{
    CheckItem* item = [[CheckItem alloc] init];
    item.itemName = itemName;
    
    if ([GYUtils checkStringInvalid:itemValue]) {
        itemValue = @"";
    }
    
    item.itemValue = itemValue;
    CGRect rect = [itemValue boundingRectWithSize:CGSizeMake(kScreenWidth - 122, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : kScoreWealQueryDetailItemFont } context:nil];
    item.height = rect.size.height + 3;
    
    [self.dataSource addObject:item];
}

- (void)addItem:(NSString*)itemName:(NSString*)itemValue:(NSArray*)urlArr:(NSString*)urlName
{
    CheckItem* item = [[CheckItem alloc] init];
    item.itemName = itemName;
    
    if ([GYUtils checkStringInvalid:itemValue]) {
        itemValue = @"";
    }
    item.itemValue = itemValue;
    CGRect rect = [itemValue boundingRectWithSize:CGSizeMake(kScreenWidth - 122, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : kScoreWealQueryDetailItemFont } context:nil];
    item.height = rect.size.height;
    item.imgTitle = urlName;
    
    if ([urlArr isKindOfClass:[NSArray class]]) {
        NSMutableArray* arr = [NSMutableArray array];
        for (NSString* strUrl in urlArr) {
            if (![GYUtils checkStringInvalid:strUrl]) {
                NSString* newUrl;
                if ([[strUrl lowercaseString] hasPrefix:@"http"]) {
                    newUrl = strUrl;
                }
                else {
                    newUrl = [globalData.loginModel.picUrl stringByAppendingString:strUrl];
                }
                [arr addObject:newUrl];
            }
        }
        item.imgUrlArr = arr;
    }
    [self.dataSource addObject:item];
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.overlay.width, self.overlay.height-65) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WealCheckDetailCell class]) bundle:nil] forCellReuseIdentifier:@"CELL"];
     
        [_overlay  addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource {

    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
