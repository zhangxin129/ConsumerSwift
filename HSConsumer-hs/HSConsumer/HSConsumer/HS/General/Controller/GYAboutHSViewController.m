//
//  AboutHS.m
//  HSConsumer
//
//  Created by 00 on 14-10-20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAboutHSViewController.h"
#import "YYKit.h"

@interface GYAboutHSViewController ()

@property (nonatomic, strong) UIScrollView* scrContainer;
@property (nonatomic, strong) UIImageView* aboutLogo;
@end

@implementation GYAboutHSViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [self initUI];
    [super viewDidLoad];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    [self.scrContainer setBackgroundColor:[UIColor whiteColor]];
    CGRect tFrame = CGRectMake(15, 15, self.scrContainer.frame.size.width - 15 * 2, self.scrContainer.frame.size.height - 15);
    
    UILabel* tlabel = [[UILabel alloc] initWithFrame:tFrame];
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", kLocalized(@"GYHS_General_AboutTheAlternateContent")]];
    
    text.font = [UIFont boldSystemFontOfSize:15.0f];
    text.color = kCorlorFromHexcode(0x464646);
    text.lineSpacing = 10.0f;
    [text setAlignment:NSTextAlignmentLeft];
    tlabel.attributedText = text;
    tlabel.numberOfLines = 0;
    [self.scrContainer addSubview:tlabel];
    
    CGSize sizeTlabel = [self adaptiveWithWidth:tlabel.frame.size.width label:tlabel];
    tlabel.frame = CGRectMake(tlabel.frame.origin.x,
                              tlabel.frame.origin.y,
                              tlabel.frame.size.width,
                              sizeTlabel.height);
    
    self.scrContainer.contentSize = CGSizeMake(self.scrContainer.frame.size.width, sizeTlabel.height+30);
}


#pragma mark - private methods
- (void)initUI
{
    self.aboutLogo.image = [UIImage imageNamed:@"hs_about_logo"];
    [self.view addSubview:self.aboutLogo];
    [self.view addSubview:self.scrContainer];
}

- (CGSize)adaptiveWithWidth:(CGFloat)width label:(UILabel*)label {
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return size;
}

#pragma mark - getters and setters
- (UIScrollView*)scrContainer
{
    if (_scrContainer == nil) {
        _scrContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.aboutLogo.frame) + 35, kScreenWidth - 30, kScreenHeight - 64 - CGRectGetMaxY(self.aboutLogo.frame) - 35)];
        _scrContainer.showsVerticalScrollIndicator = YES;
    }
    return _scrContainer;
}

- (UIImageView*)aboutLogo
{
    if (_aboutLogo == nil) {
        _aboutLogo = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, 40, 200, 107)];
    }
    return _aboutLogo;
}

@end
