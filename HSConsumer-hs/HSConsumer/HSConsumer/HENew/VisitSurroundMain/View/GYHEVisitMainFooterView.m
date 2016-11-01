//
//  GYHEVisitMainFooterView.m
//  HSConsumer
//
//  Created by lizp on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//



#import "GYHEVisitMainFooterView.h"
#import "YYKit.h"
#import "GYHEVisitTakeOutControl.h"


@interface GYHEVisitMainFooterView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;//滑动视图
@property (nonatomic,strong) UIPageControl *page;//页数
@property (nonatomic,assign) NSInteger imageCount;//图片的张数
@property (nonatomic,strong) NSTimer *time;//定时器
@property (nonatomic,strong) UIView *takeOutView;//外卖频道
@property (nonatomic,strong) UIControl *takeOutHeader;//外卖频道头部
@property (nonatomic,strong) UILabel *takeOutLabel;//外卖频道label
@property (nonatomic,strong) UIImageView *takeOutArrow;//箭头
@property (nonatomic,strong) UIView *takeOutContentView;//按钮view


@end

@implementation GYHEVisitMainFooterView

-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {
    
    self.backgroundColor = UIColorFromRGB(0xebebeb);
    //滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    //页数控制
    self.page = [[UIPageControl  alloc] init];
    self.page.backgroundColor = [UIColor clearColor];
    self.page.currentPage = 0;
    self.page.currentPageIndicatorTintColor = [UIColor redColor];
    self.page.pageIndicatorTintColor = [UIColor yellowColor];
    [self addSubview:self.page];
    
    //外卖频道
    self.takeOutView = [[UIView alloc] init];
    self.takeOutView.backgroundColor = UIColorFromRGB(0xffffff);
    [self addSubview:self.takeOutView];
    
    //头部
    self.takeOutHeader = [[UIControl alloc] init];
    self.takeOutHeader.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.takeOutHeader addTarget:self action:@selector(takeOutHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.takeOutView addSubview:self.takeOutHeader];
    
    self.takeOutLabel = [[UILabel alloc] init];
    self.takeOutLabel.text = kLocalized(@"GYHE_Main_Take_Out_Channel");
    self.takeOutLabel.textColor = UIColorFromRGB(0x4f92ef);
    self.takeOutLabel.font = [UIFont systemFontOfSize:16];
    self.takeOutLabel.textAlignment = NSTextAlignmentLeft;
    [self.takeOutHeader addSubview:self.takeOutLabel];
    
    //箭头
    self.takeOutArrow = [[UIImageView alloc] init];
    self.takeOutArrow.image = [UIImage imageNamed:@"gyhs_address_arrow"];
    [self.takeOutHeader addSubview:self.takeOutArrow];
    
    self.takeOutContentView = [[UIView alloc] init];
    self.takeOutContentView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.takeOutView addSubview:self.takeOutContentView];
    
    CGFloat leftEdge = (kScreenWidth- 3*50)/4;
    CGFloat topEdge = 15;
    CGFloat width = 50;
    CGFloat height = 69;
    CGFloat spacing = (kScreenWidth- 3*50)/4;
    
    NSArray *takeOutImageArr = @[@"gyhe_main_surround",@"gyhe_main_daily",@"gyhe_main_service"];
    NSArray *takeOutTitleArr = @[kLocalized(@"GYHE_Main_Surrounding"),kLocalized(@"外卖(送货)"),kLocalized(@"上门(到家)")];
    for (NSInteger i = 0; i< 3; i++) {
        GYHEVisitTakeOutControl *control = [[GYHEVisitTakeOutControl alloc] initWithFrame:CGRectMake(i*(width + spacing) + leftEdge, topEdge, width, height)];
        control.type = i;
        control.takeOutImageView.image = [UIImage imageNamed:takeOutImageArr[i]];
        control.titleLabel.text =  takeOutTitleArr[i];
        [control addTarget:self action:@selector(takeOutControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.takeOutContentView addSubview:control];
    }
}


-(void)willRemoveSubview:(UIView *)subview {

    [super willRemoveSubview:subview];
    
    //将定时器停止，否则可能会内存泄漏
    [self.time invalidate];
    self.time = nil;
}

-(void)layoutSubviews {

    self.scrollView.frame = CGRectMake(0, 10, self.frame.size.width, 80);
    self.page.frame = CGRectMake(0, self.scrollView.bottom -11, self.frame.size.width, 11);
    self.takeOutView.frame = CGRectMake(0, self.scrollView.bottom + 10, self.width, 144);
    self.takeOutHeader.frame = CGRectMake(0, 0, self.width, 45);
    self.takeOutLabel.frame = CGRectMake(12, 0, 120, self.takeOutHeader.height);
    self.takeOutArrow.frame = CGRectMake(self.width -25 , self.takeOutHeader.height/2-8, 16, 16);
    self.takeOutContentView.frame = CGRectMake(0, self.takeOutHeader.bottom, self.width, 99);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger pageIndex = scrollView.contentOffset.x/scrollView.width;
    self.page.currentPage = pageIndex;
}


#pragma mark - 三个按钮 事件
-(void)takeOutControlClick:(GYHEVisitTakeOutControl *)sender {

    if(self.delegate && [self.delegate respondsToSelector:@selector(takeOutClick)]) {
        
        [self.delegate takeOutControl:sender];
    }
}


#pragma mark - 外卖频道 头部点击触发
-(void)takeOutHeaderClick:(UIControl *)sender {

    if(self.delegate && [self.delegate respondsToSelector:@selector(takeOutClick)]) {
    
        [self.delegate takeOutClick];
    }
}
                     
//定时器
-(void)timeGoes:(NSTimer *)time {

    NSInteger offset_index = self.scrollView.contentOffset.x/self.bounds.size.width;
    CGFloat offset_x ;
    if (offset_index != self.imageCount-1) {
        offset_x = self.bounds.size.width * (offset_index + 1);
        offset_index ++;
    }else  {
        offset_x = 0;
        offset_index = 0;
    }
    self.page.currentPage = offset_index;
    [self.scrollView setContentOffset:CGPointMake(offset_x, self.scrollView.contentOffset.y) animated:YES];
    
}

//图片点击
-(void)tapClick:(UITapGestureRecognizer *)sender {

    UIImageView *imageView = (UIImageView *) sender.view;
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectImageIndex:)]) {
        [self.delegate selectImageIndex:imageView.tag - kImageTag ];
    }
}
                     
                     
#pragma mark - get or set 
-(void)setImageArr:(NSArray *)imageArr {

    self.imageCount = imageArr.count;
    for (NSInteger i = 0; i < imageArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width,80)];
        imageView.image = [UIImage imageNamed:imageArr[i]];
        [_scrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        imageView.tag = kImageTag + i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }
    
    self.page.numberOfPages = imageArr.count;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * imageArr.count, self.scrollView.height);

    //定时器
    self.time = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeGoes:) userInfo:nil repeats:YES];
    [self.time fire];
    [[NSRunLoop currentRunLoop] addTimer:self.time forMode:NSRunLoopCommonModes];
}



@end
