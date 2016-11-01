//
//  GYAccidtMedicalViewController.m
//  HSConsumer
//
//  Created by apple on 16/1/6.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAccidtMedicalViewController.h"
#import "GYHealthUploadImgCollectionViewCell.h"
#import "GYAccidtFootView.h"
#import "GYAccidtHeadView.h"
#import "GYBigPic.h"
#import "GYHSMedicalInstructionViewController.h"
#import "UIActionSheet+Blocks.h"
#import "GYSamplePictureManager.h"
#import "GYHSLoginManager.h"
#import "GYGetPhotoView.h"
#import "GYHSScoreWealImageShowViewController.h"
#import "GYHSTools.h"

@interface GYHSAccidtMedicalViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, GYGetPhotoViewDelegate,GYNetRequestDelegate> {
    GYBigPic* bigPic;
}
@property (nonatomic, strong) UICollectionView* cvAccMedical;
@property (nonatomic, weak) GYAccidtHeadView* afvHead;

@property (nonatomic, strong) NSMutableArray* arrImg;

@property (nonatomic, strong) NSMutableArray* arrTitleKey, *arrTitle, *isNeedKey;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableDictionary* tempDic, *urlDic;

@property (nonatomic, strong) NSIndexPath* sscIndexPath;

@property (nonatomic, strong) GYGetPhotoView* getView;
@property (nonatomic, strong) UIView* bgView;

@end

@implementation GYHSAccidtMedicalViewController
#pragma mark -- The life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    bigPic = [[GYBigPic alloc] init];

    [self initUI];
    [self initData];
}

#pragma mark - 初始化数据
- (void)initData
{

    NSMutableArray* arr = [NSMutableArray arrayWithObjects:
                                              kLocalized(@"GYHS_BP_*PointsCardPositive"),
                                          kLocalized(@"GYHS_BP_*PointsCardBack"),
                                          kLocalized(@"GYHS_BP_*IdCardPositive"),
                                          kLocalized(@"GYHS_BP_*IdCardBack"),
                                          kLocalized(@"GYHS_BP_Own_Social_Security_Card_Copy"),
                                          kLocalized(@"GYHS_BP_*Photocopy_Of_Original_FeeReceipt"),
                                          kLocalized(@"GYHS_BP_*Cost_ListCopy"),
                                          kLocalized(@"GYHS_BP_*Diagnosis_Certificate_Copy"),
                                          kLocalized(@"*住院病历复印件(一份)"),
                                          kLocalized(@"GYHS_BP_*Medical_Certificate"),
                                          kLocalized(@"GYHS_BP_Health_Center_Accept_Return_ReceiptCopy"),
                                          kLocalized(@"GYHS_BP_Medical_Expenses_Calculation_SheetCopy"),
                                          kLocalized(@"GYHS_BP_Other_Attachments_Upload"),
                                          kLocalized(@"GYHS_BP_Continue_Add_Attachments"), nil];
    self.arrTitle = [self getgetRedSnowArray:arr];

    NSArray* img = @[ @"hs_card_face.jpg",
        @"hs_card_back.jpg",
        @"hs_ID_card_face.jpg",
        @"hs_ID_card_back.jpg",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"" ];
    [self.arrImg addObjectsFromArray:img];
}

#pragma mark - 私有方法

- (NSMutableArray*)getgetRedSnowArray:(NSMutableArray*)arr
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSString* str in arr) {
        NSMutableAttributedString* s = [self getRedSnowString:str];
        [array addObject:s];
    }
    NSMutableArray* arrLast = [NSMutableArray arrayWithArray:array];
    return arrLast;
}

/**将首为*的字符变红*/
- (NSMutableAttributedString*)getRedSnowString:(NSString*)str
{
    NSMutableAttributedString* strLast = [[NSMutableAttributedString alloc] initWithString:str];
    if ([str rangeOfString:@"*"].location != NSNotFound) {
        [strLast setAttributes:@{ NSForegroundColorAttributeName : kNavigationBarColor } range:NSMakeRange(0, 1)];
    }
    return strLast;
}

/**上传图片后存储或修改键值对*/
- (void)imgKeyAddValue:(NSString*)str withDic:(NSMutableDictionary*)dic
{
    NSArray* arr = [self.tempDic allKeys];
    NSObject* objct;
    if (dic == self.tempDic) {
        //为路径数组
        objct = [NSArray arrayWithObject:str];
    }
    else {
        //为url字符串
        objct = str;
    }

    if (arr.count == 0) {
        [dic setObject:objct forKey:self.arrTitleKey[self.selectIndex]];
    }
    else {
        for (NSString* key in arr) {
            if ([key isEqualToString:self.arrTitleKey[self.selectIndex]]) {
                [dic removeObjectForKey:key];

                [dic setObject:objct forKey:self.arrTitleKey[self.selectIndex]];
            }
            else {
                [dic setObject:objct forKey:self.arrTitleKey[self.selectIndex]];
            }
        }
    }
}

#pragma mark - UI界面
- (void)initUI
{

    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.cvAccMedical registerNib:[UINib nibWithNibName:NSStringFromClass([GYHealthUploadImgCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    [self.cvAccMedical registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.cvAccMedical registerNib:[UINib nibWithNibName:NSStringFromClass([GYAccidtHeadView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [self.cvAccMedical registerNib:[UINib nibWithNibName:NSStringFromClass([GYAccidtFootView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrTitle.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYHealthUploadImgCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];

    GYSamplePictureManager* man = [GYSamplePictureManager shareInstance];

    NSArray* arr = @[ kSaftToNSString([man selectDecCode:@"1015"].fileId),
                      kSaftToNSString([man selectDecCode:@"1016"].fileId),
                      kSaftToNSString([man selectDecCode:@"1001"].fileId),
                      kSaftToNSString([man selectDecCode:@"1002"].fileId),
        @"",
        @"",
        @"",
        @"",
        @"",
        kSaftToNSString([man selectDecCode:@"1017"].fileId) ];
    UIImageView* demoImage;
    if (indexPath.row < [arr count] && ![GYUtils checkStringInvalid:arr[indexPath.row]]) {

        demoImage = [[UIImageView alloc] init];
        [demoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, arr[indexPath.row], globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];
    }

    [cell setDemoBtnState:(demoImage.image != nil)];

    cell.colum = ^() {
        if (indexPath.row > 12) {
            
        } else {
            [bigPic showView:demoImage.image];
//            GYHSScoreWealImageShowViewController *showVC  = [[GYHSScoreWealImageShowViewController alloc] init];
//            showVC.arrImg = demoImage.image;
//            showVC.view.frame = self.view.frame;
//            showVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//            //[self addChildViewController:showVC];
//            [self.view addSubview:showVC.view];
        }
    };
    WS(weakSelf);
    cell.pic = ^() {
        weakSelf.selectIndex = indexPath.row;
        [weakSelf selectImage];
    };

    NSString* imageKey = self.arrTitleKey[indexPath.row];
    if ([@"sscPath" isEqualToString:imageKey]) {
        self.sscIndexPath = indexPath;
    }

    NSString* strUrl = [self.urlDic objectForKey:imageKey];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:strUrl];
    [cell.myimageView setImageWithURL:url placeholder:[UIImage imageNamed:@"hs_img_btn_bg.png"] options:kNilOptions completion:nil];

    if (indexPath.item >= 13) {
        cell.mylb.text = kLocalized(@"GYHS_BP_Continue_Add_Attachments");
    }
    else {
        cell.mylb.attributedText = self.arrTitle[indexPath.row];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.width / 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        GYAccidtHeadView* afvHead = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        afvHead.tfHealthCare.delegate = self;
        self.afvHead = afvHead;
        return afvHead;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        GYAccidtFootView* afvFoot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot" forIndexPath:indexPath];
        afvFoot.btnActBlock = ^(NSInteger index) {
            if (index == 100) {
                [self btnInstruction];
            } else {
                [self btnApply];
            }
        };
        return afvFoot;
    }
    else
        return nil;
}

#pragma mark - UIImagePickerControllerDelegate
//选择图片调用

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    if ([GYUtils checkDictionaryInvalid:info]) {
        return;
    }
    UIImage* image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
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
    // 保存到沙盒
    NSData* imageData = UIImageJPEGRepresentation(image1, 1);

    // 获取沙盒目录
    NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    DDLogDebug(@"%ld", (unsigned long)[imageData length]);
    // 检查文件大小 不能大于2M
    NSFileManager* fm = [NSFileManager defaultManager];
    long long fSize = 0;
    if ([fm fileExistsAtPath:fullPath]) {
        fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
    }
    if (fSize > 10 * 1024 * 1024) {
        [fm removeItemAtPath:fullPath error:nil];
        CGFloat x = (10 * 1024 * 1024) / fSize;
        imageData = UIImageJPEGRepresentation(image1, x);

        // 获取沙盒目录
        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
        // 将图片写入文件
        [imageData writeToFile:fullPath atomically:NO];
    }

    //取得图片
    [picker dismissViewControllerAnimated:YES completion:^{
        [self getNetData:image1];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    textField.keyboardType = UIKeyboardTypeNumberPad;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    DDLogDebug(@"textFieldDidEndEditing:%@", textField.text);

    GYHealthUploadImgCollectionViewCell* cell = (GYHealthUploadImgCollectionViewCell*)[self.cvAccMedical cellForItemAtIndexPath:self.sscIndexPath];
    if (cell == nil) {
        DDLogDebug(@"Failed to get cell, indexpath:%@", self.sscIndexPath);
        return;
    }

    NSString* cellName = kLocalized(@"GYHS_BP_Own_Social_Security_Card_Copy");
    if ((![GYUtils checkStringInvalid:textField.text]) && (textField.text.length > 5)) {
        cellName = [NSString stringWithFormat:@"*%@", cellName];
    }
    NSAttributedString* attribute = [self getRedSnowString:cellName];
    self.arrTitle[4] = attribute;
    cell.mylb.attributedText = attribute;

    NSString* cellNameb = kLocalized(@"GYHS_BP_Health_Center_Accept_Return_ReceiptCopy");
    if ((![GYUtils checkStringInvalid:textField.text]) && (textField.text.length > 5)) {
        cellNameb = [NSString stringWithFormat:@"*%@", cellNameb];
    }
    NSAttributedString* attributeb = [self getRedSnowString:cellNameb];
    self.arrTitle[10] = attributeb;
    cell.mylb.attributedText = attributeb;

    NSString* cellNamel = kLocalized(@"GYHS_BP_Medical_Expenses_Calculation_SheetCopy");
    if ((![GYUtils checkStringInvalid:textField.text]) && (textField.text.length > 5)) {
        cellNamel = [NSString stringWithFormat:@"*%@", cellNamel];
    }
    NSAttributedString* attributel = [self getRedSnowString:cellNamel];
    self.arrTitle[11] = attributel;
    cell.mylb.attributedText = attributel;
}

#pragma mark - btnAction
- (void)btnInstruction
{
    GYHSMedicalInstructionViewController* vcInstruction = [[GYHSMedicalInstructionViewController alloc] init];
    vcInstruction.title = kLocalized(@"GYHS_BP_Medical_Insurance");
    vcInstruction.strTitle = kLocalized(@"GYHS_BP_Apply_Medical_Insurance");
    vcInstruction.strContent = kLocalized(@"GYHS_BP_Apply_Medical_Insurance_Content");
    [self.navigationController pushViewController:vcInstruction animated:YES];
}

- (void)btnApply
{
    if (![GYUtils checkStringInvalid:self.afvHead.tfHealthCare.text]) {
        if (self.afvHead.tfHealthCare.text.length > 20 || self.afvHead.tfHealthCare.text.length < 6) {
            [GYUtils showMessage:kLocalized(@"GYHS_BP_Health_Number_Input_Error")];
            return;
        }

        NSArray* arr = [self.tempDic allKeys];
        if (![arr containsObject:@"sscPath"]) {
            [GYUtils showMessage:kLocalized(@"GYHS_BP_PleaseUpload_Social_Security_Card_Copy")];
            return;
        }
    }

    if (self.tempDic.count > 0) {
        NSArray* arr = [self.tempDic allKeys];
        if (arr.count >= self.isNeedKey.count) {
            NSMutableArray* arrJugde = [NSMutableArray array];
            for (NSString* key in self.isNeedKey) {
                for (NSString* tepKey in arr) {
                    if ([tepKey isEqualToString:key]) {
                        [arrJugde addObject:tepKey];
                    }
                }
            }

            if (arrJugde.count < self.isNeedKey.count) {
                [GYUtils showMessage:kLocalized(@"GYHS_BP_PleaseUpload_All_Necessary_Images")];
                return;
            }
        }
        else {
            [GYUtils showMessage:kLocalized(@"GYHS_BP_PleaseUpload_All_Necessary_Images")];
            return;
        }
    }
    else {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_PleaseUpload_All_Necessary_Images")];
        return;
    }

    [self postDicToNet];
}

#warning 孙秋明注释
- (void)selectImage
{
    [self.view endEditing:YES];
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];

    self.getView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYGetPhotoView class]) owner:self options:nil] firstObject];
    self.getView.frame = CGRectMake(15, kScreenHeight - 155, kScreenWidth - 30, 155);
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
        [GYUtils showMessage:kLocalized(@"HEDeviceNoSupportCamera")];
    }
}

- (void)photoalbumr
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        [GYUtils showMessage:kLocalized(@"HEAccessAlbumFailed")];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* beString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (beString.length > 20) {
        textField.text = [beString substringToIndex:20];
        return NO;
    }
    return YES;
}

#pragma mark -  网络服务事件
- (void)getNetData:(UIImage*)image
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:@"1" forKey:@"isPub"];
    [params setValue:globalData.loginModel.custId forKey:@"custId"];
    [params setValue:globalData.loginModel.token forKey:@"token"];
    NSString* urlStr = [NSString stringWithFormat:@"%@?custId=%@&token=%@&isPub=1", kUrlFileUpload, globalData.loginModel.custId, globalData.loginModel.token];
    //回调函数
    [GYGIFHUD showFullScreen];
    GYNetRequest *request = [[GYNetRequest alloc] initWithUploadDelegate:self baseURL:[GYHSLoginEn sharedInstance].getLoginUrl URLString:urlStr parameters:params constructingBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if ((float)data.length > 1024 * 100) {
            data = UIImageJPEGRepresentation(image, 1024*100.0/(float)data.length);
        }
        [formData appendPartWithFileData:data name:@"1" fileName:@"1.jpeg" mimeType:@"image/jpeg"];
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}
#pragma mark GYNetRequestDelegate

- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    [self imgKeyAddValue:responseObject[@"data"] withDic:self.tempDic];
    NSString *strUrll = [NSString stringWithFormat:@"%@%@?custId= %@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, responseObject[@"data"], globalData.loginModel.custId, globalData.loginModel.token];
    [self imgKeyAddValue:strUrll withDic:self.urlDic];
    if (self.selectIndex == self.arrTitleKey.count - 1 && self.selectIndex < 16) {
        [self.arrTitle addObject:kLocalized(@"GYHS_BP_Continue_Add_Attachments")];
        [self.arrTitleKey addObject:[NSString stringWithFormat:@"sss%ld", (unsigned long)self.selectIndex]];
        [self.arrImg addObject:@""];
    }
    [self.cvAccMedical reloadData];
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    NSInteger  errorRetCode = [error code];
    if ( errorRetCode == 215){
        [self.view makeToast:kLocalized(@"GYHS_BP_Upload_Pictures_Faild") duration:1.0 position:CSToastPositionCenter];
    }else if (errorRetCode == 201){
        [self.view makeToast:kLocalized(@"GYHS_BP_UploadFails") duration:1.0 position:CSToastPositionCenter];
    }
    else if (errorRetCode == 209){
        [self.view makeToast:kLocalized(@"GYHS_BP_Upload_Image_Too_Big_Please_Upload_Pictures_Less_Than_10M") duration:1.0 position:CSToastPositionCenter];
    }
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}
- (void)postDicToNet
{
    NSDictionary* dict = @{
        @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"hsResNo" : kSaftToNSString(globalData.loginModel.resNo),
        @"proposerName" : kSaftToNSString(globalData.loginModel.custName),
        @"proposerPhone" : kSaftToNSString(globalData.loginModel.mobile),
        @"proposerPapersNo" : kSaftToNSString(globalData.loginModel.creNo),
        @"healthCardNo" : kSaftToNSString(self.afvHead.tfHealthCare.text),
    };
    //如果上传了其他证据，把上传的证件的路径合并在一个数组中
    NSArray* keyArr = [self.tempDic allKeys];
    if ([self.tempDic objectForKey:@"otherProvePath"]) {
        NSMutableArray* anothoArr = [NSMutableArray arrayWithArray:[self.tempDic objectForKey:@"otherProvePath"]];
        for (NSString* key in keyArr) {
            if ([key containsString:@"sss"]) {
                NSArray* ar = [self.tempDic objectForKey:key];
                [anothoArr addObjectsFromArray:ar];
                [self.tempDic removeObjectForKey:key];
            }
        }
        [self.tempDic setObject:anothoArr forKey:@"otherProvePath"];
    }

    [self.tempDic addEntriesFromDictionary:dict];
    [self.tempDic addEntriesFromDictionary:self.dicParams];

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlApplyAccidentSecurity parameters:self.tempDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        WS(weakSelf)
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Apply_For_Alternate_Accident_Harm_Guarantee_Success") confirm:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } withColor:kBtnBlue];
       
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
#pragma mark -- Lazy loading
- (UICollectionView*)cvAccMedical
{
    if (_cvAccMedical == nil) {
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 64);
        flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 100);
        
        _cvAccMedical = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 16, kScreenWidth, kScreenHeight - 64-10) collectionViewLayout:flowLayout];
        
        _cvAccMedical.backgroundColor = [UIColor whiteColor];
        _cvAccMedical.delegate = self;
        _cvAccMedical.dataSource = self;
        [self.view addSubview:_cvAccMedical];
    }
    return _cvAccMedical;
}

- (NSMutableArray*)isNeedKey
{
    if (!_isNeedKey) {
        _isNeedKey = [[NSMutableArray alloc] init];
        ;
        _isNeedKey = [NSMutableArray arrayWithObjects:
                      @"hscPositivePath",
                      @"hscReversePath",
                      @"cerPositivePath",
                      @"cerReversePath",
                      @"ofrPath",
                      @"cdlPath",
                      @"medicalProvePath",
                      @"ddcPath",
                      self.afvHead.tfHealthCare.text.length > 5 ? @"sscPath" : nil,
                      self.afvHead.tfHealthCare.text.length > 5 ? @"medicalAcceptPath" : nil,
                      self.afvHead.tfHealthCare.text.length > 5 ? @"costCountPath" : nil, nil];
    }
    return _isNeedKey;
}

- (NSMutableArray*)arrImg
{
    if (!_arrImg) {
        _arrImg = [NSMutableArray array];
    }
    return _arrImg;
}

- (NSMutableArray*)arrTitle
{
    if (!_arrTitle) {
        _arrTitle = [NSMutableArray array];
    }
    return _arrTitle;
}

- (NSMutableArray*)arrTitleKey
{
    if (!_arrTitleKey) {
        _arrTitleKey = [NSMutableArray arrayWithObjects:
                        @"hscPositivePath",
                        @"hscReversePath",
                        @"cerPositivePath",
                        @"cerReversePath",
                        @"sscPath",
                        @"ofrPath",
                        @"cdlPath",
                        @"ddcPath",
                        @"imrPath",
                        @"medicalProvePath",
                        @"medicalAcceptPath",
                        @"costCountPath",
                        @"otherProvePath",
                        @"sss12", nil];
    }
    return _arrTitleKey;
}

- (NSMutableDictionary*)tempDic
{
    if (!_tempDic) {
        _tempDic = [NSMutableDictionary dictionary];
    }
    return _tempDic;
}

- (NSMutableDictionary*)urlDic
{
    if (!_urlDic) {
        _urlDic = [NSMutableDictionary dictionary];
    }
    return _urlDic;
}

@end
