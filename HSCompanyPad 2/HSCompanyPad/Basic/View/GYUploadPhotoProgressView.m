//
//  GYUploadPhotoProgressView.m
//  HSCompanyPad
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYUploadPhotoProgressView.h"
#import "GYRoundProgressView.h"
#import "AppDelegate.h"
#define APPDELEGATE ((AppDelegate*)[UIApplication sharedApplication].delegate)

@interface GYUploadPhotoProgressView()
@property (nonatomic, strong) UIView* backView; //背景图
@property (nonatomic, assign) BOOL shown;
@property (nonatomic,strong) GYRoundProgressView * progressView;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, assign) CGFloat localProgress;

@end
@implementation GYUploadPhotoProgressView
static id instance;


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}



+ (void)show
{
    if (![[self sharedInstance] shown]) {
        [APPDELEGATE.window addSubview:[[self sharedInstance] addView]];
        [APPDELEGATE.window addSubview:[[self sharedInstance] addProgress]];
        
        [APPDELEGATE.window bringSubviewToFront:[self sharedInstance]];
        [[self sharedInstance] setShown:YES];
    }
}
- (UIView*)addView
{
    
    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                 kScreenWidth,
                                                                 kScreenHeight )];
        [self.backView setBackgroundColor:[UIColor grayColor]];
        [self.backView setAlpha:0.1];
        
        }
    return self.backView;
}

- (GYRoundProgressView *)addProgress
{
    if (!self.progressView) {
        self.paused = YES;
        self.progressView = [[GYRoundProgressView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.progressView.center = APPDELEGATE.window.center;
        self.progressView.tintColor = kPurple000024;
        self.progressView.borderWidth = 1.0;
        self.progressView.lineWidth = 5.0;
        self.progressView.progress = 0;
       
    }
    return self.progressView;
}

+ (void)dismiss
{
    [[self sharedInstance] setShown:NO];
    [[instance addView] removeFromSuperview];
    [[instance addProgress] removeFromSuperview];

}

+ (void)didProgress:(CGFloat)progress
{
    [[instance addProgress] refreshProgress:progress];
}

@end
