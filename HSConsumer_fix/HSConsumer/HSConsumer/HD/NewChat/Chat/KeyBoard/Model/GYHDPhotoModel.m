//
//  GYHDPhotoModel.m
//  HSConsumer
//
//  Created by shiang on 16/2/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPhotoModel.h"

@implementation GYHDPhotoModel
- (instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        _photoThumbnailImage = dict[@"thumbnailImage"];
        _photoOriginalImage = dict[@"originalImage"];
        _photoOriginalImageUrl = dict[@"originalImageUrl"];
        _photoImageSize = [dict[@"imageSize"] integerValue];
        _photoSelectStates = NO;
    }
    return self;
}

@end
