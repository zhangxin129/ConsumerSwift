//
//  GYPhotoScrollView.m
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYPhotoScrollView.h"
#import "UIImageView+YYWebImage.h"
#import "GYPhotoGroupView.h"
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface GYPhotoScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation GYPhotoScrollView



- (void)setPhotos:(NSArray *)photos {
    if (![photos isKindOfClass:[NSArray class]] || photos.count == 0) {
        return;
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _photos = photos;
    CGRect frame = self.frame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _scrollView.contentSize = CGSizeMake(width*photos.count, height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;

    for (int i = 0; i < photos.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImageWithURL:[NSURL URLWithString:photos[i]] placeholder:[UIImage imageNamed:@"ep_placeholder_image_type1"] options:YYWebImageOptionProgressive completion:nil];
        [_scrollView addSubview:imageView];
        imageView.tag = 1000+i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTaped:)];
        [imageView addGestureRecognizer:tap];

    }
    _scrollView.delegate = self;
    [self addSubview:_scrollView];


    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, height-20, width, 20)];
    _pageControl.numberOfPages = _photos.count;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.tintColor = [UIColor lightGrayColor];
    [self addSubview:_pageControl];

    _pageControl.hidden = !_showPageControl;

}

- (void)setShowPageControl:(BOOL)showPageControl {
    if (showPageControl) {
        _pageControl.hidden = NO;
    } else {
        _pageControl.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = _scrollView.contentOffset;
    NSInteger index = (point.x +kScreenWidth*0.5)/kScreenWidth;
    _pageControl.currentPage = index;
}

- (void)imageViewDidTaped:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag-1000;
    
    NSMutableArray *items = [[NSMutableArray alloc]init];
    for (NSUInteger i = 0, max = self.photos.count; i < max; i++) {
        UIImageView *imageV = self.scrollView.subviews[i];
        GYPhotoGroupItem *item = [[GYPhotoGroupItem alloc]init];
        item.thumbView = imageV;
        item.largeImageURL = [NSURL URLWithString:self.photos[i]];
        [items addObject:item];
    }
        UIResponder *responder = self;
        while (![responder isKindOfClass:[UIViewController class]]) {
            responder = [responder nextResponder];
        }
    UIViewController *vc = (UIViewController *)responder;
    GYPhotoGroupView *v = [[GYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:tap.view toContainer:vc.navigationController.view animated:YES completion:nil];

}



@end
