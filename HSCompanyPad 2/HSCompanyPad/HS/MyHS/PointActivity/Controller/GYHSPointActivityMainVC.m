//
//  GYHSPointActivityMainVC.m
//
//  Created by apple on 16/8/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointActivityMainVC.h"
#import "GYHSMemberApplyView.h"
#import "GYHSMemberProgressView.h"
#import "GYHSMemberTipView.h"
#import "GYHSPublicMethod.h"
#import "GYHSRejectView.h"
#import "GYHSmyhsHttpTool.h"
#import "GYNetApiMacro.h"
#import <GYKit/GYPlaceholderTextView.h>

#import <MJExtension/MJExtension.h>
#import "GYHSDocModel.h"
#import "GYWebViewController.h"
#import <GYKit/UIButton+GYExtension.h>
#import "GYPhotoPickerViewController.h"
#define kProgressViewWidth 233
#define kBottomHeight kDeviceProportion(70)
#define kDistance 20
@interface GYHSPointActivityMainVC () <GYHSMemberApplyDelegate, UIImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GYNetworkReloadDelete,GYPhotoPickerViewControllerDelegate>
@property (nonatomic, strong) UIButton* comfirmButton;
@property (nonatomic, weak) GYHSMemberProgressView* progressView;
@property (nonatomic, weak) UIScrollView* scroll;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) UIView* bottomBackView;
@property (nonatomic, weak) GYHSRejectView* rejectView;
@property (nonatomic, weak) GYHSMemberApplyView* applyView;
@property (nonatomic, copy) NSString* imageFile;

@end

@implementation GYHSPointActivityMainVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

#pragma mark - private methods
- (void)initView
{
    self.title = self.isJoinAction ? kLocalized(@"GYHS_Myhs_Join_Point_Action") : kLocalized(@"GYHS_Myhs_Quit_Point_Action");
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
    [comfirmButton setTitle:kLocalized(@"GYHS_Myhs_Again_Apply") forState:UIControlStateNormal];
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

- (void)dealloc
{
    [kDefaultNotificationCenter removeObserver:self];
}

#pragma request
- (void)requestData
{
    [GYNetwork sharedInstance].delegate = self;
    @weakify(self);
    [GYHSmyhsHttpTool GetEntStatus:^(id responsObject) {
        @strongify(self);
        globalData.companyStatus = [companyStatuModel mj_objectWithKeyValues:responsObject];
        if (!globalData.companyStatus.pointStatus) {
            [self setStepView];
        } else {
            if (globalData.companyStatus.pointStatus.status == companyPointActStatu_SCApprovalDeny || globalData.companyStatus.pointStatus.status == companyPointActStatu_LApprovalDeny || globalData.companyStatus.pointStatus.status == companyPointActStatu_LSecApprovalDeny) {
                [self rejectApplyView];
            } else if (globalData.companyStatus.pointStatus.status == companyPointActStatu_LSecApproval) {
                [self setStepView];
            } else {
                [self setMarkView];
            }
        }
    }
        failure:^{
        
        }];
}

#pragma mark - GYNetworkReloadDelete
- (void)gyNetworkDidTapReloadBtn
{
    [self requestData];
}

- (void)rejectApplyView
{
    self.bottomBackView.hidden = NO;
    if (_rejectView == nil) {
        GYHSRejectView* rejectView = [[GYHSRejectView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, self.view.width, self.view.height - kBottomHeight - kMainHeadHeight - kNavigationHeight)];
        [self.view addSubview:rejectView];
        self.rejectView = rejectView;
    }
    self.rejectView.rejectStr = [GYHSPublicMethod explainStatus:globalData.companyStatus.pointStatus.statusS];
    self.rejectView.opinionStr = globalData.companyStatus.pointStatus.apprRemark;
    self.rejectView.timeStr = globalData.companyStatus.pointStatus.apprDate;
}

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
    
    //申请提示信息
    GYHSMemberTipView* tipView = [[GYHSMemberTipView alloc] initWithFrame:CGRectMake(0, kDistance, self.scroll.width - kDistance, self.scroll.height - 2 * kDistance) tipType:self.isJoinAction ? kMyhsTipJoinPointActivity : kMyhsTipStopPointActivity];
    [self.scroll addSubview:tipView];
    
    //申请上传证书
    GYHSMemberApplyView* applyView = [[GYHSMemberApplyView alloc] initWithFrame:CGRectMake(self.scroll.width, kDistance, self.scroll.width - kDistance, self.scroll.height - 2 * kDistance)];
    applyView.delegate = self;
    [self.scroll addSubview:applyView];
    self.applyView = applyView;
}

- (void)setMarkView
{
    self.bottomBackView.hidden = YES;
    UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(251, 105, self.view.width - 251 * 2, 30)];
    tipLabel.text = [NSString stringWithFormat:@"%@%@%@", kLocalized(@"GYHS_Myhs_Member_Apply1"), globalData.companyStatus.pointStatus.apprDate, self.isJoinAction ? kLocalized(@"GYHS_Myhs_Join_Point_Apply2") : kLocalized(@"GYHS_Myhs_Quit_Point_Apply2")];
    tipLabel.font = kFont32;
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = kGray333333;
    CGSize tipSize = [tipLabel.text boundingRectWithSize:CGSizeMake(tipLabel.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont32, NSFontAttributeName, nil] context:nil].size;
    tipLabel.size = tipSize;
    [self.view addSubview:tipLabel];
}

- (void)comfirmButtonAction
{
    self.rejectView.hidden = YES;
    if (![self isDataAllright]) {
        return;
    }
    if (!self.progressView.index) {
        [self setStepView];
        return;
    }
    [self setBtnTitle];
    if (self.progressView.index == 2) {
        NSString* tipMessage = self.isJoinAction ? kLocalized(@"GYHS_Myhs_Join_Point_Tip") : kLocalized(@"GYHS_Myhs_Quit_Point_Tip");
        [GYAlertWithOneButtonView alertWithMessage:tipMessage
                                          topColor:self.isJoinAction ? TopColorBlue : TopColorRed
                                      comfirmBlock:^{
                                          //积分活动申请
                                          [self requestActivity];
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
        if ([self.applyView.textView.text isEqualToString:@""] || self.applyView.textView.text.length == 0) {
            [GYUtils showToast:kLocalized(@"GYHS_Myhs_Reason_Tip")];
            return NO;
        }
        if (self.applyView.textView.text.length > 300) {
            [GYUtils showToast:kLocalized(@"GYHS_Myhs_Reason_Max_Tip")];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 积分活动申请
- (void)requestActivity
{
    NSNumber* applyType = self.isJoinAction ? @1 : @0; //1、参与积分活动，2、停止积分活动
    [GYHSmyhsHttpTool createPointActivityApplyReason:self.applyView.textView.text
        oldStatus:@1
        applyType:applyType
        bizApplyFile:self.imageFile
        success:^(id responsObject) {
                                                 if (kHTTPSuccessResponse(responsObject)) {
                                                     NSString* tipMessage = self.isJoinAction ? kLocalized(@"GYHS_Myhs_Join_Point_Action_Success") : kLocalized(@"GYHS_Myhs_Quit_Point_Action_Success");
                                                     
                                                     [GYAlertWithOneButtonView alertWithMessage:tipMessage
                                                                                       topColor:TopColorBlue
                                                                                   comfirmBlock:^{
                                                         [kDefaultNotificationCenter postNotification:[NSNotification notificationWithName:GYChangeBankCardOrChageMainHSNotification object:nil]];                          [self.navigationController popViewControllerAnimated:YES];
                                                         
                                                         
                                                                                   }];
                                                 }
        }
        failure:^{
        
        }];
}

#pragma mark - GYHSMemberApplyDelegate
- (void)actionSheetWithIndex:(NSInteger)index
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
    [self actionSheetWithIndex:1];
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
                               imageName:@"pointAppply"
                                 success:^(id responsObject) {
                                     [self.applyView showImage:selectImage];
                                     self.imageFile = responsObject[GYNetWorkDataKey];
                                 }
                                 failure:^{
                                     
                                 }];

}

- (void)applyViewDidClickDownLoadButton:(UIButton*)downLoadButton
{
    [downLoadButton controlTimeOut];
    [GYHSmyhsHttpTool queryImageDocListWithSuccess:^(id responsObject) {
        NSArray *array = responsObject;
        [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GYHSDocModel *model = [GYHSDocModel mj_objectWithKeyValues:obj];
            GYHSExampleDoc doc = self.isJoinAction?GYHSExampleDocJoinActivity:GYHSExampleDocStopActivity;
            if (model.docIdentify == doc) {
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
                     });}
                     
                 }];
            }
        }];
        
    } failure:^{
    
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
        imageName:@"pointAppply"
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

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithArray: @[kLocalized(@"GYHS_Myhs_Apply_Information"),kLocalized(@"GYHS_Myhs_Upload_Apply"),kLocalized(@"GYHS_Myhs_Submit_Apply")]];
    }
    return _dataArray;
}

@end
