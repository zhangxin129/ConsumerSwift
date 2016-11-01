//
//  GYAroundLocationHeadView.m
//  HSConsumer
//
//  Created by Apple03 on 15/11/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAroundLocationHeadView.h"
#import "GYAroundLocationNameModel.h"
#define kRowCount 3
#define kTitleFont [UIFont systemFontOfSize:14]
#define kNameFont [UIFont systemFontOfSize:14]
@interface GYAroundLocationHeadView ()

@property (nonatomic, weak) UIScrollView* scvBack;
@end

@implementation GYAroundLocationHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    UIScrollView* scvBack = [[UIScrollView alloc] initWithFrame:self.bounds];
    scvBack.backgroundColor = kCorlorFromRGBA(238, 238, 238, 1);
    scvBack.scrollEnabled = NO;
    scvBack.showsVerticalScrollIndicator = NO;
    [self addSubview:scvBack];
    self.scvBack = scvBack;
}

- (void)reloadData
{
    for (UIView* view in self.scvBack.subviews) {
        [view removeFromSuperview];
    }
    [self makeView];
}

- (void)makeView
{
    NSInteger count = self.arrData.count;
    CGFloat vBackW = self.frame.size.width;
    CGFloat VMargin = 10;
    CGFloat vBackY = 0;

    CGFloat titleX = 16;
    CGFloat titleY = 10;

    CGFloat listBorder = 20;
    CGFloat listBorderY = 8;
    CGFloat listMarginY = 8;
    CGFloat goodWidth = (self.frame.size.width - listBorder * (kRowCount + 1)) / kRowCount;
    CGFloat goodHeight = 25;
    for (NSInteger i = 0; i < count; i++) {
        GYAroundLocationNameModel* model = self.arrData[i];

        UIView* vBack = [[UIView alloc] init];
        vBack.backgroundColor = [UIColor clearColor];

        UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, vBackW - titleX, 15)];
        lbTitle.textColor = kCellItemTextColor;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.font = kTitleFont;
        lbTitle.text = model.title;
        [vBack addSubview:lbTitle];
        NSInteger goodCount = model.arrData.count;
        if (goodCount == 0) {
            CGFloat vBackH = CGRectGetMaxY(lbTitle.frame);
            vBack.frame = CGRectMake(0, vBackY, vBackW, vBackH);
            vBackY += vBackH + VMargin;
        }
        for (NSInteger j = 0; j < goodCount; j++) {
            GYAroundLocationNameDetailModel* goodModel = model.arrData[j];
            CGFloat goodX = listBorder + (listBorder + goodWidth) * (j % kRowCount);
            CGFloat goodY = CGRectGetMaxY(lbTitle.frame) + listBorderY + (listMarginY + goodHeight) * (j / kRowCount);
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.font = kNameFont;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.frame = CGRectMake(goodX, goodY, goodWidth, goodHeight);
            [btn setTitle:goodModel.name forState:UIControlStateNormal];
            [btn setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(chooseGood:) forControlEvents:UIControlEventTouchUpInside];
            [vBack addSubview:btn];
            CGFloat vBackH = CGRectGetMaxY(btn.frame);
            if (j == goodCount - 1) {
                vBack.frame = CGRectMake(0, vBackY, vBackW, vBackH);
                vBackY += vBackH + VMargin;
            }
        }
        [self.scvBack addSubview:vBack];
        if (i == count - 1) {
            self.height = CGRectGetMaxY(vBack.frame) + 10;
            self.scvBack.contentSize = CGSizeMake(0, CGRectGetMaxY(vBack.frame));
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(vBack.frame));
        }
    }
}

- (void)chooseGood:(UIButton*)sender
{
    DDLogDebug(@"选择了地区");

    if ([self.delegate respondsToSelector:@selector(AroundLocationHeadView:didChooseCity:)]) {
        [self.delegate AroundLocationHeadView:self didChooseCity:sender.currentTitle];
    }
}

@end
