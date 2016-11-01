//
//  GYHDPhotoSelectViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDPhotoSelectViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "GYHDPhotoModel.h"
#import "GYHDPhotoCell.h"
static NSString* GYHDPhotoCellId  = @"PhotoCellID";

@interface GYHDPhotoSelectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

/**图片展示控制器*/
@property(nonatomic, strong)UICollectionView *photoCollectionView;
/**图片统计按钮*/
@property(nonatomic, strong)UIButton *originalPhotoButton;
/**发送按钮*/
@property(nonatomic, strong)UIButton *sendPhotoButton;
/**图片统计素组*/
@property(nonatomic, strong)NSMutableArray *photoArray;
/**底部View*/
@property(nonatomic, strong)UIView *photoBottomView;

@property(nonatomic,strong)NSMutableArray *sendPhotoArry;//发送图片的数组


@end

@implementation GYHDPhotoSelectViewController

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

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self photoFromLibrary];
    [self initView];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
     layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing =10;
    layout.minimumInteritemSpacing =10;
    
    CGFloat itemWH =(kScreenWidth-60)/5;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    
    self.photoCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-90-105) collectionViewLayout:layout];
      [self.photoCollectionView  registerClass:[GYHDPhotoCell class] forCellWithReuseIdentifier:GYHDPhotoCellId];
    self.photoCollectionView.delegate=self;
    self.photoCollectionView.dataSource=self;
    [self.view addSubview:self.photoCollectionView];
    
    // 原图按钮
    self.originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.originalPhotoButton.frame=CGRectMake(kScreenWidth-370, kScreenHeight-105-60, 200, 36);
    self.originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:20];
    self.originalPhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    self.originalPhotoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.originalPhotoButton setTitleColor:[UIColor colorWithRed:0 green:98/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.originalPhotoButton setTitle:kLocalized(@"GYHD_OriginalPicture") forState:UIControlStateNormal];
    [self.originalPhotoButton setImage:[UIImage imageNamed:@"gyhd_choose_btn_normal"] forState:UIControlStateNormal];
    [self.originalPhotoButton setImage:[UIImage imageNamed:@"gyhd_choose_btn_select"] forState:UIControlStateSelected];
    [self.originalPhotoButton addTarget:self action:@selector(originalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.originalPhotoButton.layer.cornerRadius=10;
    self.originalPhotoButton.clipsToBounds=YES;
    [self.view addSubview:self.originalPhotoButton];
    
        // 发送按钮
        self.sendPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendPhotoButton.frame=CGRectMake(kScreenWidth-180, kScreenHeight-105-60, 160, 36);
        self.sendPhotoButton.titleLabel.font = [UIFont systemFontOfSize:20];
        self.sendPhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.sendPhotoButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send_btn_normal"] forState:UIControlStateNormal];
        [self.sendPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sendPhotoButton setTitle:kLocalized(@"GYHD_Send") forState:UIControlStateNormal];
        [self.sendPhotoButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.sendPhotoButton];

}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHD_Album");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]init]];
    DDLogInfo(@"Load Controller: %@", [self class]);
}
#pragma mark -获取系统相册
/**获得系统相册所有图片*/
- (void)photoFromLibrary
{
    @weakify(self);
    __block  NSMutableArray *groupArrays = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            
            if (group != nil) {
                [groupArrays addObject:group];
            } else {
                [groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        @strongify(self);
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
                                [self.photoArray addObject:photo];
                            }
                        }
                    }];
          
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
                    errorMessage = kLocalized(@"GYHD_Refused_Visit_Album_Please_Open_In_Privacy");
                    break;
                    
                default:
                    errorMessage = @"Reason unknown.";
                    break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:kLocalized(@"GYHD_Error_Unable_To_Access")
                                                                   message:errorMessage
                                                                  delegate:self
                                                         cancelButtonTitle:kLocalized(@"GYHD_Comfirm")
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            });
        };
        
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:listGroupBlock failureBlock:failureBlock];
    });
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYHDPhotoCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:GYHDPhotoCellId forIndexPath:indexPath];
    cell.photoModel = self.photoArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    GYHDPhotoModel *photoModel = self.photoArray[indexPath.row];
//    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
//    [assetLibrary assetForURL:photoModel.photoOriginalImageUrl resultBlock:^(ALAsset *asset)  {
//
//            UIImage *image=[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//       
//        
//        
//    }failureBlock:^(NSError *error) {
//        DDLogCInfo(@"error=%@",error);
//    }];
 
}
-(void)originalButtonClick:(UIButton*)button{

    button.selected = !button.selected;
    
}
#pragma mark -发送图片
- (void)sendButtonClick:(UIButton *)button
{
            @weakify(self);
    if (self.originalPhotoButton.selected) { // 原图发送
        for (GYHDPhotoModel *photo in self.photoArray) {
            if (photo.photoSelectStates) {
                photo.photoSelectStates = NO;
        
                    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
                    [assetLibrary assetForURL:photo.photoOriginalImageUrl resultBlock:^(ALAsset *asset)  {
                        @strongify(self);
                        UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
                        
                        NSURL *url = [[asset defaultRepresentation] url];
                        int64_t fileSize = [[asset defaultRepresentation] size];
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        dict[@"thumbnailImage"] = image;
                        dict[@"original"] = @(YES);
                        dict[@"originalImageUrl"] = url.absoluteString;
                        dict[@"imageSize"] = @(fileSize);
                        if (image) {
                            
                            if (self.block) {
    
                                self.block(dict);
                            }
                            
                        }
                        
                    }failureBlock:^(NSError *error) {
                        DDLogCInfo(@"error=%@",error);
                    }];
 
            }
        }
        
    } else {    // 缩略图发送
        for (GYHDPhotoModel *photo in self.photoArray) {
            
            if (photo.photoSelectStates) {
                photo.photoSelectStates = NO;
//
//                    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
//                    [assetLibrary assetForURL:photo.photoOriginalImageUrl resultBlock:^(ALAsset *asset)  {
//                        
//                        UIImage *photoImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//                        UIImage *image = nil;
//                        if (photoImage.size.width >1080 || photoImage.size.height > 1080) {
//                            
//                            image =  [GYUtils imageCompressForWidth:photoImage targetWidth:1080];
//                            
//                        } else {
//                            image = photoImage;
//                        }
//                        
//                        if (image) {
//                         
//                            
//                        }
//                    }failureBlock:^(NSError *error) {
//                        DDLogCInfo(@"error=%@",error);
//                    }];
                
#pragma  mark - 暂时发送原图
                ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
                [assetLibrary assetForURL:photo.photoOriginalImageUrl resultBlock:^(ALAsset *asset)  {
                                     @strongify(self);
                    UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
                    
                    NSURL *url = [[asset defaultRepresentation] url];
                    int64_t fileSize = [[asset defaultRepresentation] size];
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"thumbnailImage"] = image;
                    dict[@"original"] = @(NO);
                    dict[@"originalImageUrl"] = url.absoluteString;
                    dict[@"imageSize"] = @(fileSize);
                    if (image) {
                        
                        if (self.block) {

                            self.block(dict);
                        }
                        
                    }
                    
                }failureBlock:^(NSError *error) {
                    DDLogCInfo(@"error=%@",error);
                }];

            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    selectImageCount = 0;
    
    [self.photoCollectionView reloadData];
}
#pragma mark -监听图片选择状态
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
            
            [self.originalPhotoButton setTitle:[NSString stringWithFormat:@"%@ (%ldk) ",kLocalized(@"GYHD_OriginalPicture"),sizeCount] forState:UIControlStateSelected];
    [self.sendPhotoButton setTitle:[NSString stringWithFormat:@"%@ (%ld)",kLocalized(@"GYHD_Send"),count] forState:UIControlStateNormal];
        } else {
            self.photoBottomView.hidden = YES;
            [self.originalPhotoButton setTitle:[NSString stringWithFormat:kLocalized(@"GYHD_OriginalPicture")] forState:UIControlStateSelected];
            [self.sendPhotoButton setTitle:[NSString stringWithFormat:kLocalized(@"GYHD_Send")] forState:UIControlStateNormal];
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
