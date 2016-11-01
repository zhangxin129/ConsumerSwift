//
//  GYRealNameAuthConfirmViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYRealNameAuthConfirmViewController.h"
#import "GYImgTap.h"
#import "Animations.h"
#import "CustomIOS7AlertView.h"
#import "GYRegisterAuthViewController.h"
#import "GYHSAccountViewController.h"
#import "GYAlertView.h"
#import "GYRandomCodeView.h"
#import "GYSamplePictureModel.h"
#import "GYSamplePictureManager.h"
#import "GYHSLoginManager.h"
#import "GYGetPhotoView.h"


//确认对话框背景色
#define kConfirmDialogBackgroundColor kCorlorFromRGBA(250, 245, 230, 1)

@interface GYRealNameAuthConfirmViewController ()<GYGetPhotoViewDelegate>

//验证码生成view
@property (weak, nonatomic) IBOutlet GYRandomCodeView* randomCodeView;
//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField* randomCodeTextField;
//看不清换一张 按钮
@property (weak, nonatomic) IBOutlet UIButton* nextRandomCodeBtn;

@property (weak, nonatomic) IBOutlet UILabel* verificationCodeLabel; //验证码

@property (nonatomic, strong)GYGetPhotoView *getView;
@property (nonatomic, strong)UIView *bgView;

@end

@implementation GYRealNameAuthConfirmViewController

    {
    __weak IBOutlet UIView* vCertiificateFront; //证件正面的整体View
    __weak IBOutlet UIView* vCertificateBack; //证件背面的整体View
    __weak IBOutlet UIView* vCertificateWithMan; //手持证件照的整体View
    __weak IBOutlet UIView* vOhterFile; //其他证明材料的整体View

    __weak IBOutlet NSLayoutConstraint* vPicTotalHeighLayout; //整个图片框整体的高度
    __weak IBOutlet NSLayoutConstraint* totalViewHeightLayout; //scrollView的滚动高度

    __weak IBOutlet UIImageView* ivCertificateFront; //imgv 证件正面

    __weak IBOutlet UIImageView* ivCertificateBack; //imgv  证件背面

    __weak IBOutlet UIImageView* ivCertificateWithMan; //imgv 手持证件照

    __weak IBOutlet UILabel* lbPicCommentFront; //lb 证件正面

    __weak IBOutlet UILabel* lbPicCommentBack; //lb证件背面

    __weak IBOutlet UILabel* lbPicCommentWithMan; //lb 手持证件照

    //add by zxm 20160108 预留给重要信息变更的其他证明材料上传

    __weak IBOutlet UIImageView* ivOhterFile;
    __weak IBOutlet UILabel* lbPicCommentOhterFile;

    __weak IBOutlet UIButton* btnSamplePic;
    __weak IBOutlet UIButton* btnSamplePic2;
    __weak IBOutlet UIButton* btnSamplePic3;
    __weak IBOutlet UIButton* btnSamplePic4;

    __weak IBOutlet UILabel* lbCertificateFront; //lb图片上传小于2MB

    __weak IBOutlet UILabel* lbCertificateBack; //lb图片上传小于2MB

    __weak IBOutlet UILabel* lbCertificateWithMan; //lb图片上传小于2MB

    int tagIndex;
    __weak IBOutlet UILabel* lbTips;

    __weak IBOutlet UIScrollView* scrollerView;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = kDefaultVCBackgroundColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalized(@"GYHS_RealName_Change_Next") style:UIBarButtonItemStyleBordered target:self action:@selector(Confirm)];

    self.nextRandomCodeBtn.titleLabel.numberOfLines = 0;

    [self modifyName];
    [self setTextColor];
    [self setDefaultBackground];
    [self setBtn];
    [self addGestureToImgView];

    [self hidenSomePic];
}

- (void)hidenSomePic
{

    if (self.useType == useForAuth) {

        vOhterFile.hidden = YES;
        vPicTotalHeighLayout.constant = 327; //默认高度
        if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
            vCertificateWithMan.hidden = NO; //身份证实名注册上传三张照片
        }
        else {
            vCertificateWithMan.hidden = YES;
            vPicTotalHeighLayout.constant = 327 - 16 - 145; //只有两张图片
        }
    }
    else {
        vOhterFile.hidden = NO;
        vPicTotalHeighLayout.constant = 327; //默认高度
    }

    //设置scrollView的滚动高度
    //    scrollerView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(lbTips.frame) + 10 );
    totalViewHeightLayout.constant = CGRectGetMaxY(lbTips.frame) + 10; //设置scrollView的滚动高度
}

- (void)setUseType:(KuseType)useType
{
    _useType = useType;
    [self hidenSomePic];
}

- (void)setTextColor
{
    lbPicCommentFront.textColor = kCellItemTitleColor;
    lbPicCommentBack.textColor = kCellItemTitleColor;
    lbPicCommentWithMan.textColor = kCellItemTitleColor;
    lbPicCommentOhterFile.textColor = kCellItemTitleColor;
    lbCertificateBack.textColor = kCellItemTextColor;
    lbCertificateFront.textColor = kCellItemTextColor;
    lbCertificateWithMan.textColor = kCellItemTextColor;
    lbTips.textColor = kCellItemTextColor;
}

#pragma mark - 确认
- (void)Confirm
{

    if ([GYUtils checkStringInvalid:_strCreFaceUrl]) {
        [GYAlertView showMessage:kLocalized(@"GYHS_RealName_Please_Select_Picture")];
        return;
    }
    if ([GYUtils checkStringInvalid:_strCreBackUrl]) {
        [GYAlertView showMessage:kLocalized(@"GYHS_RealName_Please_Select_Picture")];
        return;
    }
    if ([GYUtils checkStringInvalid:_strCreHoldUrl]) {
        if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify] || self.useType == useForImportantChange) {
            [GYAlertView showMessage:kLocalized(@"GYHS_RealName_Please_Select_Picture")];
            return;
        }
    }
    if ([GYUtils checkStringInvalid:_strCreOtherFileUrl]) {
        if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify] && self.useType == useForImportantChange) {
            [GYAlertView showMessage:kLocalized(@"GYHS_RealName_Please_Select_Picture")];
            return;
        }
    }

    if ([self.randomCodeTextField.text isEqualToString:@""]) {
        [GYAlertView showMessage:kLocalized(@"GYHS_RealName_Verification_Code_Cannot_Empty")];
        return;
    }

    if (![[self.randomCodeTextField.text lowercaseString] isEqualToString:[self.randomCodeView.currentVerifyCode lowercaseString]]) {
        [GYAlertView showMessage:kLocalized(@"GYHS_RealName_Verification_Code_Error_Please_Enter_Again")];
        [self.randomCodeView refreshVerifyCode];
        return;
    }

    switch (self.useType) {
    case useForAuth: {
        [self loadDataFromNetwork];
    } break;

    case useForImportantChange: {
        [self showAlertview:0];
    } break;
    default:
        break;
    }
}

#pragma mark -  上传实名认证

- (void)loadDataFromNetwork
{
    NSString* urlString = @"";

    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {

        //身份证实名认证
        [self.dictInside setValue:kSaftToNSString(_strCreFaceUrl) forKey:@"cerPica"];
        [self.dictInside setValue:kSaftToNSString(_strCreBackUrl) forKey:@"cerPicb"];
        [self.dictInside setValue:kSaftToNSString(_strCreHoldUrl) forKey:@"cerPich"];
        urlString = kPushAuthRealNameWithIdentifyUrlString;
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {

        //护照实名认证
        [self.dictInside setValue:kSaftToNSString(_strCreFaceUrl) forKey:@"cerPica"];
        [self.dictInside setValue:kSaftToNSString(_strCreBackUrl) forKey:@"cerPich"];
        urlString = kPushAuthRealNameWithPassportUrlString;
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {

        //营业执照实名认证
        [self.dictInside setValue:kSaftToNSString(_strCreFaceUrl) forKey:@"cerPica"];
        [self.dictInside setValue:kSaftToNSString(_strCreBackUrl) forKey:@"cerPich"];
        urlString = kPushAuthRealNameWithBusinessLicenceUrlString;
    }

    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:self.dictInside];
    [GYGIFHUD show];
    GYNetRequest *request =[[GYNetRequest alloc] initWithBlock:urlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject;
        NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
        [notification postNotificationName:@"refreshPersonInfo" object:self];
        [GYAlertView showMessage:dic[@"msg"] confirmBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)sendRequestForImportantChange
{

    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];

    GlobalData* global = globalData;

    [self.dictInside setValue:kSaftToNSString(_strCreFaceUrl) forKey:@"creFacePicNew"];
    [self.dictInside setValue:kSaftToNSString(_strCreBackUrl) forKey:@"creBackPicNew"];
    [self.dictInside setValue:kSaftToNSString(_strCreHoldUrl) forKey:@"creHoldPicNew"];
    [self.dictInside setValue:kSaftToNSString(_strCreOtherFileUrl) forKey:@"residenceAddrPic"];

    [self.changeItem addObject:kLocalized(@"GYHS_RealName_Household_Registration_Changes_Prove")];
    NSString* changeItemstr = [self.changeItem componentsJoinedByString:@" "];

    [dict setValue:kSaftToNSString(changeItemstr) forKey:@"changeItem"];

    [dict addEntriesFromDictionary:self.dictInside];
    [dict setValue:kSaftToNSString(global.loginModel.resNo) forKey:@"perResNo"];
    [dict setValue:kSaftToNSString(global.loginModel.custId) forKey:@"perCustId"];
    [dict setValue:kSaftToNSString(global.loginModel.custName) forKey:@"perCustName"];
    [dict setValue:kSaftToNSString(global.loginModel.mobile) forKey:@"mobile"];

    [dict addEntriesFromDictionary:self.olddictInside];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kPushImportantChangeUrlString parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger  errorRetCode = [error code];
            if ( errorRetCode == 207)
            {
                [GYUtils showMessage:kLocalized(@"GYHS_RealName_User_Is_Important_Information_Changes")];
                return ;
            }
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Important_Information_Changes_Submitted_To_Success") confirm:^{
            GYHSAccountViewController *vc = self.navigationController.viewControllers[0];
            
            [self.navigationController popToViewController:vc animated:YES];
        }];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)showAlertview:(int)index
{

    // 创建控件
    CustomIOS7AlertView* alertView = [[CustomIOS7AlertView alloc] init];

    // 添加自定义控件到 alertView

    if (index == 0) {
        [alertView setContainerView:[self createUI]];
        // 添加按钮
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"GYHS_RealName_Cancel"), kLocalized(@"GYHS_RealName_Confirm"), nil]];
    }
    else {
        [alertView setContainerView:[self succeedTip]];
        // 添加按钮
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"GYHS_RealName_Confirm"), nil]];
    }

    //设置代理
    //    [alertView setDelegate:self];

    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView* alertView, int buttonIndex) {
        DDLogDebug(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        switch (buttonIndex) {
        case 1:
            {
                [self sendRequestForImportantChange];
            }
            break;
        default:
            break;
        }

        [alertView close];
    }];

    [alertView setUseMotionEffects:true];

    // And launch the dialog
    [alertView show];
}

- (UIView*)createUI
{
    UIView* popView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 290, 130)];
    popView.backgroundColor = kConfirmDialogBackgroundColor;

    //开始添加弹出的view中的组件
    UILabel* lbTip = [[UILabel alloc] init];
    lbTip.frame = CGRectMake(290 / 2 - 40, 0, 80, 30);
    lbTip.text = kLocalized(@"GYHS_RealName_Well_Tip");
    lbTip.font = [UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor = [UIColor clearColor];
    UILabel* lbCardNumberTmp = [[UILabel alloc] initWithFrame:CGRectMake(20, lbTip.frame.origin.y + lbTip.frame.size.height + 2, 290 - 40, 60)];
    lbCardNumberTmp.text = kLocalized(@"GYHS_RealName_Important_Information_Change_Request_Submitted_During_Processing_Money_Transfer_Bank_Account_Business_Confirm_To_Submit_Application");
    lbCardNumberTmp.numberOfLines = 0;
    lbCardNumberTmp.textColor = kCellItemTitleColor;
    lbCardNumberTmp.font = [UIFont systemFontOfSize:16.0];
    lbCardNumberTmp.backgroundColor = [UIColor clearColor];
    [popView addSubview:lbTip];
    [popView addSubview:lbCardNumberTmp];

    return popView;
}

- (UIView*)succeedTip
{

    UIView* popView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 290, 50)];
    popView.backgroundColor = kConfirmDialogBackgroundColor;

    UIImageView* imgv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
    imgv.image = [UIImage imageNamed:@"hs_img_succeed"];
    UILabel* lbTip = [[UILabel alloc] init];
    lbTip.frame = CGRectMake(290 / 2 - 80, 0, 180, 30);
    lbTip.text = kLocalized(@"GYHS_RealName_Important_Information_Changes_Submitted_To_Success");
    lbTip.font = [UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor = [UIColor clearColor];

    [popView addSubview:imgv];
    [popView addSubview:lbTip];
    return popView;
}

- (void)addGestureToImgView
{
    GYImgTap* tapForFront = [[GYImgTap alloc] initWithTarget:self action:@selector(popActionSheet:)];
    tapForFront.numberOfTapsRequired = 1;
    tapForFront.tag = 100;
    [ivCertificateFront addGestureRecognizer:tapForFront];

    GYImgTap* tapForBack = [[GYImgTap alloc] initWithTarget:self action:@selector(popActionSheet:)];
    tapForBack.numberOfTapsRequired = 1;
    tapForBack.tag = 101;
    [ivCertificateBack addGestureRecognizer:tapForBack];

    GYImgTap* tapForImgWithMan = [[GYImgTap alloc] initWithTarget:self action:@selector(popActionSheet:)];
    tapForImgWithMan.tag = 102;
    tapForImgWithMan.numberOfTapsRequired = 1;
    [ivCertificateWithMan addGestureRecognizer:tapForImgWithMan];

    GYImgTap* tapForOtherFile = [[GYImgTap alloc] initWithTarget:self action:@selector(popActionSheet:)];
    tapForOtherFile.numberOfTapsRequired = 1;
    tapForOtherFile.tag = 103;
    [ivOhterFile addGestureRecognizer:tapForOtherFile];
}

- (void)popActionSheet:(GYImgTap*)tap;
{
    tagIndex = tap.tag;
   
    [self pickPhotoButtonClick];
}

#pragma mark Click Event
- (void)pickPhotoButtonClick
{
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    
    self.getView = [[[NSBundle mainBundle] loadNibNamed:@"GYGetPhotoView" owner:self options:nil] firstObject];
    self.getView.frame = CGRectMake(15, kScreenHeight - 155, kScreenWidth-30, 155);
    self.getView.delegate = self;
    [self.bgView addSubview:self.getView];
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self.bgView];
}

#pragma mark-GYGetPhotoViewDelegate
-(void)takePhotoBtnClickDelegate
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

- (void)cancelBtnClickDelegate{
    [self.getView removeFromSuperview];
    [self.bgView removeFromSuperview];
}

- (void)setBtn
{
    [btnSamplePic setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSamplePic2 setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSamplePic3 setTitleColor:kNavigationBarColor forState:UIControlStateNormal];

    [self setBtn:btnSamplePic WithColor:kNavigationBarColor WithWidth:1 WithIndex:1];
    [self setBtn:btnSamplePic2 WithColor:kNavigationBarColor WithWidth:1 WithIndex:2];
    [self setBtn:btnSamplePic3 WithColor:kNavigationBarColor WithWidth:1 WithIndex:3];
}

//进入相册
- (void)photoalbumr
{

    if ([UIImagePickerController isSourceTypeAvailable:

                                     UIImagePickerControllerSourceTypePhotoLibrary]) {

        UIImagePickerController* picker =

            [[UIImagePickerController alloc] init];

        picker.delegate = self;

        //        picker.allowsEditing = YES;

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
    //    while (fSize>2 * 1024 * 1024) {
    //        [fm removeItemAtPath:fullPath error:nil];
    //        data = UIImageJPEGRepresentation(image, 0.8);
    //         //获取沙盒目录
    //        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    //                // 将图片写入文件
    //        [data writeToFile:fullPath atomically:NO];
    //        if ([fm fileExistsAtPath:fullPath]) {
    //            fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
    //        }
    //    }

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

    switch (tagIndex) {

    case 100:

    {
#if 0
        //上传图片获取URL

        GYUploadImage *uploadPic = [[GYUploadImage alloc] init];
        uploadPic.fatherView = self.view;
        [uploadPic uploadImg:image WithParam:nil];
        uploadPic.delegate = self;
        uploadPic.urlType = 2;
        uploadPic.index = 0;
#endif
        [self uploadPicWithImage:image isPub:YES imageIndex:0];

        [self saveImage:image withName:@"AuthimgCertificationFront.png"];

        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationFront.png"];

        UIImage* savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];

        ivCertificateFront.image = savedImage;

    } break;

    case 101:

    {
#if 0
        //上传图片获取URL

        GYUploadImage *uploadPic = [[GYUploadImage alloc] init];
        uploadPic.fatherView = self.view;
        uploadPic.delegate = self;
        uploadPic.index = 1;
        uploadPic.urlType = 2;
        [uploadPic uploadImg:image WithParam:nil];
#endif

        [self uploadPicWithImage:image isPub:YES imageIndex:1];
        [self saveImage:image withName:@"AuthimgCertificationback.png"];

        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationback.png"];

        UIImage* savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];

        ivCertificateBack.image = savedImage;
    }

    break;

    case 102:

    {
#if 0
        //上传图片获取URL

        GYUploadImage *uploadPic = [[GYUploadImage alloc] init];
        uploadPic.fatherView = self.view;
        [uploadPic uploadImg:image WithParam:nil];
        uploadPic.delegate = self;
        uploadPic.urlType = 2;
        uploadPic.index = 2;
#endif
        [self uploadPicWithImage:image isPub:YES imageIndex:2];

        [self saveImage:image withName:@"AuthimgCertificationWithMan.png"];

        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationWithMan.png"];

        DDLogDebug(@"%@", fullPath);

        UIImage* savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];

        ivCertificateWithMan.image = savedImage;
    }

    break;
    case 103:

    {
#if 0
        //上传图片获取URL

        GYUploadImage *uploadPic = [[GYUploadImage alloc] init];
        uploadPic.fatherView = self.view;
        [uploadPic uploadImg:image WithParam:nil];
        uploadPic.delegate = self;
        uploadPic.urlType = 2;
        uploadPic.index = 2;
#endif

        [self uploadPicWithImage:image isPub:YES imageIndex:3];

        [self saveImage:image withName:@"AuthimgOtherFile.png"];

        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgOtherFile.png"];

        DDLogDebug(@"%@", fullPath);

        UIImage* savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];

        ivOhterFile.image = savedImage;

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

- (void)setBtn:(UIButton*)sender WithColor:(UIColor*)color WithWidth:(CGFloat)width WithIndex:(NSInteger)buttonTag
{
    sender.layer.cornerRadius = 2.0f;
    sender.layer.borderWidth = width;
    sender.tag = buttonTag;
    sender.layer.borderColor = color.CGColor;
    sender.layer.masksToBounds = YES;
}

- (void)modifyName
{
    lbPicCommentFront.text = kLocalized(@"GYHS_RealName_Id_Card_Positive");
    lbPicCommentBack.text = kLocalized(@"GYHS_RealName_Id_Card_Back");
    lbPicCommentWithMan.text = kLocalized(@"GYHS_RealName_With_Id_Card_Front_Bust");
    lbPicCommentOhterFile.text = kLocalized(@"GYHS_RealName_Household_Registration_Changes_Prove");
    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {

        lbPicCommentFront.text = kLocalized(@"GYHS_RealName_Front_Of_Papers");
        lbPicCommentBack.text = kLocalized(@"GYHS_RealName_Back_Of_Papers");
        lbPicCommentWithMan.text = kLocalized(@"GYHS_RealName_Holding_Papers_Photos");
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {

        lbPicCommentFront.text = kLocalized(@"GYHS_RealName_Passport_Documents_As");
        lbPicCommentBack.text = kLocalized(@"GYHS_RealName_Holding_Papers_Photos");
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {

        lbPicCommentFront.text = kLocalized(@"GYHS_RealName_Business_License_Certificate");
        lbPicCommentBack.text = kLocalized(@"GYHS_RealName_Holding_Papers_Photos");
    }

    [btnSamplePic setTitle:kLocalized(@"GYHS_RealName_Column_Picture") forState:UIControlStateNormal];
    [btnSamplePic2 setTitle:kLocalized(@"GYHS_RealName_Column_Picture") forState:UIControlStateNormal];
    [btnSamplePic3 setTitle:kLocalized(@"GYHS_RealName_Column_Picture") forState:UIControlStateNormal];
    //[btnSamplePic4 setTitle:kLocalized(@"HS_ColumnPicture") forState:UIControlStateNormal];
    lbTips.text = kLocalized(@"GYHS_RealName_Upload_Attachments_Images_Is_Less_Than_2M_Format_For_PNG_JPG_Jpeg_BMP");
    self.randomCodeTextField.placeholder = kLocalized(@"GYHS_RealName_Input_Validation_Code");
    self.verificationCodeLabel.text = kLocalized(@"GYHS_RealName_Verification_Code");
    [self.nextRandomCodeBtn setTitle:kLocalized(@"GYHS_RealName_Canot_See_The_Purging") forState:UIControlStateNormal];


}

- (void)setDefaultBackground
{
    ivCertificateBack.image = [UIImage imageNamed:@"hs_img_btn_bg.png"];
    ivCertificateFront.image = [UIImage imageNamed:@"hs_img_btn_bg.png"];
    ivCertificateWithMan.image = [UIImage imageNamed:@"hs_img_btn_bg.png"];
    ivOhterFile.image = [UIImage imageNamed:@"hs_img_btn_bg.png"];
}

- (IBAction)btnSamplePicA:(id)sender
{

    UIImageView* imgv;
    UIView* backgroundView;
    if (imgv == nil) {
        imgv = [[UIImageView alloc] init];
    }
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }

    imgv.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 100);
    imgv.bounds = CGRectMake(0, 0, 140 + 140 * 0.9, 90 + 90 * 0.9);

    NSString* imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1001"].fileId;

    if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {

        imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1027"].fileId;
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {

        imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1010"].fileId;
    }
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

- (IBAction)btnSamplePicB:(id)sender
{
    UIImageView* imgv;
    UIView* backgroundView;
    if (imgv == nil) {
        imgv = [[UIImageView alloc] init];
    }
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }

    imgv.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 100);
    imgv.bounds = CGRectMake(0, 0, 140 + 140 * 0.9, 90 + 90 * 0.9);

    NSString* imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1002"].fileId;
    if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {

        imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1022"].fileId;
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {

        imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1023"].fileId;
    }

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

- (IBAction)btnSamplePicC:(id)sender
{
    UIImageView* imgv;
    UIView* backgroundView;
    if (imgv == nil) {
        imgv = [[UIImageView alloc] init];
    }
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }

    imgv.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 100);
    imgv.bounds = CGRectMake(0, 0, 140 + 140 * 0.9, 90 + 90 * 0.9);
    NSString* imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1005"].fileId;
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

- (IBAction)btnSamplePicD:(id)sender
{
    DDLogDebug(@"%s", __FUNCTION__);
}

- (void)hidenView:(UITapGestureRecognizer*)tap
{
    [UIView animateWithDuration:0.24 animations:^{
        tap.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
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

#pragma mark 上传图片失败
- (void)didFailUploadImg:(NSError*)error withTag:(int)index
{
    [GYUtils showMessage:kLocalized(@"GYHS_RealName_Upload_Pictures_Failed")];
    
}

- (IBAction)nextRandomCodeBtn:(id)sender
{
    [self.randomCodeView refreshVerifyCode];
}

- (void)uploadPicWithImage:(UIImage*)image isPub:(BOOL)isPub imageIndex:(NSInteger)imageIndex
{

    //add by zxm 20160106 重构上传图片接口
    NSString* uploadUrlString = [NSString stringWithFormat:@"%@?isPub=%@", kUploadFileUrlString, isPub ? @"1" : @"0"]; //公开
    if (globalData.loginModel.custId.length) {

        uploadUrlString = [NSString stringWithFormat:@"%@&custId=%@", uploadUrlString, globalData.loginModel.custId]; //custId
    }
    if (globalData.loginModel.token.length) {

        uploadUrlString = [NSString stringWithFormat:@"%@&token=%@", uploadUrlString, globalData.loginModel.token]; //token
    }

    __block NSInteger index = imageIndex;

    UIImage* uploadImage = image;

#if 0 //test

    if (index == 0) {
        uploadImage = [UIImage imageNamed:@"001"];
    }
    else if (index == 1) {
        uploadImage = [UIImage imageNamed:@"002"];
    }
    else if (index == 2) {
        uploadImage = [UIImage imageNamed:@"003"];
    }

#endif

    [GYGIFHUD show];
    [Network Post:uploadUrlString parameters:nil image:uploadImage completion:^(NSDictionary *responseObject, NSError *error) {
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
            [GYAlertView showMessage:kLocalized(@"GYHS_RealName_Upload_Pictures_Failed")];
        }
    }];
}

@end
