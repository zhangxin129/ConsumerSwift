//
//  GYResultView.m
//  company
//
//  Created by Apple03 on 15-4-25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kTitleFont [UIFont systemFontOfSize:15]
#define kMsgFont [UIFont systemFontOfSize:13]

#import "GYResultView.h"
@interface GYResultView ()
/**背景视图*/
@property (nonatomic, weak) UIView* vBack;
/**前主视图　*/
@property (nonatomic, weak) UIView* vFront;
/**确认按钮*/
@property (nonatomic, weak) UIButton* btnConfrim;
/**成功或者失败图标*/
@property (nonatomic, weak) UIImageView* ivStatus;
/**主标题*/
@property (nonatomic, weak) UILabel* lbTitle;
/**失败原因*/
@property (nonatomic, weak) UILabel* lbMessage;
@end

@implementation GYResultView

- (instancetype)init
{
    if (self = [super init]) {
        [self settings];
    }
    return self;
}

- (void)settings
{
    self.backgroundColor = [UIColor clearColor];

    UIView* vBack = [[UIView alloc] init];
    vBack.backgroundColor = [UIColor clearColor];
    [self addSubview:vBack];
    vBack.hidden = YES;
    self.vBack = vBack;

    UIView* vFront = [[UIView alloc] init];
    vFront.backgroundColor = [UIColor whiteColor];
    vFront.layer.cornerRadius = 3;
    [self addSubview:vFront];
    vFront.hidden = YES;
    self.vFront = vFront;

    UIImageView* ivStatus = [[UIImageView alloc] init];
    [ivStatus setImage:[UIImage imageNamed:@"hs_img_succeed"]];
    [self.vFront addSubview:ivStatus];
    self.ivStatus = ivStatus;

    UILabel* lbTitle = [[UILabel alloc] init];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textColor = [UIColor blackColor];
    lbTitle.font = kTitleFont;
    [self.vFront addSubview:lbTitle];
    self.lbTitle = lbTitle;

    UILabel* lbMessage = [[UILabel alloc] init];
    lbMessage.backgroundColor = [UIColor clearColor];
    lbMessage.font = kMsgFont;
    lbMessage.textColor = kCellItemTitleColor;
    lbMessage.numberOfLines = 0;
    [self.vFront addSubview:lbMessage];
    lbMessage.hidden = YES;
    self.lbMessage = lbMessage;

    UIButton* btnConfrim = [[UIButton alloc] init];
    //    btnConfrim.backgroundColor = kNavigationBarColor;
    UIImage* imConfrim = [UIImage imageNamed:@"gyhe_alert_btn_confirm_bg"];
    imConfrim = [imConfrim stretchableImageWithLeftCapWidth:imConfrim.size.width * 0.5 topCapHeight:imConfrim.size.height * 0.5];
    [btnConfrim setBackgroundImage:imConfrim forState:UIControlStateNormal];
    [btnConfrim setTitle:kLocalized(@"GYHS_Base_confirm") forState:UIControlStateNormal];
    [btnConfrim addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.vFront addSubview:btnConfrim];
    self.btnConfrim = btnConfrim;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.vBack.frame = self.bounds;
    CGFloat ScreenWith = self.bounds.size.width;
    CGFloat boder = 10;

    CGFloat vFrontX = boder * 1;
    CGFloat vFrontY = 70;
    CGFloat vFrontW = ScreenWith - vFrontX * 2;
    CGFloat vFrontH = 0;
    if (self.bSuccess) { // 业务办理成功
        CGFloat ivStatusW = 25;
        CGFloat ivStatusH = ivStatusW;
        CGFloat ivStatusX = 0;
        CGFloat ivStatusY = boder * 4;

        CGFloat lbTitleW = [self.strResultInfo sizeWithAttributes:@{ NSFontAttributeName : kTitleFont }].width;
        CGFloat lbTitleH = 40;
        CGFloat lbTitleY = ivStatusY;

        ivStatusX = (vFrontW - (lbTitleW + boder + ivStatusW)) * 0.5;

        self.ivStatus.frame = CGRectMake(ivStatusX, ivStatusY, ivStatusW, ivStatusH);

        CGFloat lbTitleX = CGRectGetMaxX(self.ivStatus.frame) + boder;
        self.lbTitle.frame = CGRectMake(lbTitleX, lbTitleY, lbTitleW, lbTitleH);
        CGPoint center = self.lbTitle.center;
        center.y = self.ivStatus.center.y;
        self.lbTitle.center = center;
        self.lbTitle.text = self.strResultInfo;

        CGFloat btnConfrimX = boder * 1.5;
        CGFloat btnConfrimY = CGRectGetMaxY(self.ivStatus.frame) + boder * 4;
        CGFloat btnConfrimW = vFrontW - btnConfrimX * 2;
        CGFloat btnConfrimH = 35;
        self.btnConfrim.frame = CGRectMake(btnConfrimX, btnConfrimY, btnConfrimW, btnConfrimH);

        vFrontH = CGRectGetMaxY(self.btnConfrim.frame) + boder * 3;
        self.vFront.frame = CGRectMake(vFrontX, vFrontY, vFrontW, vFrontH);
    }
    else { // 业务办理失败
        NSString* strErrorTitle = kLocalized(@"GYHS_Base_deal_with_failure");
        CGFloat ivStatusW = 25;
        CGFloat ivStatusH = ivStatusW;
        CGFloat ivStatusX = 0;
        CGFloat ivStatusY = boder * 3;

        CGFloat lbTitleW = [strErrorTitle sizeWithAttributes:@{ NSFontAttributeName : kTitleFont }].width;
        CGFloat lbTitleH = 40;
        CGFloat lbTitleY = ivStatusY;

        ivStatusX = (vFrontW - (lbTitleW + boder + ivStatusW)) * 0.5;

        [self.ivStatus setImage:kLoadPng(@"gyhe_img_faild")]; //[UIImage imageWithContentsOfFile:strPath]];
        self.ivStatus.frame = CGRectMake(ivStatusX, ivStatusY, ivStatusW, ivStatusH);

        CGFloat lbTitleX = CGRectGetMaxX(self.ivStatus.frame) + boder;
        self.lbTitle.frame = CGRectMake(lbTitleX, lbTitleY, lbTitleW, lbTitleH);
        CGPoint center = self.lbTitle.center;
        center.y = self.ivStatus.center.y;
        self.lbTitle.center = center;
        self.lbTitle.text = strErrorTitle;

        // 分割线
        UIImageView* vLine1 = [[UIImageView alloc] init];

        [vLine1 setImage:[UIImage imageNamed:@"gyhe_line_confirm_dialog_yellow"]];

        CGFloat vLine1X = boder * 1.5;
        CGFloat vLine1Y = CGRectGetMaxY(self.ivStatus.frame) + boder * 2;
        CGFloat vLine1W = vFrontW - vLine1X * 2;
        CGFloat vLine1H = 1;
        vLine1.frame = CGRectMake(vLine1X, vLine1Y, vLine1W, vLine1H);
        [self.vFront addSubview:vLine1];

        // 错误信息展示
        self.lbMessage.hidden = NO;
        CGFloat lbMessageX = boder * 1.5;
        CGFloat lbMessageY = CGRectGetMaxY(vLine1.frame) + boder * 2;
        CGFloat lbMessageW = vFrontW - lbMessageX * 2;
        CGFloat lbMessageH = [GYUtils heightForString:self.strResultInfo fontSize:13 andWidth:lbMessageW];

        self.lbMessage.frame = CGRectMake(lbMessageX, lbMessageY, lbMessageW, lbMessageH);
        self.lbMessage.text = self.strResultInfo;

        // 分割线
        UIImageView* vLine2 = [[UIImageView alloc] init];

        [vLine2 setImage:[UIImage imageNamed:@"gyhe_line_confirm_dialog_yellow"]];
        CGFloat vLine2X = boder * 1.5;
        CGFloat vLine2Y = CGRectGetMaxY(self.lbMessage.frame) + boder * 2;
        CGFloat vLine2W = vFrontW - vLine2X * 2;
        CGFloat vLine2H = 1;
        vLine2.frame = CGRectMake(vLine2X, vLine2Y, vLine2W, vLine2H);
        [self.vFront addSubview:vLine2];

        CGFloat btnConfrimX = boder * 1.5;
        CGFloat btnConfrimY = CGRectGetMaxY(vLine2.frame) + boder * 3;
        CGFloat btnConfrimW = vFrontW - btnConfrimX * 2;
        CGFloat btnConfrimH = 35;
        self.btnConfrim.frame = CGRectMake(btnConfrimX, btnConfrimY, btnConfrimW, btnConfrimH);

        vFrontH = CGRectGetMaxY(self.btnConfrim.frame) + boder * 3;
        self.vFront.frame = CGRectMake(vFrontX, vFrontY, vFrontW, vFrontH);
    }
}

- (void)show
{
    self.vBack.alpha = 0;
    self.vBack.hidden = NO;
    self.vFront.alpha = 1;
    [UIView animateWithDuration:0.2 animations:^{
        self.vBack.backgroundColor = [UIColor blackColor];
        self.vBack.alpha = 0.3;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2 animations:^{
                [self bringSubviewToFront:self.vFront];
                self.vFront.hidden = NO;
            }];
        }
    }];
}

/**先生成功或者失败页面 bStatus表示成功或者失败 message表示成功或者失败的信息*/
- (void)showWithView:(UIView*)view status:(BOOL)bStatus message:(NSString*)message
{
    self.frame = view.bounds;
    self.bSuccess = bStatus;
    self.strResultInfo = message;
    [view addSubview:self];
    [self show];
}

- (void)close
{
    [self removeFromSuperview];
}

- (void)closeView
{
    if ([self.delegate respondsToSelector:@selector(ResultViewConfrimButtonClicked:success:)]) {
        [self.delegate ResultViewConfrimButtonClicked:self success:self.bSuccess];
    }
    [self close];
}

@end
