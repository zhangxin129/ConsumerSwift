//
//  GYHealthUploadImgViewController.m
//  HSConsumer
//
//  Created by apple on 16/1/6.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSHealthUploadImgViewController.h"
#import "GYHealthUploadImgCollectionViewCell.h"
#import "GYUploadImage.h"
#import "GYBigPic.h"
#import "UIActionSheet+Blocks.h"
#import "GYSamplePictureManager.h"
#import "GYHSLoginManager.h"
#import "GYGetPhotoView.h"
#import "GYHSUploadImgFooterView.h"
#import "GYHSTools.h"

@interface GYHSHealthUploadImgViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GYUploadPicDelegate,GYGetPhotoViewDelegate,GYNetRequestDelegate> {
    GYBigPic* bigPic;
}
@property (nonatomic, strong) UICollectionView* mycollectionView;
@property (nonatomic, strong) NSMutableArray* dataArr;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSMutableArray* isNeedKey, *arrTitleKey;
@property (nonatomic, strong) NSMutableDictionary* mydic;
@property (nonatomic, strong) NSMutableDictionary* tempDic;

@property (nonatomic, strong)GYGetPhotoView *getView;
@property (nonatomic, strong)UIView *bgView;

@end

@implementation GYHSHealthUploadImgViewController
#pragma mark 懒加载

- (NSMutableDictionary*)tempDic
{
    if (!_tempDic) {
        _tempDic = [[NSMutableDictionary alloc] init];
    }
    return _tempDic;
}

- (NSMutableDictionary*)mydic
{
    if (_mydic == nil) {
        _mydic = [[NSMutableDictionary alloc] init];
    }
    return _mydic;
}

- (NSMutableArray*)arrTitleKey //必须上传图片的数组
{
    if (!_arrTitleKey) {
        _arrTitleKey = [NSMutableArray array];
        _arrTitleKey = [NSMutableArray arrayWithObjects:
                                           @"hscPositivePath",
                                       @"hscReversePath",
                                       @"cerPositivePath",
                                       @"cerReversePath",
                                       @"sscPath",
                                       @"ofrPath",
                                       @"cdlPath",
                                       @"omrPath",
                                       @"imrPath",
                                       @"ddcPath",
                                       @"medicalAcceptPath",
                                       @"costCountPath",
                                       @"otherProvePath",
                                        @"sss12",nil];
    }
    return _arrTitleKey;
}

- (NSMutableArray*)isNeedKey //必须上传图片的数组
{
    if (!_isNeedKey) {
        _isNeedKey = [NSMutableArray array];
        _isNeedKey = [NSMutableArray arrayWithObjects:
                                         @"hscPositivePath",
                                     @"ddcPath",
                                     @"ofrPath",
                                     @"cerReversePath",
                                     @"omrPath",
                                     @"hscReversePath",
                                     @"cdlPath",
                                     @"cerPositivePath",
                                     self.healthCardNo.length > 0 ? @"sscPath" : nil,
                                     self.healthCardNo.length > 0 ? @"medicalAcceptPath" : nil,
                                     self.healthCardNo.length > 0 ? @"costCountPath" : nil, nil];
    }
    return _isNeedKey;
}

- (NSMutableArray*)dataArr
{
    if (_dataArr == nil) {
        NSString* str1, *str2, *str3;

        if (self.healthCardNo.length > 0) {
            str1 = [@"*" stringByAppendingString:kLocalized(@"GYHS_BP_Own_Social_Security_Card_Copy")];
            str2 = [@"*" stringByAppendingString:kLocalized(@"GYHS_BP_Health_Center_Accept_Return_ReceiptCopy")];
            str3 = [@"*" stringByAppendingString:kLocalized(@"GYHS_BP_Medical_Expenses_Calculation_SheetCopy")];
        }
        else {
            str1 = kLocalized(@"GYHS_BP_Own_Social_Security_Card_Copy");
            str2 = kLocalized(@"GYHS_BP_Health_Center_Accept_Return_ReceiptCopy");
            str3 = kLocalized(@"GYHS_BP_Medical_Expenses_Calculation_SheetCopy");
        }

        _dataArr = [NSMutableArray arrayWithObjects:
                                   kLocalized(@"GYHS_BP_*PointsCardPositive"),
                                   kLocalized(@"GYHS_BP_*PointsCardBack"),
                                   kLocalized(@"GYHS_BP_*IdCardPositive"),
                                   kLocalized(@"GYHS_BP_*IdCardBack"),
                                   str1,
                                   kLocalized(@"GYHS_BP_*Photocopy_Of_Original_FeeReceipt"),
                                   kLocalized(@"GYHS_BP_*Cost_ListCopy"),
                                   kLocalized(@"GYHS_BP_*Outpatient_RecordsCopy"),
                                   kLocalized(@"GYHS_BP_Hospital_Medical_RecordsCopy"),
                                   kLocalized(@"GYHS_BP_*Disease_Diagnosis_Certificate_Copy"),
                                   str2,
                                   str3,
                                   kLocalized(@"GYHS_BP_Other_Attachments_Upload"),
                                     kLocalized(@"GYHS_BP_Continue_Add_Attachments"),nil];
    }
    return _dataArr;
}

- (UICollectionView*)mycollectionView
{
    if (_mycollectionView == nil) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _mycollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
        _mycollectionView.dataSource = self;
        _mycollectionView.delegate = self;
        _mycollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _mycollectionView;
}

#pragma mark - 控件的创建
- (void)initUI
{

    bigPic = [[GYBigPic alloc] init];
    [self.view addSubview:self.mycollectionView];
    [self.mycollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHealthUploadImgCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"collectioncell"];
    [self.mycollectionView registerClass:[GYHSUploadImgFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kGYHSUploadImgFooterViewIdentifier];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self initUI];
}

#pragma mark - collectionView  代理
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake(self.view.frame.size.width / 2 - 0, self.view.frame.size.width / 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 0, 0);
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYHealthUploadImgCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];

    //设置成红星
    NSString* strShow = nil;
    if (self.dataArr.count > indexPath.item) {
        strShow = self.dataArr[indexPath.item];
    }
    NSInteger length = strShow.length;
    NSRange posi = [strShow rangeOfString:@"*"];
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:strShow];
    [str setAttributes:@{ NSForegroundColorAttributeName : kNavigationBarColor } range:posi];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, length)];//字体不做宏定义
    cell.mylb.attributedText = str;

    GYSamplePictureManager* man = [GYSamplePictureManager shareInstance];
    NSArray* arr = @[ kSaftToNSString([man selectDecCode:@"1015"].fileId),
        kSaftToNSString([man selectDecCode:@"1016"].fileId),
        kSaftToNSString([man selectDecCode:@"1001"].fileId),
        kSaftToNSString([man selectDecCode:@"1002"].fileId) ];

    UIImageView* demoImage;
    if (indexPath.row < [arr count]) {

        demoImage = [[UIImageView alloc] init];
        [demoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, arr[indexPath.row], globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];
    }

    [cell setDemoBtnState:(demoImage != nil)];
    //示列图片的点击事件
    cell.colum = ^() {
        [bigPic showView:demoImage.image];
    };
    //上传图片的点击事件
    cell.pic = ^() {
        self.index = indexPath.row;
        [self selectImage];
    };
    NSString* strUrl = nil;
    if (self.arrTitleKey.count > indexPath.row) {
        strUrl = [self.mydic objectForKey:self.arrTitleKey[indexPath.row]];
    }
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:strUrl];
    [cell.myimageView setImageWithURL:url placeholder:[UIImage imageNamed:@"hs_img_btn_bg.png"] options:kNilOptions completion:nil];

    return cell;
}

#pragma mark - collectionView 表尾的代理
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 300);
}

- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        GYHSUploadImgFooterView * v = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kGYHSUploadImgFooterViewIdentifier forIndexPath:indexPath];
        [v.applyBtn addTarget:self action:@selector(btnApply) forControlEvents:UIControlEventTouchUpInside];
        return v;
    }
    return nil;
}

//点击取消按钮调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage*)currentImage withName:(NSString*)imageName
{

    NSData* imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录

    NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - UIImagePickerControllerDelegate
//选择图片调用
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary<NSString*, id>*)editingInfo
{
}

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
    // 检查文件大小 不能大于10M
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

    // 保存到沙盒
    [self saveImage:image1 withName:imageName];

    //取得图片
    [picker dismissViewControllerAnimated:YES completion:^{
        //回调函数
        [self getNetData:image1];
    }];
}

- (void)selectImage
{
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    
    self.getView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYGetPhotoView class]) owner:self options:nil] firstObject];
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

-(void)photocamera
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
        [GYUtils showMessage:kLocalized(@"HEDeviceNoSupportCamera") confirm:^{
            
        } withColor:UIColorFromRGB(0x1d7dd6)];
    }
    
}

-(void)photoalbumr
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        [GYUtils showMessage:kLocalized(@"HEAccessAlbumFailed") confirm:^{
            
        } withColor:UIColorFromRGB(0x1d7dd6)];
    }
    
}


#pragma mark -  网络服务事件
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

    NSArray* arrary = [NSArray arrayWithObject:str];
    if (arr.count == 0) {
        [self.tempDic setObject:arrary forKey:self.arrTitleKey[self.index]];
    }
    else {
        for (NSString* key in arr) {
            if ([key isEqualToString:self.arrTitleKey[self.index]]) {
                [dic removeObjectForKey:key];
                [dic setObject:objct forKey:self.arrTitleKey[self.index]];
            }
            else {
                [dic setObject:objct forKey:self.arrTitleKey[self.index]];
            }
        }
    }
}

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
#pragma mark -- GYNetRequestDelegate
-(void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject
{
    [GYGIFHUD dismiss];
    if (self.index == self.dataArr.count-1 && self.index < 16) {
        [self.dataArr addObject:kLocalized(@"GYHS_BP_Continue_Add_Attachments")];
        [self.arrTitleKey addObject:[NSString stringWithFormat:@"sss%ld", (unsigned long)self.index]];
    }
    
    [self imgKeyAddValue:responseObject[@"data"] withDic:self.tempDic];
    NSString *strUrll = [NSString stringWithFormat:@"%@%@?custId= %@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, responseObject[@"data"], globalData.loginModel.custId, globalData.loginModel.token];
    [self imgKeyAddValue:strUrll withDic:self.mydic];
    
    [self.mycollectionView reloadData];
}
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error
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
- (void)btnApply
{
    if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Registration_Certificate_Type_Enterprise_Not_Enjoy_Alternate_Health_Benefits") confirm:^{
            
        } withColor:UIColorFromRGB(0x1d7dd6)];
        return;
    }

    if (![self isAllSnowUpload]) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_TheBelt*Photo_MustBe_Uploaded") confirm:^{
            
        } withColor:UIColorFromRGB(0x1d7dd6)];
        return;
    }

    [self postDicToNet];
}

- (BOOL)isAllSnowUpload
{
    for (NSString* key in self.isNeedKey) {
        NSArray* arr = [self.tempDic objectForKey:key];
        if (arr.count == 0) {
            return NO;
        }
    }
    return YES;
}

- (void)postDicToNet
{
    GlobalData* global = [GlobalData shareInstance];
    NSDate* date = [NSDate date];
    NSString* applyDate = [GYUtils dateToString:date]; //申请日期

    NSDictionary* dict = @{
        @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"hsResNo" : kSaftToNSString(globalData.loginModel.resNo),
        @"proposerName" : kSaftToNSString(global.loginModel.custName),
        @"proposerPhone" : kSaftToNSString(global.loginModel.mobile),
        @"city" : kSaftToNSString(self.dictBaseInfo[@"city"]),
        @"startDate" : kSaftToNSString(self.dictBaseInfo[@"startDate"]),
        @"endDate" : kSaftToNSString(self.dictBaseInfo[@"endDate"]),
        @"hospital" : kSaftToNSString(self.dictBaseInfo[@"hospital"]),

        @"proposerPapersNo" : kSaftToNSString(globalData.loginModel.creNo),
        @"healthCardNo" : kSaftToNSString(self.dictBaseInfo[@"healthCardNo"]),
        @"applyDate" : kSaftToNSString(applyDate),
    };

    //如果上传了其他证件，把上传的证件的路径合并在一个数组中
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

    [GYGIFHUD showFullScreen];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHScardMedicalSubsidySchemeUrlString parameters:self.tempDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        WS(weakSelf)
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Apply_For_Alternate_Medical_Subsidy_Succeed") confirm:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } withColor:UIColorFromRGB(0x1d7dd6)];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

@end
