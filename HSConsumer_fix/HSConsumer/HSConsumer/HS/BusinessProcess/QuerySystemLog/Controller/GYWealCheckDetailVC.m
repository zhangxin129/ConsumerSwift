//
//  GYWealCheckDetailVC.m
//  HSConsumer
//
//  Created by 00 on 15-3-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYWealCheckDetailVC.h"
#import "WealCheckDetailCell.h"
#import "CheckModel.h"
#import "GYAlertView.h"
#import "GYHSLoginManager.h"

@interface GYWealCheckDetailVC () <UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITableView* tbv;
    GlobalData* data; //全局单例

    NSMutableArray* mArrData;
}

//tableView的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* tbvHeightLayout;
//tableView的Y值
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* tbvYLayout;

@property (nonatomic, assign) CGFloat cellHeigth;

@property (nonatomic, copy) NSString* cellContent;

@property (nonatomic, copy) NSString* approvalStatus;

@end

@implementation GYWealCheckDetailVC

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [tbv addAllBorder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mArrData = [[NSMutableArray alloc] init];

    //实例化单例
    data = globalData;

    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tbv registerNib:[UINib nibWithNibName:@"WealCheckDetailCell" bundle:nil] forCellReuseIdentifier:@"CELL"];

    [self tbvHeight];
    [self getPointWelfareDetailFromNetWork];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return mArrData.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    CheckItem* item = nil;
    if (mArrData.count > indexPath.row) {
        item = mArrData[indexPath.row];
    }
    return item.height;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    WealCheckDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];

    CheckItem* item = nil;
    if (mArrData.count > indexPath.row) {
        item = mArrData[indexPath.row];
    }
    cell.lbTitle.text = item.itemName;
    cell.lbContent.text = item.itemValue;
    cell.nc = self.navigationController;

    if (item.imgUrlArr) {
        cell.arrImg = item.imgUrlArr;
        cell.btn.hidden = NO;
        [cell.btn setTitle:item.imgTitle forState:UIControlStateNormal];
        cell.lbContent.hidden = YES;
    }
    else {
        cell.btn.hidden = YES;
        cell.lbContent.hidden = NO;
    }

    if (indexPath.row == mArrData.count - 3) {
        if ([self.approvalStatus isEqualToString:kLocalized(@"GYHS_BP_Rejected")]) {
            cell.lbContent.text = @"";
        }
        else {
            cell.lbContent.textColor = kNavigationBarColor;
            //cell.lbContent.text = [GYUtils formatCurrencyStyle:item.itemValue.doubleValue];
            cell.lbContent.text = item.itemValue;
        }
    }

    return cell;
}

- (void)addItem:(NSString*)itemName:(NSString*)itemValue
{
    CheckItem* item = [[CheckItem alloc] init];
    item.itemName = itemName;

    if ([GYUtils checkStringInvalid:itemValue]) {
        itemValue = @"";
    }

    item.itemValue = itemValue;
    CGRect rect = [itemValue boundingRectWithSize:CGSizeMake(kScreenWidth - 122, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12] } context:nil];
    item.height = rect.size.height + 3;

    [mArrData addObject:item];
}

- (void)addItem:(NSString*)itemName:(NSString*)itemValue:(NSArray*)urlArr:(NSString*)urlName
{
    CheckItem* item = [[CheckItem alloc] init];
    item.itemName = itemName;

    if ([GYUtils checkStringInvalid:itemValue]) {
        itemValue = @"";
    }
    item.itemValue = itemValue;
    CGRect rect = [itemValue boundingRectWithSize:CGSizeMake(kScreenWidth - 122, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12] } context:nil];
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
    [mArrData addObject:item];
}

- (void)tbvHeight
{
    float tbvHeight = 0.0;
    for (int i = 0; i < mArrData.count; i++) {
        CheckItem* item = mArrData[i];
        tbvHeight += (item.height);
    }

    if (tbvHeight > kScreenHeight - 64 - 16) {
        tbvHeight = kScreenHeight - 64 - 16;
        tbv.scrollEnabled = YES;
    }
    else
        tbv.scrollEnabled = NO;

    self.tbvHeightLayout.constant = tbvHeight;
    self.tbvYLayout.constant = 16;
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
        [mArrData removeAllObjects];
        NSDictionary *dicData = responseObject[@"data"];
        
        [self addItem:kLocalized(@"GYHS_BP_Apply_Order_Number"):kSaftToNSString(dicData[@"applyWelfareNo"]) ];
        [self addItem:kLocalized(@"GYHS_BP_Apply_For_Time"):kSaftToNSString(dicData[@"applyDate"]) ];
        if ([dicData[@"welfareType"] integerValue] == [kWelfareTypeHealthBenefitsDetail integerValue]) { //免费医疗
            
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Welfare_Category"):kLocalized(@"GYHS_BP_Health_Benefits") ];
            [self addItem:kLocalized(@"GYHS_BP_Medicare_Number"):kSaftToNSString(dicData[@"healthCardNo"]) ];
            [self addItem:kLocalized(@"GYHS_BP_Medical_Start_Time"):[GYUtils separatedStringByFlag:dicData[@"startDate"] flag:@" "] ];
            [self addItem:kLocalized(@"GYHS_BP_Medical_End_Time"):[GYUtils separatedStringByFlag:dicData[@"endDate"] flag:@" "] ];
            [self addItem:kLocalized(@"GYHS_BP_Local_City"):kSaftToNSString(dicData[@"city"]) ];
            [self addItem:kLocalized(@"GYHS_BP_Local_Hospital"):kSaftToNSString(dicData[@"hospital"]) ];
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Operation_People"):kSaftToNSString(dicData[@"proposerName"]) ];
            
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
            
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Welfare_Category"):kLocalized(@"GYHS_BP_Accident_Harm_Security") ];
            [self addItem:kLocalized(@"GYHS_BP_Medicare_Number"):kSaftToNSString(dicData[@"healthCardNo"]) ];
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Operation_People"):kSaftToNSString(dicData[@"proposerName"]) ];
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
            
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Welfare_Category"):kLocalized(@"GYHS_BP_Others_Application_Security_Accident") ];
            [self addItem:kLocalized(@"GYHS_BP_By_Security_People_HSNumber"):kSaftToNSString(dicData[@"deathResNo"]) ];
            [self addItem:kLocalized(@"GYHS_BP_By_Safeguard_People's_Name"):kSaftToNSString(dicData[@"diePeopleName"]) ];
            [self addItem:kLocalized(@"GYHS_BP_Apply_For_Operation_People"):kSaftToNSString(dicData[@"proposerName"]) ];
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
        
        [self addItem:kLocalized(@"GYHS_BP_Review_The_Result_status"):self.approvalStatus ];
        
        
        
        [self addItem:kLocalized(@"GYHS_BP_Approval_Amount"):kSaftToNSString(dicData[@"replyAmount"]) ];
        
        [self addItem:kLocalized(@"GYHS_BP_Audit_Information"):kSaftToNSString(dicData[@"approvalReason"]) ];
        [self addItem:kLocalized(@"GYHS_BP_Audit_Time"):kSaftToNSString(dicData[@"approvalDate"]) ];
        
        //调整表格size
        [self tbvHeight];
        //刷新表格
        [tbv reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

@end
