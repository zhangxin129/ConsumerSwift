//
//  GYHDPhotoModel.h
//  HSConsumer
//
//  Created by shiang on 16/2/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDPhotoModel : NSObject
/**缩略图片*/
@property (nonatomic, strong, readonly) UIImage* photoThumbnailImage;
/**原图*/
@property (nonatomic, strong, readonly) UIImage* photoOriginalImage;
/**系统相册原图Url*/
@property (nonatomic, strong, readonly) NSURL* photoOriginalImageUrl;
/**图片大小*/
@property (nonatomic, assign, readonly) NSInteger photoImageSize;
@property (nonatomic, assign, getter=isSelectStates) BOOL photoSelectStates;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
