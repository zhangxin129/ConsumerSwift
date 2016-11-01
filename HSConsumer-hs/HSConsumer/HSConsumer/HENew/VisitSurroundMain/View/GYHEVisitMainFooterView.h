//
//  GYHEVisitMainFooterView.h
//  HSConsumer
//
//  Created by lizp on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kImageTag 700

#define kGYHEVisitMainFooterViewIdentifier @"GYHEVisitMainFooterView"

@class GYHEVisitTakeOutControl;
@protocol GYHEVisitMainFooterViewDelegate<NSObject>

@optional

/**
 *  外卖频道
 */
-(void)takeOutClick;

/**
 *  外卖频道 下面按钮
 */
-(void)takeOutControl:(GYHEVisitTakeOutControl *)control;

/**
 *  图片点击调用
 *
 *  @param index index 为照片的下标
 */
-(void)selectImageIndex:(NSInteger)index;


@end

#import <UIKit/UIKit.h>


@interface GYHEVisitMainFooterView : UICollectionReusableView

@property (nonatomic,strong) NSArray *imageArr;//滚动图片
@property (nonatomic,weak) id<GYHEVisitMainFooterViewDelegate>delegate;


@end
