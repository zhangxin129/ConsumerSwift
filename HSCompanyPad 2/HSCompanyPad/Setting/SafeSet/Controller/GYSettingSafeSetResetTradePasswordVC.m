//
//  GYSettingSafeSetResetTradePasswordVC.m
//
//  Created by apple on 16/8/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingSafeSetResetTradePasswordVC.h"
#import "GYHSmyhsHttpTool.h"
#import "GYNetwork.h"
#import "GYSetingSafeSetInputViewCell.h"
#import "GYSetingSafeSetMainCell.h"
#import "GYSetingSafeSetUpdateCell.h"
#import "GYSettingSaftSetLastApplyBeanModel.h"
#import "GYSettingSaftSetResetTradePasswordOverruleView.h"
#import <YYKit/NSString+YYAdd.h>
#import <YYKit/UIControl+YYAdd.h>
#import <YYKit/UIView+YYAdd.h>
#import "GYPhotoPickerViewController.h"
#import "GYWebViewController.h"
#import <MJExtension/MJExtension.h>
#import "GYHSDocModel.h"
typedef NS_ENUM(NSUInteger, ApplyStatus) {
    ApplyStatusNever = -1, //未申请
    ApplyStatusPending = 0, //待审核
    ApplyStatusThrough = 1, //审核通过
    ApplyStatusOverrule = 2 //驳回
};

static NSString* idMainCell = @"safeSetMainCell";
static NSString* idUpdateCell = @"safeSetUpdateCell";
static NSString* idInputCell = @"safeSetInputViewCell";

@interface GYSettingSafeSetResetTradePasswordVC () <UITableViewDataSource, UITableViewDelegate, GYSetingSafeSetUpdateCellDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate,GYPhotoPickerViewControllerDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* bottomBackView;
@property (nonatomic, strong) UIButton* applyButton;
@property (nonatomic, strong) UIButton* cancelApplyButton;
@property (nonatomic, strong) NSArray* titleArray;
@property (nonatomic, strong) NSArray* contentArray;
/*!
 *    临时的按钮，目的是其获取cell的button的frame
 */
@property (nonatomic, weak) UIButton* tempButton;
@property (nonatomic, strong) NSMutableDictionary* requestDic;
@property (nonatomic, strong) UIImage* tempImage;

@property (nonatomic, strong) GYSettingSaftSetLastApplyBeanModel* model;

@property (nonatomic, weak) UITextField* authorizationCodeTextField;
@property (nonatomic, weak) UITextField* newsTradePasswordTextField;
@property (nonatomic, weak) UITextField* againTradePasswordTextField;
@end

@implementation GYSettingSafeSetResetTradePasswordVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self qureyLastApplyBean];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row < 4) {
        GYSetingSafeSetMainCell* mainCell = [tableView dequeueReusableCellWithIdentifier:idMainCell forIndexPath:indexPath];
        mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
        mainCell.titleLabel.text = self.titleArray[indexPath.row];
        mainCell.contentLabel.text = self.contentArray[indexPath.row];
        return mainCell;
    } else if (indexPath.row == 4) {
        GYSetingSafeSetUpdateCell* updateCell = [tableView dequeueReusableCellWithIdentifier:idUpdateCell forIndexPath:indexPath];
        updateCell.delegate = self;
        updateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        updateCell.titleLabel.text = self.titleArray[indexPath.row];
        if (self.tempImage) {
            updateCell.myImagesView.image = self.tempImage;
        }
        return updateCell;
    } else {
        GYSetingSafeSetInputViewCell* inputCell = [tableView dequeueReusableCellWithIdentifier:idInputCell forIndexPath:indexPath];
        inputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        inputCell.titleLabel.text = self.titleArray[indexPath.row];
        return inputCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return kDeviceProportion(16.0);
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row < 4) {
        return kDeviceProportion(40);
    } else if (indexPath.row == 4) {
        return kDeviceProportion(100);
    } else {
        return kDeviceProportion(200);
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    // 获取图片名称
    NSDate* date = [NSDate date];
    NSString* tempName = [[NSString stringWithFormat:@"c%@", date] substringToIndex:10];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* beText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.newsTradePasswordTextField || textField == self.againTradePasswordTextField) {
        //处理交易密码长度问题
        if (![beText isValidNumber]) {
            return NO;
        }
        
        if (beText.length > 8) {
            textField.text = [beText substringToIndex:8];
            [textField tipWithContent:kLocalized(@"GYSetting_Set_Trade_Password_Eight") animated:YES];
            return NO;
        }
    }
    
    if (textField == self.authorizationCodeTextField) {
        //处理授权码长度问题
        if (![beText isValidNumberAndLetter]) {
            return NO;
        }
        if (beText.length > 20) {
            textField.text = [beText substringToIndex:20];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - GYSetingSafeSetUpdateCellDelegate
- (void)safeSetupdateCellTouch:(safeSetUpdateTouchEvent)event button:(UIButton*)button
{
    self.tempButton = button;
    if (event == safeSetUpdateTouchEventUpload) {
        //上传
        [self takePhoto];
    }
    
    if (event == safeSetUpdateTouchEventDownload) {
        //下载模板
        [self downloadPicModel:GYHSExampleDocResetPwd];
    }
}

#pragma mark - event response
- (void)applyButtonAction
{
    DDLogInfo(@"点击申请");
    if (!self.requestDic[@"applyPath"]) {
        [GYUtils showToast:kLocalized(@"GYSetting_Set_Please_Upload_Bussiness_Book")];
        return;
    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    GYSetingSafeSetInputViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.requestDic addEntriesFromDictionary:@{ @"applyReason" : kSaftToNSString(cell.content)}];
    
    [self commitDataToService];
}

- (void)reApplyButtonAction
{
    // 重新申请
    [self judgeStatus:ApplyStatusNever];
}

- (void)cancelApplyButtonAction
{
    //取消重置
}

- (void)comfirmAction
{
    //确定
    if (self.authorizationCodeTextField.text.length == 0) {
        [self.authorizationCodeTextField tipWithContent:kLocalized(@"GYSetting_Set_Please_Input_Authrence_Code") animated:YES];
        return;
    }
    
    if (self.newsTradePasswordTextField.text.length == 0) {
        [self.newsTradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Trade_Password_New_Input_Eight") animated:YES];
        return;
    }
    
    if (self.newsTradePasswordTextField.text.length == 0) {
        [self.newsTradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Trade_Password_New_Input_Eight_Again") animated:YES];
        return;
    }
    
    if (![self.newsTradePasswordTextField.text isEqualToString:self.againTradePasswordTextField.text]) {
        [self.againTradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Password_Is_Diffrence") animated:YES];
        return;
    }
    
    [self resetTradePasswordToNet];
}

#pragma mark - request
- (void)resetTradePasswordToNet
{
    
    NSMutableDictionary* dicParams = @{
                                       @"custId" : globalData.loginModel.entCustId,
                                       @"operCustId" : globalData.loginModel.custId,
                                       @"mobile" : globalData.loginModel.contactPhone
                                       }.mutableCopy;
    
    [dicParams addEntriesFromDictionary:@{
                                          @"newTraderPwd" : [self.newsTradePasswordTextField.text md5String],
                                          @"authCode" : self.againTradePasswordTextField.text
                                          }];
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYSettingResetTradePwdByAuthCode)
          parameter:dicParams
            success:^(id returnValue) {
                
                if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                    [GYUtils showToast:returnValue[@"msg"]];
                }
                
            }
            failure:^(NSError* error) {
                
            }
        isIndicator:YES];
}

- (void)commitDataToService
{
    [self.requestDic addEntriesFromDictionary:@{
                                                @"entResNo" : globalData.loginModel.entResNo,
                                                @"entCustId" : globalData.loginModel.entCustId,
                                                @"entCustName" : globalData.loginModel.entCustName,
                                                @"linkman" : globalData.loginModel.contactPerson,
                                                @"mobile" : globalData.loginModel.contactPhone,
                                                @"createdby" : globalData.loginModel.operName
                                                }];
    @weakify(self);
    [GYNetwork PUT:GY_HSDOMAINAPPENDING(GYSettingCreateResetTransPwdApply)
         parameter:self.requestDic
           success:^(id returnValue) {
               @strongify(self);
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   [GYUtils showToast:kLocalized(@"GYSetting_Set_Commit_apply_Success")];
                   [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYSetting_Set_Commit_apply_Tip")
                                                     topColor:TopColorBlue
                                                 comfirmBlock:^{
                                                     [self judgeStatus:ApplyStatusPending];
                                                 }];
               }
               
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];
}

- (void)qureyLastApplyBean
{
    NSDictionary* dicParams = @{
                                @"entCustId" : globalData.loginModel.entCustId
                                };
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYSettingQueryLastApplyBean)
         parameter:dicParams
           success:^(id returnValue) {
               
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   self.model = [[GYSettingSaftSetLastApplyBeanModel alloc] initWithDictionary:returnValue[GYNetWorkDataKey] error:nil];
                   ApplyStatus status = ApplyStatusNever;
                   if (_model.status) {
                       status = _model.status.unsignedIntegerValue;
                   }
                   [self judgeStatus:status];
               }
               
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];
}

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
                                         [GYUtils showToast:kLocalized(@"GYSetting_Set_Upload_Image_Success")];
                                         [self.requestDic addEntriesFromDictionary:@{ @"applyPath" : responsObject[GYNetWorkDataKey] }];
                                         self.tempImage = [UIImage imageWithData:imageData];
                                         [self.tableView reloadData];
                                         
                                     } else {
                                         [GYUtils showToast:responsObject[@"msg"]];
                                     }
                                 }
                                 failure:^{
                                     
                                 }];
}

#pragma mark - private methods
- (void)judgeStatus:(ApplyStatus)status
{
    if (self.view.subviews.count > 0) {
        [self.view removeAllSubviews];
    }
    switch (status) {
        case ApplyStatusNever: {
            [self haveNotResetTradePasswordView];
        } break;
            
        case ApplyStatusPending: {
            [self resetTradePasswordPendingView];
        } break;
            
        case ApplyStatusThrough: {
            [self resetTradePasswordThroughView];
        } break;
            
        case ApplyStatusOverrule: {
            [self resetTradePasswordOverruleView];
        } break;
            
        default:
            break;
    }
}

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

- (void)pickImageFromAlbum
{
    
    UIImagePickerController* pickCtl = [[UIImagePickerController alloc] init];
    [pickCtl setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickCtl.delegate = self;
    pickCtl.allowsEditing = YES;
    pickCtl.modalPresentationStyle = UIModalPresentationPopover;
    pickCtl.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    pickCtl.popoverPresentationController.sourceView = self.tempButton.superview;
    pickCtl.popoverPresentationController.sourceRect = CGRectMake(self.tempButton.x, self.tempButton.y, self.tempButton.width, self.tempButton.height / 2.0);
    [self presentViewController:pickCtl animated:YES completion:nil];
}

- (void)downloadPicModel:(GYHSExampleDoc)type {
    
    [GYHSmyhsHttpTool queryImageDocListWithSuccess:^(id responsObject) {
        NSArray *array = responsObject;
        [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GYHSDocModel *model = [GYHSDocModel mj_objectWithKeyValues:obj];
            if (model.docIdentify == type && [model.fileType isEqualToString:@"applyFile"]) {
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

- (void)takePhoto
{
//    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:kLocalized(@"GYHS_Myhs_Please_Select_Upload_Style") delegate:self cancelButtonTitle:nil destructiveButtonTitle:kLocalized(@"GYHS_Myhs_Camera") otherButtonTitles:kLocalized(@"GYHS_Myhs_Photo_Gallery"), nil];
//    [actionSheet showFromRect:CGRectMake(self.tempButton.x, self.tempButton.y + self.tempButton.height / 2.0, self.tempButton.width, self.tempButton.height / 2.0) inView:self.tempButton.superview animated:YES];
    GYPhotoPickerViewController* vc = [[GYPhotoPickerViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
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
    self.title = kLocalized(@"GYSetting_Set_Trade_Password_Reset");
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
}

- (void)addBottonView
{
    [self.view addSubview:self.bottomBackView];
    [_bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    [_bottomBackView addSubview:self.applyButton];
    [self.applyButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(_bottomBackView);
    }];
}

/*!
 *    从未申请的视图
 */
- (void)haveNotResetTradePasswordView
{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.top.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(kDeviceProportion(-70));
    }];
    
    [self addBottonView];
    if (_applyButton.allTargets.count > 0) {
        [_applyButton removeAllTargets];
    }
    [_applyButton setTitle:kLocalized(@"GYSetting_Set_Commit_apply") forState:UIControlStateNormal];
    [_applyButton addTarget:self action:@selector(applyButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

/*!
 *    审核中的视图
 */
- (void)resetTradePasswordPendingView
{
    UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceProportion(200), kDeviceProportion(106) + 44, kScreenWidth - kDeviceProportion(200 * 2), 60)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = kFont32;
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = kGray333333;
    tipLabel.text = kLocalized(@"GYSetting_Set_Commit_apply_Tip");
    [self.view addSubview:tipLabel];
}

/*!
 *    驳回界面
 */
- (void)resetTradePasswordOverruleView
{
    GYSettingSaftSetResetTradePasswordOverruleView* view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYSettingSaftSetResetTradePasswordOverruleView class]) owner:self options:nil] lastObject];
    view.model = self.model;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(kDeviceProportion(16));
        make.height.equalTo(@(kDeviceProportion(120)));
        make.width.equalTo(@(kDeviceProportion(500)));
    }];
    
    [self addBottonView];
    if (_applyButton.allTargets.count > 0) {
        [_applyButton removeAllTargets];
    }
    [_applyButton setTitle:kLocalized(@"GYSetting_Set_Reapply") forState:UIControlStateNormal];
    [_applyButton addTarget:self action:@selector(reApplyButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

/*!
 *    审批通过的视图
 */
- (void)resetTradePasswordThroughView
{
    UITextField* authorizationCodeTextField = [[UITextField alloc] init];
    self.authorizationCodeTextField = authorizationCodeTextField;
    authorizationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    authorizationCodeTextField.borderStyle = UITextBorderStyleLine;
    authorizationCodeTextField.delegate = self;
    authorizationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    authorizationCodeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    authorizationCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    authorizationCodeTextField.font = kFont32;
    authorizationCodeTextField.placeholder = kLocalized(@"GYSetting_Set_Please_Input_Authrence_Code");
    [self.view addSubview:authorizationCodeTextField];
    [authorizationCodeTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kDeviceProportion(340)));
        make.top.equalTo(self.view).offset(kDeviceProportion(16));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    UITextField* newTradePasswordTextField = [[UITextField alloc] init];
    self.newsTradePasswordTextField = newTradePasswordTextField;
    newTradePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
    newTradePasswordTextField.borderStyle = UITextBorderStyleLine;
    newTradePasswordTextField.delegate = self;
    newTradePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    newTradePasswordTextField.secureTextEntry = YES;
    newTradePasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    newTradePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    newTradePasswordTextField.font = kFont32;
    newTradePasswordTextField.placeholder = kLocalized(@"GYSetting_Set_Trade_Password_New_Input_Eight");
    [self.view addSubview:newTradePasswordTextField];
    [newTradePasswordTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kDeviceProportion(340)));
        make.top.mas_equalTo(authorizationCodeTextField.mas_bottom).offset(20);
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    UITextField* againTradePasswordTextField = [[UITextField alloc] init];
    self.againTradePasswordTextField = againTradePasswordTextField;
    againTradePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
    againTradePasswordTextField.borderStyle = UITextBorderStyleLine;
    againTradePasswordTextField.delegate = self;
     againTradePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    againTradePasswordTextField.secureTextEntry = YES;
    againTradePasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    againTradePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    againTradePasswordTextField.font = kFont32;
    againTradePasswordTextField.placeholder = kLocalized(@"GYSetting_Set_Trade_Password_New_Input_Eight_Again");
    [self.view addSubview:againTradePasswordTextField];
    [againTradePasswordTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kDeviceProportion(340)));
        make.top.mas_equalTo(newTradePasswordTextField.mas_bottom).offset(20);
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    UILabel* tipLabel = [[UILabel alloc] init];
    NSString* strText = kLocalized(@"GYSetting_Set_Tip_Trade_Password_Eight");
    NSMutableAttributedString* attText = [[NSMutableAttributedString alloc] initWithString:strText attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGray333333 }];
    NSRange range = [strText rangeOfString:kLocalized(@"GYSetting_Set_Tip")];
    [attText setAttributes:@{ NSFontAttributeName : kFont32,
                              NSForegroundColorAttributeName : kRedE40011 }
                     range:range];
    tipLabel.attributedText = attText;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kDeviceProportion(340)));
        make.top.mas_equalTo(againTradePasswordTextField.mas_bottom).offset(20);
        make.height.equalTo(@(kDeviceProportion(21)));
    }];
    
    [self addBottonView];
    [self.applyButton mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.equalTo(_bottomBackView.mas_centerX).offset(-70);
        make.centerY.equalTo(_bottomBackView.mas_centerY);
    }];
    
    [self.view addSubview:self.cancelApplyButton];
    [self.cancelApplyButton mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.equalTo(_bottomBackView.mas_centerX).offset(70);
        make.centerY.equalTo(_bottomBackView.mas_centerY);
    }];
    
    [_applyButton setTitle:kLocalized(@"GYSetting_Comfirm") forState:UIControlStateNormal];
    [_applyButton addTarget:self action:@selector(comfirmAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - lazy load
- (GYSettingSaftSetLastApplyBeanModel*)model
{
    if (!_model) {
        _model = [[GYSettingSaftSetLastApplyBeanModel alloc] init];
    }
    return _model;
}

- (UIView*)bottomBackView
{
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc] init];
        _bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    }
    return _bottomBackView;
}
- (NSMutableDictionary*)requestDic
{
    if (!_requestDic) {
        _requestDic = [NSMutableDictionary dictionary];
    }
    return _requestDic;
}

- (NSArray*)contentArray
{
    if (!_contentArray) {
        _contentArray = @[ globalData.loginModel.entResNo, globalData.loginModel.entCustName, globalData.loginModel.contactPerson, globalData.loginModel.contactPhone ];
    }
    return _contentArray;
}

- (NSArray*)titleArray
{
    if (!_titleArray) {
        _titleArray = @[ kLocalized(@"GYSetting_Set_ResNo_Colon"), kLocalized(@"GYSetting_Set_Ent_Name_Colon"), kLocalized(@"GYSetting_Set_Linkman_Name_Colon"), kLocalized(@"GYSetting_Set_Linkman_Phone_Colon"), kLocalized(@"GYSetting_Set_Bussiness_Book_Colon"), kLocalized(@"GYSetting_Set_Apply_Description_Colon") ];
    }
    return _titleArray;
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSetingSafeSetMainCell class]) bundle:nil] forCellReuseIdentifier:idMainCell];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSetingSafeSetUpdateCell class]) bundle:nil] forCellReuseIdentifier:idUpdateCell];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSetingSafeSetInputViewCell class]) bundle:nil] forCellReuseIdentifier:idInputCell];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton*)cancelApplyButton
{
    if (!_cancelApplyButton) {
        _cancelApplyButton = [[UIButton alloc] init];
        _cancelApplyButton.layer.cornerRadius = 5;
        [_cancelApplyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelApplyButton setBackgroundColor:kGray535362];
        [_cancelApplyButton setTitle:kLocalized(@"取消重置") forState:UIControlStateNormal];
        [_cancelApplyButton addTarget:self action:@selector(cancelApplyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelApplyButton;
}

- (UIButton*)applyButton
{
    if (!_applyButton) {
        _applyButton = [[UIButton alloc] init];
        _applyButton.layer.cornerRadius = 5;
        [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyButton setBackgroundColor:kRedE50012];
    }
    return _applyButton;
}


@end
