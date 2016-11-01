//
//  GYUploadPhotoProgressView.h
//  HSCompanyPad
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYUploadPhotoProgressView : UIView
+ (void)show;
+ (void)dismiss;
+ (void)didProgress:(CGFloat)progress;
@end
