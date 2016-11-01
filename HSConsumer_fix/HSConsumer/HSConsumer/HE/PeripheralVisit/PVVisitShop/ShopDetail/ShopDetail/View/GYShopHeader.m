//
//  GYShopHeader.m
//  HSConsumer
//
//  Created by apple on 15/8/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopHeader.h"
#import "GYMallBaseInfoModel.h"

#define kDetailFont [UIFont systemFontOfSize:12]
#define kTitleFont [UIFont systemFontOfSize:15]

@interface GYShopHeader () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel* lbShopName;
@property (weak, nonatomic) IBOutlet UILabel* lbHSCardNum;
@property (weak, nonatomic) IBOutlet UILabel* lbScore;
//@property (weak, nonatomic) IBOutlet UIButton *btnRequestHSCard;
@property (weak, nonatomic) IBOutlet UIButton* btnSign;


@property (weak, nonatomic) UIView* vBottom;
@property (weak, nonatomic) IBOutlet UIButton* requestHSCardBtn; //申请互生卡

@property (weak, nonatomic) UIPageControl* pageControl;
@property (assign, nonatomic) NSInteger currentIndex;

- (IBAction)requestHSCard:(UIButton*)sender; //申请互生卡

@end

@implementation GYShopHeader
- (void)awakeFromNib
{

    CGFloat vBottomW = kScreenWidth;
    CGFloat vBottomH = 60;
    CGFloat vBottomX = 0;
    CGFloat vBottomY = self.frame.size.height - vBottomH;
    UIView* vBottom = [[UIView alloc] initWithFrame:CGRectMake(vBottomX, vBottomY, vBottomW, vBottomH)];
    self.vBottom = vBottom;
    self.vBottom.backgroundColor = kCorlorFromRGBA(140, 120, 90, 0.5);
    [self addSubview:self.vBottom];
    [self bringSubviewToFront:self.lbShopName];
    [self bringSubviewToFront:self.lbHSCardNum];
    [self bringSubviewToFront:self.lbScore];
    //    [self bringSubviewToFront:self.btnRequestHSCard];
    [self bringSubviewToFront:self.btnSign];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPic)];
    [self.svBack addGestureRecognizer:tap];
    self.svBack.delegate = self;
}

- (void)changePayAttentionBtnWithStatus:(BOOL)status
{
    if (status) {
        //        [self.btnSign setTitle:@"已关注" forState:UIControlStateNormal];
        //        [self.btnSign setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        //        [self.btnSign removeAllBorder];
        //        [self.btnSign addAllBorderWithBorderWidth:0.5 andBorderColor:[UIColor yellowColor]];
        [self.btnSign setImage:[UIImage imageNamed:@"gyhe_already_attention"] forState:UIControlStateNormal];
    }
    else {
        [self.btnSign setImage:[UIImage imageNamed:@"gyhe_payattention_shop"] forState:UIControlStateNormal];
        //        [self.btnSign setTitle:@"关注商铺" forState:UIControlStateNormal];
        //        [self.btnSign setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        //        [self.btnSign removeAllBorder];
        //        [self.btnSign addAllBorderWithBorderWidth:0.5 andBorderColor:kNavigationBarColor];
    }
}

+ (instancetype)initWithXib
{
    GYShopHeader* hearder = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    hearder.lbHSCardNum.font = kDetailFont;
    hearder.lbShopName.font = kTitleFont;
    hearder.lbScore.font = kDetailFont;

    hearder.btnSign.backgroundColor = [UIColor clearColor];
    hearder.lbHSCardNum.textColor = [UIColor whiteColor];
    hearder.lbShopName.textColor = [UIColor whiteColor];
    hearder.lbShopName.numberOfLines = 2;
    hearder.lbScore.textColor = [UIColor yellowColor];
    hearder.requestHSCardBtn.hidden = YES;
    hearder.svBack.scrollEnabled = YES;
    hearder.svBack.pagingEnabled = YES;
    hearder.svBack.backgroundColor = [UIColor whiteColor];
    hearder.svBack.showsHorizontalScrollIndicator = NO;

    hearder.currentIndex = 0;

    return hearder;
}

+ (CGFloat)height
{
    return 160;
}

- (void)setModel:(GYMallBaseInfoModel*)model
{
    _model = model;
    //    self.btnRequestHSCard.hidden = YES;
    if (model.companyResourceNo.length == 11) {

        NSString* strLast4 = [model.companyResourceNo substringFromIndex:7];
        // 是托管企业
        if ([strLast4 isEqualToString:@"0000"]) {

            //            self.btnRequestHSCard.hidden = YES;
        }
    }

    if ([model.isApplyCard intValue] == 1) {

        self.requestHSCardBtn.hidden = NO;
    }
    [self changePayAttentionBtnWithStatus:self.model.beFocus];

    if(![GYUtils checkStringInvalid:model.companyResourceNo]) {
        self.lbHSCardNum.text = [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_SurroundVisit_PointsCardNumber"), [GYUtils formatCardNo:model.companyResourceNo]];
        
        NSString* strRate = [NSString stringWithFormat:@"%0.1f", [model.rate floatValue]];
        self.lbScore.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"GYHE_SurroundVisit_Score"), strRate];
    }
    
    self.lbShopName.text = model.vShopName;
    

    self.svBack.contentSize = CGSizeMake(kScreenWidth * (model.picList.count), 0);

    CGFloat imgW = kScreenWidth;
    CGFloat imgH = self.frame.size.height;
    CGFloat imgY = 0;
    // add by songjk 清除之前数据
    if (model.picList.count > 0) {
        for (UIView* view in [self.svBack subviews]) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < model.picList.count; i++) {
        GYMallBaseInfoPicListModel* picModel = model.picList[i];
        CGFloat imgX = i * imgW;
        UIImageView* ivPic = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
        ivPic.contentMode = UIViewContentModeScaleAspectFit;
        [ivPic setImageWithURL:[NSURL URLWithString:picModel.url] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
        [self.svBack addSubview:ivPic];
    }

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPic)];
    [self.svBack addGestureRecognizer:tap];
    self.svBack.delegate = self;

    // songjk 清除之前的
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }
    UIPageControl* pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth - 50) * 0.5, CGRectGetMaxY(self.svBack.frame) * 0.95, 50, 15)];
    self.pageControl = pageControl;
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.numberOfPages = self.model.picList.count;
    [self addSubview:self.pageControl];
}

// add by songjk 计算名称的frame
- (void)layoutSubviews
{
    [super layoutSubviews];

    //用自动布局
    /*
       CGSize nameSize = [GYUtils sizeForString:self.lbShopName.text font:kTitleFont width:self.lbShopName.frame.size.width];
       // add by songjk
       CGFloat fHeight = nameSize.height;
       if (fHeight>self.lbShopName.frame.size.height) {
        fHeight = self.lbShopName.frame.size.height;
       }
       self.lbShopName.frame = CGRectMake(self.lbShopName.frame.origin.x, self.lbShopName.frame.origin.y, self.lbShopName.frame.size.width, fHeight);
     */
}

- (void)showBigPic
{

    if ([self.delegate respondsToSelector:@selector(ShopHeaderDidSelectShowBigPicWithHeader:index:)]) {
        [self.delegate ShopHeaderDidSelectShowBigPicWithHeader:self index:self.currentIndex];
    }
}

- (IBAction)payAttentionClick:(UIButton*)sender
{
    sender.enabled = NO;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        sender.enabled = YES;

    });

    if ([self.delegate respondsToSelector:@selector(ShopHeaderDidSelectPayAtentionBtn:)]) {
        [self.delegate ShopHeaderDidSelectPayAtentionBtn:self];
    }
}

- (IBAction)requireForHsCard
{
}

#pragma makr UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offx = scrollView.contentOffset.x;
    self.currentIndex = (scrollView.frame.size.width * 0.5 + offx) / scrollView.frame.size.width;
    self.pageControl.currentPage = self.currentIndex;
}

- (IBAction)requestHSCard:(UIButton *)sender {


    DDLogDebug(@"申请互生卡");

}

@end
