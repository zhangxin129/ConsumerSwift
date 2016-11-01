//
//  GYAlertWithOneButtonView.m
//  HSCompanyPad
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYAlertWithOneButtonView.h"

static float height = 180.0f;
static float weight = 325.0f;

@interface GYAlertWithOneButtonView ()

@property (nonatomic, weak) UIImageView* backImageView;
@property (nonatomic, copy) dispatch_block_t block;

@end

@implementation GYAlertWithOneButtonView

+ (GYAlertWithOneButtonView*)alertWithMessage:(NSString*)message topColor:(TopColor)topColor comfirmBlock:(dispatch_block_t)block
{
    GYAlertWithOneButtonView* alert = [[GYAlertWithOneButtonView alloc] initWithMessage:message topColor:topColor comfirmBlock:block];
    [alert show];
    return alert;
}

- (instancetype)initWithMessage:(NSString*)message topColor:(TopColor)topColor comfirmBlock:(dispatch_block_t)block
{
    CGRect frame = CGRectMake(0, 0, weight, height);
    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        [self setUpViewWithMessage:message topColor:topColor];
    }
    return self;
}

- (void)setUpViewWithMessage:(NSString*)message topColor:(TopColor)topColor
{
    UIImage* image;
    NSString* title;
    if (topColor == 0) {
        image = [UIImage imageNamed:@"gycom_redTop"];
        title = @"温馨提示";
    }
    else {
        image = [UIImage imageNamed:@"gycom_blueTop"];
        title = @"温馨提示";
    }
    UIImageView* hsIconImageView = [[UIImageView alloc] initWithImage:image];
    hsIconImageView.userInteractionEnabled = YES;
    hsIconImageView.multipleTouchEnabled = YES;
    hsIconImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:hsIconImageView];
    [hsIconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@36);
    }];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont boldSystemFontOfSize:16 ]. fontName matrix :matrix];
    UIFont *font = [ UIFont fontWithDescriptor :desc size :16];
    titleLabel.font = font;
    [hsIconImageView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(hsIconImageView).offset(40);
        make.centerY.equalTo(hsIconImageView).offset(-4);
        make.width.equalTo(@85);
        make.height.equalTo(@15);
    }];
    
    UIButton* forkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forkButton.contentMode = UIViewContentModeCenter;
    forkButton.backgroundColor = [UIColor clearColor];
    [forkButton setImage:[UIImage imageNamed:@"gycom_forkButton"] forState:UIControlStateNormal];
    [forkButton addTarget:self action:@selector(cancelAct) forControlEvents:UIControlEventTouchUpInside];
    [hsIconImageView addSubview:forkButton];
    [forkButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(hsIconImageView).offset(2);
        make.height.equalTo(@26);
        make.right.equalTo(hsIconImageView.mas_right).offset(-10);
        make.width.equalTo(@26);
    }];
    
    UIButton* comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButton.backgroundColor = kRedE50012;
    [comfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    comfirmButton.titleLabel.font = kFont32;
    comfirmButton.layer.cornerRadius = 6;
    [comfirmButton addTarget:self action:@selector(comfimAct) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:comfirmButton];
    [comfirmButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.mas_centerX);;
        make.bottom.equalTo(self).offset(-35);
        make.height.equalTo(@33);
        make.width.equalTo(@70);
    }];
    
    UILabel* messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = kFont32;
    messageLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self).offset(40);
        make.bottom.equalTo(comfirmButton.mas_top).offset(-15);
        make.top.equalTo(hsIconImageView.mas_bottom).offset(15);
        make.right.equalTo(self).offset(-40);
    }];
}

- (void)cancelAct
{
    DDLogInfo(@"点击取消");
    [self disMiss];
}

- (void)comfimAct
{
    DDLogInfo(@"点击确认");
    if (self.block) {
        self.block();
        [self disMiss];
    }
}

- (void)show
{
    UIImageView* backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backImageView.userInteractionEnabled = YES;
    backImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
    self.backImageView = backImageView;
    self.center = backImageView.center;
    [backImageView addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:backImageView];
}

- (void)disMiss
{
    if (self.backImageView) {
        [self.backImageView removeFromSuperview];
    }
}

- (void)dealloc
{
    
    DDLogInfo(@"dealloc");
}


@end
