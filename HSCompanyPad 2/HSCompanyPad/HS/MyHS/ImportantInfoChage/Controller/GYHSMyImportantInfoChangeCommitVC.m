//
//  GYHSMyImportantInfoChangeCommitVC.m
//
//  Created by apple on 16/8/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyImportantInfoChangeCommitVC.h"
#import "GYHSMemberProgressView.h"
#import "GYHSMyImportantChageModel.h"
#import "GYHSMyImportantCommitCell.h"
#import "GYHSMyImportantInfoChageFinishVC.h"
#import "GYHSmyhsHttpTool.h"
#import <MJExtension/MJExtension.h>
#import "GYHSmyhsHttpTool.h"
#import "GYHSDocModel.h"
#import "GYPhotoPickerViewController.h"
#import "GYWebViewController.h"
#import <GYKit/GYPhotoGroupView.h>

static NSString* idCell = @"importantCommitCell";
static NSString* aa = @"aaaa";

@interface GYHSMyImportantInfoChangeCommitVC () <UITableViewDelegate, UITableViewDataSource, GYHSMyImportantCommitCellDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,GYPhotoPickerViewControllerDelegate>

@property (nonatomic, strong) UIButton* commitButton;
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, weak) UIButton* tempButton;
@property (nonatomic, assign) GYHSImportantUploadType type;
@end

@implementation GYHSMyImportantInfoChangeCommitVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.customBorderColor = kGrayE3E3EA;
    self.tableView.customBorderLineWidth = @1;
    self.tableView.customBorderType = UIViewCustomBorderTypeAll;
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController* pickerCtl = [[UIImagePickerController alloc] init];
    pickerCtl.delegate = self;
    
    switch (buttonIndex) {
        case 0: {
            [self pickImageFromCamera];
        } break;
            
        case 1: {
            [self pickImageFromAlbum];
        } break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    // 获取图片名称
    
    NSDate* date = [NSDate date];
    NSString* tempName = [[NSString stringWithFormat:@"%@", date] substringToIndex:10];
    NSString* imageName = [tempName stringByAppendingString:@".jpg"];
    
    //换成二进制数据
    NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
    // 设置图片沙盒目录
    NSString* fullPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    
    // 检查文件大小 不能大于1M
    NSFileManager* fm = [NSFileManager defaultManager];
    long long fSize = 0;
    if ([fm fileExistsAtPath:fullPath]) {
        fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
    }
    
    //如果大于2M进行压缩处理
    if (fSize > 1024 * 1024) {
        imageData = UIImageJPEGRepresentation(image, 0.25);
        [imageData writeToFile:fullPath atomically:NO];
    }
    
    if (imageData) {
        [self uploadImage:imageData imageName:imageName];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  点击取消销毁控制器
 *
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSMyImportantCommitCell* cell = [tableView dequeueReusableCellWithIdentifier:idCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.requestDict = self.requestDict;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return self.tableView.height;
}

#pragma mark - GYHSMyImportantCommitCellDelegate
- (void)uploadTheBusinessLicense:(UIButton*)imageButton
{
    //上传营业执照
    self.tempButton = imageButton;
    self.type = GYHSImportantUploadTypebusiLicenseImg;
    [self takePhoto];
}

- (void)uploadTheContactPowerOfAttorney:(UIButton*)imageButton
{
    //上传联系人授权委托书
    self.tempButton = imageButton;
    self.type = GYHSImportantUploadTypelinkAuthorizePic;
    [self takePhoto];
}

- (void)uploadTheBusinessProcessApplication:(UIButton*)imageButton
{
    //上传业务办理申请书
    self.tempButton = imageButton;
    self.type = GYHSImportantUploadTypeImptappPic;
    [self takePhoto];
}

- (void)loadDownBusinessLicense
{
    //营业执照示例
    [self lookPicture];
}

- (void)loadDownContactPowerOfAttorney
{
    //下载联系人授权委托书模板
    [self loadDown:GYHSExampleDocContactPersonAuthorizedToScan];
}

- (void)loadDownBusinessProcessApplication
{
    //下载业务办理申请书模板
    [self loadDown:GYHSExampleDocImportant];
}

#pragma mark - event response
/*!
 *    提交数据按钮点击事件
 */
- (void)commitButtonAction
{
    if (![self judgeUploadIsRight]) {
        return;
    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    GYHSMyImportantCommitCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    /*
     *非必填项
    if (cell.textViewsText.length == 0) {
        [GYUtils showToast:kLocalized(@"GYHS_Myhs_Input_Authenticate_Reason")];
        return;
    }
     */
    
    if (cell.textViewsText.length > 300) {
        [GYUtils showToast:kLocalized(@"GYHS_Myhs_Authenticate_Reason_More_Three_Hundred_Words")];
        return;
    }
    //符合条件则加入都字典中
    [self.requestDict addEntriesFromDictionary:@{ @"applyReason" : kSaftToNSString(cell.textViewsText) }];
    
    if (!cell.isEmptyCode) {
        [GYUtils showToast:kLocalized(@"GYHS_Myhs_Input_Code")];
        return;
    }
    
    if (!cell.isRightCode) {
        [GYUtils showToast:kLocalized(@"GYHS_Myhs_Authenticate_Code_Error")];
        return;
    }
    
    NSString* operName = [NSString stringWithFormat:@"(%@)", globalData.loginModel.operName];
    NSString* optName = [globalData.loginModel.userName stringByAppendingString:operName];
    NSMutableDictionary* parameter = @{
                                       @"entCustId" : globalData.loginModel.entCustId,
                                       @"entResNo" : globalData.loginModel.entResNo,
                                       @"entCustName" : globalData.loginModel.entCustName,
                                       @"custType" : [@(globalData.companyType) stringValue],
                                       @"countryNo" : globalData.loginModel.countryCode,
                                       @"provinceNo" : globalData.loginModel.provinceCode,
                                       @"cityNo" : globalData.loginModel.cityCode,
                                       
                                       @"optCustId" : globalData.loginModel.custId,
                                       @"optName" : optName,
                                       @"optEntName" : globalData.loginModel.entCustName,
                                       @"linkman":self.oldModel.contactPerson,
                                        @"mobile" : self.oldModel.contactPhone
                                       }.mutableCopy;
    [self.requestDict addEntriesFromDictionary:parameter];
    @weakify(self);
    if (globalData.companyType == kCompanyType_Membercom) {
        [GYAlertView alertWithTitle:nil
                            Message:kLocalized(@"GYHS_Myhs_CompanyType_Membercom_Important_Chaging_Tip")
                           topColor:TopColorBlue
                       comfirmBlock:^{
                           @strongify(self);
                           [self commitData];
                       }];
    } else {
        [GYAlertView alertWithTitle:nil
                            Message:kLocalized(@"GYHS_Myhs_CompanyType_Trustcom_Important_Chaging_Tip")
                           topColor:TopColorBlue
                       comfirmBlock:^{
                           @strongify(self);
                           [self commitData];
                       }];
    }
    
}

#pragma mark - request
/*!
 *    下载示例图片
 *
 *    @param type 示例图片类型
 */
- (void) loadDown:(GYHSExampleDoc)type {
    [GYHSmyhsHttpTool queryImageDocListWithSuccess:^(id responsObject) {
        NSArray *array = responsObject;
        [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GYHSDocModel *model = [GYHSDocModel mj_objectWithKeyValues:obj];
            if (model.docIdentify == type) {
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:model.docUrl];
                [NSURLConnection
                 sendAsynchronousRequest:request
                 queue:[NSOperationQueue mainQueue]
                 completionHandler:^(NSURLResponse *_Nullable response,
                                     NSData *_Nullable data,
                                     NSError *_Nullable connectionError) {
                     if([data writeToFile:model.localPath atomically:YES]){
                         dispatch_async(dispatch_get_main_queue(), ^(){
                             
                             GYWebViewController *webVC = [[GYWebViewController alloc]init];
                             webVC.fileUrl = [NSURL URLWithString:model.localPath];
                             [self.navigationController pushViewController:webVC animated:YES];
                         });
                     
                     }
                     
                 }];
            }
            
        }];
        
    } failure:^{
        
    }];
}
/**
 *  查看营业执照的示例图片
 */

- (void)lookPicture{
    [GYHSmyhsHttpTool getQueryImageDocListWithSuccess:^(id responsObject) {
        for (NSDictionary *dic in responsObject) {
            GYHSDocModel *model = [GYHSDocModel mj_objectWithKeyValues:dic];
            if (model.docIdentify == GYHSExampleDocHandheldBusinessLicense) {
                NSString *url = GY_PICTUREAPPENDING(model.docUrl);
                GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
                item.largeImageURL = [NSURL URLWithString:url];
                item.thumbView = self.tempButton;
                
                GYPhotoGroupView* photoGroupView = [[GYPhotoGroupView alloc] initWithGroupItems:@[ item ]];
                [photoGroupView presentFromImageView:self.tempButton toContainer:self.navigationController.view animated:YES completion:nil];

            }
        }
    } failure:^{
        
    }];

}

/*!
 *    创建重要信息变更信息
 */
- (void) commitData {
    //提交信息
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSCreateEntChangeInfo)
          parameter:self.requestDict
            success:^(id returnValue) {
                if (kHTTPSuccessResponse(returnValue)) {
                    
                    if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                        [GYUtils showToast:returnValue[@"msg"]];
                        GYHSMyImportantInfoChageFinishVC* vc = [[GYHSMyImportantInfoChageFinishVC alloc] init];
                        [self.navigationController pushViewController:vc animated:NO];
                    }
                }
            }
            failure:^(NSError* error) {
                
            }
        isIndicator:YES];

}

/*!
 *    上传图片
 *
 *    @param imageData 图片
 *    @param imageName 图片的名称
 */
- (void)uploadImage:(NSData*)imageData imageName:(NSString*)imageName
{
    @weakify(self);
    [GYHSmyhsHttpTool uploadImageWithUrl:upLoadPictureUrl
                                  params:nil
                               imageData:imageData
                               imageName:imageName
                                 success:^(id responsObject) {
                                     @strongify(self);
                                     
                                     if ([responsObject[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                                         [GYUtils showToast:kLocalized(@"GYHS_Myhs_Upload_Image_Success")];
                                         
                                         NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                         
                                         GYHSMyImportantCommitCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
                                         
                                         switch (self.type) {
                                             case GYHSImportantUploadTypeImptappPic: {
                                                 cell.businessProcessApplicationImage = [UIImage imageWithData:imageData];
                                                 [self.requestDict addEntriesFromDictionary:@{ @"imptappPic" : responsObject[GYNetWorkDataKey] }];
                                             } break;
                                                 
                                             case GYHSImportantUploadTypebusiLicenseImg: {
                                                 cell.businessLicenseImage = [UIImage imageWithData:imageData];
                                                 [self.requestDict addEntriesFromDictionary:@{ @"bizLicenseCrePicNew" : responsObject[GYNetWorkDataKey] }];
                                                 [self.requestDict addEntriesFromDictionary:@{ @"bizLicenseCrePicOld" : self.oldModel.busiLicenseImg }];
                                             } break;
                                                 
                                             case GYHSImportantUploadTypelinkAuthorizePic: {
                                                 cell.contactPowerOfAttorneyIamge = [UIImage imageWithData:imageData];
                                                 [self.requestDict addEntriesFromDictionary:@{ @"linkAuthorizePicNew" : responsObject[GYNetWorkDataKey] }];
                                                 [self.requestDict addEntriesFromDictionary:@{ @"linkAuthorizePicOld" : self.oldModel.authProxyFile }];
                                             } break;
                                             case GYHSImportantUploadTypeNone:
                                             default:
                                                 break;
                                         }
                                     }
                                     
                                 }
                                 failure:^{
                                     
                                 }];
}

#pragma mark - private methods
/*!
 *    判断上传条件是否正确
 *
 *    @return YES or NO
 */
- (BOOL)judgeUploadIsRight
{
    
    NSArray* keyArray = [self.requestDict allKeys];
    //是否显示联系人授权书
    BOOL showContactPower = NO;
    //是否显示营业执照
    BOOL showBusiness = NO;

    
    for (NSString* key in keyArray) {
        //如果包含联系人姓名、联系人手机，则显示上传联系人授权委托书
        if ([key containsString:@"linkmanMobileOld"] || [key containsString:@"linkmanOld"]) {
            showContactPower = YES;
        }
        
        //如果包含企业名称、企业注册地址、法定代表人姓名，则显示上传营业执照的按钮
        if ([key containsString:@"custNameOld"] || [key containsString:@"custAddressOld"]|| [key containsString:@"legalRepOld"]) {
            showBusiness = YES;
        }
    }
    
    if (showContactPower == NO && showBusiness == YES) {
        //判读营业执照是否上传
        if (!self.requestDict[@"bizLicenseCrePicNew"]) {
            [GYUtils showToast:kLocalized(@"GYHS_Myhs_Upload_Business_File")];
            return NO;
        }
    }
    
    if (showContactPower == YES && showBusiness == NO) {
        //判读联系人授权委托书是否上传
        if (!self.requestDict[@"linkAuthorizePicNew"]) {
            [GYUtils showToast:kLocalized(@"GYHS_Myhs_Upload_Contact_Power_of_Attorney")];
            return NO;
        }
    }
    
    if (showContactPower == YES && showBusiness == YES) {
        //判读营业执照是否上传
        if (!self.requestDict[@"bizLicenseCrePicNew"]) {
            [GYUtils showToast:kLocalized(@"GYHS_Myhs_Upload_Business_File")];
            return NO;
        }
        
        //判读联系人授权委托书是否上传
        if (!self.requestDict[@"linkAuthorizePicNew"]) {
            [GYUtils showToast:kLocalized(@"GYHS_Myhs_Upload_Contact_Power_of_Attorney")];
            return NO;
        }
    }
    
    //只要更改重要信息，都要上传业务办理申请书
    if (!self.requestDict[@"imptappPic"]) {
        [GYUtils showToast:kLocalized(@"GYHS_Myhs_Upload_Business_Process_Application")];
        return NO;
    }
    return YES;
}

/*!
 *    打开相机
 */
- (void)pickImageFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* pickCtl = [[UIImagePickerController alloc] init];
        pickCtl.delegate = self;
        pickCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickCtl.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        pickCtl.allowsEditing = YES;
        [self presentViewController:pickCtl animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication].delegate.window makeToast:kLocalized(@"GYHS_Myhs_Device_Not_Support_Camera") duration:1.f position:CSToastPositionBottom];
    }
}

/*!
 *    打开相册
 */
- (void)pickImageFromAlbum
{
    
    UIImagePickerController* pickCtl = [[UIImagePickerController alloc] init];
    [pickCtl setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickCtl.delegate = self;
    pickCtl.allowsEditing = YES;
    pickCtl.modalPresentationStyle = UIModalPresentationPopover;
    pickCtl.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    pickCtl.popoverPresentationController.sourceView = self.tempButton.superview;
    pickCtl.popoverPresentationController.sourceRect = CGRectMake(self.tempButton.x, self.tempButton.y, self.tempButton.width, self.tempButton.height / 2.0);
    [self presentViewController:pickCtl animated:YES completion:nil];
}

/*!
 *    弹出选择相机或照片的ActionSheet
 */
- (void)takePhoto
{
    
    GYPhotoPickerViewController* vc = [[GYPhotoPickerViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
//    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:kLocalized(@"GYHS_Myhs_Please_Select_Upload_Style") delegate:self cancelButtonTitle:nil destructiveButtonTitle:kLocalized(@"GYHS_Myhs_Camera") otherButtonTitles:kLocalized(@"GYHS_Myhs_Photo_Gallery"), nil];
//    [actionSheet showFromRect:CGRectMake(self.tempButton.x, self.tempButton.y, self.tempButton.width, self.tempButton.height) inView:self.tempButton.superview animated:YES];
}

/**
 *  点击图片选择器的确定按钮
 */
-(void)imagePickerViewController:(GYPhotoPickerViewController *)ivc imageAsset:(ALAsset *)asset{
    
    
    // 使用asset来获取本地图片
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *image = [UIImage imageWithCGImage:imgRef
                                              scale:assetRep.scale
                                        orientation:(UIImageOrientation)assetRep.orientation];
    
    
    
    NSDate* date = [NSDate date];
    NSString* tempName = [[NSString stringWithFormat:@"%@", date] substringToIndex:10];
    NSString* imageName = [tempName stringByAppendingString:@".jpg"];
    
    //换成二进制数据
    NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
    // 设置图片沙盒目录
    NSString* fullPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    
    // 检查文件大小 不能大于1M
    NSFileManager* fm = [NSFileManager defaultManager];
    long long fSize = 0;
    if ([fm fileExistsAtPath:fullPath]) {
        fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
    }
    
    //如果大于2M进行压缩处理
    if (fSize > 1024 * 1024) {
        imageData = UIImageJPEGRepresentation(image, 0.25);
        [imageData writeToFile:fullPath atomically:NO];
    }
    
    if (imageData) {
        [self uploadImage:imageData imageName:imageName];
    }
}
/**
 *  选择相机
 *
 *  @param ivc 前面控制器视图
 */
-(void)imagePickerViewControllerCamera:(GYPhotoPickerViewController *)ivc{
    [self pickImageFromCamera];
}


- (void)initView
{
    self.title = kLocalized(@"GYHS_Myhs_Important_Info_Chage");
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addLeftView];
    [self addBottomView];
}

/*!
 *    添加UI左半部分视图
 */
- (void)addLeftView
{
    
    GYHSMemberProgressView* progressView = [[GYHSMemberProgressView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kDeviceProportion(225), kDeviceProportion(400)) array:@[ kLocalized(@"GYHS_Myhs_Click_Modify_Info"), kLocalized(@"GYHS_Myhs_Upload_Related_Image"),kLocalized(@"GYHS_Myhs_Finish_Chage") ]];
    progressView.index = 2;
    [self.view addSubview:progressView];
}

/*!
 *    添加UI底部视图
 */
- (void)addBottomView
{
    
    UIView* backBottomView = [[UIView alloc] init];
    backBottomView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:backBottomView];
    [backBottomView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    [backBottomView addSubview:self.commitButton];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(backBottomView);
    }];
    
    //添加tableview
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.width.mas_equalTo(kDeviceProportion(791));
        make.right.equalTo(self.view).offset(kDeviceProportion(-16));
        make.top.equalTo(self.view).offset(kDeviceProportion(16) + kNavigationHeight);
        make.bottom.equalTo(backBottomView.mas_top).offset(kDeviceProportion(-16));
    }];
}

#pragma mark - lazy load
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = kWhiteFFFFFF;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMyImportantCommitCell class]) bundle:nil] forCellReuseIdentifier:idCell];
    }
    return _tableView;
}

- (UIButton*)commitButton
{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setTitle:kLocalized(@"GYHS_Myhs_Submit") forState:UIControlStateNormal];
        [_commitButton setTitleColor:kWhiteFFFFFF forState:UIControlStateNormal];
        _commitButton.backgroundColor = kRedE50012;
        _commitButton.layer.cornerRadius = 6;
        [_commitButton addTarget:self action:@selector(commitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

@end
