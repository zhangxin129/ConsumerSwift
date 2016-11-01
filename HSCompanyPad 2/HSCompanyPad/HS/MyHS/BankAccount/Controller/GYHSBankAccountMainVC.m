//
//  GYHSBankAccountMainVC.m
//
//  Created by apple on 16/8/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSBankAccountMainVC.h"
#import "GYHSBankAccountAddVC.h"
#import "GYHSBankAccountDetialVC.h"
#import "GYHSBankListModel.h"
#import "GYHSCollectBankAddCell.h"
#import "GYHSCollectBankCell.h"
#import "GYHSCollectBankOpenCell.h"
#import "GYHSmyhsHttpTool.h"
#import "GYHSMainViewController.h"
#import "GYPhotoPickerViewController.h"
#import "GYHSDocModel.h"
#import <GYKit/GYPhotoGroupView.h>
#import <MJExtension/MJExtension.h>
#define kTopHeight 70
#define kMargin 37
#define kCollectItemHeight 193
#define kMaxBankNmuber 5
@interface GYHSBankAccountMainVC () <UICollectionViewDataSource, UICollectionViewDelegate, GYHSCollectBanClickDelegate, GYHSBankAddDelegate, GYNetworkReloadDelete, GYHSCollectBankOpenDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GYPhotoPickerViewControllerDelegate>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) GYHSCollectBankOpenCell* openCell;
@property (nonatomic, strong) NSString* openLicenseFile; //开户许可证
@end

@implementation GYHSBankAccountMainVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout:^{
        @strongify(self);
        [self addNoticce];
        [self initView];
        [self request];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)dealloc
{
    [kDefaultNotificationCenter removeObserver:self];
}

- (void)addNoticce
{
    [kDefaultNotificationCenter addObserver:self selector:@selector(request) name:GYChangeBankCardOrChageMainHSNotification object:nil];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Myhs_Bank_Account");
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - 银行列表请求
- (void)request
{
    [GYNetwork sharedInstance].delegate = self;
    @weakify(self);
    [GYHSmyhsHttpTool getCompanyBindAccountListWithSuccess:^(id responsObject) {
        @strongify(self);
        [self.dataArray removeAllObjects];
        for (NSDictionary* temp in responsObject[@"banks"]) {
            GYHSBankListModel* model = [[GYHSBankListModel alloc] initWithDictionary:temp error:nil];
            [model getLocation:nil];
            [self.dataArray addObject:model];
        }
        self.openLicenseFile = kSaftToNSString(responsObject[@"accountLicenseImg"]);
        [self.collectionView reloadData];
        
    }
        failure:^{
        
        }];
}

#pragma mark - GYNetworkReloadDelete
- (void)gyNetworkDidTapReloadBtn
{
    [self request];
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count < kMaxBankNmuber ? self.dataArray.count + 2 : self.dataArray.count + 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.dataArray.count < kMaxBankNmuber) {
        if (indexPath.row == self.dataArray.count) {
            GYHSCollectBankAddCell* addCell = [collectionView dequeueReusableCellWithReuseIdentifier:bankAddCollectCell forIndexPath:indexPath];
            addCell.addNumber = kMaxBankNmuber - self.dataArray.count;
            addCell.delegate = self;
            return addCell;
        }
        else if (indexPath.row == self.dataArray.count + 1) {
            GYHSCollectBankOpenCell* openCell = [collectionView dequeueReusableCellWithReuseIdentifier:bankOpenCollectCell forIndexPath:indexPath];
            if (self.openLicenseFile.length) {
                NSString* urlStr = GY_PICTUREAPPENDING(self.openLicenseFile);
                openCell.openLabel.hidden = YES;
                [openCell.openImage setImageWithURL:[NSURL URLWithString:urlStr] placeholder:nil options:kNilOptions completion:nil];

            }
            openCell.delegate = self;
            return openCell;
        }
    }
    else {
        if (indexPath.row == self.dataArray.count) {
            GYHSCollectBankOpenCell* openCell = [collectionView dequeueReusableCellWithReuseIdentifier:bankOpenCollectCell forIndexPath:indexPath];
            if (self.openLicenseFile.length) {
                NSString* urlStr = GY_PICTUREAPPENDING(self.openLicenseFile);
                openCell.openLabel.hidden = YES;
                [openCell.openImage setImageWithURL:[NSURL URLWithString:urlStr] placeholder:nil options:kNilOptions completion:nil];
            }
            openCell.delegate = self;
            return openCell;
        }
    }
    
    GYHSCollectBankCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:bankCollectCell forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger numbers = [self collectionView:collectionView numberOfItemsInSection:indexPath.section];
    if (indexPath.row != numbers - 1) {
        Class collectClass = [[self collectionView:collectionView cellForItemAtIndexPath:indexPath] class];
        if (([collectClass class] == [GYHSCollectBankCell class])) {
            if (_delegate && [_delegate respondsToSelector:@selector(selectBankAccountWithModel:)]) {
                [_delegate selectBankAccountWithModel:self.dataArray[indexPath.row]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake((self.view.width - 4 * kMargin) / 3, kCollectItemHeight);
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kTopHeight, kMargin, 0, kMargin);
}

#pragma mark - GYHSCollectBanClickDelegate
- (void)collectBankClick:(NSInteger)index model:(GYHSBankListModel*)model
{
    //1、详情 2、删除
    if (index == 1) {
        GYHSBankAccountDetialVC* bankDetialVC = [[GYHSBankAccountDetialVC alloc] init];
        bankDetialVC.model = model;
        [self.navigationController pushViewController:bankDetialVC animated:YES];
    }
    else if (index == 2) {
        [GYAlertView alertWithTitle:kLocalized(@"GYHS_Myhs_Warm_Tip") Message:kLocalized(@"GYHS_Myhs_Is_Delete_Bank") topColor:TopColorRed comfirmBlock:^{
            //删除银行卡操作
            [self deleteBank:model];
        }];
    }
}

#pragma mark - GYHSBankAddDelegate
- (void)bankAddClick
{
    //添加银行账户
    GYHSBankAccountAddVC* bankAddVC = [[GYHSBankAccountAddVC alloc] init];
    [self.navigationController pushViewController:bankAddVC animated:YES];
}

#pragma mark - 删除银行卡
- (void)deleteBank:(GYHSBankListModel*)model
{
    [GYHSmyhsHttpTool unBindBankWithAccId:model.accId
        success:^(id responsObject) {
                                      [self request];
                                      [kDefaultNotificationCenter postNotification:[NSNotification notificationWithName:GYChangeBankCardOrChageMainHSNotification object:nil]];
                                       [kDefaultNotificationCenter postNotification:[NSNotification notificationWithName:GYDeleteBankCardSNotification object:model]];
        }
        failure:^{
        
        }];
}

#pragma mark - GYHSCollectBankOpenDelegate
- (void)clickWithButtonTag:(NSInteger)tag cell:(GYHSCollectBankOpenCell*)cell
{
    self.openCell = cell;
    if (tag == 1) {
        GYPhotoPickerViewController* vc = [[GYPhotoPickerViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tag == 2) {
        //查看示例图片
        [GYHSmyhsHttpTool getQueryImageDocListWithSuccess:^(id responsObject) {
            for (NSDictionary *dic in responsObject) {
                GYHSDocModel *model = [GYHSDocModel mj_objectWithKeyValues:dic];
                if (model.docIdentify == GYHSExampleDocBankLicense) {
                    NSString *url = GY_PICTUREAPPENDING(model.docUrl);
                    GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
                    item.largeImageURL = [NSURL URLWithString:url];
                    UIButton * btn = (UIButton *)[cell viewWithTag:tag];
                    item.thumbView = btn;
                    
                    GYPhotoGroupView* photoGroupView = [[GYPhotoGroupView alloc] initWithGroupItems:@[ item ]];
                    [photoGroupView presentFromImageView:btn toContainer:self.view animated:YES completion:nil];
                    
                }
            }
        } failure:^{
        
        }];
    }
    else if (tag == 3) {
        //查看开户许可证
        if (self.openLicenseFile.length) {
            NSString* url = GY_PICTUREAPPENDING(self.openLicenseFile);
            GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
            item.largeImageURL = [NSURL URLWithString:url];
            UIImageView* image = [cell viewWithTag:tag];
            item.thumbView = image;
            GYPhotoGroupView* photoGroupView = [[GYPhotoGroupView alloc] initWithGroupItems:@[ item ]];
            [photoGroupView presentFromImageView:image toContainer:self.view animated:YES completion:nil];
        }
    }
}

/**
 *  点击图片选择器的确定按钮
 */
- (void)imagePickerViewController:(GYPhotoPickerViewController*)ivc imageAsset:(ALAsset*)asset
{

    // 使用asset来获取本地图片
    ALAssetRepresentation* assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage* selectImage = [UIImage imageWithCGImage:imgRef
                                               scale:assetRep.scale
                                         orientation:(UIImageOrientation)assetRep.orientation];
                                         
    // 获取图片名称
    NSURL* iamgeUrl = [asset valueForProperty:ALAssetPropertyAssetURL];
    NSString* strUrl = [iamgeUrl absoluteString];
    NSRange rangeOne = [strUrl rangeOfString:@"="];
    NSRange rangeTwo = [strUrl rangeOfString:@"&"];
    NSString* name = [strUrl substringWithRange:NSMakeRange(rangeOne.location + 1, rangeTwo.location - rangeOne.location - 1)];
    NSString* strType = [strUrl substringFromIndex:strUrl.length - 3];
    NSString* imageName = [NSString stringWithFormat:@"%@.%@", name, strType];
    NSData* imageData = UIImageJPEGRepresentation(selectImage, 0.5);
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
                //[picker dismissViewControllerAnimated:YES completion:nil];
            }];
            [fm removeItemAtPath:fullPath error:nil];
            return;
        }
    }
    
    //    [picker dismissViewControllerAnimated:YES completion:nil];
    @weakify(self);
    [GYHSmyhsHttpTool uploadImageWithUrl:upLoadPictureUrl
        params:nil
        imageData:imageData
        imageName:@"bankAppply"
        success:^(id responsObject) {
               @strongify(self);
                                     self.openCell.openLabel.hidden = YES;
                                     self.openCell.openImage.image = selectImage;
                                     self.openLicenseFile = responsObject[GYNetWorkDataKey];
                           [GYHSmyhsHttpTool saveBankOpenLiceseWithFile:self.openLicenseFile success:^(id responsObject) {
//                               [self.collectionView reloadData];
                               NSInteger allItems = [self.collectionView numberOfItemsInSection:0];
                               [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:allItems - 1 inSection:0]]];
                           } failure:^{
                           
                           }];
                           
        }
        failure:^{
        
        }];
}
/**
 *  选择相机
 *
 *  @param ivc 前面控制器视图
 */
- (void)imagePickerViewControllerCamera:(GYPhotoPickerViewController*)ivc
{
    UIImagePickerController* pickCtl = [[UIImagePickerController alloc] init];
    pickCtl.allowsEditing = YES;
    pickCtl.delegate = self;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [GYUtils showToast:kLocalized(@"GYHS_Myhs_No_Support")];
        return;
    }
    pickCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickCtl.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.navigationController presentViewController:pickCtl animated:YES completion:nil];
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
    
    @weakify(self);
    [GYHSmyhsHttpTool uploadImageWithUrl:upLoadPictureUrl
                                  params:nil
                               imageData:imageData
                               imageName:@"bankAppply"
                                 success:^(id responsObject) {
                                     @strongify(self);
                                     self.openCell.openLabel.hidden = YES;
                                     self.openCell.openImage.image = selectImage;
                                     self.openLicenseFile = responsObject[GYNetWorkDataKey];
                                     [GYHSmyhsHttpTool saveBankOpenLiceseWithFile:self.openLicenseFile success:^(id responsObject) {
//                                         [self.collectionView reloadData];
                                         NSInteger allItems = [self.collectionView numberOfItemsInSection:0];
                                         [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:allItems - 1 inSection:0]]];
                                     } failure:^{
                                         
                                     }];
                                     
                                 }
                                 failure:^{
                                     
                                 }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController* pickCtl = [[UIImagePickerController alloc] init];
    pickCtl.allowsEditing = YES;
    pickCtl.delegate = self;
    switch (buttonIndex) {
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
        [self.navigationController presentViewController:pickCtl animated:YES completion:nil];
    }];
}

#pragma mark - lazy load
- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayOut];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSCollectBankCell class]) bundle:nil] forCellWithReuseIdentifier:bankCollectCell];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSCollectBankAddCell class]) bundle:nil] forCellWithReuseIdentifier:bankAddCollectCell];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSCollectBankOpenCell class]) bundle:nil] forCellWithReuseIdentifier:bankOpenCollectCell];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
