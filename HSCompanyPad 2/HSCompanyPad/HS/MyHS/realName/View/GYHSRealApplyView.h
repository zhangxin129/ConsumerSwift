//
//  GYHSRealApplyView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYPlaceholderTextView,GYHSIdentifyCode,GYHSCunsumeTextField;
@protocol GYHSRealApplyDelegate <NSObject>

- (void)actionPictureWithIndex:(NSInteger)index;
- (void)showBigPicture:(UIButton *)btn;
-(void)viewControllerWithPictureAndCamera;
@end
@interface GYHSRealApplyView : UIView
@property (nonatomic,strong)  GYPlaceholderTextView * textView;
@property (nonatomic,weak) GYHSIdentifyCode * codeView;
@property (nonatomic,weak) GYHSCunsumeTextField * inputCodeField;
@property (nonatomic,weak) id<GYHSRealApplyDelegate> delegate;
@property (nonatomic,copy) NSString * codeString;
- (void)showImage:(UIImage *)image;

@end
