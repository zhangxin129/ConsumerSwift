//
//  GYDiePeopleViewController.m
//  HSConsumer
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYDiePeopleViewController.h"
#import "GYHealthUploadImgCollectionViewCell.h"
#import "GYInstructionViewController.h"
#import "GYAccidtFootView.h"
#import "GYBigPic.h"
#import "UIActionSheet+Blocks.h"
#import "GYDiePeopleHeaderView.h"
#import "GYSamplePictureManager.h"
#import "GYHSLoginManager.h"

static NSString* itemDy = @"item";
static NSString* footerDy = @"footer";
static NSString* headerDy = @"header";

@interface GYDiePeopleViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate,GYNetRequestDelegate>

@property (nonatomic, strong) GYBigPic* bigPic;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* arrayPath;
@property (nonatomic, strong) NSArray* arrayNeedKey;
@property (nonatomic, strong) NSMutableArray* arrImg;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) NSMutableArray* arrTitle;
@property (nonatomic, strong) NSMutableDictionary* tempDic, *urlDic;

@end

@implementation GYDiePeopleViewController

#pragma mark - 懒加载

- (NSMutableDictionary*)tempDic
{
    if (!_tempDic) {
        _tempDic = [[NSMutableDictionary alloc] init];
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

- (GYBigPic*)bigPic
{
    if (!_bigPic) {
        _bigPic = [[GYBigPic alloc] init];
    }
    return _bigPic;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 105);
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 100);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHealthUploadImgCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:itemDy];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYAccidtFootView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerDy];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYDiePeopleHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerDy];
    }
    return _collectionView;
}

- (NSMutableArray*)arrayPath
{
    if (!_arrayPath) {
        _arrayPath = [NSMutableArray arrayWithArray:@[
            @"deathProvePath",
            @"ifpPath",
            @"hrcPath",
            @"aipPath",
            @"diePeopleCerPath",
            @"otherProvePath"
        ]];
    }
    return _arrayPath;
}

- (NSArray*)arrayNeedKey
{
    if (!_arrayNeedKey) {
        _arrayNeedKey = @[
            @"deathProvePath",
            @"ifpPath",
            @"hrcPath",
            @"aipPath",

        ];
    }
    return _arrayNeedKey;
}

- (NSMutableArray*)arrImg
{
    if (!_arrImg) {
        _arrImg = [NSMutableArray arrayWithArray:@[
            @"hs_deathCer.jpg",
            @"hs_agent_accredit_pic.jpg",
            @"hs_Id_logout_cer.jpg",
            @"hs_trusteeId_card_pic.jpg",
            @"",
            @""
        ]];
    }
    return _arrImg;
}

- (NSMutableArray*)arrTitle
{
    if (!_arrTitle) {
        _arrTitle = [[NSMutableArray alloc] initWithArray:@[
            [self getRedSnowString:kLocalized(@"GYHS_BP_*Guaranteed_Death_Certificate_In_Attachment")],
            [self getRedSnowString:kLocalized(@"GYHS_BP_*Guarantee_Certificate_Of_Relationship")],
            [self getRedSnowString:kLocalized(@"GYHS_BP_*Registration_Cancellation_Of_Certificate")],
            [self getRedSnowString:kLocalized(@"GYHS_BP_*Agent_Legal_Proof_Of_Identity")],
            [self getRedSnowString:kLocalized(@"GYHS_BP_By_Guaranteed_Legal_Proof_Identity")],
            [self getRedSnowString:kLocalized(@"GYHS_BP_Other_Documents")]
        ]];
    }
    return _arrTitle;
}

#pragma mark - 私有方法
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
        [dic setObject:objct forKey:self.arrayPath[self.selectIndex]];
    }
    else {
        for (NSString* key in arr) {
            if ([key isEqualToString:self.arrayPath[self.selectIndex]]) {
                [dic removeObjectForKey:key];

                [dic setObject:objct forKey:self.arrayPath[self.selectIndex]];
            }
            else {
                [dic setObject:objct forKey:self.arrayPath[self.selectIndex]];
            }
        }
    }
}

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initUI];
}

- (void)initUI
{

    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrTitle.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collection cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYHealthUploadImgCollectionViewCell* cell = [collection dequeueReusableCellWithReuseIdentifier:itemDy forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];

    GYSamplePictureManager* man = [GYSamplePictureManager shareInstance];
    NSArray *arr = @[kSaftToNSString([man selectDecCode:@"1018"].fileId),
                     kSaftToNSString([man selectDecCode:@"1012"].fileId),
                     kSaftToNSString([man selectDecCode:@"1011"].fileId),
                     kSaftToNSString([man selectDecCode:@"1024"].fileId]);
    UIImageView* demoImage;
    if (indexPath.row < [arr count] ) {

        demoImage = [[UIImageView alloc] init];
        [demoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, arr[indexPath.row], globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];

    }

   
    [cell setDemoBtnState:(demoImage.image != nil)];
    cell.colum = ^() {
        [self.bigPic showView:demoImage.image];
    };
    cell.pic = ^() {
        self.selectIndex = indexPath.row;
        [self selectImage];
    };
    NSString* strUrl = [self.urlDic objectForKey:self.arrayPath[indexPath.row]];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:strUrl];
    [cell.myimageView  setImageWithURL:url placeholder:[UIImage imageNamed:@"hs_img_btn_bg.png"] options:kNilOptions completion:nil];
    cell.mylb.attributedText = self.arrTitle[indexPath.row];
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
        GYDiePeopleHeaderView* headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerDy forIndexPath:indexPath];
        headView.resTitle.text = kLocalized(@"GYHS_BP_By_Security_People_HSNumber");
        headView.nameTitle.text = kLocalized(@"GYHS_BP_By_Safeguard_People's_Name");
        headView.name.text = self.dicParams[@"diePeopleName"];
        headView.resNo.text = self.dicParams[@"deathResNo"];
        return headView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        GYAccidtFootView* afvFoot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerDy forIndexPath:indexPath];
        afvFoot.btnActBlock = ^(NSInteger index) {
            if (index == 100) {
                [self btnInstruction];
            } else {
                [self btnApply];
            }
        };
        return afvFoot;
    }
    else {
        return nil;
    }
}

#pragma - mark 相册选图片
- (void)selectImage
{

    NSMutableArray* arr = [NSMutableArray array];
    [arr addObject:kLocalized(@"GYHS_RealName_Photo_Album")];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [arr addObject:kLocalized(@"GYHS_RealName_Camera")];
    }

    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:kLocalized(@"GYHS_RealName_Cancel") destructiveButtonTitle:nil otherButtonTitles:arr tapBlock:^(UIActionSheet* _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) {  //相册
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            //图片来源 相册 相机
            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            ipc.delegate = self;
            [self presentViewController:ipc animated:YES completion:nil];
        } else if (buttonIndex == 1) { //相机
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.delegate = self;
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }];
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
    if (fSize > 2 * 1024 * 1024) {
        [fm removeItemAtPath:fullPath error:nil];
        CGFloat x = (2 * 1024 * 1024) / fSize;
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

#pragma mark - 事件
- (void)btnInstruction
{
    GYInstructionViewController* vcInstruction = [[GYInstructionViewController alloc] init];
    vcInstruction.title = kLocalized(@"GYHS_RealName_Death_Benefits");
    vcInstruction.strTitle = kLocalized(@"GYHS_RealName_Apply_Death_Benefits");
    vcInstruction.strContent = kLocalized(@"GYHS_RealName_To_Disclose_The_Information_Content");
    [self.navigationController pushViewController:vcInstruction animated:YES];
}

- (void)btnApply
{
    if (self.tempDic.count > 0) {
        NSArray* arr = [self.tempDic allKeys];
        if (arr.count >= self.arrayNeedKey.count) {
            NSMutableArray* arrJugde = [NSMutableArray array];
            for (NSString* key in self.arrayNeedKey) {
                for (NSString* tepKey in arr) {
                    if ([tepKey isEqualToString:key]) {
                        [arrJugde addObject:tepKey];
                    }
                }
            }

            if (arrJugde.count < self.arrayNeedKey.count) {
                [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Upload_All_The_Necessary_Images")];
                return;
            }
        }
        else {
            [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Upload_All_The_Necessary_Images")];
            return;
        }
    }
    else {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Upload_All_The_Necessary_Images")];
        return;
    }
    [self getNetData];
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
    [GYGIFHUD show];
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
    [self imgKeyAddValue:responseObject[@"data"] withDic:self.tempDic];
     NSString *strUrll = [NSString stringWithFormat:@"%@%@?custId= %@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, responseObject[@"data"], globalData.loginModel.custId, globalData.loginModel.token];
    [self imgKeyAddValue:strUrll withDic:self.urlDic];
    if (self.selectIndex == self.arrayPath.count-1 && self.selectIndex <= 8) {
        [self.arrTitle addObject:[self getRedSnowString:kLocalized(@"GYHS_RealName_Continue_To_Add_Attachments")]];
        [self.arrayPath addObject:[NSString stringWithFormat:@"sss%ld", (unsigned long)self.selectIndex]];
        [self.arrImg addObject:@""];
    }
    [self.collectionView reloadData];
}
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error
{
    [GYGIFHUD dismiss];
    NSInteger  errorRetCode = [error code];
    if(errorRetCode ==215){
        [self.view makeToast:kLocalized(@"GYHS_RealName_Failure_To_Upload_Pictures") duration:1.0 position:CSToastPositionCenter];
        
    }else if (errorRetCode ==201) {
        [self.view makeToast:kLocalized(@"GYHS_RealName_Upload_Failed") duration:1.0 position:CSToastPositionCenter];
        
    }else if (errorRetCode ==209) {
        [self.view makeToast:kLocalized(@"GYHS_RealName_Upload_Your_Image_Is_Too_Big_Please_Upload_Pictures_Of_Less_Than_10M") duration:1.0 position:CSToastPositionCenter];
        
    }
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    //WS(weakSelf)
    [GYUtils parseNetWork:error resultBlock:^(NSInteger retCode) {
        //[weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)getNetData
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"hsResNo" : kSaftToNSString(globalData.loginModel.resNo),
        @"proposerName" : kSaftToNSString(globalData.loginModel.custName),
        @"proposerPhone" : kSaftToNSString(globalData.loginModel.mobile),
        @"proposerPapersNo" : kSaftToNSString(globalData.loginModel.creNo),
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
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlApplyDieSecurity parameters:self.tempDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if(error){
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        [GYUtils showMessage:responseObject[@"msg"] confirm:^{
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:NSClassFromString(@"GYHSAccountViewController")]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
@end
