//
//  GYHSNewIphoneController.m
//  HSConsumer
//
//  Created by liss on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSNewIphoneController.h"
#import "GYModifyEmailBandingViewController.h"
#import "GYHSAccountViewController.h"
@interface GYHSNewIphoneController ()

@end

@implementation GYHSNewIphoneController


#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backview) forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationController.navigationItem.leftBarButtonItem = back;
    
    self.iphone.text = self.iphonestr;
    self.isSeting.text = self.ipSetStr;
    self.image.image = [UIImage imageNamed:self.imageName];
    self.btn.hidden = self.isbtnH;
    if (self.setFloat == 0) {
        self.isSetingConstraint.constant = self.setFloat;
    }
}


#pragma mark - SystemDelegate

#pragma mark TableView Delegate

#pragma mark - CustomDelegate

#pragma mark - event response
- (IBAction)upEmail:(id)sender
{
    
    GYModifyEmailBandingViewController* email = [[GYModifyEmailBandingViewController alloc] init];
    
    [self.navigationController pushViewController:email animated:YES];
}

#pragma mark - private methods
- (void)backview
{
    if (globalData.loginModel.cardHolder) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        for (UIViewController* controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[GYHSAccountViewController class]]) {
                NSNotification* notifiaction = [NSNotification notificationWithName:@"updateBaseQueryController" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notifiaction];
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

#pragma mark - getters and setters






@end
