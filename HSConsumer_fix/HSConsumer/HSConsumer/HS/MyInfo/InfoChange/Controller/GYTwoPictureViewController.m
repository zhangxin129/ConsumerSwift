//
//  GYTwoPictureViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYTwoPictureViewController.h"
#import "GYImgTap.h"
#import "Animations.h"
#import "CustomIOS7AlertView.h"
#import "GYHSAccountViewController.h"
#import "GYRandomCodeView.h"
#import "GYRegisterAuthViewController.h"
#import "GYAlertView.h"
#import "GYSamplePictureManager.h"
#import "GYHSLoginManager.h"
#import "GYGetPhotoView.h"

//确认对话框背景色
#define kConfirmDialogBackgroundColor kCorlorFromRGBA(250, 245, 230, 1)

@interface GYTwoPictureViewController ()<GYGetPhotoViewDelegate,GYNetRequestDelegate>
//验证码生成view
@property (weak, nonatomic) IBOutlet GYRandomCodeView* randomCodeView;
//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField* randomCodeTextField;
//看不清换一张 按钮
@property (weak, nonatomic) IBOutlet UIButton* nextRandomCodeBtn;

@property (weak, nonatomic) IBOutlet UILabel* verificationCodeLabel; //验证码

@property (nonatomic, strong)GYGetPhotoView *getView;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, assign)NSInteger imageIndex;
@end

@implementation GYTwoPictureViewController {

    __weak IBOutlet UILabel* lbTips;

    __weak IBOutlet UIView* vUpBackground;

    __weak IBOutlet UIImageView* imgvPictureA;

    __weak IBOutlet UILabel* lbPictureA;

    __weak IBOutlet UIButton* btnSampleA;

    __weak IBOutlet UIImageView* imgvPictureB;

    __weak IBOutlet UIButton* btnPictureB;

    __weak IBOutlet UILabel* lbPictureB;

    int tagIndex;

    UIImageView* imgv;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = kDefaultVCBackgroundColor;
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //设置边框
    [vUpBackground addAllBorder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nextRandomCodeBtn.titleLabel.numberOfLines = 0;
    if ([globalData.loginModel.creType isEqualToString:@"2"]) {
        lbPictureA.text = kLocalized(@"GYHS_MyInfo_Passport_Documents_As");
        lbPictureB.text = kLocalized(@"GYHS_MyInfo_Holding_Papers_Photos");
    }
    else if ([globalData.loginModel.creType isEqualToString:@"3"]) {
        lbPictureB.text = kLocalized(@"GYHS_MyInfo_Holding_Papers_Photos");
        lbPictureA.text = kLocalized(@"GYHS_MyInfo_The_Business_License_Certificate");
    }

    [self modifyName];
    vUpBackground.backgroundColor = [UIColor whiteColor];
    UIButton* btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 40, 40);
    [btnRight setTitle:kLocalized(@"GYHS_MyInfo_Change_Next") forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];

    [self addGestureToImgView];
}

- (void)submit
{
    switch (self.useType) {
    case useForAuth: {
    } break;

    case useForImportantChange: {
        [self showAlertview:0];
    } break;
    default:
        break;
    }
}

- (void)showAlertview:(int)index
{
    if ([GYUtils checkStringInvalid:_strCreFaceUrl] || [GYUtils checkStringInvalid:_strcreHoldPic]) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Please_Select_Picture")];
        return;
    }
    if ([self.randomCodeTextField.text isEqualToString:@""]) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Verification_Code_Cannot_Empty")];
        return;
    }
    if (![[self.randomCodeTextField.text lowercaseString] isEqualToString:[self.randomCodeView.currentVerifyCode lowercaseString]]) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Verification_CodeError_Please_Enter_Again")];
        [self.randomCodeView refreshVerifyCode];
        return;
    }

    // 创建控件
    CustomIOS7AlertView* alertView = [[CustomIOS7AlertView alloc] init];

    // 添加自定义控件到 alertView

    if (index == 0) {
        [alertView setContainerView:[self createUI]];
        // 添加按钮
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"GYHS_MyInfo_Cancel"), kLocalized(@"GYHS_MyInfo_Confirm"), nil]];
    }
    else {
        [alertView setContainerView:[self succeedTip]];
        // 添加按钮
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"GYHS_MyInfo_Confirm"), nil]];
    }
    //设置代理
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

- (UIView*)succeedTip
{

    UIView* popView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 290, 50)];
    popView.backgroundColor = kConfirmDialogBackgroundColor;

    UIImageView* imgvTip = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
    imgvTip.image = [UIImage imageNamed:@"hs_img_succeed"];
    UILabel* lbTip = [[UILabel alloc] init];
    lbTip.frame = CGRectMake(290 / 2 - 80, 0, 180, 30);
    lbTip.text = kLocalized(@"GYHS_MyInfo_Important_Information_Changes_Submitted_Success");
    lbTip.font = [UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor = [UIColor clearColor];

    [popView addSubview:imgvTip];
    [popView addSubview:lbTip];
    return popView;
}

- (UIView*)createUI
{
    UIView* popView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 290, 130)];
    popView.backgroundColor = kConfirmDialogBackgroundColor;

    //开始添加弹出的view中的组件
    UILabel* lbTip = [[UILabel alloc] init];
    lbTip.frame = CGRectMake(290 / 2 - 40, 0, 80, 30);
    lbTip.text = kLocalized(@"GYHS_MyInfo_Well_Tip");
    lbTip.font = [UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor = [UIColor clearColor];
    UILabel* lbCardNumberTmp = [[UILabel alloc] initWithFrame:CGRectMake(20, lbTip.frame.origin.y + lbTip.frame.size.height + 2, 290 - 40, 60)];
    lbCardNumberTmp.text = kLocalized(@"GYHS_MyInfo_Important_Information_Change_Request_Submitted_During_Processing_Money_Transfer_Bank_Account_Business_Confirm_To_Submit_Application");
    lbCardNumberTmp.numberOfLines = 0;
    lbCardNumberTmp.textColor = kCellItemTitleColor;
    lbCardNumberTmp.font = [UIFont systemFontOfSize:16.0];
    lbCardNumberTmp.backgroundColor = [UIColor clearColor];
    [popView addSubview:lbTip];
    [popView addSubview:lbCardNumberTmp];

    return popView;
}

- (void)modifyName
{
    [btnSampleA setTitle:kLocalized(@"GYHS_MyInfo_Column_Picture") forState:UIControlStateNormal];
    [btnPictureB setTitle:kLocalized(@"GYHS_MyInfo_Column_Picture") forState:UIControlStateNormal];

    lbTips.text = kLocalized(@"GYHS_MyInfo_Warm_Prompt_Upload_Attachments_Pictures_Less_Than_2M_Format_Of_JPG_Jpeg_BMP");
    self.randomCodeTextField.placeholder = kLocalized(@"GYHS_MyInfo_Input_Validation_Code");
    [self.nextRandomCodeBtn setTitle:kLocalized(@"GYHS_MyInfo_Canot_See_The_Purging") forState:UIControlStateNormal];
    self.verificationCodeLabel.text = kLocalized(@"GYHS_MyInfo_Verification_Code");

    imgvPictureA.image = [UIImage imageNamed:@"hs_img_btn_bg.png"];
    imgvPictureB.image = [UIImage imageNamed:@"hs_img_btn_bg.png"];
    [btnPictureB setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSampleA setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    lbPictureA.textColor = kCellItemTitleColor;
    lbPictureB.textColor = kCellItemTitleColor;
    lbTips.textColor = kCellItemTextColor;
}

///重要信息变更的请求方法
- (void)sendRequestForImportantChange
{

    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [self.mdictParams setValue:kSaftToNSString(_strCreFaceUrl) forKey:@"creFacePicNew"];
    [self.mdictParams setValue:kSaftToNSString(_strcreHoldPic) forKey:@"creHoldPicNew"];
    NSString* changeItem = [self.changeItem componentsJoinedByString:@","];

    [dict setValue:kSaftToNSString(changeItem) forKey:@"changeItem"];
    [dict setValue:kSaftToNSString(globalData.loginModel.mobile) forKey:@"mobile"];
    [dict setValue:kSaftToNSString(globalData.loginModel.resNo) forKey:@"perResNo"];
    [dict setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"perCustId"];
    [dict setValue:kSaftToNSString(globalData.loginModel.custName) forKey:@"perCustName"];
    [dict addEntriesFromDictionary:self.mdictParams];
    [dict addEntriesFromDictionary:self.oldmdictParams];

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kPushImportantChangeUrlString parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
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
            GYHSAccountViewController *vc = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:vc animated:YES];
        }];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}


- (void)addGestureToImgView
{
    GYImgTap* tapForFront = [[GYImgTap alloc] initWithTarget:self action:@selector(popActionSheet:)];
    tapForFront.numberOfTapsRequired = 1;
    tapForFront.tag = 100;
    [imgvPictureA addGestureRecognizer:tapForFront];
    GYImgTap* tapForBack = [[GYImgTap alloc] initWithTarget:self action:@selector(popActionSheet:)];
    tapForBack.numberOfTapsRequired = 1;
    tapForBack.tag = 101;
    [imgvPictureB addGestureRecognizer:tapForBack];
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

        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Access_Album_Failed")];
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
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Device_No_Support_Camera")];
    }
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

    NSData* data = UIImagePNGRepresentation(image);

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
    }

    if (tagIndex == 100) {
        [self saveImage:image withName:@"AuthimgCertificationFront.png"];

        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationFront.png"];
        UIImage* savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        imgvPictureA.image = savedImage;

        [self uploadPicWithImage:image isPub:YES imageIndex:0];
    }
    else {
        [self saveImage:image withName:@"AuthimgCertificationback.png"];
        NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AuthimgCertificationback.png"];
        UIImage* savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        imgvPictureB.image = savedImage;

        [self uploadPicWithImage:image isPub:YES imageIndex:1];
    }
}

//保存图片至沙盒

#pragma mark - save
- (void)saveImage:(UIImage*)currentImage withName:(NSString*)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(currentImage, 0.6);

    // 获取沙盒目录
    NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark 上传图片失败
- (void)didFailUploadImg:(NSError*)error withTag:(int)index
{
    [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Upload_Pictures_Faild")];
   
}

- (IBAction)btnSamplePictureA:(id)sender
{

    UIView* backgroundView;
    if (imgv == nil) {
        imgv = [[UIImageView alloc] init];
    }
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }

    [self setSamplePicture:globalData.loginModel.creType withTag:1];
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

- (IBAction)btnSamplePictureB:(id)sender
{
    UIView* backgroundView;
    if (imgv == nil) {
        imgv = [[UIImageView alloc] init];
    }
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }

    [self setSamplePicture:globalData.loginModel.creType withTag:2];
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

- (void)setSamplePicture:(NSString*)picType withTag:(int)index
{
    NSString* imageName;

    if ([picType isEqualToString:kCertypePassport]) {

        switch (index) {

        case 1: {
            imgv.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 50);
            imgv.bounds = CGRectMake(0, 0, 245 * 0.9, 340 * 0.9);
            imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1027"].fileId;
            [imgv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, imageName, globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];

        } break;
        case 2: {
            imgv.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 100);
            imgv.bounds = CGRectMake(0, 0, 140 + 140 * 0.9, 90 + 90 * 0.9);
            imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1022"].fileId;
            [imgv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, imageName, globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];

        } break;
        default:
            break;
        }
    }
    else if ([picType isEqualToString:kCertypeBusinessLicence]) {
        switch (index) {
        case 1: {
            imgv.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 100);
            imgv.bounds = CGRectMake(0, 0, 160 + 140 * 0.9, 110 + 110 * 0.9);
            imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1010"].fileId;
            [imgv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, imageName, globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];

        } break;
        case 2: {
            imgv.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 100);
            imgv.bounds = CGRectMake(0, 0, 300, 216);
            imageName = [[GYSamplePictureManager shareInstance] selectDecCode:@"1023"].fileId;
            [imgv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, imageName, globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];

        } break;
        default:
            break;
        }
    }
}

- (IBAction)nextRandomCodeBtn:(id)sender
{
    [self.randomCodeView refreshVerifyCode];
}

- (void)uploadPicWithImage:(UIImage*)image isPub:(BOOL)isPub imageIndex:(NSInteger)imageIndex
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:@"1" forKey:@"isPub"];
    [params setValue:globalData.loginModel.custId forKey:@"custId"];
    [params setValue:globalData.loginModel.token forKey:@"token"];
    //add by zxm 20160106 重构上传图片接口
    NSString* uploadUrlString = [NSString stringWithFormat:@"%@?isPub=%@", kUploadFileUrlString, isPub ? @"1" : @"0"]; //公开
    if (globalData.loginModel.custId.length) {

        uploadUrlString = [NSString stringWithFormat:@"%@&custId=%@", uploadUrlString, globalData.loginModel.custId]; //custId
    }
    if (globalData.loginModel.token.length) {

        uploadUrlString = [NSString stringWithFormat:@"%@&token=%@", uploadUrlString, globalData.loginModel.token]; //token
    }

    __block NSInteger index = imageIndex;
    self.imageIndex = index;
    UIImage* uploadImage = image;

    GYNetRequest * request = [[GYNetRequest alloc] initWithUploadDelegate:self baseURL:[GYHSLoginEn sharedInstance].getLoginUrl URLString:uploadUrlString parameters:params constructingBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if ((float)data.length > 1024 * 100) {
            data = UIImageJPEGRepresentation(image, 1024*100.0/(float)data.length);
        }
        [formData appendPartWithFileData:data name:@"1" fileName:@"1.jpeg" mimeType:@"image/jpeg"];
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}
#pragma mark -- GYNetRequestDelegate
-(void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject
{
    [GYGIFHUD dismiss];
    NSString *urlOnServer = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
    if (self.imageIndex == 0) {
        _strCreFaceUrl = urlOnServer;
        
    } else if (self.imageIndex == 1) {
        _strcreHoldPic = urlOnServer;
    }
}
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
   
    [GYUtils parseNetWork:error resultBlock:^(NSInteger retCode) {
    }];
}

@end
