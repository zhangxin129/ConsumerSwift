//
//  GYShopADCell.m
//  HSConsumer
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopADCell.h"
#import "GYSearchShopsMainModel.h"

@implementation GYShopADCell {
    UIPageControl* _pageControl; //广告页面白点显示
    UIView* _bottomView;
    NSInteger index;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frame.size.width * 2, _bgScrollView.frame.size.height);
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.bounces = NO;
        _bgScrollView.tag = 1000;
        _bgScrollView.delegate = self;

        for (NSInteger i = 0; i < 2; i++) {

            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, _bgScrollView.frame.size.height)];

            imgView.backgroundColor = [UIColor lightGrayColor];
            imgView.userInteractionEnabled = YES;
            imgView.backgroundColor = [UIColor lightGrayColor];
            imgView.tag = 110 + i;
            UITapGestureRecognizer* tapBottom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
            [imgView addGestureRecognizer:tapBottom];
            [_bgScrollView addSubview:imgView];
        }

        [self setPageControll];
        [self addSubview:_bgScrollView];
        [self bringSubviewToFront:_bottomView];

        if (index == 0) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(myGes) userInfo:nil repeats:YES];
        }
    }

    return self;
}

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setImgArr:(NSMutableArray*)imgArr
{
    if (imgArr.count > 0) {
        _imgArr = imgArr;

        for (NSInteger i = 0; i < _imgArr.count; i++) {
            UIImageView* imgView = (UIImageView*)[_bgScrollView viewWithTag:110 + i];
            NSDictionary* dic = _imgArr[i];
            NSString* fileName = dic[@"picAddr"];

            if ([fileName hasPrefix:@"http"]) {
                [imgView setImageWithURL:[NSURL URLWithString:fileName] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
            }
            else {
                imgView.image = [UIImage imageNamed:fileName];
            }
        }
    }
}

- (void)setPageControll
{
    // 底部半透明view
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _bgScrollView.bounds.size.height - 30, _bgScrollView.bounds.size.width, 30)];
    _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self addSubview:_bottomView];

    _pageControl = [[UIPageControl alloc] initWithFrame:_bottomView.bounds];
    _pageControl.numberOfPages = 2;
    _pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [_bottomView addSubview:_pageControl];
}

#pragma mark - 定时器

- (void)myGes
{
    _pageControl.currentPage = (_pageControl.currentPage + 1) % 2;
    [_bgScrollView setContentOffset:CGPointMake(_pageControl.currentPage * _bgScrollView.bounds.size.width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
//已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    //显示第几页
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

- (void)imgClick:(UITapGestureRecognizer*)tap
{
    NSInteger i = tap.view.tag - 110;
    if(_imgArr.count > i) {
        NSDictionary* dic = _imgArr[i];
        
        if (_block) {
            _block(tap.view.tag, dic[@"id"]);
        }
    }
    
}

@end
