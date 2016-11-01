
//  HSConsumer
//
//  Created by apple on 15-1-15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "UIButton+GYExtension.h"
#import "GYImportantChangeViewController.h"
#import "InputCellStypeView.h"
#import "GYCountrySelectionViewController.h"
#import "GYRealNameAuthConfirmViewController.h"
#import "GYChooseAreaModel.h"
#import "FMDatabase.h"
#import "GYTwoPictureViewController.h"
#import "GYDatePiker.h"
#import "UIActionSheet+Blocks.h"
#import "GYAddressCountryModel.h"
#import "GYAddressData.h"

@interface GYImportantChangeViewController () <GYDatePikerDelegate, UITextFieldDelegate>

@end

@implementation GYImportantChangeViewController {
    __weak IBOutlet UIScrollView* scrMain; //背景滚动试图
    __weak IBOutlet InputCellStypeView* InputRealNameRow; //输入真实姓名
    __weak IBOutlet InputCellStypeView* InputSexRow; //输入性别
    __weak IBOutlet InputCellStypeView* InputNationaltyRow; //输入国籍
    __weak IBOutlet InputCellStypeView* InputCertificationType; //输入证件类型
    __weak IBOutlet InputCellStypeView* InputCerNumberRow; //输入证件号码
    __weak IBOutlet InputCellStypeView* InputCerDurationRow; //输入证件有效时间

    __weak IBOutlet UIView* vBackgroundDown; //下面的背景view
    __weak IBOutlet UILabel* lbPlaceHolder; //占位符
    __weak IBOutlet UILabel* lbTitle; //下面的标题

    __weak IBOutlet InputCellStypeView* InputRegAddressRow; //输入户籍地址

    __weak IBOutlet UITextView* tfInputRegAddress;
    __weak IBOutlet UILabel* lbRegAddressPlaceholder;

    __weak IBOutlet UITextView* tvInputText;

    __weak IBOutlet InputCellStypeView* InputPaperOrganization; //发证机关
    __weak IBOutlet InputCellStypeView* birthPlaceRowView; // 出生地点
    __weak IBOutlet InputCellStypeView* placeIssueRowView; // 签发地点

    NSMutableDictionary* dictInside;

    FMDatabase* dataBase;

    GYDatePiker* datePiker;

    __weak IBOutlet UIButton* btnChangeCountry;

    NSString* sexString;

    NSString* countryString;

    __weak IBOutlet UIButton* btnLongPeriod;

    BOOL islongPeriod;

    NSMutableDictionary* dicParams, *olddicParams;
    NSMutableArray* changeItemArr;

    BOOL isSelect;

    __weak IBOutlet UIButton* sexbutton;

    //旧值
    NSString* fullUserName;
    NSString* oldFullUserName;
    
    NSString* fullIdentityCard;
    NSString *oldfullIdentityCard;
    
    NSString *sex;
    NSString *nationalty;
    NSString *issuingOrg;
    NSString *birthAddress;
    NSString *longPerid;
    NSString *newlongPerid;
    NSString *authDate;
    NSString *entType;
    NSString *entRegAddr;
    NSString *OldplaceIssue;// 旧签发地点
    NSString *birthPlace;//出生地址
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_MyInfo_Important_Informatiron_Change");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    islongPeriod = NO;

    [sexbutton setEnlargEdgeWithTop:2 right:20 bottom:5 left:100];
    [btnChangeCountry setEnlargEdgeWithTop:2 right:20 bottom:5 left:100];
    dicParams = [[NSMutableDictionary alloc] init];
    olddicParams = [[NSMutableDictionary alloc] init];
    changeItemArr = [[NSMutableArray alloc] init];

    InputCertificationType.tfRightTextField.enabled = NO;

    //1、获得沙盒中Document文件夹的路径——目的路径
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [paths objectAtIndex:0];
    NSString* desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];

    //2、移动数据库到沙盒
    [self moveToDBFile];

    //3、打开数据库
    dataBase = [FMDatabase databaseWithPath:desPath];
    if (![dataBase open]) {
        DDLogDebug(@"open db error!");
    }

    [self changePageView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalized(@"GYHS_MyInfo_Next_Step") style:UIBarButtonItemStyleBordered target:self action:@selector(confirm)];

    //获取实名认证的信息
    [self loadsearchRealNameRegInfo];
}

- (void)moveToDBFile
{
    //1、获得数据库文件在工程中的路径——源路径。
    NSString* sourcesPath = [[NSBundle mainBundle] pathForResource:@"T_PUB_AREA" ofType:@"db"];

    //2、获得沙盒中Document文件夹的路径——目的路径
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [paths objectAtIndex:0];
    NSString* desPath = [documentPath stringByAppendingPathComponent:@"T_PUB_AREA.db"];

    //3、通过NSFileManager类，将工程中的数据库文件复制到沙盒中。
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:desPath]) {
        NSError* error;

        if ([fileManager copyItemAtPath:sourcesPath toPath:desPath error:&error]) {
            DDLogDebug(@"数据库移动成功");
        }
        else {
            DDLogDebug(@"数据库移动失败");
        }
    }
}

- (NSString*)selectFromDBAreaName:(NSString*)countryCode
{
    GYChooseAreaModel* model;
    FMResultSet* set = [dataBase executeQuery:@"select * from T_PUB_AREA"];
    while ([set next]) {
        model = [[GYChooseAreaModel alloc] init];
        model.areaNo = [NSString stringWithFormat:@"%@", [set stringForColumn:@"area_no"]];

        if ([model.areaNo isEqualToString:countryCode]) {
            model.areaName = [NSString stringWithFormat:@"%@", [set stringForColumn:@"area_name"]];
            break;
        }
    }

    return model.areaName;
}

- (void)alerViewByString:(NSString*)string
{
    [GYUtils showMessage:string];
    
    return;
}

- (void)confirm
{
    // modify by songjk
    BOOL bCheck = true;
    NSString* name = kSaftToNSString(fullUserName);
    NSString* identCode = kSaftToNSString(fullIdentityCard);
    NSString* officeDepartment = kSaftToNSString(InputPaperOrganization.tfRightTextField.text);
    NSString* reason = kSaftToNSString(tvInputText.text);
    NSString* Certification = kSaftToNSString(InputCertificationType.tfRightTextField.text);
    NSString* address = kSaftToNSString(tfInputRegAddress.text);
    NSString* Valid_date = kSaftToNSString(InputCerDurationRow.tfRightTextField.text);

    if ([Certification rangeOfString:kLocalized(@"GYHS_MyInfo_Papers_Type")].location != NSNotFound) {
        Certification = @"";
        if (name.length == 0 && identCode.length == 0 && officeDepartment.length == 0 && countryString.length == 0 && sexString.length == 0 && Certification.length == 0 && address.length == 0 && Valid_date.length == 0) {
            bCheck = false;
        }
    }
    else {
        if (name.length == 0 && identCode.length == 0 && officeDepartment.length == 0 && countryString.length == 0 && sexString.length == 0 && address.length == 0 && Valid_date.length == 0) {
            bCheck = false;
        }
    }

    if (!bCheck) {
        [self alerViewByString:kLocalized(@"GYHS_MyInfo_Please_Fill_Least_One_Item_Change")];
        return;
    }

    // 问题单：26684要求用户名不修改，不做校验
    if (![oldFullUserName isEqualToString:name]) {
        if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
            if (name.length > 0 && (name.length < 2 || name.length > 64)) {
                [self alerViewByString:kLocalized(@"GYHS_MyInfo_Business_License_Character_Length_Is_Between_2_To_64_Please_Fill_In_According_To_The_Requirements")];
                return;
            }
        }
        else {
            if (name.length > 0 && (![GYUtils isUserName:name])) {
                [self alerViewByString:kLocalized(@"GYHS_MyInfo_The_Name_Format_Not_Correct")];
                return;
            }

            if (name.length > 0 && (name.length < 2 || name.length > 20)) {
                [self alerViewByString:kLocalized(@"GYHS_MyInfo_Name_Character_Length_Between_2_To_20_Please_Fill_According_The_Requirement")];
                return;
            }
        }
    }

    if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
        if (identCode.length < 7 || identCode.length > 30) {
            [self alerViewByString:kLocalized(@"GYHS_MyInfo_Business_License_Number_Input_Errors")];
            return;
        }
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
        if (identCode.length != 9) {
            [self alerViewByString:kLocalized(@"GYHS_MyInfo_The_Length_Of_The_Passport_Id_Number_Is_Nine")];
            return;
        }
    }
    else {
        if (![GYUtils verifyIDCardNumber:identCode country:InputNationaltyRow.tfRightTextField.text]) {
            [self alerViewByString:kLocalized(@"GYHS_MyInfo_Please_Enter_The_Correct_Id_Number")];

            return;
        }
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* datenow = [formatter dateFromString:InputCerDurationRow.tfRightTextField.text];
    NSDate* currentDate = [NSDate date];
    NSDate* earlierDate = [datenow earlierDate:currentDate];
    if (!islongPeriod) {
        if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
            if (earlierDate != datenow) {
                [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_RealName_Enterprises_Set_Up_Date_Must_Be_Less_Than_The_Current_Date")];
                return;
            }
        }else {
            if (earlierDate == datenow) {
                [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Documents_Effective_Date_Must_Be_Greater_Than_The_Current_Date")];
                return;
            }
        }
        newlongPerid = InputCerDurationRow.tfRightTextField.text;
    }
    // 保护 * 认为没有修改
    NSRange range = [identCode rangeOfString:@"*"];
    if (range.location != NSNotFound) {
        [self alerViewByString:kLocalized(@"GYHS_MyInfo_Id_Number_To_Contain_The_Illegal_Characters_Such_As_Star_Please_Fill_In_As_Required")];
        return;
    }

    if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
        NSString* birthPlace = birthPlaceRowView.tfRightTextField.text;
        if (![GYUtils checkStringInvalid:birthPlace] && (birthPlace.length < 2 || birthPlace.length > 128)) {
            [self alerViewByString:kLocalized(@"GYHS_MyInfo_Place_Of_Birth_Length_Between_2_128_Please_Fill_In_According_To_The_Requirements")];
            return;
        }

        NSString* issuePlace = placeIssueRowView.tfRightTextField.text;
        if (![GYUtils checkStringInvalid:issuePlace] && (issuePlace.length < 2 || issuePlace.length > 128)) {
            [self alerViewByString:kLocalized(@"GYHS_MyInfo_Place_Of_Issue_Character_Length_Is_Between_2_To_128_Please_Fill_In_According_To_The_Requirement")];
            return;
        }
    }

    if (officeDepartment.length > 0 && (InputPaperOrganization.tfRightTextField.text.length < 2 || InputPaperOrganization.tfRightTextField.text.length > 128)) {
        [self alerViewByString:kLocalized(@"GYHS_MyInfo_License_Issuing_Organ_Character_Length_Between_2_To_20_Please_Fill_As_Required")];
        return;
    }

    if (![globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {

        if (address.length > 0 && (tfInputRegAddress.text.length < 2 || tfInputRegAddress.text.length > 128)) {
            [self alerViewByString:kLocalized(@"GYHS_MyInfo_Address_Character_Length_Between_2_128_Please_Fill_As_Required")];
            return;
        }
    }

    if (reason.length == 0) {
        [self alerViewByString:kLocalized(@"GYHS_MyInfo_Change_Reason_Not_To_Fill_Out")];
        return;
    }
    // 保护 * 认为没有修改
    NSString *RealNameRow,*CerNumberRow;
    NSRange rangeRealName = [InputRealNameRow.tfRightTextField.text rangeOfString:@"*"];
    if (rangeRealName.location != NSNotFound) {
        RealNameRow = oldFullUserName;
    }else {
        RealNameRow = fullUserName;
    }
    NSRange rangeCerNumber = [InputCerNumberRow.tfRightTextField.text rangeOfString:@"*"];
    
    if (rangeCerNumber.location != NSNotFound) {
        CerNumberRow = oldfullIdentityCard;
    }else {
        CerNumberRow = fullIdentityCard;
    }
    
    if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
        if ([oldFullUserName isEqualToString:RealNameRow ] &&  [oldfullIdentityCard isEqualToString:CerNumberRow] &&[authDate isEqualToString:InputCerDurationRow.tfRightTextField.text] && [entType isEqualToString:InputPaperOrganization.tfRightTextField.text] && [entRegAddr isEqualToString:InputNationaltyRow.tfRightTextField.text]) {
            [self alerViewByString:kLocalized(@"You_Do_Not_Change_Any_Content_Cannot_Be_An_Application_Regarding_The_Change_Of_Important_Information")];
            return;
        }
    }
    
    
    
    if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
        if ([oldFullUserName isEqualToString:RealNameRow] && [oldfullIdentityCard isEqualToString:CerNumberRow] && [sex isEqualToString:InputSexRow.tfRightTextField.text] && [nationalty isEqualToString:InputNationaltyRow.tfRightTextField.text] && [issuingOrg isEqualToString:InputPaperOrganization.tfRightTextField.text] && [birthPlace isEqualToString:birthPlaceRowView.tfRightTextField.text] && [OldplaceIssue isEqualToString:placeIssueRowView.tfRightTextField.text] && [longPerid isEqualToString:newlongPerid] ) {
            [self alerViewByString:kLocalized(@"You_Do_Not_Change_Any_Content_Cannot_Be_An_Application_Regarding_The_Change_Of_Important_Information")];
            return;
        }
        
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
        if ([oldFullUserName isEqualToString:RealNameRow] && [oldfullIdentityCard isEqualToString:CerNumberRow] && [sex isEqualToString:InputSexRow.tfRightTextField.text] && [nationalty isEqualToString:InputNationaltyRow.tfRightTextField.text] && [issuingOrg isEqualToString:InputPaperOrganization.tfRightTextField.text] && [birthAddress isEqualToString:tfInputRegAddress.text] && [longPerid isEqualToString:newlongPerid] ) {
            [self alerViewByString:kLocalized(@"You_Do_Not_Change_Any_Content_Cannot_Be_An_Application_Regarding_The_Change_Of_Important_Information")];
            return;
        }
        
    }
    [self queryCustomerInfo];
}

- (void)queryCustomerInfo
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId) };

    [GYGIFHUD show];
    [Network GET:CustomerInfoUrl parameters:dict completion:^(id responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        
        if (error != nil) {
            DDLogDebug(@"Error:%@", [error localizedDescription]);
            [GYUtils showToast:kLocalized(@"GYHS_MyInfo_Net_Error")];
            return;
        }
        
        if (![responseObject[@"retCode"] isEqualToNumber:@200]) {
            DDLogDebug(@"responseObject:%@", responseObject);
            [GYUtils showToast:kLocalized(@"GYHS_MyInfo_Net_Error")];
            return;
        }
        
        NSDictionary *authInfodic = responseObject[@"data"][@"authInfo"];
        NSRange rangeRealName = [InputRealNameRow.tfRightTextField.text rangeOfString:@"*"];
        if (fullUserName.length > 0  &&  (rangeRealName.location == NSNotFound && ![oldFullUserName isEqualToString:InputRealNameRow.tfRightTextField.text]) ) {
            if ([InputCertificationType.tfRightTextField.text isEqualToString:kLocalized(@"GYHS_MyInfo_The_Business_License")]){
                [dicParams setValue:kSaftToNSString(fullUserName) forKey:@"entNameNew"];
                [olddicParams setValue:authInfodic[@"entName"] forKey:@"entNameOld"];
                [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_An_Enterprise_Name")];
            }
            else {
                [dicParams setValue:kSaftToNSString(fullUserName) forKey:@"nameNew"];
                [olddicParams setValue:authInfodic[@"userName"] forKey:@"nameOld"];
                [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_User_Name")];
            }
        }
        
        if (sexString.length > 0 && ![sex isEqualToString:InputSexRow.tfRightTextField.text]) {
            [dicParams setValue:sexString forKey:@"sexNew"];
            [olddicParams setValue:authInfodic[@"sex"] forKey:@"sexOld"];
            [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Sex")];
        }
        
        if (InputNationaltyRow.tfRightTextField.text.length > 0) {
            if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence] && ![entRegAddr isEqualToString:InputNationaltyRow.tfRightTextField.text]) {
                [dicParams setValue:InputNationaltyRow.tfRightTextField.text forKey:@"entRegAddrNew"];
                [olddicParams setValue:authInfodic[@"entRegAddr"] forKey:@"entRegAddrOld"];
                [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_The_Registered_Address")];
            }
            else if(![nationalty isEqualToString:InputNationaltyRow.tfRightTextField.text]){
                
                NSString *countryCodestr = [[GYAddressData shareInstance] queryCountryName:InputNationaltyRow.tfRightTextField.text].countryNo;
                NSCharacterSet *inset = [NSCharacterSet characterSetWithCharactersInString:@"."];
                
                NSArray *arr = [countryCodestr componentsSeparatedByCharactersInSet:inset];
                NSArray *arr1 = [authInfodic[@"countryCode"] componentsSeparatedByCharactersInSet:inset];
                
                NSString *str = arr[0];
                NSString *str1 = arr1[0];
                [dicParams setValue:str forKey:@"nationalityNew"];
                [olddicParams setValue:str1 forKey:@"nationalityOld"];
                [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Nationality")];
            }
        }
        
        if (InputCertificationType.tfRightTextField.text.length > 0) {
            if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
                [dicParams setValue:@1 forKey:@"creTypeNew"];
                [olddicParams setValue:@1  forKey:@"creTypeOld"];
            }
            else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
                [dicParams setValue:@2 forKey:@"creTypeNew"];
                [olddicParams setValue:@2  forKey:@"creTypeOld"];
            }
            else {
                [dicParams setValue:@3 forKey:@"creTypeNew"];
                [olddicParams setValue:@3  forKey:@"creTypeOld"];
            }
            
            [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Papers_Type")];
        }
        
        NSRange rangeCerNumber = [InputCerNumberRow.tfRightTextField.text rangeOfString:@"*"];
        
        if (fullIdentityCard.length > 0 && (rangeCerNumber.location == NSNotFound &&![oldfullIdentityCard isEqualToString:InputCerNumberRow.tfRightTextField.text])) {
            [dicParams setValue:kSaftToNSString(fullIdentityCard) forKey:@"creNoNew"];
            [olddicParams setValue:authInfodic[@"cerNo"] forKey:@"creNoOld"];
            [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Papers_Number")];
        }
        
        if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
            if (![birthPlaceRowView.tfRightTextField.text isEqualToString:authInfodic[@"birthAddress"]]) {
                // 出生地点
                [dicParams setValue:kSaftToNSString(birthPlaceRowView.tfRightTextField.text) forKey:@"registorAddressNew"];
                [olddicParams setValue:authInfodic[@"birthAddress"] forKey:@"registorAddressOld"];
                [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Place_Birth")];

            }
            if (![placeIssueRowView.tfRightTextField.text isEqualToString:authInfodic[@"issuePlace"]]) {
                // 签发地点
                [dicParams setValue:kSaftToNSString(placeIssueRowView.tfRightTextField.text) forKey:@"issuePlaceNew"];
                [olddicParams setValue:authInfodic[@"issuePlace"] forKey:@"issuePlaceOld"];
                [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Place_Issue")];
            }
            
        }
        else{
            if (tfInputRegAddress.text.length > 0 &&![tfInputRegAddress.text isEqualToString:authInfodic[@"birthAddress"]]) {
                [dicParams setValue:tfInputRegAddress.text forKey:@"registorAddressNew"];
                [olddicParams setValue:authInfodic[@"birthAddress"] forKey:@"registorAddressOld"];
                [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_The_Household_Registration_Address")];
            }
        }
        
        if (InputPaperOrganization.tfRightTextField.text.length > 0) {
            if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence] &&![InputPaperOrganization.tfRightTextField.text isEqual:authInfodic[@"entType"]]) {
                [dicParams setValue:InputPaperOrganization.tfRightTextField.text forKey:@"entTypeNew"];
                [olddicParams setValue:authInfodic[@"entType"] forKey:@"entTypeOld"];
                [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_The_Enterprise_Type")];
            }
            else if(![InputPaperOrganization.tfRightTextField.text isEqual:authInfodic[@"issuingOrg"]]){
                [dicParams setValue:InputPaperOrganization.tfRightTextField.text forKey:@"creIssueOrgNew"];
                [olddicParams setValue:authInfodic[@"issuingOrg"] forKey:@"creIssueOrgOld"];
                [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Issuing_Authority")];
            }
        }
        
        if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
            [olddicParams setValue:authInfodic[@"cerPich"] forKey:@"creHoldPicOld"];
            [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Holding_Certificates_Bust")];
        }
        
        if (islongPeriod) {
            [olddicParams setValue:authInfodic[@"validDate"] forKey:@"creExpireDateOld"];
            [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Long_Time")];
        }
        else {
            if (InputCerDurationRow.tfRightTextField.text.length > 0) {
                if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence] &&![InputCerDurationRow.tfRightTextField.text isEqualToString:authInfodic[@"realnameRegDate"]]) {
                    [dicParams setValue:InputCerDurationRow.tfRightTextField.text forKey:@"entBuildDateNew"];
                    [olddicParams setValue:authInfodic[@"realnameRegDate"] forKey:@"entBuildDateOld"];
                    [changeItemArr addObject:@"GYHS_MyInfo_Enterprises_Set_Up_The_Date"];
                }
                else if(![InputCerDurationRow.tfRightTextField.text isEqualToString:authInfodic[@"validDate"]]){
                    [dicParams setValue:InputCerDurationRow.tfRightTextField.text forKey:@"creExpireDateNew"];
                    [olddicParams setValue:authInfodic[@"validDate"] forKey:@"creExpireDateOld"];
                    [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Certification_Valid_Date")];
                }
            }
        }
        
        if (tvInputText.text.length > 0) {
            [dicParams setValue:tvInputText.text forKey:@"applyReason"];
            [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Change_Reason")];
        }
        
        if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
            [olddicParams setValue:authInfodic[@"cerPica"] forKey:@"creFacePicOld"];
            [olddicParams setValue:authInfodic[@"cerPicb"] forKey:@"creBackPicOld"];
            [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Certificate_Front")];
            [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Certificate_Opposite_Accordingt")];
        }
        else {
            [olddicParams setValue:authInfodic[@"cerPica"] forKey:@"creFacePicOld"];
            [olddicParams setValue:authInfodic[@"cerPich"] forKey:@"creHoldPicOld"];
            [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Certificate_Front")];
            [changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Holding_Papers_Photos")];
        }
        
        // 页面跳转
        UIViewController *vc;
        if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
            InputCertificationType.tfRightTextField.text = kLocalized(@"GYHS_MyInfo_Id_Card");
            GYRealNameAuthConfirmViewController *vcAuthConfirm = [[GYRealNameAuthConfirmViewController alloc] initWithNibName:@"GYRealNameAuthConfirmViewController" bundle:nil];
            vcAuthConfirm.dictInside = dicParams;
            vcAuthConfirm.olddictInside = olddicParams;
            vcAuthConfirm.changeItem = changeItemArr;
            vcAuthConfirm.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
            
            vcAuthConfirm.useType = useForImportantChange;
            vc = vcAuthConfirm;
            
        } else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
            GYTwoPictureViewController *vcPicture = [[GYTwoPictureViewController alloc] initWithNibName:@"GYTwoPictureViewController" bundle:nil];
            vcPicture.mdictParams = dicParams;
            vcPicture.oldmdictParams = olddicParams;
            vcPicture.changeItem = changeItemArr;
            vcPicture.useType = useForImportantChange;
            vcPicture.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
            vc = vcPicture;
            
        } else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
            GYTwoPictureViewController *vcPicture = [[GYTwoPictureViewController alloc] initWithNibName:@"GYTwoPictureViewController" bundle:nil];
            vcPicture.mdictParams = dicParams;
            vcPicture.oldmdictParams = olddicParams;
            vcPicture.changeItem = changeItemArr;
            vcPicture.useType = useForImportantChange;
            vcPicture.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
            vc = vcPicture;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

//设置滚动区域
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [scrMain setContentSize:CGSizeMake(kScreenWidth, 568)];
}

- (void)changePageView
{
    if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
        InputRealNameRow.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_An_Enterprise_Name");
        InputRealNameRow.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Please_Input_An_Enterprise_Name");
        InputNationaltyRow.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_The_Registered_Address");
        InputCerDurationRow.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_Set_Up_The_Date");
        InputPaperOrganization.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_The_Enterprise_Type");

        InputSexRow.hidden = YES;
        InputRegAddressRow.hidden = YES;
        btnChangeCountry.hidden = YES;
        btnChangeCountry.enabled = NO;
        InputNationaltyRow.tfRightTextField.enabled = YES;
        birthPlaceRowView.hidden = YES;
        placeIssueRowView.hidden = YES;

        // 证件类型
        [self changeViewFrame:InputCertificationType originY:60];

        // 证件号码
        [self changeViewFrame:InputCerNumberRow originY:98];

        // 注册地址
        [self changeViewFrame:InputNationaltyRow originY:142];

        // 企业类型
        [self changeViewFrame:InputPaperOrganization originY:197];

        // 成立日期
        [self changeViewFrame:InputCerDurationRow originY:241];

        // 备注
        [self changeViewFrame:vBackgroundDown originY:289];
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
        InputRegAddressRow.hidden = YES;
        // 姓名 16
        // 国籍
        [self changeViewFrame:InputNationaltyRow originY:60];

        // 证件类型
        [self changeViewFrame:InputCertificationType originY:104];

        // 证件号码
        [self changeViewFrame:InputCerNumberRow originY:148];

        // 性别
        [self changeViewFrame:InputSexRow originY:192];

        // 证件有效期
        [self changeViewFrame:InputCerDurationRow originY:236];

        // 出生地点
        [self changeViewFrame:birthPlaceRowView originY:280];

        // 签发地点
        [self changeViewFrame:placeIssueRowView originY:324];

        // 签发机关
        [self changeViewFrame:InputPaperOrganization originY:368];

        // 备注
        [self changeViewFrame:vBackgroundDown originY:413];

        birthPlaceRowView.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_Place_Birth");
        birthPlaceRowView.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Please_Input_Place_Birth");
        placeIssueRowView.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_Place_Issue");
        placeIssueRowView.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Please_Input_Place_Issue");
    }
    // 身份证
    else {
        InputSexRow.hidden = NO;
        InputRegAddressRow.hidden = NO;
        btnChangeCountry.hidden = NO;
        birthPlaceRowView.hidden = YES;
        placeIssueRowView.hidden = YES;
        btnChangeCountry.enabled = YES;
        InputNationaltyRow.tfRightTextField.enabled = NO;

        InputRealNameRow.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_User_Name");
        InputRealNameRow.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Input_Receive_Name");
        InputSexRow.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_Sex");
        InputNationaltyRow.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_Nationality");
        InputRegAddressRow.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_Famliy_Reigster_Address");

        InputPaperOrganization.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_Issuing_Authority");
        InputCerDurationRow.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_Certification_Valid_Date");
        lbRegAddressPlaceholder.textColor = kCellItemTextColor;
        tfInputRegAddress.textColor = kCellItemTitleColor;
    }

    InputCerNumberRow.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Input_Papers_Number");

    InputRealNameRow.tfRightTextField.delegate = self;
    InputCerNumberRow.tfRightTextField.delegate = self;

    [btnLongPeriod setImage:[UIImage imageNamed:@"hs_long_period_nomal"] forState:UIControlStateNormal];
    [btnLongPeriod setImage:[UIImage imageNamed:@"hs_long_period_selected"] forState:UIControlStateSelected];
    [btnLongPeriod setTitle:kLocalized(@"GYHS_MyInfo_Long_Time") forState:UIControlStateNormal];
    [btnLongPeriod setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    btnLongPeriod.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 45);
    btnLongPeriod.titleEdgeInsets = UIEdgeInsetsMake(5, -10, 5, 1);

    InputCertificationType.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_Papers_Type");

    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
        InputCertificationType.tfRightTextField.text = kLocalized(@"GYHS_MyInfo_Id_Card");
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
        InputCertificationType.tfRightTextField.text = kLocalized(@"GYHS_MyInfo_The_Business_License");
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
        InputCertificationType.tfRightTextField.text = kLocalized(@"GYHS_MyInfo_Passport");
    }

    if ([globalData.personInfo.importantInfoStatus isEqualToString:@"N"]) {
        InputSexRow.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Please_Select_Gender");
        InputPaperOrganization.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Enter_The_License_Issuing_Agencies");
        InputCerDurationRow.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Enter_The_Period_Of_Validity");
        lbRegAddressPlaceholder.text = kLocalized(@"GYHS_MyInfo_Enter_The_Hukou_Address");
    }
    else {
        InputCerNumberRow.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Input_Papers_Number");
        InputCerDurationRow.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Enter_Valid");
        InputPaperOrganization.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Enter_The_License_Issuing_Agencies");
    }

    InputCerNumberRow.lbLeftlabel.text = kLocalized(@"GYHS_MyInfo_Papers_Number");

    lbTitle.text = kLocalized(@"GYHS_MyInfo_Change_Reason");
    lbTitle.textColor = kCellItemTitleColor;
    lbPlaceHolder.text = kLocalized(@"GYHS_MyInfo_Input_Change_Reason");
    lbPlaceHolder.textColor = kCellItemTextColor;
    tvInputText.backgroundColor = kDefaultVCBackgroundColor;
    tvInputText.textColor = kCellItemTitleColor;
}

- (void)changeViewFrame:(UIView*)view originY:(CGFloat)originY
{
    CGRect viewFrame = view.frame;
    viewFrame.origin.y = originY;
    view.frame = viewFrame;
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{

    if (InputRealNameRow.tfRightTextField == textField) {
        fullUserName = @"";
        InputRealNameRow.tfRightTextField.text = @"";
    }
    else if (InputCerNumberRow.tfRightTextField == textField) {
        fullIdentityCard = @"";
        InputCerNumberRow.tfRightTextField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if (InputRealNameRow.tfRightTextField == textField) {
        fullUserName = textField.text;
        InputRealNameRow.tfRightTextField.text = textField.text;
    }
    else if (InputCerNumberRow.tfRightTextField == textField) {
        fullIdentityCard = textField.text;
        InputCerNumberRow.tfRightTextField.text = textField.text;
    }

    switch (textField.tag) {
    case 10: {
        _strRealName = textField.text;
    } break;
    case 11: {
        _strSex = textField.text;
    } break;
    case 12: {
        _strNationality = textField.text;
    } break;

    case 13: {
        _strCerType = textField.text;
    } break;
    case 14: {
        _strCerNumber = textField.text;
    } break;

    case 15: {
        _strCerduration = textField.text;
    } break;
    default:
        break;
    }
}

#pragma mark textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView*)textView
{
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField.tag == 15) {
        if (!datePiker) {
            datePiker = [[GYDatePiker alloc] initWithFrame:CGRectMake(0, 0, 0, 0) date:nil];
            datePiker.delegate = self;
            [datePiker noMaxTime];
            [self.view addSubview:datePiker];
            datePiker = nil;
        }

        return NO;
    }

    return YES;
}

- (void)textViewDidEndEditing:(UITextView*)textView
{

    lbPlaceHolder.text = @"";
    if (textView.tag == 17) {
        _strRegAddress = textView.text;
    }
}

- (void)textViewDidChange:(UITextView*)textView
{

    if (textView.tag == 20) {
        lbPlaceHolder.text = @"";
    }
    else {
        lbRegAddressPlaceholder.text = @"";
    }
}

- (void)getDate:(NSString*)date WithDate:(NSDate*)date1
{
    InputCerDurationRow.tfRightTextField.text = date;
    DDLogDebug(@"%@------date", date);
}

- (IBAction)btnChangeCoutryAction:(id)sender
{
    GYCountrySelectionViewController* vcCountry = [[GYCountrySelectionViewController alloc] initWithNibName:@"GYCountrySelectionViewController" bundle:nil];
    vcCountry.Delegate = self;
    [self.navigationController pushViewController:vcCountry animated:YES];
}
- (IBAction)btnChangeSex:(id)sender
{
    [self.view endEditing:YES];

    NSArray* arrSex = @[ kLocalized(@"GYHS_MyInfo_Woman"), kLocalized(@"GYHS_MyInfo_Man") ];

    [UIActionSheet showInView:self.view withTitle:kLocalized(@"GYHS_MyInfo_Please_Select_Gender") cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:arrSex tapBlock:^(UIActionSheet* _Nonnull actionSheet, NSInteger buttonIndex) {
        InputSexRow.tfRightTextField.text = arrSex[buttonIndex];
        
        switch (buttonIndex) {
            case 0:
            {
                sexString = @"0";
            }
                break;
            case 1:
            {
                sexString = @"1";
            }
                break;
            default:
                break;
        }

    }];
}

//选择国家代理方法
- (void)selectNationalityModel:(GYAddressCountryModel*)CountryInfo
{
    InputNationaltyRow.tfRightTextField.text = CountryInfo.countryName;
    countryString = CountryInfo.countryNo;
}

- (IBAction)btnLongPeriodAction:(id)sender
{
    UIButton* ValidPeriod = sender;
    islongPeriod = !islongPeriod;

    if (islongPeriod) {
        ValidPeriod.selected = YES;
        InputCerDurationRow.tfRightTextField.enabled = NO;
        InputCerDurationRow.tfRightTextField.placeholder = @"";
        InputCerDurationRow.tfRightTextField.text = @"";
        newlongPerid = kLocalized(@"GYHS_MyInfo_Set_Up_The_Date");
        [dicParams setValue:kLocalized(@"GYHS_MyInfo_Set_Up_The_Date") forKey:@"creExpireDateNew"];
    }
    else {
        
        InputCerDurationRow.tfRightTextField.enabled = YES;
        InputCerDurationRow.tfRightTextField.placeholder = kLocalized(@"GYHS_MyInfo_Enter_The_Period_Of_Validity");
       
        ValidPeriod.selected = NO;
    }
}

- (void)loadsearchRealNameRegInfo
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId) };
    [GYGIFHUD show];
    [Network GET:kHSGetsearchRealNameAuthInfo parameters:dict completion:^(id responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        
        if (error != nil ) {
            DDLogDebug(@"Error:%@", [error localizedDescription]);
            return;
        }
        
        if (![responseObject[@"retCode"] isEqualToNumber:@200]) {
            DDLogDebug(@"The returnCode:%@ is not 200.", responseObject[@"retCode"]);
            return;
        }
        
        NSDictionary *dic = responseObject[@"data"];
        if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]){
            
            fullUserName = dic[@"entName"];
            oldFullUserName = fullUserName;
            InputRealNameRow.tfRightTextField.text = fullUserName;
            InputNationaltyRow.tfRightTextField.text = dic[@"entRegAddr"];
            entRegAddr = dic[@"entRegAddr"];
            oldfullIdentityCard = dic[@"cerNo"];
            fullIdentityCard = dic[@"cerNo"];
            InputCerNumberRow.tfRightTextField.text = [GYUtils encryptBusinessLicense:fullIdentityCard];;
            InputPaperOrganization.tfRightTextField.text = dic[@"entType"];
            entType = dic[@"entType"];
            
            // 营业执照长期不显示
            btnLongPeriod.hidden = YES;
            authDate = [NSString stringWithFormat:@"%@", [dic valueForKey:@"entBuildDate"]];
            InputCerDurationRow.tfRightTextField.text = authDate;
        }
        else {
            // 姓名
            fullUserName = dic[@"userName"];
            oldFullUserName = fullUserName;
            InputRealNameRow.tfRightTextField.text = [GYUtils encryptUserName:fullUserName];
            
            // 性别
            if ([dic[@"sex"] isEqualToString:@"1"]) {
                InputSexRow.tfRightTextField.text =  kLocalized(@"GYHS_MyInfo_Man");
                sex =  kLocalized(@"GYHS_MyInfo_Man");
            }
            else {
                InputSexRow.tfRightTextField.text= kLocalized(@"GYHS_MyInfo_Woman");
                sex =  kLocalized(@"GYHS_MyInfo_Woman");
            }
            
            // 国籍
            InputNationaltyRow.tfRightTextField.text = [self selectFromDBAreaName:dic[@"countryCode"]];
            nationalty =[self selectFromDBAreaName:dic[@"countryCode"]];
            oldfullIdentityCard = dic[@"cerNo"];
            fullIdentityCard = dic[@"cerNo"];
            if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
                // 证件号码
                
                InputCerNumberRow.tfRightTextField.text = [GYUtils encryptPassport:fullIdentityCard];
                
                // 出生地点
                birthPlaceRowView.tfRightTextField.text = dic[@"birthPlace"];
                birthPlace = dic[@"birthPlace"];
                // 签发地点
                OldplaceIssue = dic[@"issuePlace"];
                placeIssueRowView.tfRightTextField.text = dic[@"issuePlace"];
                
                // 证件有效期
                btnLongPeriod.hidden = YES;
                longPerid = [NSString stringWithFormat:@"%@", [dic valueForKey:@"validDate"]];
                if ([kLocalized(@"GYHS_MyInfo_Set_Up_The_Date") isEqualToString:longPerid]) {
                    longPerid = @"";
                }
                InputCerDurationRow.tfRightTextField.text = longPerid;
            }
            else {
                
                if (![nationalty isEqualToString:kLocalized(@"GYHS_MyInfo_China")] ) {
                    InputCerNumberRow.tfRightTextField.text = [GYUtils encryptBusinessLicense:fullIdentityCard];
                }else {
                    InputCerNumberRow.tfRightTextField.text = [GYUtils encryptIdentityCard:fullIdentityCard];
                }

                
                // 证件有效期
                longPerid = [NSString stringWithFormat:@"%@", [dic valueForKey:@"validDate"]];
                if ([kLocalized(@"GYHS_MyInfo_Set_Up_The_Date") isEqualToString:longPerid]) {
                    // 长期为YES，在btnLongPeriodAction 中取一次反
                    islongPeriod = NO;
                    [self btnLongPeriodAction:btnLongPeriod];
                    newlongPerid = dic[@"validDate"];
                   
                }
                else {
                    InputCerDurationRow.tfRightTextField.text = longPerid;
                }
            }
            
            // 发证机关
            InputPaperOrganization.tfRightTextField.text = dic[@"issuingOrg"];
            issuingOrg  =dic[@"issuingOrg"];
            tfInputRegAddress.text = dic[@"birthAddress"];
            birthAddress = dic[@"birthAddress"];
        }
    }];
}

@end
