//
//  PhotoViewController.h
//  AssetsLibraryDemo
//
//  Created by coderyi on 14-10-16.
//  Copyright (c) 2014年 coderyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface GYPhotoViewController : UIViewController
@property ALAssetsGroup *group;
@property(nonatomic,assign)BOOL isFromCustomer;
@end
