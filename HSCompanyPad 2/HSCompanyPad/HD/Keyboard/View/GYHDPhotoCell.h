//
//  GYHDPhotoCell.h
//  HSConsumer
//
//  Created by shiang on 16/2/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
/**选中图片统计*/
extern  int selectImageCount;
@class  GYHDPhotoModel;
@interface GYHDPhotoCell : UICollectionViewCell
@property(nonatomic, strong)GYHDPhotoModel *photoModel;

@end
