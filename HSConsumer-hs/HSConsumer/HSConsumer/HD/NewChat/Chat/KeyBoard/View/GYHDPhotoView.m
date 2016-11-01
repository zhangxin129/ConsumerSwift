//
//  GYHDPhotoView.m
//  HSConsumer
//
//  Created by shiang on 16/2/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPhotoView.h"
#import "GYHDMessageCenter.h"
#import "GYHDPhotoCell.h"
#import "GYHDPhotoModel.h"
#import "GYHDPhotoShowView.h"
#import "UIImage+GYExtension.h"
//#import "GYLoadImg.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface GYHDPhotoView () <UICollectionViewDataSource, UICollectionViewDelegate, GYHDPhotoShowViewDelegate>
/**图片展示控制器*/
@property (nonatomic, weak) UICollectionView* photoCollectionView;
/**图片统计按钮*/
@property (nonatomic, weak) UIButton* originalPhotoButton;
/**发送按钮*/
@property (nonatomic, weak) UIButton* sendPhotoButton;
/**图片统计素组*/
@property (nonatomic, strong) NSMutableArray* photoArray;
/**底部View*/
@property (nonatomic, weak) UIView* photoBottomView;
@end

@implementation GYHDPhotoView
- (NSMutableArray*)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self photoFromLibrary];

    //1. 展示photoView
    //创建一个layout布局类
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat itemWH = (kScreenWidth - 6) / 3;
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView* collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    WS(weakSelf);
    collect.backgroundColor = [UIColor whiteColor];
    //代理设置
    collect.delegate = self;
    collect.dataSource = self;
    //注册item类型 这里使用系统的类型
    [collect registerClass:[GYHDPhotoCell class] forCellWithReuseIdentifier:@"PhotoCellID"];
    [self addSubview:collect];
    _photoCollectionView = collect;

    [collect mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];

    UIView* photoBottomView = [[UIView alloc] init];
    photoBottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:photoBottomView];
    _photoBottomView = photoBottomView;
    photoBottomView.hidden = YES;
    [photoBottomView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    // 原图按钮
    UIButton* originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    originalPhotoButton.backgroundColor = [UIColor whiteColor];
    originalPhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    originalPhotoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [originalPhotoButton setTitleColor:[UIColor colorWithRed:250 / 255.0f green:60 / 255.0f blue:40 / 255.0f alpha:1] forState:UIControlStateNormal];
    [originalPhotoButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Chat_photo_original_Photo"] forState:UIControlStateNormal];
    [originalPhotoButton setImage:[UIImage imageNamed:@"gyhd_select_original_btn_normal"] forState:UIControlStateNormal];
    [originalPhotoButton setImage:[UIImage imageNamed:@"gyhd_select_original_btn_Highlighte"] forState:UIControlStateSelected];
    [originalPhotoButton addTarget:self action:@selector(originalButtonClick:) forControlEvents:UIControlEventTouchDown];
    [photoBottomView addSubview:originalPhotoButton];
    _originalPhotoButton = originalPhotoButton;
    [originalPhotoButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(photoBottomView);
        make.size.mas_equalTo(CGSizeMake(150, 30));

    }];
    // 发送按钮
    UIButton* sendPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendPhotoButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    //    sendPhotoButton.backgroundColor = [UIColor whiteColor];
    //    sendPhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [sendPhotoButton setTitleColor: forState:UIControlStateNormal];
    [sendPhotoButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Send"] forState:UIControlStateNormal];
    [sendPhotoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_text_field_send_icom"] forState:UIControlStateNormal];
    [sendPhotoButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [photoBottomView addSubview:sendPhotoButton];
    _sendPhotoButton = sendPhotoButton;
    [sendPhotoButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-24);
        make.centerY.equalTo(photoBottomView);
        make.size.mas_equalTo(CGSizeMake(60, 24));

    }];
}

- (void)sendButtonClick:(UIButton*)button
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        

    if (self.originalPhotoButton.selected) { // 原图发送
        for (GYHDPhotoModel* photo in self.photoArray) {
            if (photo.photoSelectStates) {
                photo.photoSelectStates = NO;

                if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
                    ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
                    [assetLibrary assetForURL:photo.photoOriginalImageUrl resultBlock:^(ALAsset* asset) {

                        UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate GYHDKeyboardSelectBaseView:self sendDict:[self saveImageToBoxWithImage:image] SendType:GYHDKeyboardSelectBaseSendPhoto];
                        });
               
                    } failureBlock:^(NSError* error){

                    }];
                }
            }
        }
    }
    else { // 缩略图发送
        for (GYHDPhotoModel* photo in self.photoArray) {

            if (photo.photoSelectStates) {
                photo.photoSelectStates = NO;

                if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
                    ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
                    [assetLibrary assetForURL:photo.photoOriginalImageUrl resultBlock:^(ALAsset* asset) {

                        UIImage *photoImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                        UIImage *image = nil;
                        if (photoImage.size.width > 1080 || photoImage.size.height > 1080) {
                            image = [GYUtils imageCompressForWidth:photoImage targetWidth:1080];
                        } else {
                            image = photoImage;
                        }

                        dispatch_async(dispatch_get_main_queue(), ^{
                           [self.delegate GYHDKeyboardSelectBaseView:self sendDict:[self saveImageToBoxWithImage:image] SendType:GYHDKeyboardSelectBaseSendPhoto];
                        });

                    } failureBlock:^(NSError* error){

                    }];
                }
            }
        }
    }
    });
    selectImageCount = 0;

    [self.photoCollectionView reloadData];
}

/**保存图片到沙盒*/
- (NSDictionary*)saveImageToBoxWithImage:(UIImage*)image
{

    NSData* imageData = nil;
    if (UIImageJPEGRepresentation(image, 1)) {
        imageData = UIImageJPEGRepresentation(image, 1);
    }
    else {
        imageData = UIImagePNGRepresentation(image);
    }
    NSString* timeNumber = [NSString stringWithFormat:@"%u_%d", arc4random_uniform(1000), (int)[[NSDate date] timeIntervalSince1970]];
    NSString* imageName = [NSString stringWithFormat:@"originalImage%@.jpg", timeNumber];
    NSString* imagePath = [NSString pathWithComponents:@[ [[GYHDMessageCenter sharedInstance] imagefolderNameString], imageName ]];
    [imageData writeToFile:imagePath atomically:YES];

    UIImage* thumbnailsImage = [GYUtils imageCompressForWidth:image targetWidth:300];
    NSData* thumbnailsImageData = nil;
    if (UIImageJPEGRepresentation(thumbnailsImage, 1)) {
        thumbnailsImageData = UIImageJPEGRepresentation(thumbnailsImage, 1);
    }
    else {
        thumbnailsImageData = UIImagePNGRepresentation(thumbnailsImage);
    }

    NSString* thumbnailsImageName = [NSString stringWithFormat:@"thumbnailsImage%@.jpg", timeNumber];
    NSString* thumbnailsImageNamePath = [NSString pathWithComponents:@[ [[GYHDMessageCenter sharedInstance] imagefolderNameString], thumbnailsImageName ]];
    [thumbnailsImageData writeToFile:thumbnailsImageNamePath atomically:YES];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"originalName"] = imageName;
    dict[@"thumbnailsName"] = thumbnailsImageName;
    return dict;
    //                            UIImage *save1 = [UIImage imageWithContentsOfFile:imagePath];
    //                            UIImageWriteToSavedPhotosAlbum(save1, nil, nil, nil);
    //                            UIImage *save2 = [UIImage imageWithContentsOfFile:thumbnailsImageNamePath];
    //                            UIImageWriteToSavedPhotosAlbum(save2, nil, nil, nil);
}

- (void)originalButtonClick:(UIButton*)button
{
    button.selected = !button.selected;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCellID" forIndexPath:indexPath];
    cell.photoModel = self.photoArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{

    GYHDPhotoModel* photoModel = self.photoArray[indexPath.row];
    GYHDPhotoShowView* photoShowView = [[GYHDPhotoShowView alloc] init];
    photoShowView.delegate = self;
    ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:photoModel.photoOriginalImageUrl resultBlock:^(ALAsset* asset) {
        [photoShowView setImage:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
    } failureBlock:^(NSError* error){

    }];
    [photoShowView show];
}

- (void)GYHDPhotoShowView:(UIView*)photoShowView SendImageData:(NSData*)imageData
{
    UIImage* image = [UIImage imageWithData:imageData];
    if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
        [self.delegate GYHDKeyboardSelectBaseView:self sendDict:[self saveImageToBoxWithImage:image] SendType:GYHDKeyboardSelectBaseSendPhoto];
    }
}

/**获得系统相册所有图片*/
- (void)photoFromLibrary
{
    WS(weakSelf);
    __block NSMutableArray* groupArrays = [NSMutableArray array];
    //    __block NSMutableArray *photoArray = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {

            if (group != nil) {
                [groupArrays addObject:group];
            } else {
                [groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {

                        if ([result thumbnail] != nil) {
                            // 照片
                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {

//                                NSDate *date = [result valueForProperty:ALAssetPropertyDate];
                                UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
//                                NSString *fileName = [[result defaultRepresentation] filename];
                                NSURL *url = [[result defaultRepresentation] url];
                                int64_t fileSize = [[result defaultRepresentation] size];



                                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                dict[@"thumbnailImage"] = image;
                                dict[@"originalImageUrl"] = url;
                                dict[@"imageSize"] = @(fileSize);
                                GYHDPhotoModel *photo = [[GYHDPhotoModel alloc] initWithDict:dict];

                                [photo addObserver:self forKeyPath:@"photoSelectStates" options:NSKeyValueObservingOptionNew context:NULL];
                                [weakSelf.photoArray addObject:photo];
                            }
                        }
                    }];
                    // UI的更新记得放在主线程,要不然等子线程排队过来都不知道什么年代了,会很慢的
                    dispatch_async(dispatch_get_main_queue(), ^{

                        [self.photoCollectionView reloadData];
                    });

                }];

            }
        };
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {

            NSString *errorMessage = nil;

            switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage =[GYUtils localizedStringWithKey:@"GYHD_setPrivacyPhoto"];
                break;

            default:
                errorMessage = @"Reason unknown.";
                break;
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:errorMessage
                                                                   delegate:self
                                                          cancelButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_confirm"]
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            });
        };


        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:listGroupBlock failureBlock:failureBlock];
    });
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{

    if ([keyPath isEqualToString:@"photoSelectStates"]) {

        NSInteger sizeCount = 0;
        NSInteger count = 0;
        for (GYHDPhotoModel* photo in self.photoArray) {
            if (photo.photoSelectStates) {
                sizeCount += photo.photoImageSize;
                count++;
            }
        }
        sizeCount = sizeCount / 1024;
        if (sizeCount) {
            self.photoBottomView.hidden = NO;
            [self.originalPhotoButton setTitle:[NSString stringWithFormat:@"%@ (%ldk) ",[GYUtils localizedStringWithKey:@"GYHD_Chat_photo_original_Photo"], (long)sizeCount] forState:UIControlStateSelected];
            [self.sendPhotoButton setTitle:[NSString stringWithFormat:@"%@ (%ld)",[GYUtils localizedStringWithKey:@"GYHD_Send"] ,(long)count] forState:UIControlStateNormal];
        }
        else {
            self.photoBottomView.hidden = YES;
            [self.originalPhotoButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Chat_photo_original_Photo"] forState:UIControlStateSelected];
            [self.sendPhotoButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Send"] forState:UIControlStateNormal];
        }
    }
}

- (void)dealloc
{
    for (GYHDPhotoModel* photo in self.photoArray) {
        [photo removeObserver:self forKeyPath:@"photoSelectStates"];
    }
}

@end
//                            NSData *imageData = nil;
//                            if (UIImageJPEGRepresentation(image, 1)) {
//                                imageData = UIImageJPEGRepresentation(image, 1);
//                            } else {
//                                imageData = UIImagePNGRepresentation(image);
//                            }
//
//
//                            NSDictionary imageDict = [self saveImageToBox];
//                            NSInteger timeNumber = [[NSDate date] timeIntervalSince1970];
//                            NSString *imageName = [NSString stringWithFormat:@"originalImage%ld.jpg",timeNumber];
//                            NSString *imagePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] imagefolderNameString],imageName]];
//                            [imageData writeToFile:imagePath atomically:YES];
//
//                            UIImage *thumbnailsImage = [GYUtils imageCompressForWidth:image targetWidth:150];
//                            NSData *thumbnailsImageData = nil;
//                            if (UIImageJPEGRepresentation(thumbnailsImage, 1)) {
//                                thumbnailsImageData = UIImageJPEGRepresentation(thumbnailsImage, 1);
//                            }else {
//                                thumbnailsImageData = UIImagePNGRepresentation(thumbnailsImage);
//                            }
//
//                            NSString *thumbnailsImageName = [NSString stringWithFormat:@"thumbnailsImage%ld.jpg",timeNumber];
//                            NSString *thumbnailsImageNamePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] imagefolderNameString],thumbnailsImageName]];
//                            [thumbnailsImageData writeToFile:thumbnailsImageNamePath atomically:YES];
//                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                            dict[@"originalImage"] = imagePath;
//                            dict[@"thumbnailsImage"]= thumbnailsImageNamePath;
//
//                            [self.delegate GYHDPhotoView:self DidSendWithDict:dict];
//
//                            UIImage *save1 = [UIImage imageWithContentsOfFile:imagePath];
//                             UIImageWriteToSavedPhotosAlbum(save1, nil, nil, nil);
//                            UIImage *save2 = [UIImage imageWithContentsOfFile:thumbnailsImageNamePath];
//                            UIImageWriteToSavedPhotosAlbum(save2, nil, nil, nil);
//                            GYLoadImg *uploadImg = [[GYLoadImg alloc] init];
//                            [uploadImg uploadImg:image WithIndexPath:nil];
//                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//                            [self.delegate GYHDPhotoView:self DidSendData:imageData];