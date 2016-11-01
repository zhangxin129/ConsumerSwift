//
//  GYAboutsHSViewController.m
//  HSConsumer
//
//  Created by kuser on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAboutsHSViewController.h"
#import "YYKit.h"

@interface GYAboutsHSViewController ()

@property(nonatomic,strong)UIScrollView* scrContainer;
@property (nonatomic, strong)UIImageView* aboutHSLogo;
@property (nonatomic, strong)UILabel* aboutManagerLabel;
@property (nonatomic, strong)UILabel* aboutManagerEnglishLabel;


@end

@implementation GYAboutsHSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化控件
    [self initWithUI];
    
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
      CGRect tFrame = CGRectMake(13, 15, self.scrContainer.frame.size.width - 13 * 2, self.scrContainer.frame.size.height - 15);
    UILabel* tlabel = [[UILabel alloc] initWithFrame:tFrame];
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", kLocalized(@"GYHS_General_AboutTheAlternateContent")]];
    
    text.font = [UIFont boldSystemFontOfSize:12.0f];
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
    self.scrContainer.contentSize = CGSizeMake(self.scrContainer.frame.size.width, sizeTlabel.height+60);
}

#pragma mark - private methods

-(void)initWithUI
{
    [self.view addSubview:self.aboutHSLogo];
    [self.view addSubview:self.aboutManagerLabel];
    [self.view addSubview:self.aboutManagerEnglishLabel];
    [self.view addSubview:self.scrContainer];
    
    [self setBackButton];
}
-(void)setBackButton
{

    UIImageView* leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    leftImage.image = [UIImage imageNamed:@"gy_he_back_arrow"];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushBack)];
    [leftImage addGestureRecognizer:tapSetting];
    UIBarButtonItem* leftBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftBackBtn;
}

-(void)pushBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGSize)adaptiveWithWidth:(CGFloat)width label:(UILabel*)label {
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return size;
}

#pragma mark - lazyMark

- (UIImageView*)aboutHSLogo
{
    if (!_aboutHSLogo) {
        _aboutHSLogo = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.5 - 27, 27, 53, 60)];
        self.aboutHSLogo.image = [UIImage imageNamed:@"gyhd_about_hs_logo"];
    }
    return _aboutHSLogo;
}

-(UILabel *)aboutManagerLabel
{
    if (!_aboutManagerLabel) {
        _aboutManagerLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 100, CGRectGetMaxY(self.aboutHSLogo.frame) + 15, 200, 20)];
        _aboutManagerLabel.text = kLocalized(@"GYHD_HDNew_ConsumeIntegralManagementPlatform"); 
        _aboutManagerLabel.textAlignment = NSTextAlignmentCenter;
        _aboutManagerLabel.font = [UIFont systemFontOfSize:18];
    }
    return _aboutManagerLabel;
}

-(UILabel *)aboutManagerEnglishLabel
{
    if (!_aboutManagerEnglishLabel) {
        _aboutManagerEnglishLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 120, CGRectGetMaxY(self.aboutManagerLabel.frame) + 5, 240, 20)];
        _aboutManagerEnglishLabel.text = @"INTERGROWTH POINTS MANAGEMENT PLATFORM";
        _aboutManagerEnglishLabel.textAlignment = NSTextAlignmentCenter;
        _aboutManagerEnglishLabel.font = [UIFont systemFontOfSize:7];
    }
    return _aboutManagerEnglishLabel;
}

- (UIScrollView*)scrContainer
{
    if (!_scrContainer) {
        _scrContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.aboutManagerEnglishLabel.frame) + 30, kScreenWidth - 26, kScreenHeight - CGRectGetMaxY(self.aboutManagerEnglishLabel.frame))];
        _scrContainer.backgroundColor = [UIColor whiteColor];
        _scrContainer.showsVerticalScrollIndicator = YES;
    }
    return _scrContainer;
}


@end
