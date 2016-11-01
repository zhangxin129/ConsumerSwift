//
//  GYHSMyCompanyInfoChageHeadImageVC.m
//
//  Created by apple on 16/8/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyMainChageHeadImageVC.h"
#import "GYHSmyhsHttpTool.h"
#import "GYNetWork.h"
#import "GYPhotoPickerViewController.h"
@interface GYHSMyMainChageHeadImageVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,GYPhotoPickerViewControllerDelegate>

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIButton* albumButton;
@property (nonatomic, strong) UIButton* photographButton;

@property (nonatomic, copy) NSString* imageDataStr;
@property (nonatomic, strong) UIImage* image;

@end

@implementation GYHSMyMainChageHeadImageVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout :^{
        @strongify(self);
        [self initView];
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString*, id>*)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    //换成二进制数据
    NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
    ;
    
    // 获取图片名称
    NSDate* date = [NSDate date];
    NSString* tempName = [[NSString stringWithFormat:@"%@", date] substringToIndex:10];
    NSString* imageName = [tempName stringByAppendingString:@".jpg"];
    
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
    if (fSize > 2 * 1024 * 1024) {
        imageData = UIImageJPEGRepresentation(image, 0.25);
    }
    
    if (imageData) {
        [self uploadImage:imageData imageName:imageName];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 图片选择器的代理方法 GYPhotoPickerViewControllerDelegate
/**
 *  点击确定的回调
 *
 *  @param assetArray 选中的照片的url数组
 */
- (void)imagePickerViewController:(GYPhotoPickerViewController*)ivc imageAsset:(ALAsset*)asset{
    
    // 使用asset来获取本地图片
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *image = [UIImage imageWithCGImage:imgRef
                                         scale:assetRep.scale
                                   orientation:(UIImageOrientation)assetRep.orientation];
    
    
    
    //换成二进制数据
    NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
    ;
    
    // 获取图片名称
    NSDate* date = [NSDate date];
    NSString* tempName = [[NSString stringWithFormat:@"%@", date] substringToIndex:10];
    NSString* imageName = [tempName stringByAppendingString:@".jpg"];
    
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
    if (fSize > 2 * 1024 * 1024) {
        imageData = UIImageJPEGRepresentation(image, 0.25);
    }
    
    if (imageData) {
        [self uploadImage:imageData imageName:imageName];
    }
    
    
}
//点击相册
- (void)imagePickerViewControllerCamera: (GYPhotoPickerViewController *)ivc{
    [self photographButtonAction];
}


#pragma mark - event response
- (void)albumButtonAction
{
    //相册
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
//        UIImagePickerController* pickVC = [[UIImagePickerController alloc] init];
//        pickVC.modalPresentationStyle = UIModalPresentationCustom;
//        pickVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        pickVC.delegate = self;
//        pickVC.allowsEditing = YES;
//        [self presentViewController:pickVC animated:YES completion:nil];
//    }
    GYPhotoPickerViewController* vc = [[GYPhotoPickerViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)photographButtonAction
{
    //拍照
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* pickVC = [[UIImagePickerController alloc] init];
        pickVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        pickVC.delegate = self;
        pickVC.allowsEditing = YES;
        pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickVC animated:YES completion:nil];
    }
}





#pragma mark - request
- (void)uploadImageWithUrl:(NSString*)url params:(NSDictionary*)params imageData:(NSData*)data imageName:(NSString*)name success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork UPLOAD:url
            imageData:data
            imageName:name
              success:^(id returnValue) {
                  KExcuteBlock(success, returnValue);
              }
              failure:^(NSError* error) {
                  KExcuteBlock(err, nil);
              }];
}

- (void)uploadImage:(NSData*)imageData imageName:(NSString*)imageName
{
    //上传电商企业头像特有接口
    NSString* urlString = [NSString stringWithFormat:@"%@?type=logoPic&fileType=image&isPub=1&userName=%@&entResNo=%@", GY_HSDOMAINAPPENDING(GYHEUploadAndUpdateShopLogoPic), globalData.loginModel.userName, globalData.loginModel.entResNo];
    
    [self uploadImageWithUrl:urlString
                      params:nil
                   imageData:imageData
                   imageName:imageName
                     success:^(id responsObject) {
                         
                         self.imageView.image = [UIImage imageWithData:imageData];
                         globalData.loginModel.vshopLogo = responsObject[@"data"][@"logoHttpUrl"];
                         [kDefaultNotificationCenter postNotificationName:GYChangeHeadImageNotification object:nil];
                     }
                     failure:^{
                         
                     }];
}

#pragma mark - private methods

- (void)initView
{
    self.title = kLocalized(@"GYHS_Myhs_Select_Picturn");
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(self.view).offset(kDeviceProportion(70) + 44);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kDeviceProportion(430));
        make.height.mas_equalTo(kDeviceProportion(350));
    }];
    
    [self.view addSubview:self.photographButton];
    [self.photographButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(kDeviceProportion(81));
        make.right.mas_equalTo(self.view.mas_centerX).offset(kDeviceProportion(-8));
        make.width.mas_equalTo(kDeviceProportion(98));
        make.height.mas_equalTo(kDeviceProportion(44));
    }];
    
    [self.view addSubview:self.albumButton];
    [self.albumButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(kDeviceProportion(81));
        make.left.equalTo(self.view.mas_centerX).offset(kDeviceProportion(7));
        make.width.mas_equalTo(kDeviceProportion(98));
        make.height.mas_equalTo(kDeviceProportion(44));
    }];
}

#pragma mark - lazy load

- (UIImageView*)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setImageWithURL:[NSURL URLWithString:GYHE_PICTUREAPPENDING(globalData.loginModel.vshopLogo)] placeholder:[UIImage imageNamed:@"gyhs_upload_image_bigHead"]];
    }
    return _imageView;
}

- (UIButton*)photographButton
{
    if (!_photographButton) {
        _photographButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photographButton setImage:[UIImage imageNamed:@"gyhs_btn_photograph"] forState:UIControlStateNormal];
        [_photographButton setImage:[UIImage imageNamed:@"gyhs_btn_photograph"] forState:UIControlStateHighlighted];
        [_photographButton addTarget:self action:@selector(photographButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photographButton;
}

- (UIButton*)albumButton
{
    if (!_albumButton) {
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumButton setImage:[UIImage imageNamed:@"gyhs_btn_alum"] forState:UIControlStateNormal];
        [_albumButton setImage:[UIImage imageNamed:@"gyhs_btn_alum"] forState:UIControlStateHighlighted];
        [_albumButton addTarget:self action:@selector(albumButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumButton;
}

@end
