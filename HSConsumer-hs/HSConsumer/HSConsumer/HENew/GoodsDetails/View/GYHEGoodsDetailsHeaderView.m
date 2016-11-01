//
//  GYHEGooddsDetailsHeaderView.m
//  HSConsumer
//
//  Created by lizp on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEGoodsDetailsHeaderView.h"
#import "YYKit.h"

@interface GYHEGoodsDetailsHeaderView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scroll;
@property (nonatomic,strong) UIPageControl *page;

@end

@implementation GYHEGoodsDetailsHeaderView


-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

//    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 320)];
//    self.headerImageView.backgroundColor = UIColorFromRGB(0xffffff);
//    //图片是否充满这个区域
////    self.headerImageView.contentMode = UIViewContentModeScaleAspectFit ;
//    [self addSubview:self.headerImageView];
    
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 320)];
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.bounces = NO;
    self.scroll.pagingEnabled  = YES;
    [self addSubview:self.scroll];
    
}

-(void)setImageArr:(NSArray *)imageArr {

    self.scroll.contentSize = CGSizeMake(imageArr.count * kScreenWidth, 320);
    if (imageArr.count == 0) {
        UIImageView *imView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, 320)];
        imView.image = [UIImage imageNamed:@"gycommon_image_placeholder"];
        [self.scroll addSubview:imView];
        return;
    }
    for (NSInteger i = 0; i<imageArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, 320)];
        [imageView setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
            //图片是否充满这个区域
        imageView.contentMode = UIViewContentModeScaleAspectFit ;
        [self.scroll addSubview:imageView];
    }
    
    if (imageArr.count != 1) {
        self.scroll.delegate = self;
        
        self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scroll.frame.size.height - 20, kScreenWidth, 20)];
        self.page.currentPage = 0;
        self.page.numberOfPages = imageArr.count;
        self.page.currentPageIndicatorTintColor = [UIColor redColor];
        self.page.pageIndicatorTintColor = [UIColor yellowColor];
        [self addSubview:self.page];
    }
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    self.page.currentPage = index;
}

@end
