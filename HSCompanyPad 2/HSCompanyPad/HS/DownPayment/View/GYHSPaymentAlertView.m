//
//  GYHSPaymentAlertView.m
//  HSCompanyPad
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPaymentAlertView.h"
static float height = 278.5f;
static float weight = 325.0f;

@interface GYHSPaymentAlertView ()
@property (nonatomic, weak) UIImageView* backImageView;
@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, weak) UILabel* messageLabel;
@property (nonatomic, weak) UIButton* comfirmButton;
@property (nonatomic, weak) UIButton* cancelButton;
@property (nonatomic, strong) UILabel* leftAttributeLab;
@property (nonatomic, strong) UILabel* rightAttributeLab;

@end
@implementation GYHSPaymentAlertView
+ (GYHSPaymentAlertView*)alertWithTitle:(NSString*)title Message:(NSString*)message leftAttribute:(NSMutableAttributedString*)leftAttribute rightAttribute:(NSMutableAttributedString*)rightAttribute topColor:(TopColor)topColor comfirmBlock:(dispatch_block_t)block
{
    GYHSPaymentAlertView* alert = [[GYHSPaymentAlertView alloc] initWithTitle:(NSString*)title Message:message leftAttribute:leftAttribute rightAttribute:rightAttribute topColor:topColor comfirmBlock:block];
    [alert show];
    return alert;
}

- (instancetype)initWithTitle:(NSString*)title Message:(NSString*)message leftAttribute:(NSMutableAttributedString*)leftAttribute rightAttribute:(NSMutableAttributedString*)rightAttribute topColor:(TopColor)topColor comfirmBlock:(dispatch_block_t)block
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
        [self setUpViewWithTitle:title Message:message leftAttribute:leftAttribute rightAttribute:rightAttribute topColor:topColor];
    }
    return self;
}

- (void)setUpViewWithTitle:(NSString*)title Message:(NSString*)message leftAttribute:(NSMutableAttributedString*)leftAttribute rightAttribute:(NSMutableAttributedString*)rightAttribute topColor:(TopColor)topColor
{

    UIImage* image;
    if (topColor == 0) {
        image = [UIImage imageNamed:@"gycom_redTop"];
    } else {
        image = [UIImage imageNamed:@"gycom_blueTop"];
    }
    UIImageView* hsIconImageView = [[UIImageView alloc] initWithImage:image];
    hsIconImageView.userInteractionEnabled = YES;
    hsIconImageView.multipleTouchEnabled = YES;
    hsIconImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:hsIconImageView];
    @weakify(self);
    [hsIconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.left.right.equalTo(self);
        make.height.equalTo(@36);
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
    
    UILabel* messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = kFont32;
    messageLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:messageLabel];
    self.messageLabel = messageLabel;
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self).offset(40);
        make.top.equalTo(hsIconImageView.mas_bottom).offset(15);
        make.right.equalTo(self).offset(-40);
    }];
    
    UIButton* comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButton.backgroundColor = [UIColor colorWithHexString:@"e50012"];
    [comfirmButton setTitle:kLocalized(@"GYHS_Down_Sure") forState:UIControlStateNormal];
    comfirmButton.titleLabel.font = kFont32;
    comfirmButton.layer.cornerRadius = 6;
    [comfirmButton addTarget:self action:@selector(comfimAct) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:comfirmButton];
    self.comfirmButton = comfirmButton;
    [self.comfirmButton mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self).offset(85);
        make.bottom.equalTo(self).offset(-35);
        make.height.equalTo(@33);
        make.width.equalTo(@70);
    }];
    
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor colorWithHexString:@"868695"];
    [cancelButton setTitle:kLocalized(@"GYHS_Down_Cancel") forState:UIControlStateNormal];
    cancelButton.titleLabel.font = kFont32;
    cancelButton.layer.cornerRadius = 6;
    [cancelButton addTarget:self action:@selector(cancelAct) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(comfirmButton.mas_right).offset(15);
        make.bottom.equalTo(comfirmButton);
        make.height.equalTo(@33);
        make.width.equalTo(@70);
    }];
    
    self.leftAttributeLab = [[UILabel alloc] init];
    self.leftAttributeLab.numberOfLines = 0;
    self.leftAttributeLab.font = kFont28;
    self.leftAttributeLab.textColor = kGray666666;
    CGRect rectLeft = [leftAttribute boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    self.leftAttributeLab.size = rectLeft.size;
    NSMutableParagraphStyle* leftStyle = [[NSMutableParagraphStyle alloc] init];
    [leftStyle setLineSpacing:5]; //调整行间距
    leftStyle.alignment = NSTextAlignmentLeft;
    [leftAttribute addAttribute:NSParagraphStyleAttributeName value:leftStyle range:NSMakeRange(0, [leftAttribute length])];
    self.leftAttributeLab.attributedText = leftAttribute;
    [self addSubview:self.leftAttributeLab];
    [self.leftAttributeLab mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self).offset(40);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.comfirmButton.mas_top).offset(-30);
        
    }];
    
    self.rightAttributeLab = [[UILabel alloc] init];
    self.rightAttributeLab.numberOfLines = 0;
    self.rightAttributeLab.font = kFont28;
    self.rightAttributeLab.textColor = kGray666666;
    CGRect rectRight = [rightAttribute boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    self.rightAttributeLab.size = rectRight.size;
    NSMutableParagraphStyle* rightStyle = [[NSMutableParagraphStyle alloc] init];
    [rightStyle setLineSpacing:5]; //调整行间距
    rightStyle.alignment = NSTextAlignmentRight;
    [rightAttribute addAttribute:NSParagraphStyleAttributeName value:rightStyle range:NSMakeRange(0, [rightAttribute length])];
    self.rightAttributeLab.attributedText = rightAttribute;
    [self addSubview:self.rightAttributeLab];
    [self.rightAttributeLab mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.right.equalTo(self).offset(-40);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.comfirmButton.mas_top).offset(-30);
        
    }];
}

- (void)cancelAct
{
    [self disMiss];
}

#pragma mark - 确定
- (void)comfimAct
{
    if (self.block) {
        self.block();
        [self disMiss];
    }
}

#pragma mark - 显示
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
