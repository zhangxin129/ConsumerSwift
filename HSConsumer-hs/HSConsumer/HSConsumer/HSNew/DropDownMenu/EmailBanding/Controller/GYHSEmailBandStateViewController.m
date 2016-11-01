//
//  GYHSPhoneBandStateViewController.m
//  HSConsumer
//
//  Created by admin on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSEmailBandStateViewController.h"
#import "GYHSModifyEmailBandingViewController.h"
#import "GYHSPhoneBandingVC.h"

@interface GYHSEmailBandStateViewController ()
@property (weak, nonatomic) IBOutlet UILabel* emailTagLabel;
@property (weak, nonatomic) IBOutlet UILabel* emailLabel;
@property (weak, nonatomic) IBOutlet UIButton* changeEmailBtn;

@end

@implementation GYHSEmailBandStateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadSubView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSubView
{
    self.title = kLocalized(@"邮箱绑定");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.emailTagLabel.text = kLocalized(@"邮箱");
    self.changeEmailBtn.layer.cornerRadius = 15.0f;
    [self.changeEmailBtn setTitle:kLocalized(@"修改邮箱") forState:UIControlStateNormal];

    NSMutableString* emailStr = [[NSMutableString alloc] initWithString:kSaftToNSString(globalData.loginModel.email)];
    NSRange range = [emailStr rangeOfString:@"@"];
    if (range.length > 2) {
        [emailStr replaceCharactersInRange:NSMakeRange(2, range.location - 2) withString:@"****"];
    }
    self.emailLabel.text = emailStr;
}

- (IBAction)changeEmailAction:(UIButton*)sender
{
    GYHSModifyEmailBandingViewController* vc = [[GYHSModifyEmailBandingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
