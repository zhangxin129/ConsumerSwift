//
//  GYHSRealNameMainVC.m
//
//  Created by apple on 16/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSRealNameMainVC.h"
#import "GYHSMemberProgressView.h"
#import "GYHSMyHSMainModel.h"
#import "GYHSRealApplyView.h"
#import "GYHSRealInfoView.h"
#import "GYHSRejectView.h"
#import "GYHSmyhsHttpTool.h"
#import "GYNetApiMacro.h"
#import <GYKit/GYPlaceholderTextView.h>
#import "GYRealNameAuthModel.h"
#import "GYRealNameAuthStatusModel.h"
#import "GYHSCunsumeTextField.h"
#import "GYPhotoPickerViewController.h"
#import <MJExtension/MJExtension.h>
#import <GYKit/GYPhotoGroupView.h>
#import "GYHSDocModel.h"

#define kProgressViewWidth 233
#define kBottomHeight kDeviceProportion(70)
#define kDistance 20
@interface GYHSRealNameMainVC () <GYHSRealApplyDelegate, UIImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GYNetworkReloadDelete,GYPhotoPickerViewControllerDelegate>
@property (nonatomic, strong) UIButton* comfirmButton;
@property (nonatomic, weak) GYHSMemberProgressView* progressView;
@property (nonatomic, weak) UIScrollView* scroll;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) UIView* bottomBackView;
@property (nonatomic, weak) GYHSRejectView* rejectView;
@property (nonatomic, weak) GYHSRealApplyView* applyView;
@property (nonatomic, strong) GYRealNameAuthStatusModel* statusModel;
@property (nonatomic, strong) GYRealNameAuthModel* realNameModel;
@property (nonatomic, copy) NSString* imageFile;

@end

@implementation GYHSRealNameMainVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout :^{
        @strongify(self);
        [self initView];
        if (self.model.isRealnameAuth.boolValue) {
            [self isRealNameAuth];
        }
        else {
            [self getEntRealnameAuthByCustId];
        }

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

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Myhs_Real_Authen");
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhs_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    
    UIView* bottomBackView = [[UIView alloc] init];
    bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:bottomBackView];
    self.bottomBackView = bottomBackView;
    [self.bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kBottomHeight));
    }];
    UIButton* comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButton.layer.cornerRadius = 5;
    comfirmButton.layer.borderWidth = 1;
    comfirmButton.layer.borderColor = kRedE50012.CGColor;
    comfirmButton.layer.masksToBounds = YES;
    [comfirmButton setTitle:kLocalized(@"GYHS_Myhs_Again_Real_Authen") forState:UIControlStateNormal];
    [comfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfirmButton setBackgroundColor:kRedE50012];
    [comfirmButton addTarget:self action:@selector(comfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addSubview:comfirmButton];
    self.comfirmButton = comfirmButton;
    [self.comfirmButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(bottomBackView);
    }];
}

#pragma mark - 获取实名状态
- (void)getEntRealnameAuthByCustId
{
    [GYNetwork sharedInstance].delegate = self;
    @weakify(self);
    [GYHSmyhsHttpTool getEntRealnameAuthByCustId:^(id responsObject) {
        @strongify(self);
        if (responsObject && ![responsObject isKindOfClass:[NSNull class]]) {
            GYRealNameAuthStatusModel* model = [[GYRealNameAuthStatusModel alloc] initWithDictionary:responsObject error:nil];
            self.statusModel = model;
            if (self.statusModel.status.integerValue == 2) {
                //完成认证
                [self isRealNameAuth];
            } else if (self.statusModel.status.integerValue == 3 || self.statusModel.status.integerValue == 4) {
                //未通过
                [self rejectApplyView];
            } else if (self.statusModel.status.integerValue == 0 || self.statusModel.status.integerValue == 1) {
                //审批状态
                [self setMarkView];
            }
        } else {
            [self getEntRealnameInfo];
        }
    }
        failure:^{
        
        }];
}

#pragma mark - GYNetworkReloadDelete
- (void)gyNetworkDidTapReloadBtn
{
    [self getEntRealnameAuthByCustId];
}
- (void)getEntRealnameInfo
{
    [GYHSmyhsHttpTool getEntRealnameAuthByhsResNo:^(id responsObject) {
        GYRealNameAuthModel* model = [[GYRealNameAuthModel alloc] initWithDictionary:responsObject error:nil];
        self.realNameModel = model;
        [self setStepView];
    }
        failure:^{
        
        }];
}

#pragma mark - 驳回
- (void)rejectApplyView
{
    self.bottomBackView.hidden = NO;
    if (_rejectView == nil) {
        GYHSRejectView* rejectView = [[GYHSRejectView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, self.view.width, self.view.height - kBottomHeight - kMainHeadHeight - kNavigationHeight)];
        [self.view addSubview:rejectView];
        self.rejectView = rejectView;
    }
    self.rejectView.rejectStr = kLocalized(@"GYHS_Point_Approval_Status_Reject");
    self.rejectView.opinionStr = self.statusModel.apprContent;
    self.rejectView.timeStr = self.statusModel.apprDate;
}

#pragma mark - 申请步骤
- (void)setStepView
{
    self.bottomBackView.hidden = NO;
    [self.comfirmButton setTitle:kLocalized(@"GYHS_Myhs_Next") forState:UIControlStateNormal];
    GYHSMemberProgressView* progressView = [[GYHSMemberProgressView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kProgressViewWidth, self.view.height - kNavigationHeight - kBottomHeight) array:self.dataArray];
    progressView.index = 1;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.progressView.frame), kNavigationHeight, kScreenWidth - self.progressView.width, self.view.height - kNavigationHeight - kBottomHeight)];
    scroll.scrollEnabled = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scroll];
    self.scroll = scroll;
    self.scroll.contentSize = CGSizeMake(scroll.width * (self.dataArray.count - 1), 0);
    
    //企业信息
    GYHSRealInfoView* infoView = [[GYHSRealInfoView alloc] initWithFrame:CGRectMake(0, kDistance, self.scroll.width - kDistance, self.scroll.height - 2 * kDistance) model:self.realNameModel];
    [self.scroll addSubview:infoView];
    
    //申请上传证书
    GYHSRealApplyView* applyView = [[GYHSRealApplyView alloc] initWithFrame:CGRectMake(self.scroll.width, kDistance, self.scroll.width - kDistance, self.scroll.height - 2 * kDistance)];
    applyView.delegate = self;
    [self.scroll addSubview:applyView];
    self.applyView = applyView;
}

#pragma mark - 申请时间
- (void)setMarkView
{
    self.bottomBackView.hidden = YES;
    UILabel* tipLabel = [[UILabel alloc] init];
    tipLabel.text = [NSString stringWithFormat:@"%@%@%@", kLocalized(@"GYHS_Myhs_Real_Apply1"), self.statusModel.createdDate, kLocalized(@"GYHS_Myhs_Real_Apply2")];
    tipLabel.font = kFont32;
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = kGray333333;
    CGSize tipSize = [tipLabel.text boundingRectWithSize:CGSizeMake(tipLabel.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont32, NSFontAttributeName, nil] context:nil].size;
    tipLabel.size = tipSize;
    tipLabel.center = self.view.center;
    [self.view addSubview:tipLabel];
}

#pragma mark - 通过实名认证
- (void)isRealNameAuth
{
    self.bottomBackView.hidden = YES;
    UILabel* tipLabel = [[UILabel alloc] init];
    tipLabel.text = kLocalized(@"GYHS_Myhs_Real_Name_Pass");
    tipLabel.font = kFont32;
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = kGray333333;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    CGSize tipSize = [tipLabel.text boundingRectWithSize:CGSizeMake(tipLabel.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont32, NSFontAttributeName, nil] context:nil].size;
    tipLabel.size = tipSize;
    tipLabel.center = self.view.center;
    [self.view addSubview:tipLabel];
}

#pragma mark - click
- (void)comfirmButtonAction
{
    self.rejectView.hidden = YES;
    if (![self isDataAllright]) {
        return;
    }
    if (!self.progressView.index) {
        [self getEntRealnameInfo];
        return;
    }
    [self setBtnTitle];
    if (self.progressView.index == 2) {
        [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Myhs_Sure_Submit_Real_Apply")
                                          topColor:TopColorBlue
                                      comfirmBlock:^{
                                          //实名认证申请
                                          [self requestReal];
                                      }];
    }
    else {
        self.progressView.index++;
        self.scroll.contentOffset = CGPointMake((self.progressView.index - 1) * self.scroll.width, 0);
    }
}

- (void)leftClick
{
    [self setBtnTitle];
    if (self.progressView.index == self.dataArray.count) {
        self.progressView.hidden = YES;
        self.bottomBackView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.progressView.index--;
    self.scroll.contentOffset = CGPointMake((self.progressView.index - 1) * self.scroll.width, 0);
    if (self.progressView.index < 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setBtnTitle
{
    if (self.progressView.index == self.dataArray.count - 2) {
        [self.comfirmButton setTitle:kLocalized(@"GYHS_Myhs_Submit") forState:UIControlStateNormal];
    }
    else {
        [self.comfirmButton setTitle:kLocalized(@"GYHS_Myhs_Next") forState:UIControlStateNormal];
    }
}

#pragma mark - 数据是否正确
- (BOOL)isDataAllright
{
    //申请
    if (self.progressView.index == 2) {
        if (!self.imageFile) {
            [GYUtils showToast:kLocalized(@"GYHS_Myhs_Bussiness_Apply_Tip")];
            return NO;
        }
        if (self.applyView.textView.text.length > 300) {
            [GYUtils showToast:kLocalized(@"GYHS_Myhs_Reason_Max_Tip")];
            return NO;
        }
        if (self.applyView.inputCodeField.text.length == 0) {
            [self.applyView.inputCodeField tipWithContent:kLocalized(@"GYHS_Myhs_Code_Tip") animated:YES];
            return NO;
        }
        //不区分大小写
        if ([self.applyView.inputCodeField.text compare:self.applyView.codeString options:NSCaseInsensitiveSearch]) {
            [self.applyView.inputCodeField tipWithContent:kLocalized(@"GYHS_Myhs_Code_Error_Tip") animated:YES];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 实名认证申请
- (void)requestReal
{
    NSString* operName = [NSString stringWithFormat:@"(%@)", globalData.loginModel.operName];
    NSString* optName = [globalData.loginModel.userName stringByAppendingString:operName];
    
    NSDictionary* parameter = @{
        @"entResNo" : globalData.loginModel.entResNo,
        @"entCustId" : globalData.loginModel.entCustId,
        @"custType" : [NSString stringWithFormat:@"%lu", (unsigned long)globalData.companyType],
        @"entCustName" : self.realNameModel.entName,
        @"entAddr" : self.realNameModel.entRegAddr,
        @"linkman" : self.realNameModel.contactPerson,
        @"mobile" : self.realNameModel.contactPhone,
        @"legalName" : self.realNameModel.creName,
        @"licenseNo" : self.realNameModel.busiLicenseNo,
        @"legalCreType" : self.realNameModel.creType == nil ? @"" : self.realNameModel.creType,
        @"orgNo" : self.realNameModel.orgCodeNo,
        @"taxNo" : self.realNameModel.taxNo,
        @"lrcFacePic" : @"",
        @"lrcBackPic" : @"",
        @"licensePic" : self.imageFile,
        @"orgPic" : @"",
        @"taxPic" : @"",
        @"optCustId" : globalData.loginModel.custId,
        @"optName" : optName,
        @"optEntName" : globalData.loginModel.entCustName,
        @"postScript" : @"",
        @"cityNo" : kSaftToNSString(globalData.loginModel.cityCode),
        @"countryNo" : kSaftToNSString(globalData.loginModel.countryCode),
        @"provinceNo" : kSaftToNSString(globalData.loginModel.provinceCode)
    };
    [GYHSmyhsHttpTool createEntRealNameAuthWithparamters:parameter
        success:^(id responsObject) {
                                                     if (kHTTPSuccessResponse(responsObject)) {
                                                     
                                                         [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Myhs_Submit_Real_Success")
                                                                                           topColor:TopColorBlue
                                                                                    comfirmBlock:^{
                                                                                    
                                                            [kDefaultNotificationCenter postNotification:[NSNotification notificationWithName:GYChangeBankCardOrChageMainHSNotification object:nil]];                                [self.navigationController popViewControllerAnimated:YES];                                                                                       }];
                                                     }
        }
        failure:^{
        
        }];
}

#pragma mark - GYHSRealApplyDelegate
- (void)actionPictureWithIndex:(NSInteger)index
{
    UIImagePickerController* pickCtl = [[UIImagePickerController alloc] init];
    pickCtl.allowsEditing = YES;
    pickCtl.delegate = self;
    
    switch (index) {
    case 0:
        pickCtl.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickCtl.modalPresentationStyle = UIModalPresentationCustom;
        break;
    case 1:
        // 拍照
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [GYUtils showToast:kLocalized(@"GYHS_Myhs_No_Support")];
            return;
        }
        pickCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickCtl.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        break;
    case 2:
        return;
    default:
        break;
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:pickCtl animated:YES completion:nil];
    }];
}

- (void)showBigPicture:(UIButton *)btn{
    [GYHSmyhsHttpTool getQueryImageDocListWithSuccess:^(id responsObject) {
        for (NSDictionary *dic in responsObject) {
            GYHSDocModel *model = [GYHSDocModel mj_objectWithKeyValues:dic];
            if (model.docIdentify == GYHSExampleDocHandheldBusinessLicense) {
                NSString *url = GY_PICTUREAPPENDING(model.docUrl);
                GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
                item.largeImageURL = [NSURL URLWithString:url];
                item.thumbView = btn;
                
                GYPhotoGroupView* photoGroupView = [[GYPhotoGroupView alloc] initWithGroupItems:@[ item ]];
                [photoGroupView presentFromImageView:btn toContainer:self.navigationController.view animated:YES completion:nil];
                
            }
        }
    } failure:^{
        
    }];

   
}
#pragma mark 新的图片选择器
/**
 *  进入新的图片选择控制器
 */
-(void)viewControllerWithPictureAndCamera{
    GYPhotoPickerViewController* vc = [[GYPhotoPickerViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  进入相机
 *
 *  @param ivc 图片选择器自身视图
 */
-(void)imagePickerViewControllerCamera:(GYPhotoPickerViewController *)ivc{
    [self actionPictureWithIndex:1];
}
/**
 *  点击选择确定按钮
 *
 *  @param ivc   图片选择器自身视图
 *  @param asset 图片信息对象
 */
-(void)imagePickerViewController:(GYPhotoPickerViewController *)ivc imageAsset:(ALAsset *)asset{
    // 使用asset来获取本地图片
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *selectImage = [UIImage imageWithCGImage:imgRef
                                               scale:assetRep.scale
                                         orientation:(UIImageOrientation)assetRep.orientation];
    
    //    UIImage* selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 获取图片名称
    //    NSURL* iamgeUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSURL* iamgeUrl = [asset valueForProperty:ALAssetPropertyAssetURL];
    NSString* strUrl = [iamgeUrl absoluteString];
    NSRange rangeOne = [strUrl rangeOfString:@"="];
    NSRange rangeTwo = [strUrl rangeOfString:@"&"];
    NSString* name = [strUrl substringWithRange:NSMakeRange(rangeOne.location + 1, rangeTwo.location - rangeOne.location - 1)];
    NSString* strType = [strUrl substringFromIndex:strUrl.length - 3];
    NSString* imageName = [NSString stringWithFormat:@"%@.%@", name, strType];
    NSData* imageData = UIImageJPEGRepresentation(selectImage, 1);
    // 获取沙盒目录
    NSString* fullPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
    // 检查文件大小 不能大于2M
    NSFileManager* fm = [NSFileManager defaultManager];
    long long fSize = 0;
    if ([fm fileExistsAtPath:fullPath]) {
        fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
    }
    
    //如果大于2M进行压缩处理
    if (fSize > 2 * 1024 * 1024) {
        imageData = UIImageJPEGRepresentation(selectImage, 2 * 1024.0 * 1024.0 / fSize);
        [imageData writeToFile:fullPath atomically:NO];
        fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
        if (fSize > 2 * 1024 * 1024)
        {
            [GYAlertWithOneButtonView alertWithMessage:@"上传附件图片要求小于2M，格式为jpeg、jpg、png、bmp！" topColor:TopColorRed comfirmBlock:^{
                //                [picker dismissViewControllerAnimated:YES completion:nil];
                //            }];
                [ivc.navigationController popViewControllerAnimated:YES];
            }];
            [fm removeItemAtPath:fullPath error:nil];
            return;
        }
        
    }
    //[picker dismissViewControllerAnimated:YES completion:nil];
    
    [GYHSmyhsHttpTool uploadImageWithUrl:upLoadPictureUrl
                                  params:nil
                               imageData:imageData
                               imageName:@"realAppply"
                                 success:^(id responsObject) {
                                     [self.applyView showImage:selectImage];
                                     self.imageFile = responsObject[GYNetWorkDataKey];
                                 }
                                 failure:^{
                                     
                                 }];

}




#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    UIImage* selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 获取图片名称
    NSURL* iamgeUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSString* strUrl = [iamgeUrl absoluteString];
    NSRange rangeOne = [strUrl rangeOfString:@"="];
    NSRange rangeTwo = [strUrl rangeOfString:@"&"];
    NSString* name = [strUrl substringWithRange:NSMakeRange(rangeOne.location + 1, rangeTwo.location - rangeOne.location - 1)];
    NSString* strType = [strUrl substringFromIndex:strUrl.length - 3];
    NSString* imageName = [NSString stringWithFormat:@"%@.%@", name, strType];
    NSData* imageData = UIImageJPEGRepresentation(selectImage, 1);
    // 获取沙盒目录
    NSString* fullPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
    // 检查文件大小 不能大于2M
    NSFileManager* fm = [NSFileManager defaultManager];
    long long fSize = 0;
    if ([fm fileExistsAtPath:fullPath]) {
        fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
    }
    
    //如果大于2M进行压缩处理
    if (fSize > 2 * 1024 * 1024) {
    
        imageData = UIImageJPEGRepresentation(selectImage, 2 * 1024.0 * 1024.0 / fSize);
        [imageData writeToFile:fullPath atomically:NO];
        fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
        if (fSize > 2 * 1024 * 1024) {
            [GYAlertWithOneButtonView alertWithMessage:@"上传附件图片要求小于2M，格式为jpeg、jpg、png、bmp！" topColor:TopColorRed comfirmBlock:^{
                [picker dismissViewControllerAnimated:YES completion:nil];
            }];
            [fm removeItemAtPath:fullPath error:nil];
            return;
        }

    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [GYHSmyhsHttpTool uploadImageWithUrl:upLoadPictureUrl
        params:nil
        imageData:imageData
        imageName:@"realAppply"
        success:^(id responsObject) {
                                     [self.applyView showImage:selectImage];
                                     self.imageFile = responsObject[GYNetWorkDataKey];
        }
        failure:^{
        
        }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy load
- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithArray: @[kLocalized(@"GYHS_Myhs_Company_Information"),kLocalized(@"GYHS_Myhs_Upload_Photo_Information"),kLocalized(@"GYHS_Myhs_Submit_Real")]];
    }
    return _dataArray;
}

@end
