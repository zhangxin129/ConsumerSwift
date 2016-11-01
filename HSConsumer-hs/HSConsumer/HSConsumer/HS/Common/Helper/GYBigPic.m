//
//  GYBigPic.m
//  HSConsumer
//
//  Created by 00 on 15-3-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYBigPic.h"
#import "UIView+Extension.h"
@implementation GYBigPic {
    CGRect screen;
    UIImageView* imgView;
    UIScrollView * scrollview;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        screen = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.frame = screen;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(screen.size.width / 2, screen.size.height / 2 - 32, 0, 0)];
        [self addSubview:scrollview];
        
        imgView = [[UIImageView alloc] initWithFrame:scrollview.bounds];
        [scrollview addSubview:imgView];
        scrollview.contentSize=imgView.size;
        scrollview.delegate=self;
        scrollview.maximumZoomScale=2.0;
        scrollview.minimumZoomScale=1;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCilck)];

        [self addGestureRecognizer:tap];

        UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanTap:)];
        tap2.delegate = self;
        tap2.numberOfTapsRequired = 2;
        [tap requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
        self.hidden = YES;
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
 {
    return imgView;
 }
//图片点击手势
- (void)tapCilck
{
    self.hidden = YES;
}

#pragma mark - 放大手势
- (void)scanTap:(UITapGestureRecognizer *)tapgesture
{
    if (scrollview.zoomScale > 1) {
        [scrollview setZoomScale:1 animated:YES];
    }else{
        CGPoint touchPoint = [tapgesture locationInView:imgView];
        CGFloat newZoomScale = scrollview.maximumZoomScale;
        CGFloat xsize = imgView.width/newZoomScale;
        CGFloat ysize = imgView.height / newZoomScale;
        [scrollview zoomToRect:CGRectMake(touchPoint.x - xsize / 2, touchPoint.y - ysize / 2, xsize, ysize) animated:YES];

    }

}

- (void)showView:(UIImage*)image
{
    if (image == nil) {
        return;
    }

    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    DDLogDebug(@"%f", image.size.height);
    imgView.image = image;
    [self imgFrame:image];

    self.hidden = NO;
}

- (void)imgFrame:(UIImage*)image
{
    CGRect imgFrame;
    //一开始不放大
    scrollview.zoomScale = 1;
    imgFrame = CGRectMake(20, (kScreenHeight - image.size.height * kScreenWidth / image.size.width) / 2 , kScreenWidth-40, image.size.height * kScreenWidth / image.size.width -40);
    scrollview.frame = imgFrame;
    imgView.frame = scrollview.bounds;
    scrollview.contentSize=imgView.size;
}

@end
