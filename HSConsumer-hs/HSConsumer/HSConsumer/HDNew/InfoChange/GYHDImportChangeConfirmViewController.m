//
//  GYHDImportChangeConfirmViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDImportChangeConfirmViewController.h"
#import "Masonry.h"
#import "GYHDUploadDocumentsCell.h"
#import "GYHSButtonCell.h"
#import "GYHSTools.h"
#import "GYSamplePictureManager.h"
#import "GYHDRandomCodeCell.h"
#import "Animations.h"
#import "GYImgTap.h"
#import "GYGetPhotoView.h"
#import "IQKeyboardManager.h"

@interface GYHDImportChangeConfirmViewController () <GYHSButtonCellDelegate, UITableViewDataSource, UITableViewDelegate, GYHDNextRandomCodeBtnDelegate, GYHDUploadDocumentDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GYGetPhotoViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView* uploadTableView;
@property (nonatomic, strong) NSMutableArray* dataArray; //数据源
@property (nonatomic, strong) GYGetPhotoView* getView;
@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, assign) NSInteger tagIndex;
@property (nonatomic, copy) NSString* randomCodeText;
@property (weak, nonatomic) GYRandomCodeView* randomCodeView;

@end

@implementation GYHDImportChangeConfirmViewController
#pragma mark-- The life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self.uploadTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHDUploadDocumentsCell class]) bundle:nil] forCellReuseIdentifier:@"GYHDUploadDocumentsCell"];
    [self.uploadTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self.uploadTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHDRandomCodeCell class]) bundle:nil] forCellReuseIdentifier:@"GYHDRandomCodeCell"];
}
#pragma mark-- GYHDUploadDocumentDelegate
- (void)uploadDocument:(NSIndexPath*)indexPath //上传图片
{
    if (indexPath.section == 0) {
        self.tagIndex = indexPath.row + 100;
    }
    [self pickPhotoButtonClick];
}
#pragma mark Click Event
- (void)pickPhotoButtonClick
{
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    
    self.getView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYGetPhotoView class]) owner:self options:nil] firstObject];
    self.getView.frame = CGRectMake(15, kScreenHeight - 155, kScreenWidth-30, 155);
    self.getView.delegate = self;
    [self.bgView addSubview:self.getView];
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self.bgView];
}

#pragma mark -GYGetPhotoViewDelegate
- (void)takePhotoBtnClickDelegate
{
    [self.getView removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self photocamera];
}

- (void)getBlumBtnClickDelegate
{
    [self.getView removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self photoalbumr];
}

- (void)cancelBtnClickDelegate
{
    [self.getView removeFromSuperview];
    [self.bgView removeFromSuperview];
}
//进入相册
- (void)photoalbumr
{

    if ([UIImagePickerController isSourceTypeAvailable:

                                     UIImagePickerControllerSourceTypePhotoLibrary]) {

        UIImagePickerController* picker =

            [[UIImagePickerController alloc] init];

        picker.delegate = self;

        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Access_Album_Failed")];
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
    else {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Device_No_Support_Camera")];
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

    // 获取图片名称
    NSURL* Url = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSString* strUrl = [Url absoluteString];
    // 得到文件名称
    NSRange one = [strUrl rangeOfString:@"="];
    NSRange two = [strUrl rangeOfString:@"&"];
    NSString* name = [strUrl substringWithRange:NSMakeRange(one.location + 1, two.location - one.location - 1)];
    NSString* strType = [strUrl substringFromIndex:strUrl.length - 3];
    DDLogDebug(@"%@,%@,%@", strType, strUrl, name);
    NSString* imageName = [NSString stringWithFormat:@"%@.%@", name, strType];

    NSData* data = UIImageJPEGRepresentation(image, 1);
    // 获取沙盒目录
    NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [data writeToFile:fullPath atomically:NO];
    DDLogDebug(@"%ld", (unsigned long)[data length]);
    // 检查文件大小 不能大于2M
    NSFileManager* fm = [NSFileManager defaultManager];
    long long fSize = 0;
    if ([fm fileExistsAtPath:fullPath]) {
        fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
    }
    if (fSize > 2 * 1024 * 1024) {

        [fm removeItemAtPath:fullPath error:nil];
        CGFloat x = (2 * 1024 * 1024) / fSize;
        data = UIImageJPEGRepresentation(image, x);

        // 获取沙盒目录
        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
        // 将图片写入文件
        [data writeToFile:fullPath atomically:NO];
        NSFileManager* fm = [NSFileManager defaultManager];
        long long fSize = 0;
        if ([fm fileExistsAtPath:fullPath]) {
            fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
        }
    }
    switch (self.tagIndex) {
    case 100: {
        [self uploadPicWithImage:image isPub:YES imageIndex:0];
        [self saveImage:image withName:@"AuthimgCertificationFront.png"];

        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationFront.png"];

        UIImage* savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        [self.dataArray[0][0] setObject:savedImage forKey:@"UploadDocument"];
        [self.uploadTableView reloadData];

    } break;
    case 101: {
        [self uploadPicWithImage:image isPub:YES imageIndex:1];
        [self saveImage:image withName:@"AuthimgCertificationback.png"];
        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationback.png"];

        UIImage* savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        [self.dataArray[0][1] setObject:savedImage forKey:@"UploadDocument"];
        [self.uploadTableView reloadData];
    } break;
    case 102: {
        [self uploadPicWithImage:image isPub:YES imageIndex:2];
        [self saveImage:image withName:@"AuthimgCertificationWithMan.png"];
        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationWithMan.png"];
        DDLogDebug(@"%@", fullPath);
        UIImage* savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        [self.dataArray[0][2] setObject:savedImage forKey:@"UploadDocument"];
        [self.uploadTableView reloadData];
    } break;
    case 103: {
        [self uploadPicWithImage:image isPub:YES imageIndex:3];
        [self saveImage:image withName:@"AuthimgOtherFile.png"];
        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgOtherFile.png"];
        DDLogDebug(@"%@", fullPath);
        UIImage* savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        [self.dataArray[0][3] setObject:savedImage forKey:@"UploadDocument"];
        [self.uploadTableView reloadData];
    } break;
    default:
        break;
    }
}

//保存图片至沙盒
#pragma mark - save
- (void)saveImage:(UIImage*)currentImage withName:(NSString*)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(currentImage, 0.5);

    // 获取沙盒目录
    NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];

    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}
- (void)uploadPicWithImage:(UIImage*)image isPub:(BOOL)isPub imageIndex:(NSInteger)imageIndex
{
    NSString* uploadUrlString = [NSString stringWithFormat:@"%@?isPub=%@", kUploadFileUrlString, isPub ? @"1" : @"0"]; //公开
    if (globalData.loginModel.custId.length) {

        uploadUrlString = [NSString stringWithFormat:@"%@&custId=%@", uploadUrlString, globalData.loginModel.custId]; //custId
    }
    if (globalData.loginModel.token.length) {

        uploadUrlString = [NSString stringWithFormat:@"%@&token=%@", uploadUrlString, globalData.loginModel.token]; //token
    }
    __block NSInteger index = imageIndex;
    UIImage* uploadImage = image;
    [GYGIFHUD show];
    [Network Post:uploadUrlString parameters:nil image:uploadImage completion:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (!error) {
            NSString *urlOnServer = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
            
            if (index == 0) {
                
                _strCreFaceUrl = urlOnServer;
                
            } else if (index == 1) {
                
                _strCreBackUrl = urlOnServer;
                
            } else if (index == 2) {
                
                _strCreHoldUrl = urlOnServer;
                
            } else if (index == 3) {
                _strCreOtherFileUrl = urlOnServer;
            }
        } else {
            [GYUtils showMessage:kLocalized(@"GYHS_RealName_Upload_Pictures_Failed")];
        }
    }];
}
#pragma mark 上传图片代理方法。
- (void)didFinishUploadImg:(NSURL*)url withTag:(int)index
{
    NSString* picUrlString = [NSString stringWithFormat:@"%@", url];
    switch (index) {
    case 0: {
        _strCreFaceUrl = picUrlString;
        DDLogDebug(@"%@=======cccc", _strCreFaceUrl);
    } break;
    case 1: {
        _strCreBackUrl = picUrlString;
    } break;
    case 2: {
        _strCreHoldUrl = picUrlString;
    } break;
    case 3: {
        _strCreOtherFileUrl = picUrlString;
    } break;

    default:
        break;
    }
}
- (void)columnPicture:(NSIndexPath*)indexPath //示列图片
{
    UIImageView* imgv;
    UIView* backgroundView;
    NSString* imageName = self.dataArray[indexPath.section][indexPath.row][@"ColumnPicture"];
    if (imgv == nil) {
        imgv = [[UIImageView alloc] init];
    }
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }

    imgv.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 100);
    imgv.bounds = CGRectMake(0, 0, 140 + 140 * 0.9, 90 + 90 * 0.9);
    [imgv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, imageName, globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];

    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [backgroundView addSubview:imgv];
    [self.view addSubview:backgroundView];

    [UIView animateWithDuration:0.24 animations:^{
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        [Animations zoomIn:imgv andAnimationDuration:0.24 andWait:NO];

    } completion:^(BOOL finished){

    }];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenView:)];
    [backgroundView addGestureRecognizer:tap];
}
- (void)hidenView:(UITapGestureRecognizer*)tap
{
    [UIView animateWithDuration:0.24 animations:^{
        tap.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
}
#pragma mark-- 提交
- (void)nextBtn
{
    if ([GYUtils checkStringInvalid:_strCreFaceUrl]) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Select_Picture")];
        return;
    }
    if ([GYUtils checkStringInvalid:_strCreBackUrl]) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Select_Picture")];
        return;
    }
    if ([GYUtils checkStringInvalid:_strCreHoldUrl]) {
        if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
            [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Select_Picture")];
            return;
        }
    }
    if ([GYUtils checkStringInvalid:_strCreOtherFileUrl]) {
        if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
            [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Select_Picture")];
            return;
        }
    }

    if ([GYUtils isBlankString:self.randomCodeText]) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Verification_Code_Cannot_Empty")];
        return;
    }
   
    if (![[self.randomCodeText lowercaseString] isEqualToString:[self.randomCodeView.currentVerifyCode lowercaseString]]) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Verification_Code_Error_Please_Enter_Again")];
        [self.randomCodeView refreshVerifyCode];
        return;
    }
    [GYUtils showMessge:kLocalized(@"GYHS_MyInfo_Important_Information_Change_Request_Submitted_During_Processing_Money_Transfer_Bank_Account_Business_Confirm_To_Submit_Application") confirm:^{
        [self sendRequestForImportantChange];
    } cancleBlock:^{

    }];
}
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    self.randomCodeText = textField.text;
}
#pragma mark -  提交重要信息变更
- (void)sendRequestForImportantChange
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [self.dictInside setValue:kSaftToNSString(_strCreFaceUrl) forKey:@"creFacePicNew"];
    [self.dictInside setValue:kSaftToNSString(_strCreHoldUrl) forKey:@"creHoldPicNew"];
    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
        [self.dictInside setValue:kSaftToNSString(_strCreBackUrl) forKey:@"creBackPicNew"];
        [self.dictInside setValue:kSaftToNSString(_strCreOtherFileUrl) forKey:@"residenceAddrPic"];
        [self.changeItem addObject:kLocalized(@"GYHS_RealName_Household_Registration_Changes_Prove")];
    }
    NSString* changeItem = [self.changeItem componentsJoinedByString:@","];
    [dict setValue:kSaftToNSString(changeItem) forKey:@"changeItem"];
    [dict setValue:kSaftToNSString(globalData.loginModel.mobile) forKey:@"mobile"];
    [dict setValue:kSaftToNSString(globalData.loginModel.resNo) forKey:@"perResNo"];
    [dict setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"perCustId"];
    [dict setValue:kSaftToNSString(globalData.loginModel.custName) forKey:@"perCustName"];
    [dict addEntriesFromDictionary:self.dictInside];
    [dict addEntriesFromDictionary:self.oldmdictParams];
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kPushImportantChangeUrlString parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger  errorRetCode = [error code];
            if ( errorRetCode == 207)
            {
                [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_User_Is_Important_Information_Changes")];
                return ;
            }
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Important_Information_Changes_Submitted_To_Success") confirm:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark-- GYHDNextRandomCodeBtnDelegate换一张  验证码
- (void)nextRandomCodeBtn:(GYRandomCodeView*)randomCodeView
{

    [randomCodeView refreshVerifyCode];
}
#pragma mark-- UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.dataArray[section] count];
    }
    return 1;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSMutableDictionary* dic = self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        GYHDUploadDocumentsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDUploadDocumentsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.uploadDocumentDelegate = self;
        [cell title:dic[@"Title"] columnPicture:dic[@"ColumnPicture"] uploadDocument:dic[@"UploadDocument"] tag:indexPath];
        if (indexPath.row == 3) {
            cell.rightView.hidden = YES;
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        GYHDRandomCodeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDRandomCodeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.randomCodeView = cell.randomCodeView;
        self.randomCodeView.randColor = NO;
        self.randomCodeView.interferingLine = NO;
        self.randomCodeView.interferingPoint = NO;
        self.randomCodeView.randomPointY = NO;
        [self.randomCodeView refreshVerifyCode];

        cell.randomCodeTextField.delegate = self;
        cell.randomCodeBtnDelegate = self;
        return cell;
    }
    else {
        GYHSButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btnTitle setTitle:kLocalized(@"GYHS_MyInfo_Change_Next") forState:UIControlStateNormal];
        cell.btnTitle.backgroundColor = kButtonCellBtnCorlor;
        cell.btnDelegate = self;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return 142;
    }
    else {
        return 50;
    }
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UILabel* lb = [[UILabel alloc] init];
    lb.numberOfLines = 0;
    lb.font = kWarmCellFont;
    lb.textColor = kcurrencyBalanceCorlor;
    if (section == 0) {
        lb.frame = CGRectMake(15, 0, kScreenWidth - 30, 26);
        lb.text = @"上传证件";
    }
    else if (section == 1) {
        lb.frame = CGRectMake(15, 0, kScreenWidth - 30, 44);
        lb.text = kLocalized(@"GYHS_RealName_Upload_Attachments_Images_Is_Less_Than_2M_Format_For_PNG_JPG_Jpeg_BMP");
    }
    [view addSubview:lb];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}
//组头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 26.0f;
    }
    else if (section == 1) {
        return 44;
    }
    else {
        return 1.0f;
    }
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
#pragma mark-- Lazy loading
- (UITableView*)uploadTableView
{
    if (!_uploadTableView) {
        _uploadTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _uploadTableView.delegate = self;
        _uploadTableView.dataSource = self;
        [self.view addSubview:_uploadTableView];
        [_uploadTableView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _uploadTableView;
}
- (NSMutableArray*)dataArray
{
    if (!_dataArray) {
        NSArray* keyAry = @[ @"Title", @"ColumnPicture" ];
        NSMutableArray* array1 = [[NSMutableArray alloc] init];
        NSMutableArray* array2 = [[NSMutableArray alloc] init];
        NSMutableArray* array3 = [[NSMutableArray alloc] init];
        NSString* imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1001"].fileId;
        NSString* titleValue1 = kLocalized(@"GYHD_RealnameRegister_Certificates_Positive");
        if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
            titleValue1 = kLocalized(@"GYHD_RealnameRegister_Passport_Documents");
            imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1027"].fileId;
        }
        else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
            titleValue1 = kLocalized(@"GYHD_RealnameRegister_Business_License_Certificate");
            imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1010"].fileId;
        }
        NSArray* valueAry = @[ titleValue1, kSaftToNSString(imageName) ];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];

        NSString* titleValue2 = kLocalized(@"GYHD_RealnameRegister_Certificate_Opposite");
        imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1002"].fileId;
        if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
            titleValue2 = kLocalized(@"GYHD_RealnameRegister_Holding_Certificates_According");
            imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1022"].fileId;
        }
        else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
            titleValue2 = kLocalized(@"GYHD_RealnameRegister_Holding_Certificates_According");
            imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1023"].fileId;
        }
        valueAry = @[ titleValue2, kSaftToNSString(imageName) ];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];

        if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
            valueAry = @[ kLocalized(@"GYHD_RealnameRegister_Holding_Certificates_According"), kSaftToNSString([[GYSamplePictureManager shareInstance] selectDecCode:@"1005"].fileId) ];
            [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
            valueAry = @[ kLocalized(@"GYHD_InfoChange_Household_Registration_Changes_Prove"), @"" ];
            [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        }

        valueAry = @[ @"" ];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];

        valueAry = @[@""];
        [array3  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        _dataArray = [[NSMutableArray alloc] initWithObjects:array1,array2,array3, nil];
        
    }
    return _dataArray;
}
@end
