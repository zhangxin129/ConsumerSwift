//
//  GYGetPhotoView.h
//  HSConsumer
//
//  Created by kuser on 16/7/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYGetPhotoView;
@protocol GYGetPhotoViewDelegate <NSObject>

- (void)takePhotoBtnClickDelegate;
- (void)getBlumBtnClickDelegate;
- (void)cancelBtnClickDelegate;

@end

@interface GYGetPhotoView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgColor;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;  //拍照
@property (weak, nonatomic) IBOutlet UIButton *getBlumBtn;   //相册
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;    //取消
@property (nonatomic, weak) id<GYGetPhotoViewDelegate> delegate;

@end
