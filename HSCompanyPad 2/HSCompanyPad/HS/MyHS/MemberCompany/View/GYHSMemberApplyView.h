//
//  GYHSMemberApplyView.h
//
//  Created by apple on 16/8/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYPlaceholderTextView;
@protocol GYHSMemberApplyDelegate <NSObject>

- (void)actionSheetWithIndex:(NSInteger)index;
- (void)applyViewDidClickDownLoadButton:(UIButton *)downLoadButton;

-(void)viewControllerWithPictureAndCamera;

@end
@interface GYHSMemberApplyView : UIView
@property (nonatomic,weak) id<GYHSMemberApplyDelegate>delegate;
@property (nonatomic,strong)  GYPlaceholderTextView * textView;
- (void)showImage:(UIImage *)image;
@end
                                                