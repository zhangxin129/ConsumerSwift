//
//  GYSurroundShopFourthCell.m
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/3/18.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurroundShopVisitFourthCell.h"
#import "Masonry.h"

@interface GYSurroundShopVisitFourthCell () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) UIImageView* firstImageView;
@property (nonatomic, strong) UIImageView* secondImageView;
@end

@implementation GYSurroundShopVisitFourthCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kDefaultVCBackgroundColor;
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat height = width * 16 / 75;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(width * 2, height);
        _firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
        [_scrollView addSubview:_firstImageView];
        [_scrollView addSubview:_secondImageView];
        _firstImageView.userInteractionEnabled = YES;
        _secondImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstTapped:)];
        UITapGestureRecognizer* secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondTapped:)];
        [_firstImageView addGestureRecognizer:firstTap];
        [_secondImageView addGestureRecognizer:secondTap];
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = 2;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.tintColor = [UIColor orangeColor];
        [self.contentView addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(20);
            make.leading.trailing.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).with.offset(-15);
        }];

        NSTimer* timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)firstTapped:(UITapGestureRecognizer*)tap
{
    UIViewController* infoVC = [[NSClassFromString(@"GYHSBExplainController") alloc] init];
    UIViewController* mainVC = (UIViewController*)self.superview.superview.superview.nextResponder;
    mainVC = mainVC.parentViewController;
    if (mainVC && infoVC && mainVC.navigationController) {
        infoVC.hidesBottomBarWhenPushed = YES;
        [mainVC.navigationController pushViewController:infoVC animated:YES];
    }
}

- (void)secondTapped:(UITapGestureRecognizer*)tap
{
    UIViewController* infoVC = [[NSClassFromString(@"GYHSCardExplainController") alloc] init];
    UIViewController* mainVC = (UIViewController*)self.superview.superview.superview.nextResponder;
    mainVC = mainVC.parentViewController;
    if (mainVC && infoVC && mainVC.navigationController) {
        infoVC.hidesBottomBarWhenPushed = YES;
        [mainVC.navigationController pushViewController:infoVC animated:YES];
    }
}

- (void)scrollImage
{
    CGPoint point = _scrollView.contentOffset;
    if (point.x >= kScreenWidth) {
        point.x = 0;
    }
    else {
        point.x = kScreenWidth;
    }
    [_scrollView scrollRectToVisible:CGRectMake(point.x, 0, kScreenWidth, _scrollView.frame.size.height) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGPoint point = _scrollView.contentOffset;
    NSInteger index = (point.x + kScreenWidth * 0.5) / kScreenWidth;
    _pageControl.currentPage = index;
}

- (void)setFirstImageURLStrings:(NSString*)firstImageURLStrings
{
    [_firstImageView setImageWithURL:[NSURL URLWithString:firstImageURLStrings] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
}

- (void)setSecondImageURLStrings:(NSString*)secondImageURLStrings
{
    [_secondImageView setImageWithURL:[NSURL URLWithString:secondImageURLStrings] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
}

@end
