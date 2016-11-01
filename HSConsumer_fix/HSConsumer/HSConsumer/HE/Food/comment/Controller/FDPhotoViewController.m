//
//  FDPhotoViewController.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define space 20
#import "FDPhotoViewController.h"

@interface FDPhotoViewController () <UIScrollViewDelegate>

@end

@implementation FDPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth + 20, kScreenHeight)];
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake((kScreenWidth + space) * _images.count, kScreenHeight - 20);
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor blackColor];
    for (NSInteger i = 0; i < _images.count; i++) {
        UIScrollView* sv = [[UIScrollView alloc] initWithFrame:CGRectMake((kScreenWidth + space) * i, 0, kScreenWidth + space, kScreenHeight)];
        sv.contentSize = sv.bounds.size;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImageWithURL:[NSURL URLWithString:_images[i]] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:^(UIImage* _Nullable image, NSURL* _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError* _Nullable error){

        }];

        [sv addSubview:imageView];
        sv.maximumZoomScale = 3.0;
        sv.delegate = self;
        sv.minimumZoomScale = 1.0;
        sv.bounces = NO;
        sv.backgroundColor = [UIColor blackColor];
        [scrollView addSubview:sv];
    }
    scrollView.contentOffset = CGPointMake((_currentSelected * (kScreenWidth + space)), 0);
    scrollView.pagingEnabled = YES;

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoDidTapped:)];
    [scrollView addGestureRecognizer:tap];
}

- (void)photoDidTapped:(UITapGestureRecognizer*)tap
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    for (UIView* view in scrollView.subviews) {
        return view;
    }
    return nil;
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

@end
