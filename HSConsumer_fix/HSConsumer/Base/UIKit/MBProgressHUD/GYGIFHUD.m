//
//  GYGIFHUD.m
//  HudDemo
//
//  Created by wangfd on 16/8/23.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "GYGIFHUD.h"
#import "MBProgressHUD.h"

#define GYGIFHUD_Timeout 15.0f

@interface GYGIFHUD ()
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSMutableArray *hudImgAry;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GYGIFHUD

+ (instancetype)sharedInstance {
    static GYGIFHUD *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GYGIFHUD alloc] init];
    });

    return instance;
}

+ (void)show {
    [[self class] dismiss];
    UIImageView *imageView = [[GYGIFHUD sharedInstance] getHudIndicator];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow
                                          hudIndicator:imageView
                                              animated:YES];

    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.backgroundColor = [UIColor whiteColor];

    CGRect frame = [UIApplication sharedApplication].keyWindow.frame;
    frame.origin.x = (frame.size.width - 120) / 2;
    frame.origin.y = (frame.size.height - 120) / 2;
    frame.size.width = 120;
    frame.size.height = 120;
    hud.frame = frame;

    [hud hideAnimated:YES afterDelay:GYGIFHUD_Timeout];
    [GYGIFHUD sharedInstance].hud = hud;
}

+ (void)showFullScreen {
    [[self class] dismiss];
    UIImageView *imageView = [[GYGIFHUD sharedInstance] getHudIndicator];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow
                                          hudIndicator:imageView
                                              animated:YES];

    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.backgroundColor = [UIColor whiteColor];

    CGRect frame = [UIApplication sharedApplication].keyWindow.frame;
    frame.origin.x = 0;
    frame.origin.y = 64;
    frame.size.width = kScreenWidth;
    frame.size.height = kScreenHeight - 64;
    hud.frame = frame;



    [hud hideAnimated:YES afterDelay:GYGIFHUD_Timeout];
    [GYGIFHUD sharedInstance].hud = hud;
}

+ (void)dismiss {
    if ([GYGIFHUD sharedInstance].hud != nil) {
        [[GYGIFHUD sharedInstance].hud hideAnimated:YES];
        [[GYGIFHUD sharedInstance].hud removeFromSuperview];
        [GYGIFHUD sharedInstance].hud = nil;
    }
}

#pragma mark - private methods
- (UIImageView *)getHudIndicator {
    return self.imageView;
}

#pragma mark - getter and setter
- (NSMutableArray *)hudImgAry {
    if (_hudImgAry == nil) {
        _hudImgAry = [NSMutableArray array];

        for (int i = 0; i < 20; i++) {
            NSString *filename = [NSString stringWithFormat:@"gifhud_%03d.png", i + 1];

            // 加载图片
            UIImage *image = [UIImage imageNamed:filename];
            if (image == nil) {
                NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
                image = [UIImage imageWithContentsOfFile:path];
            }

            // 添加图片到数组中
            if (image != nil) {
                [_hudImgAry addObject:image];
            }
        }
    }

    return _hudImgAry;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;

        // 如果小于零，再重新加载一次
        if ([self.hudImgAry count] <= 0) {
            [self.hudImgAry removeAllObjects];
            self.hudImgAry = nil;
        }

        if ([self.hudImgAry count] > 0) {
            //设置动画数组
            [_imageView setAnimationImages:self.hudImgAry];
            //设置播放次数(无限次)
            _imageView.animationRepeatCount = 0;
            //设置每次动画播放时间
            [_imageView setAnimationDuration:self.hudImgAry.count * 0.05];

            //开始动画,使用时启动
            //[_imageView startAnimating];
        }
    }

    return _imageView;
}

@end
