//
//  GYAlertWithOneButtonView.m
//  HSCompanyPad
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYAlertViewWithView.h"

static float height = 180.0f;
static float weight = 325.0f;

@interface GYAlertViewWithView ()

@property (nonatomic, weak) UIImageView* backImageView;
@property (nonatomic, copy) GYdispatch_block_t block;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, weak) UIButton* comfirmButton;

@end

@implementation GYAlertViewWithView

+ (GYAlertViewWithView*)alertWithView:(UIView*)contentView size:(CGSize)contentSize buttonTitle:(NSString*)title topColor:(TopColor)topColor comfirmBlock:(GYdispatch_block_t)block
{
    GYAlertViewWithView* alert = [[GYAlertViewWithView alloc] initWithView:contentView size:contentSize topColor:topColor comfirmBlock:block];
    alert.title = title;
    [alert show];
    return alert;
}

- (instancetype)initWithView:(UIView*)view size:(CGSize)size topColor:(TopColor)topColor comfirmBlock:(GYdispatch_block_t)block
{
    CGFloat totalWeigth = size.width + 30 > weight ? size.width + 30 : weight;
    CGFloat totalHeight = size.height + 15 + 15 + 33 + 35 + 36 > height ? size.height + 15 + 15 + 33 + 35 + 36 : height;
    CGRect frame = CGRectMake(0, 0, totalWeigth, totalHeight);
    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        [self setUpViewWithView:view topColor:topColor];
    }
    return self;
}

- (void)setUpViewWithView:(UIView*)view topColor:(TopColor)topColor
{
    UIImage* image;
    NSString* title;
    if (topColor == 0) {
        image = [UIImage imageNamed:@"gycom_redTop"];
        title = kLocalized(@"提示");
    }
    else {
        image = [UIImage imageNamed:@"gycom_blueTop"];
        title = kLocalized(@"温馨提示");
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
    
    UIImageView *intergrowthImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"001"]];
     [hsIconImageView addSubview:intergrowthImage];
    [intergrowthImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hsIconImageView).offset(10);
        make.centerY.equalTo(hsIconImageView).offset(-4);
        make.width.height.equalTo(@25);
    }];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
    UIFontDescriptor* desc = [UIFontDescriptor fontDescriptorWithName:[UIFont boldSystemFontOfSize:16].fontName matrix:matrix];
    UIFont* font = [UIFont fontWithDescriptor:desc size:16];
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
    self.comfirmButton = comfirmButton;
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
    
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self).offset(40);
        make.bottom.equalTo(comfirmButton.mas_top).offset(-15);
        make.top.equalTo(hsIconImageView.mas_bottom).offset(15);
        make.right.equalTo(self).offset(-40);
    }];
}

- (void)setTitle:(NSString*)title
{
    _title = title;
    [self.comfirmButton setTitle:title forState:UIControlStateNormal];
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
    ;
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
