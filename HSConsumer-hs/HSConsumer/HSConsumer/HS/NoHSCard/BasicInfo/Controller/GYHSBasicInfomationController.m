//
//  GYHSBasicInfomationController.m
//  HSConsumer
//
//  Created by zhangqy on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBasicInfomationController.h"
#import "GYHSInfoHeadPicCell.h"
#import "GYHSInfoNormalCell.h"
#import "GYNetRequest.h"
#import "GYHSBasicInformationModel.h"
#import "GYGIFHUD.h"
#import "GYHSAddressCountryViewController.h"
#import "GYCityAddressModel.h"
#import "GYAlertView.h"
#import "GYAddressData.h"
#import "GYAccounTradeAlertView.h"
#import "GYHSAccountViewController.h"
#import "GYHSBindBankCardListVC.h"

#define kGYHSInfoHeadPicCellReuseId @"GYHSInfoHeadPicCell"
#define kGYHSInfoNormalCellReuseId @"GYHSInfoNormalCell"
#define kTrimString(key) [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 ? @"" : [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

@interface GYHSBasicInfomationController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate, UIActionSheetDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GYHSInfoNormalCellDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* titleDataSource;
@property (nonatomic, strong) GYCityAddressModel* cityModel;

/**昵称*/
@property (nonatomic, strong) UITextField* nicknameTF;
/**年龄*/
@property (nonatomic, strong) UITextField* ageTF;
/**姓名*/
@property (nonatomic, strong) UITextField* nameTF;

/**个性签名*/
@property (nonatomic, strong) UITextField* individualSignTF;
/**性别 1：男  0：女*/
@property (nonatomic, strong) UITextField* sexTF;
/**出生年月*/
@property (nonatomic, strong) UITextField* birthdayTF;
/**爱好*/
@property (nonatomic, strong) UITextField* hobbyTF;
/**血型
 * 1：A;2：B;3：AB;4：O;5：其他*/
@property (nonatomic, strong) UITextField* bloodTF;
/**职业*/
@property (nonatomic, strong) UITextField* jobTF;
///**电话*/
//@property (nonatomic, strong) UITextField* telNoTF;
/**邮编*/
@property (nonatomic, strong) UITextField* postcodeTF;
///**邮箱*/
//@property (nonatomic, strong) UITextField* emailTF;
/**毕业院校*/
@property (nonatomic, strong) UITextField* graduateSchoolTF;
/**手机号*/
@property (nonatomic, strong) UITextField* mobileTF;
/**地址*/
@property (nonatomic, strong) UITextField* homeAddrTF;
/**微信号*/
@property (nonatomic, strong) UITextField* weixinTF;
/**qq号*/
@property (nonatomic, strong) UITextField* qqNoTF;
/**国家编号*/
@property (nonatomic, strong) UITextField* countryNoTF;
/**省编号*/
@property (nonatomic, strong) UITextField* provinceNoTF;
/**市编号*/
@property (nonatomic, strong) UITextField* cityNoTF;
/**国家*/
@property (nonatomic, copy) NSString* country;
/**省*/
@property (nonatomic, copy) NSString* province;
/**市*/
@property (nonatomic, copy) NSString* city;
/**区域*/
@property (nonatomic, copy) NSString* area;
/**地址*/
@property (nonatomic, strong) UITextField* addressTF;

@property (nonatomic, strong) GYHSBasicInformationModel* model;
@end

@implementation GYHSBasicInfomationController
#pragma mark - lazy load
- (GYCityAddressModel*)cityModel
{
    if (!_cityModel) {
        _cityModel = [[GYCityAddressModel alloc] init];
    }
    return _cityModel;
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_NoHSCard_baseInfo");
    self.view.backgroundColor = kBackgroundGrayColor;
    _titleDataSource = @[ kLocalized(@"GYHS_NoHSCard_avatar"), kLocalized(@"GYHS_NoHSCard_user_Name"), kLocalized(@"GYHS_NoHSCard_nickname"), kLocalized(@"GYHS_NoHSCard_age"), kLocalized(@"GYHS_NoHSCard_sex"), kLocalized(@"GYHS_NoHSCard_graduation_from"), kLocalized(@"GYHS_NoHSCard_professional"),
        kLocalized(@"GYHS_NoHSCard_hobby"),
        kLocalized(@"GYHS_NoHSCard_blood"),
        kLocalized(@"GYHS_NoHSCard_qq_num"),
        kLocalized(@"GYHS_NoHSCard_weixin_number"),
        kLocalized(@"GYHS_NoHSCard_local_area"),
        kLocalized(@"GYHS_NoHSCard_postcodes"),
        kLocalized(@"GYHS_NoHSCard_resident_address") ];
    [self.view addSubview:self.tableView];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:kLocalized(@"GYHS_NoHSCard_Address_Save") style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnDidClicked:)];
    [bbi setTintColor:[UIColor whiteColor]];
    [bbi setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont
                                                           boldSystemFontOfSize:17], NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = bbi;
    _model = [[GYHSBasicInformationModel alloc] init];
    [self tableView];
    [self requestData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddress:) name:@"GYUpdateBasicInfomationNotification" object:nil];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)hidenKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getAddress:(NSNotification*)notification
{
    self.cityModel = [notification object];
    _addressTF.text = self.cityModel.cityFullName;
}

- (void)saveBtnDidClicked:(UIBarButtonItem*)bbi
{
    
    [self.view endEditing:YES];
    _model.custId = globalData.loginModel.custId;
    _model.name = kTrimString(_nameTF.text);
    if ([GYUtils checkStringInvalid:_model.name]) {
        [GYUtils showMessage:kLocalized(@"GYHS_NoHSCard_please_input_name")];
        return;
    }
    
    if([GYUtils checkStringInvalid:_model.nickname]) {
        [GYUtils showMessage:@"请输入昵称"];
        return;
    }

    globalData.loginModel.custName = kTrimString(_nameTF.text);
    _model.nickname = kTrimString(_nicknameTF.text);
    _model.age = kTrimString(_ageTF.text);

    // 收入年龄时，只能在1 到120 之间。
    if (![GYUtils checkStringInvalid:_model.age] && ([_model.age integerValue] > 120 || [_model.age integerValue] < 1)) {
        [GYUtils showMessage:kLocalized(@"GYHS_NoHSCard_age_must_1to120_old")];
        return;
    }

    if ([GYUtils checkStringInvalid:_sexTF.text]) {
        _model.sex = nil;
    }
    else if ([kTrimString(_sexTF.text) isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Man"]]) {
        _model.sex = @"1";
    }
    else if ([kTrimString(_sexTF.text) isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Woman"]]) {
        _model.sex = @"0";
    }

    _model.graduateSchool = kTrimString(_graduateSchoolTF.text);
    _model.job = kTrimString(_jobTF.text);
    _model.hobby = kTrimString(_hobbyTF.text);
    NSString* bloodStr = kTrimString(_bloodTF.text);

    if ([bloodStr isEqualToString:@"A"]) {
        _model.blood = @(1);
    }
    if ([bloodStr isEqualToString:@"B"]) {
        _model.blood = @(2);
    }
    if ([bloodStr isEqualToString:@"AB"]) {
        _model.blood = @(3);
    }
    if ([bloodStr isEqualToString:@"O"]) {
        _model.blood = @(4);
    }
    if ([bloodStr isEqualToString:@"其他"]) {
        _model.blood = @(5);
    }

    _model.qqNo = kTrimString(_qqNoTF.text);
    if (![GYUtils checkStringInvalid:_model.qqNo] && (_model.qqNo.length > 20)) {
        [GYUtils showMessage:kLocalized(@"GYHS_NoHSCard_qqNum_cannot_more_than_20")];
        return;
    }
    _model.weixin = kTrimString(_weixinTF.text);
    if (![GYUtils checkStringInvalid:_model.weixin] && (_model.weixin.length > 20)) {
        [GYUtils showMessage:kLocalized(@"GYHS_NoHSCard_weixinNum_cannot_more_than_20")];
        return;
    }

    _model.postcode = kTrimString(_postcodeTF.text);
    if (_model.postcode.length != 0 && ![GYUtils isValidZipcode:_model.postcode]) {
        [GYUtils showToast:@"请输入6位数邮编"];
        return;
    }
    _model.homeAddr = kTrimString(_homeAddrTF.text);
    _model.cityNo = kSaftToNSString(self.cityModel.cityNo) == nil ? _model.cityNo : self.cityModel.cityNo;
    _model.provinceNo = kSaftToNSString(self.cityModel.provinceNo) == nil ? _model.provinceNo : self.cityModel.provinceNo;
    _model.countryNo = kSaftToNSString(self.cityModel.countryNo) == nil ? _model.countryNo : self.cityModel.countryNo;
    [self updateData];
}

- (NSString*)trimString:(NSString*)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)requestData
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:globalData.loginModel.custId forKey:@"userId"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:kHSGetInfo parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    request.tag = 1;
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
}

- (void)updateData
{
    [self.view endEditing:YES];
    NSString* baseUrl = [GYHSLoginEn sharedInstance].getLoginUrl;
    NSString* URLString = @"customer/updateNetInfo";
    NSDictionary* dict = [_model toDictionary];
    NSDictionary* params = [[NSMutableDictionary alloc] init];
    for (NSString* key in dict.allKeys) {

        if ([dict[key] isKindOfClass:[NSString class]] ) {
            NSString *str ;
            if([dict[key] isEqualToString:@""] || dict[key] == nil) {
                str = @"";
                if([key isEqualToString:@"age"]) {
                    str = @"0";
                }
            }else {
                str = dict[key];
            }
            [params setValue:str forKey:key];
        }
        else if ([dict[key] isKindOfClass:[NSNumber class]] && dict[key] >= 0) {
            [params setValue:dict[key] forKey:key];
        }
    }

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:baseUrl URLString:URLString parameters:params requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 2;
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
}

#pragma mark GYNetRequestDelegate

- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{

    if (request.tag == 1) {
        [GYGIFHUD dismiss];
        if (!responseObject[@"data"]) {
            DDLogDebug(@"responseObject:%@", responseObject);
            [GYUtils showMessage:kLocalized(@"GYHS_NoHSCard_request_data_failure")];
            return;
        }
        _model = [[GYHSBasicInformationModel modelArrayWithResponseObject:responseObject error:nil] firstObject];
        [self.tableView reloadData];
    }
    if (request.tag == 2) {
        [GYGIFHUD dismiss];
        GYAccounTradeAlertView* confirmAlertView = [[GYAccounTradeAlertView alloc] init];
        [self.view addSubview:confirmAlertView];

        confirmAlertView.alertViewAccounTradeResult.alertContentLabel.text = @"基本资料保存成功!";
        _delegate.infoModel = _model;
        [GYAlertView showMessage:@"基本资料保存成功!" confirmBlock:^{
            if(!globalData.loginModel.cardHolder) {
                for (UIViewController *VC in self.navigationController.viewControllers) {
                    if([VC isMemberOfClass:[GYHSBindBankCardListVC class]]) {
                        GYHSBindBankCardListVC *listVC = (GYHSBindBankCardListVC *)VC;
                        listVC.isPerfect = GYHSBindBankCardListVCTypePerfect;
                        [self.navigationController popToViewController:listVC   animated:YES];
                        return ;
                    }
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }];
    }
    if (request.tag == 3) {
        [GYGIFHUD dismiss];
        _model.headShot = responseObject[@"data"];
        [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    if (request.tag == 2) {
        DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
        [GYUtils parseNetWork:error resultBlock:nil];
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GYHSInfoHeadPicCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSInfoHeadPicCellReuseId forIndexPath:indexPath];
            if (_titleDataSource.count > indexPath.row) {
                cell.titleLabel.text = _titleDataSource[indexPath.row];
            }
            [cell.headPicImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, _model.headShot]] placeholder:[UIImage imageNamed:@"hs_cell_img_noneuserimg"] options:kNilOptions completion:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            GYHSInfoNormalCell* cell = [[[NSBundle mainBundle] loadNibNamed:kGYHSInfoNormalCellReuseId owner:nil options:nil] lastObject];
            cell.cellDelegate = self;
            cell.indexPath = indexPath;
            if (_titleDataSource.count > indexPath.row) {
                cell.titleLabel.text = _titleDataSource[indexPath.row];
                cell.textField.placeholder = [NSString stringWithFormat:@"%@%@", @"输入", _titleDataSource[indexPath.row]];
            }
            cell.arrowImageView.hidden = YES;
            cell.textField.enabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.textField.text = @"";
            switch (indexPath.row) {
            case 1: {
                cell.textField.text = _model.name;
                _nameTF = cell.textField;
            } break;
            case 2: {
                cell.textField.text = _model.nickname;
                _nicknameTF = cell.textField;
            } break;
            case 3: {
                cell.textField.text = [_model.age isEqualToString:@"0"] ? @"": _model.age;
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                _ageTF = cell.textField;
                _ageTF.delegate = self;
            } break;
            case 4: {
                cell.arrowImageView.hidden = NO;
                cell.textField.enabled = NO;
                if (!_model.sex ) {
                    cell.textField.text = @"";
                }
                else if ([_model.sex isEqualToString:@"1"]) {
                    cell.textField.text = [GYUtils localizedStringWithKey:@"GYHD_Man"];
                }
                else if ([_model.sex isEqualToString:@"0"]) {
                    cell.textField.text = [GYUtils localizedStringWithKey:@"GYHD_Woman"];
                }
                if (_titleDataSource.count > indexPath.row) {
                    cell.textField.placeholder = [NSString stringWithFormat:@"%@%@", @"选择", _titleDataSource[indexPath.row]];
                }
                _sexTF = cell.textField;
            } break;
            case 5: {
                cell.textField.text = _model.graduateSchool;
                _graduateSchoolTF = cell.textField;
            } break;
            case 6: {
                cell.textField.text = _model.job;
                _jobTF = cell.textField;
            } break;
            case 7: {
                cell.textField.text = _model.hobby;
                _hobbyTF = cell.textField;
            } break;
            case 8: {
                cell.arrowImageView.hidden = NO;
                cell.textField.enabled = NO;
                if (_titleDataSource.count > indexPath.row) {
                    cell.textField.placeholder = [NSString stringWithFormat:@"%@%@", @"选择", _titleDataSource[indexPath.row]];
                }
                NSString* bloodStr = @"";
                if (!_model.blood) {
                    bloodStr = @"";
                }
                if (_model.blood.integerValue == 1) {
                    bloodStr = @"A";
                }
                if (_model.blood.integerValue == 2) {
                    bloodStr = @"B";
                }
                if (_model.blood.integerValue == 3) {
                    bloodStr = @"AB";
                }
                if (_model.blood.integerValue == 4) {
                    bloodStr = @"O";
                }
                if (_model.blood.integerValue == 5) {
                    bloodStr = @"其他";
                }
                cell.textField.text = bloodStr;
                _bloodTF = cell.textField;
            } break;

            default:
                break;
            }
            return cell;
        }
    }

    if (indexPath.section == 1) {
        GYHSInfoNormalCell* cell = [[[NSBundle mainBundle] loadNibNamed:kGYHSInfoNormalCellReuseId owner:nil options:nil] lastObject];
        cell.cellDelegate = self;
        cell.indexPath = indexPath;
        if (_titleDataSource.count > indexPath.row + 9) {
            cell.titleLabel.text = _titleDataSource[indexPath.row + 9];
            cell.textField.placeholder = [NSString stringWithFormat:@"%@%@", @"输入", _titleDataSource[indexPath.row + 9]];
        }
        cell.arrowImageView.hidden = YES;
        cell.textField.enabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.text = @"";
        switch (indexPath.row) {
        case 0: {
            cell.textField.text =  _model.qqNo;
            _qqNoTF = cell.textField;
            _qqNoTF.delegate = self;
            _qqNoTF.keyboardType = UIKeyboardTypeNumberPad;
        } break;
        case 1: {
            cell.textField.text = _model.weixin;
            _weixinTF = cell.textField;
            _weixinTF.delegate = self;
        } break;
        case 2: {
            cell.arrowImageView.hidden = NO;
            cell.textField.enabled = NO;
            if (_titleDataSource.count > indexPath.row) {
                cell.textField.placeholder = [NSString stringWithFormat:@"%@%@", @"选择", _titleDataSource[indexPath.row + 9]];
            }
            cell.textField.text = [[GYAddressData shareInstance] queryCityNo:_model.cityNo].cityFullName;
            _addressTF = cell.textField;
        } break;
        case 3: {
            cell.textField.text = _model.postcode;
            _postcodeTF = cell.textField;
            _postcodeTF.delegate = self;
            _postcodeTF.keyboardType = UIKeyboardTypeNumberPad;
        } break;
        case 4: {
            cell.textField.text = _model.homeAddr;
            _homeAddrTF = cell.textField;
        } break;

        default:
            break;
        }
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 9;
    }
    else {
        return 5;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet* PicChooseSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kLocalized(@"GYHS_NoHSCard_cancel") destructiveButtonTitle:nil otherButtonTitles:kLocalized(@"GYHS_NoHSCard_take_photos"), kLocalized(@"GYHS_NoHSCard_ablum"), nil];
            PicChooseSheet.destructiveButtonIndex = 2;
            PicChooseSheet.delegate = self;
            PicChooseSheet.tag = 1;
            [PicChooseSheet showInView:self.view];
        }
        if (indexPath.row == 4) {
            [self.view endEditing:YES];
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:[GYUtils localizedStringWithKey:@"GYHD_Man"], [GYUtils localizedStringWithKey:@"GYHD_Woman"], nil];
            actionSheet.tag = 2;
            [actionSheet showInView:self.view];
        }
        if (indexPath.row == 8) {
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择血型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"A", @"B", @"AB", @"O", @"其他", nil];
            actionSheet.tag = 3;
            [actionSheet showInView:self.view];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            GYHSAddressCountryViewController* vc = [[GYHSAddressCountryViewController alloc] init];
            vc.addressType = noLocationfunction;
            vc.fromBandingCard = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    return kCellHeight;
}

#pragma mark GYAroundLocationChooseControllerDelegate
- (void)getCity:(NSString*)CityTitle WithType:(int)type
{
}

- (void)getIsLocation:(BOOL)location
{
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self photocamera];
        }
        if (buttonIndex == 1) {
            [self photoalbumr];
        }
    }

    if (actionSheet.tag == 2) {
        _model.sex = buttonIndex == 0 ? @"1" : @"0";
        [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:4 inSection:0] ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (actionSheet.tag == 3) {
        _model.blood = @(buttonIndex + 1).stringValue;
        [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:8 inSection:0] ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kBackgroundGrayColor;
        [_tableView registerNib:[UINib nibWithNibName:kGYHSInfoHeadPicCellReuseId bundle:nil] forCellReuseIdentifier:kGYHSInfoHeadPicCellReuseId];
        [_tableView registerNib:[UINib nibWithNibName:kGYHSInfoNormalCellReuseId bundle:nil] forCellReuseIdentifier:kGYHSInfoNormalCellReuseId];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

//进入相册
- (void)photoalbumr
{

    if ([UIImagePickerController isSourceTypeAvailable:
                                     UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

//进入拍照
- (void)photocamera
{

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.delegate = self;
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagepicker.allowsEditing = NO;
        [self presentViewController:imagepicker animated:YES completion:nil];
    }
}

//此方法用于模态 消除actionsheet
- (void)actionSheetCancel:(UIActionSheet*)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

//Pickerviewcontroller的代理方法。
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        nil;
    }];

    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:@"1" forKey:@"isPub"];
    [params setValue:globalData.loginModel.custId forKey:@"custId"];
    [params setValue:globalData.loginModel.token forKey:@"token"];

    NSString* URLString = [NSString stringWithFormat:@"%@?isPub=%@&token=%@&custId=%@", @"fileController/fileUpload", @"1", globalData.loginModel.token, globalData.loginModel.custId];

    GYNetRequest* request = [[GYNetRequest alloc] initWithUploadDelegate:self baseURL:[GYHSLoginEn sharedInstance].getLoginUrl URLString:URLString parameters:nil constructingBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if ((float)data.length > 1024 * 100) {
            data = UIImageJPEGRepresentation(image, 1024*100.0/(float)data.length);
        }
        
        [formData appendPartWithFileData:data name:@"1" fileName:@"1.jpeg" mimeType:@"image/jpeg"];
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    request.tag = 3;
    [request start];
    [GYGIFHUD show];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField == _qqNoTF || textField == _weixinTF) {
        if (toBeString.length > 20) {
            return NO;
        }
    }

    return YES;
}


#pragma mark - GYHSInfoNormalCellDelegate
- (void)inputTextField:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            _model.name = value;
        }
        else if (indexPath.row == 2) {
            _model.nickname = value;
        }
        else if (indexPath.row == 3) {
            _model.age = value;
        }
        else if (indexPath.row == 5) {
            _model.graduateSchool = value;
        }
        else if (indexPath.row == 6) {
            _model.job = value;
        }
        else if (indexPath.row == 7) {
            _model.hobby = value;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            _model.qqNo = value;
        }
        else if (indexPath.row == 1) {
            _model.weixin = value;
        }
        else if (indexPath.row == 3) {
            _model.postcode = value;
        }
        else if (indexPath.row == 4) {
            _model.homeAddr = value;
        }
    }
}

@end
