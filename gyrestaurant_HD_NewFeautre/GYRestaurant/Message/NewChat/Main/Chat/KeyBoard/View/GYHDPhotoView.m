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
//#import "UIImage+Rotate.h"
//#import "GYLoadImg.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface GYHDPhotoView ()<UICollectionViewDataSource,UICollectionViewDelegate,GYHDPhotoShowViewDelegate>
/**图片展示控制器*/
@property(nonatomic, weak)UICollectionView *photoCollectionView;
/**图片统计按钮*/
@property(nonatomic, weak)UIButton *originalPhotoButton;
/**发送按钮*/
@property(nonatomic, weak)UIButton *sendPhotoButton;
/**图片统计素组*/
@property(nonatomic, strong)NSMutableArray *photoArray;
/**底部View*/
@property(nonatomic, weak)UIView *photoBottomView;

@property(nonatomic,strong)NSMutableArray *sendPhotoArry;//发送图片的数组

@end

@implementation GYHDPhotoView
- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

-(NSMutableArray *)sendPhotoArry{

    if (!_sendPhotoArry) {
        _sendPhotoArry = [NSMutableArray array];
    }
    return _sendPhotoArry;

}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void) setup
{
    [self photoFromLibrary];
    
    //1. 展示photoView
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWH =(kScreenWidth-250 -6) /4;
    layout.minimumLineSpacing =0;
    layout.minimumInteritemSpacing = 0;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    WS(weakSelf);
    
    //代理设置
    collect.delegate=self;
    collect.dataSource=self;
    //注册item类型 这里使用系统的类型
    [collect registerClass:[GYHDPhotoCell class] forCellWithReuseIdentifier:@"PhotoCellID"];
    [self addSubview:collect];
    _photoCollectionView = collect;
    collect.backgroundColor = [UIColor whiteColor
                               ];
    [collect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    
    
    UIView *photoBottomView = [[UIView alloc] init];
    photoBottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:photoBottomView];
    _photoBottomView = photoBottomView;
    photoBottomView.hidden = YES;
    [photoBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    // 原图按钮
    UIButton *originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    originalPhotoButton.backgroundColor = [UIColor whiteColor];
    originalPhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    originalPhotoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [originalPhotoButton setTitleColor:[UIColor colorWithRed:0 green:167.0/255.0 blue:215.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [originalPhotoButton setTitle:@"原图" forState:UIControlStateNormal];
    [originalPhotoButton setImage:[UIImage imageNamed:@"HD_unSelect"] forState:UIControlStateNormal];
    [originalPhotoButton setImage:[UIImage imageNamed:@"HD_singleSelect"] forState:UIControlStateSelected];
    [originalPhotoButton addTarget:self action:@selector(originalButtonClick:) forControlEvents:UIControlEventTouchDown];
    originalPhotoButton.layer.cornerRadius=10;
    originalPhotoButton.clipsToBounds=YES;
    [self addSubview:originalPhotoButton];
    _originalPhotoButton = originalPhotoButton;
    [originalPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(-10);
        make.size.mas_equalTo(CGSizeMake(120, 30));
        make.bottom.mas_equalTo(weakSelf).offset(-30);
        
    }];
//    // 发送按钮
//    UIButton *sendPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    sendPhotoButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
//    sendPhotoButton.backgroundColor = [UIColor whiteColor];
//    sendPhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [sendPhotoButton setTitleColor:[UIColor colorWithRed:0 green:167.0/255.0 blue:215.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [sendPhotoButton setTitle:@"发送" forState:UIControlStateNormal];
//    [sendPhotoButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [photoBottomView addSubview:sendPhotoButton];
//    _sendPhotoButton = sendPhotoButton;
//    [sendPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.equalTo(photoBottomView);
//        make.size.mas_equalTo(CGSizeMake(200, 30));
//        
//    }];
}
- (void)sendButtonClick:(UIButton *)button
{

    if (self.originalPhotoButton.selected) { // 原图发送
        for (GYHDPhotoModel *photo in self.photoArray) {
            if (photo.photoSelectStates) {
                photo.photoSelectStates = NO;
                
                if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
                        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
                        [assetLibrary assetForURL:photo.photoOriginalImageUrl resultBlock:^(ALAsset *asset)  {

                            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                            
                            [self.delegate GYHDKeyboardSelectBaseView:self sendDict:[self saveImageToBoxWithImage:image] SendType:GYHDKeyboardSelectBaseSendPhoto];
                        }failureBlock:^(NSError *error) {
                            DDLogCInfo(@"error=%@",error);
                        }];
                }
                
            }
        }
        
    } else {    // 缩略图发送
        for (GYHDPhotoModel *photo in self.photoArray) {
            
            if (photo.photoSelectStates) {
                photo.photoSelectStates = NO;
                
                if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
                        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
                        [assetLibrary assetForURL:photo.photoOriginalImageUrl resultBlock:^(ALAsset *asset)  {
    
                            UIImage *photoImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                            UIImage *image = nil;
                            if (photoImage.size.width >1080 || photoImage.size.height > 1080) {
                                image =  [Utils imageCompressForWidth:photoImage targetWidth:1080];
                            } else {
                                image = photoImage;
                            }
                            
                            [self.delegate GYHDKeyboardSelectBaseView:self sendDict:[self saveImageToBoxWithImage:image] SendType:GYHDKeyboardSelectBaseSendPhoto];
                        }failureBlock:^(NSError *error) {
                            DDLogCInfo(@"error=%@",error);
                        }];
                }
            }
        }
    }

    selectImageCount = 0;

    [self.photoCollectionView reloadData];
}
/**保存图片到沙盒*/
- (NSDictionary *)saveImageToBoxWithImage:(UIImage *)image
{
    

    NSData *imageData = nil;
    if (UIImageJPEGRepresentation(image, 1)) {
        imageData = UIImageJPEGRepresentation(image, 1);
    } else {
        imageData = UIImagePNGRepresentation(image);
    }
    NSInteger timeNumber = arc4random_uniform(1000)+[[NSDate date] timeIntervalSince1970];
    NSString *imageName = [NSString stringWithFormat:@"originalImage%ld.jpg",timeNumber];
    NSString *imagePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] imagefolderNameString],imageName]];
    [imageData writeToFile:imagePath atomically:NO];
    
    UIImage *thumbnailsImage = [Utils imageCompressForWidth:image targetWidth:300];
    NSData *thumbnailsImageData = nil;
    if (UIImageJPEGRepresentation(thumbnailsImage, 1)) {
        thumbnailsImageData = UIImageJPEGRepresentation(thumbnailsImage, 1);
    }else {
        thumbnailsImageData = UIImagePNGRepresentation(thumbnailsImage);
    }
    
    NSString *thumbnailsImageName = [NSString stringWithFormat:@"thumbnailsImage%ld.jpg",timeNumber];
    NSString *thumbnailsImageNamePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] imagefolderNameString],thumbnailsImageName]];
    [thumbnailsImageData writeToFile:thumbnailsImageNamePath atomically:NO];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"originalName"] = imageName;
    dict[@"thumbnailsName"]= thumbnailsImageName;
    return dict;
    //                            UIImage *save1 = [UIImage imageWithContentsOfFile:imagePath];
    //                            UIImageWriteToSavedPhotosAlbum(save1, nil, nil, nil);
    //                            UIImage *save2 = [UIImage imageWithContentsOfFile:thumbnailsImageNamePath];
    //                            UIImageWriteToSavedPhotosAlbum(save2, nil, nil, nil);
}

- (void)originalButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYHDPhotoCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCellID" forIndexPath:indexPath];
    cell.photoModel = self.photoArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    GYHDPhotoModel *photoModel = self.photoArray[indexPath.row];
    GYHDPhotoShowView *photoShowView = [[GYHDPhotoShowView alloc] init];
    photoShowView.delegate = self;
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:photoModel.photoOriginalImageUrl resultBlock:^(ALAsset *asset)  {
        [photoShowView setImage:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
    }failureBlock:^(NSError *error) {
        DDLogCInfo(@"error=%@",error);
    }];
    [photoShowView show];
}


- (void)GYHDPhotoShowView:(UIView *)photoShowView SendImageData:(NSData *)imageData
{
    UIImage *image = [UIImage imageWithData:imageData];
    if ([self.delegate respondsToSelector:@selector(GYHDKeyboardSelectBaseView:sendDict:SendType:)]) {
        [self.delegate GYHDKeyboardSelectBaseView:self sendDict:[self saveImageToBoxWithImage:image] SendType:GYHDKeyboardSelectBaseSendPhoto];
    }
}
/**获得系统相册所有图片*/
- (void)photoFromLibrary
{
    WS(weakSelf);
    __block  NSMutableArray *groupArrays = [NSMutableArray array];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            
            if (group != nil) {
                [groupArrays addObject:group];
            } else {
                [groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        
                        if ([result thumbnail] != nil) {
                            // 照片
                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
                                

                                UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];

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
                    errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
                    break;
                    
                default:
                    errorMessage = @"Reason unknown.";
                    break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问!"
                                                                   message:errorMessage
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            });
        };
        
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:listGroupBlock failureBlock:failureBlock];
    });
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if([keyPath isEqualToString:@"photoSelectStates"])
    {
        NSInteger sizeCount = 0;
        NSInteger count = 0;
        [self.sendPhotoArry removeAllObjects];
        for (GYHDPhotoModel *photo in self.photoArray) {
            if (photo.photoSelectStates) {
                sizeCount += photo.photoImageSize;
                count++;
                [self.sendPhotoArry addObject:photo];
            }
        }
        sizeCount = sizeCount / 1024;
        if (sizeCount) {
//            隐藏底部发送按钮
//            self.photoBottomView.hidden = NO;
            [self.originalPhotoButton setTitle:[NSString stringWithFormat:@"原图 (%ldk) ",sizeCount] forState:UIControlStateSelected];

            if (self.delegate && [self.delegate respondsToSelector:@selector(GYHDKeyboardSendBtnCount:potoArry:isoriginalPhoto:)]) {
                if (self.originalPhotoButton.selected) {
                    
                    [self.delegate GYHDKeyboardSendBtnCount:count potoArry:self.sendPhotoArry isoriginalPhoto:YES];
                }else{
                
                [self.delegate GYHDKeyboardSendBtnCount:count potoArry:self.sendPhotoArry isoriginalPhoto:NO];
                
                }
                
            }
//            [self.sendPhotoButton setTitle:[NSString stringWithFormat:@"发送 (%ld)",count] forState:UIControlStateNormal];
        } else {
            self.photoBottomView.hidden = YES;
            [self.originalPhotoButton setTitle:[NSString stringWithFormat:@"原图"] forState:UIControlStateSelected];
//            [self.sendPhotoButton setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];

            if (self.delegate && [self.delegate respondsToSelector:@selector(GYHDKeyboardSendBtnCount:potoArry:isoriginalPhoto:)]) {
                if (self.originalPhotoButton.selected) {
                    
                    [self.delegate GYHDKeyboardSendBtnCount:count potoArry:self.sendPhotoArry isoriginalPhoto:YES];
                }else{
                    
                    [self.delegate GYHDKeyboardSendBtnCount:count potoArry:self.sendPhotoArry isoriginalPhoto:NO];
                    
                }
                
            }
        }
    }
}

- (void)dealloc
{
    for (GYHDPhotoModel *photo in self.photoArray) {
        [photo removeObserver:self forKeyPath:@"photoSelectStates"];
    }
}
@end