//
//  GYUploadImagTool.m
//  company
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYPhotoPickerService.h"
#import "UIActionSheet+Blocks.h"
#import "GYKitCommon.h"

@interface GYPhotoPickerService () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, copy) NSString* fullPath;
@property (nonatomic, copy) GYPhotoPickerServiceBlock block;
@property (nonatomic, assign) NSInteger imageSize;

@end

@implementation GYPhotoPickerService

+ (GYPhotoPickerService*)uploadImageWithController:(UIViewController*)controller imageName:(NSString*)imageName fileSize:(NSInteger)imageSize uploadBlock:(GYPhotoPickerServiceBlock)block
{
    GYPhotoPickerService* tool = [[GYPhotoPickerService alloc] initWithController:controller imageName:imageName fileSize:(NSInteger)imageSize uploadBlock:block];
    return tool;
}

- (instancetype)initWithController:(UIViewController*)controller imageName:(NSString*)imageName fileSize:(NSInteger)imageSize uploadBlock:(GYPhotoPickerServiceBlock)block
{

    if (self = [super init]) {
        self.imageName = imageName;
        self.block = block;
        self.imageSize = imageSize;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [UIActionSheet showInView:controller.view
                             withTitle:nil
                     cancelButtonTitle:[GYKitCommon localizedStringForKey:@"GYKitOhterCancel" withDefault:@"取消"]
                destructiveButtonTitle:nil
                     otherButtonTitles:@[ [GYKitCommon localizedStringForKey:@"GYKitOhterPhoto" withDefault:@"照片"], [GYKitCommon localizedStringForKey:@"GYKitOhterCamel" withDefault:@"相机"], [GYKitCommon localizedStringForKey:@"GYKitOhterAlbum" withDefault:@"相薄"] ]
                              tapBlock:^(UIActionSheet* _Nonnull actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex == 0) {
                                     UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
                                     //图片来源 相册 相机
                                     ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                     ipc.delegate = self;
                                     [controller presentViewController:ipc animated:YES completion:nil];
                                     
                                 } else if (buttonIndex == 1) {
                                     UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
                                     ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
                                     ipc.delegate = self;
                                     [controller presentViewController:ipc animated:YES completion:nil];
                                 } else if (buttonIndex == 2) {
                                     UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
                                     ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                     ipc.delegate = self;
                                     [controller presentViewController:ipc animated:YES completion:nil];
                                 }
                              }];
        }
        else {
            [UIActionSheet showInView:controller.view
                             withTitle:nil
                     cancelButtonTitle:[GYKitCommon localizedStringForKey:@"GYKitOhterCancel" withDefault:@"取消"]
                destructiveButtonTitle:nil
                     otherButtonTitles:@[ [GYKitCommon localizedStringForKey:@"GYKitOhterPhoto" withDefault:@"照片"],  [GYKitCommon localizedStringForKey:@"GYKitOhterAlbum" withDefault:@"相薄"] ]
                              tapBlock:^(UIActionSheet* _Nonnull actionSheet, NSInteger buttonIndex) {
                              
                                 if (buttonIndex == 0) {
                                     UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
                                     //图片来源 相册
                                     ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                     
                                     [controller presentViewController:ipc
                                                              animated:YES
                                                            completion:^{
                                                                ipc.delegate = self;
                                                            }];
                                 } else if (buttonIndex == 1) {
                                     UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
                                     ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                     ipc.delegate = self;
                                     [controller presentViewController:ipc animated:YES completion:nil];
                                 }
                              }];
        }
    }
    return self;
}

#pragma mark - UIImagePickerControllerDelegate
#pragma mark
//选择图片调用
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    //取得图片
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveImage:image withName:self.imageName];
    NSFileManager* fm = [NSFileManager defaultManager];
    long long fSize = 0;
    if ([fm fileExistsAtPath:self.fullPath]) {
        fSize = [[fm attributesOfItemAtPath:self.fullPath error:nil] fileSize];
    }
    if (fSize > self.imageSize * 1024 * 1024) {
        CGFloat x = (self.imageSize * 1024 * 1024) / fSize;
        NSData* imageData = UIImageJPEGRepresentation(image, x);
        // 将图片写入文件
        [imageData writeToFile:self.fullPath atomically:NO];
    }
    
    if (self.block) {
        self.block(image, self.fullPath);
    }
}

//点击取消按钮调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//保存图片至沙盒
- (void)saveImage:(UIImage*)currentImage withName:(NSString*)imageName
{
    self.fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSData* imageData = UIImageJPEGRepresentation(currentImage, 1);
    // 将图片写入文件
    [imageData writeToFile:self.fullPath atomically:NO];
}


@end
