//
//  GYUploadImagTool.h
//  company
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GYPhotoPickerServiceBlock)(UIImage* image, NSString* fullPath);

@interface GYPhotoPickerService : NSObject

/*!
 *    @author wangbb
 *
 *    注意：GYUploadImageHttpTool的对象 需要一直持有，转跳界面时才不会释放
 *
 *    @param controller 转跳到相册界面之前的控制器
 *    @param imageName  命名一个图片的名字
 *    @param imageSize  设定限制上传图片的大小
 *    @param block      image: 返回界面时的图片 fullPath：返回界面时的图片所在沙盒路径
 *
 *    @return GYUploadImageHttpTool的对象
 */
+ (GYPhotoPickerService*)uploadImageWithController:(UIViewController*)controller imageName:(NSString*)imageName fileSize:(NSInteger)imageSize uploadBlock:(GYPhotoPickerServiceBlock)block;

@end
