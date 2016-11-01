//
//  GYHSMyContactInfoVC.m
//
//  Created by apple on 16/8/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyContactInfoVC.h"
#import "GYHSMyContactInfoFirstSectionCell.h"
#import "GYHSMyContactInfoSecondSectionCell.h"
#import "GYHSMyContactInfoThirdCell.h"

#import "GYHSMyContactInfoMainModel.h"
#import "GYHSmyhsHttpTool.h"
#import "GYNetwork.h"
#import <GYKit/GYPhotoGroupView.h>
#import <GYKit/UIImage+GYExtension.h>
#import <YYKit/UIImageView+YYWebImage.h>

static NSString* idFirstCell = @"firstSectionCell";
static NSString* idSecondCell = @"secondSectionCell";
static NSString* idThirdCell = @"thirdCell";

typedef NS_ENUM(NSInteger, ModifyType) {
    ModifyTypeAddress,
    ModifyTypePostCode,
    ModifyTypeEmail,
    ModifyTypeHelpFile,
    ModifyTypeLinkFile
};

@interface GYHSMyContactInfoVC () <UITableViewDataSource, UITableViewDelegate, GYHSMyContactInfoSecondSectionCellDeleage, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, assign) float sectionCellHeight;

@property (nonatomic, strong) GYHSMyContactInfoMainModel* model;
/*!
 *    临时的按钮，目的是其获取cell的button的frame
 */
@property (nonatomic, weak) UIButton* tempButton;
/*!
 *    是否上传的是帮扶文件
 */
@property (nonatomic, assign) BOOL isHelpFile;

@end

@implementation GYHSMyContactInfoVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout :^{
        @strongify(self);
        [self initView];
        [self loadMainViewData];
    }];
    
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
    NSString* tempName = [[NSString stringWithFormat:@"contactInfo%@", date] substringToIndex:10];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return section == 0 ? 4 : 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.section) {
        case 0: {
            GYHSMyContactInfoFirstSectionCell* cell = [tableView dequeueReusableCellWithIdentifier:idFirstCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.model = self.model;
            cell.indexPath = indexPath;
            return cell;
        } break;
        case 1: {
            GYHSMyContactInfoSecondSectionCell* cell = [tableView dequeueReusableCellWithIdentifier:idSecondCell forIndexPath:indexPath];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.model = self.model;
            return cell;
        }
        case 2: {
            GYHSMyContactInfoThirdCell* cell = [tableView dequeueReusableCellWithIdentifier:idThirdCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.model = self.model;
            @weakify(self)
            cell.toUploadLinkFileBlock
            = ^(UIButton* btn) {
                @strongify(self);
                //上传联系人授权书
                self.tempButton = btn;
                self.isHelpFile = NO;
                [self takePhoto];
            };
            
            cell.toBrowerHelpFileBlock = ^(UIButton* btn) {
                @strongify(self);
                //浏览帮扶文件
                self.tempButton = btn;
                [self showExampleImg:self.model.helpAgreement];
            };
            
            cell.toUploadHelpFileBlock = ^(UIButton* btn) {
                @strongify(self);
                //上传帮扶文件
                self.tempButton = btn;
                self.isHelpFile = NO;
                [self takePhoto];
            };
            
            cell.toBrowerLinkFileBlock = ^(UIButton* btn) {
                @strongify(self);
                //浏览联系人授权书
                self.tempButton = btn;
                [self showExampleImg:self.model.authProxyFile];
            };
            
            return cell;
        } break;
            
        default: {
            return nil;
        } break;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.section) {
        case 0:
            return kDeviceProportion(40);
            break;
        case 1:
            return self.sectionCellHeight;
            break;
        case 2:
            return kDeviceProportion(233.0);
            break;
        default:
            return 44;
            break;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return kDeviceProportion(14);
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = kWhiteFFFFFF;
    return view;
}

#pragma mark - GYHSMyContactInfoSecondSectionCellDeleage
/*!
 *    更新地址
 *
 *    @param modifyContactAddress 需要更新的用的地址
 *    @param complete             完成后的事件
 */
- (void)updateContactAddress:(UITextField*)modifyContactAddressTextField complete:(dispatch_block_t)complete
{
    [self.view endEditing:YES];
    if (modifyContactAddressTextField.text.length == 0) {
        [modifyContactAddressTextField tipWithContent:kLocalized(@"GYHS_Myhs_PleaseInputContent") animated:YES];
        return;
    }
    
    if (modifyContactAddressTextField.text.length < 2 || modifyContactAddressTextField.text.length > 128) {
        [modifyContactAddressTextField tipWithContent:kLocalized(@"GYHS_Myhs_Contact_Address_Error") animated:YES];
        return;
    }
    @weakify(self);
    [self modifyCompanyInfo:modifyContactAddressTextField.text
                       type:ModifyTypeAddress
                   complete:^{
                       @strongify(self);
                       self.model.contactAddr = modifyContactAddressTextField.text;
                       [self.tableView reloadData];
                       if (complete) {
                           complete();
                       }
                   }];
}

/*!
 *    邮政编码
 *
 *    @param modifyPostCode 需要更新的邮政编码
 *    @param complete       完成后的事件
 */
- (void)updatePostCode:(UITextField*)modifyPostCodeTextField complete:(dispatch_block_t)complete
{
    [self.view endEditing:YES];
    if (modifyPostCodeTextField.text.length == 0) {
        [modifyPostCodeTextField tipWithContent:kLocalized(@"GYHS_Myhs_PleaseInputContent") animated:YES];
        return;
    }
    
    if (![modifyPostCodeTextField.text isValidPostalcode]) {
        [modifyPostCodeTextField tipWithContent:kLocalized(@"GYHS_Myhs_Post_Code_Error") animated:YES];
        return;
    }
    @weakify(self);
    [self modifyCompanyInfo:modifyPostCodeTextField.text
                       type:ModifyTypePostCode
                   complete:^{
                       @strongify(self);
                       self.model.postCode = modifyPostCodeTextField.text;
                       [self.tableView reloadData];
                       if (complete) {
                           complete();
                       }
                   }];
}

/*!
 *    邮箱
 *
 *    @param modifyCompanyEmail 需要更新的企业邮箱
 *    @param complete           完成后的事件
 */
- (void)updateCompanyEmail:(UITextField*)modifyCompanyEmailTextField complete:(dispatch_block_t)complete
{
    [self.view endEditing:YES];
    if (modifyCompanyEmailTextField.text.length == 0) {
        [modifyCompanyEmailTextField tipWithContent:kLocalized(@"GYHS_Myhs_PleaseInputContent") animated:YES];
        return;
    }
    
    if (![modifyCompanyEmailTextField.text isEmailAddress]) {
        [modifyCompanyEmailTextField tipWithContent:kLocalized(@"GYHS_Myhs_Email_Format_Error") animated:YES];
        return;
    }
    
    @weakify(self);
    [self modifyCompanyInfo:modifyCompanyEmailTextField.text
                       type:ModifyTypeEmail
                   complete:^{
                       @strongify(self);
                       self.model.email = modifyCompanyEmailTextField.text;
                       self.model.isAuthEmail = @"0";
                       [self.tableView reloadData];
                       if (complete) {
                           complete();
                       }
                   }];
}

/*!
 *    更新cell的高度
 *
 *    @param height cell的高度
 */
- (void)updateCellHeight:(float)height
{
    self.sectionCellHeight = height;
    [self.tableView reloadData];
}

#pragma mark - request
/*!
 *    示例图片
 *
 *    @param data 需要跟服务器域名拼接的部分
 */
- (void)showExampleImg:(NSString*)data
{
    NSString* url = GY_PICTUREAPPENDING(data);
    
    GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
    item.largeImageURL = [NSURL URLWithString:url];
    item.thumbView = self.tempButton;
    GYPhotoGroupView* photoGroupView = [[GYPhotoGroupView alloc] initWithGroupItems:@[ item ]];
    [photoGroupView presentFromImageView:self.tempButton toContainer:self.view animated:YES completion:nil];
}

/*!
 *    上传图片
 *
 *    @param imageData image转化为data的data
 *    @param imageName 图片名称
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
                                     
                                     if ([responsObject[@"retCode"] isEqualToNumber:@200]) {
                                         ModifyType type;
                                         if (self.isHelpFile) {
                                             type = ModifyTypeHelpFile;
                                         } else {
                                             type = ModifyTypeLinkFile;
                                         }
                                         [self modifyCompanyInfo:responsObject[@"data"]
                                                            type:type
                                                        complete:^{
                                                            if (self.isHelpFile) {
                                                                self.model.helpAgreement = responsObject[@"data"];
                                                            } else {
                                                                self.model.authProxyFile = responsObject[@"data"];
                                                            }
                                                            [self.tableView reloadData];
                                                        }];
                                     } else {
                                         [GYUtils showToast:responsObject[@"msg"]];
                                     }
                                 }
                                 failure:^{
                                     
                                 }];
}

/*!
 *    请求主界面的企业信息
 */
- (void)loadMainViewData
{
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSMainInfo)
         parameter:@{ @"entCustId" : globalData.loginModel.entCustId }
           success:^(id returnValue) {
               
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   self.model = [[GYHSMyContactInfoMainModel alloc] initWithDictionary:returnValue[GYNetWorkDataKey] error:nil];
                   [self.tableView reloadData];
               } else {
                   [GYUtils showToast:returnValue[@"msg"]];
               }
               
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];
}

- (void)modifyCompanyInfo:(NSString*)parama type:(ModifyType)type complete:(void (^)(void))complete
{
    
    NSMutableDictionary* dictM = @{
                                   @"operatorCustId" : [GlobalData shareInstance].loginModel.custId,
                                   @"entCustId" : globalData.loginModel.entCustId,
                                   @"entResNo" : globalData.loginModel.entResNo
                                   }.mutableCopy;
    switch (type) {
        case ModifyTypeAddress:
            [dictM addEntriesFromDictionary:@{ @"contactAddr" : parama }];
            break;
            
        case ModifyTypeEmail:
            [dictM addEntriesFromDictionary:@{ @"email" : parama }];
            break;
            
        case ModifyTypePostCode:
            [dictM addEntriesFromDictionary:@{ @"postCode" : parama }];
            
            break;
            
        case ModifyTypeHelpFile:
            [dictM addEntriesFromDictionary:@{ @"helpAgreement" : parama }];
            
            break;
            
        case ModifyTypeLinkFile:
            [dictM addEntriesFromDictionary:@{ @"authProxyFile" : parama }];
            break;
        default:
            break;
    }
    
    [GYNetwork PUT:GY_HSDOMAINAPPENDING(GYHSUpdateMainInfo)
         parameter:dictM
           success:^(id returnValue) {
               
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   [GYUtils showToast:returnValue[@"msg"]];
                   //修改企业邮箱需要刷新我的互生界面
                   if (type == ModifyTypeEmail) {
                       [[NSNotificationCenter defaultCenter] postNotificationName:GYChangeBankCardOrChageMainHSNotification object:nil];
                   }
                   if (complete) {
                       complete();
                   }
                   
               } else {
                   [GYUtils showToast:returnValue[@"msg"]];
               }
               
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];
}

#pragma mark - private methods
- (void)pickImageFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* pickCtl = [[UIImagePickerController alloc] init];
        pickCtl.delegate = self;
        pickCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickCtl.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        pickCtl.allowsEditing = YES;
        [self presentViewController:pickCtl animated:YES completion:nil];
    }
    else {
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
    pickCtl.popoverPresentationController.sourceRect = CGRectMake(self.tempButton.x, self.tempButton.y + self.tempButton.height / 2.0, self.tempButton.width, self.tempButton.height / 2.0);
    [self presentViewController:pickCtl animated:YES completion:nil];
}

- (void)takePhoto
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:kLocalized(@"GYHS_Myhs_Please_Select_Upload_Style") delegate:self cancelButtonTitle:nil destructiveButtonTitle:kLocalized(@"GYHS_Myhs_Camera") otherButtonTitles:kLocalized(@"GYHS_Myhs_Photo_Gallery"), nil];
    [actionSheet showFromRect:CGRectMake(self.tempButton.x, self.tempButton.y + self.tempButton.height / 2.0, self.tempButton.width, self.tempButton.height / 2.0) inView:self.tempButton.superview animated:YES];
}

- (void)initView
{
    self.title = kLocalized(@"GYHS_Myhs_Contact_Info");
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //赋值一个临时的默认高度值
    self.sectionCellHeight = 184.0;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(44);
        make.width.equalTo(@(kDeviceProportion(705)));
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - lazy load

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kWhiteFFFFFF;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMyContactInfoFirstSectionCell class]) bundle:nil] forCellReuseIdentifier:idFirstCell];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMyContactInfoSecondSectionCell class]) bundle:nil] forCellReuseIdentifier:idSecondCell];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMyContactInfoThirdCell class]) bundle:nil] forCellReuseIdentifier:idThirdCell];
    }
    return _tableView;
}

@end
