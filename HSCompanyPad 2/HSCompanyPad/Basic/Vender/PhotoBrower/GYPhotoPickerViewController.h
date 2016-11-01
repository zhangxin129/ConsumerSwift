//
//  ImagePickerViewController.h
//  DaGeng
//
//  Created by fu on 15/5/14.
//  Copyright (c) 2015年 fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol GYPhotoPickerViewControllerDelegate;

@interface GYPhotoPickerViewController : UIViewController 

@property (nonatomic, assign) id<GYPhotoPickerViewControllerDelegate> delegate;

@end

@protocol GYPhotoPickerViewControllerDelegate <NSObject>
@optional

/**
 *  点击确定的回调
 *
 *  @param assetArray 选中的照片的url数组
 */
- (void)imagePickerViewController:(GYPhotoPickerViewController*)ivc imageAsset:(ALAsset*)asset;

/**
 *  点击第一张图片（照相机）的回调
 *
 *  @param image 拍照的image
 */
- (void)imagePickerViewControllerCamera: (GYPhotoPickerViewController *)ivc;


@end
