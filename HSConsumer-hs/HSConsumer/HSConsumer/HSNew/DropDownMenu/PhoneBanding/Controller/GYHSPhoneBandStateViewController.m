//
//  GYHSPhoneBandStateViewController.m
//  HSConsumer
//
//  Created by admin on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPhoneBandStateViewController.h"
#import "GYHSPhoneBandingVC.h"
#import "GYHSLoginModel.h"

@interface GYHSPhoneBandStateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeNumberBtn;

@end

@implementation GYHSPhoneBandStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSubView {
    self.title = kLocalized(@"手机绑定");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.phoneNumTagLabel.text = kLocalized(@"手机号码");
    self.changeNumberBtn.layer.cornerRadius = 15.0f;
    [self.changeNumberBtn setTitle:kLocalized(@"更换手机号") forState:UIControlStateNormal];
    
    GYHSLoginModel *model = [[GYHSLoginManager shareInstance] loginModuleObject];
    NSMutableString *phoneNum = [[NSMutableString alloc] initWithString:kSaftToNSString(model.mobile)];
    if (phoneNum.length > 7) {
        [phoneNum replaceCharactersInRange:NSMakeRange(3, phoneNum.length - 7) withString:@"****"];
    }
    self.phoneNumberLabel.text = phoneNum;
    
}

- (IBAction)changePhoneNumberAction:(UIButton *)sender {
    GYHSPhoneBandingVC *vc  = [[GYHSPhoneBandingVC alloc] init];
    vc.pageType = GYHSPhoneBandingVCPageModify;
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
