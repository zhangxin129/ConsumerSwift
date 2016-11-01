//
//  GYBaseViewController.m
//  HSCompanyPad
//
//  Created by User on 16/7/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"
#import "GYBaseNavController.h"
#import <Shimmer/FBShimmeringView.h>
#import <YYKit/YYTextKeyboardManager.h>

@interface GYBaseViewController ()


@end

@implementation GYBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.navigationController.viewControllers.count > 1) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhs_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction)];
        
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhs_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeView)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeView)];
    }
    


    
    self.view.backgroundColor = kDefaultVCBackgroundColor;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 1;

}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (globalData.isLogined && !globalData.isLocked) {
        [globalData.timer invalidate];
        globalData.timer = nil;
        [globalData.timer isValid];

    }
    return [super canPerformAction:action withSender:sender];

}

#pragma mark -method
- (void)leftBtnAction
{
    
    if (self.navigationController.viewControllers.count==2){
        
        self.navigationController.navigationBarHidden = YES;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)closeView{
    
    if (self.navigationController.viewControllers.count>=2){
        
        self.navigationController.navigationBarHidden = YES;
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)initLoadingView {


    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:shimmeringView];
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:80.0];
    loadingLabel.textColor = [UIColor grayColor];
    loadingLabel.text = @"互生企业";
    self.view.backgroundColor = [ UIColor whiteColor];
    shimmeringView.contentView = loadingLabel;
    // Start
    //    shimmeringView.shimmeringAnimationOpacity = 0.8;
      shimmeringView.shimmering = YES;
    shimmeringView.shimmeringOpacity = 0.5;
    shimmeringView.shimmeringSpeed = 200;
    shimmeringView.shimmeringEndFadeDuration = 0.3;
    shimmeringView.shimmeringBeginFadeDuration = 0.3;
  


}

//获取当前控制器

+(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        
        result = nextResponder;
        
        DDLogInfo(@"childVC=%@",result.childViewControllers);
        
        for (id object in result.childViewControllers) {
            
            if ([object isKindOfClass:[GYBaseNavController class]]) {
                
                GYBaseNavController *nav = (GYBaseNavController*)object;
                
                UIViewController *viewVC = [nav.childViewControllers lastObject];
                
                result = viewVC;
            }
        }
    }
    
    else
        result = window.rootViewController;
    
    return result;
}

+(void)showCurrentVcView{
    
    UIViewController*control = [self getCurrentVC];
    
    control.view.hidden = NO;
    
}

+(void)hideCurrentVcView{
    
    UIViewController*control = [self getCurrentVC];
    
    control.view.hidden = YES;
    
}

- (void)loadInitViewType:(GYStopType)type :(void(^)(void))load 
{
    if (load) {
      if ((type == GYStopTypeLogout || type == GYStopTypeAll) && globalData.companyStatus.appStatu == companyStatu_request_logout) {
          [self loadTipView:@"您已经提交了成员企业资格注销申请，无权操作此业务！"];
      }else if ((type == GYStopTypeStopPointAct || type == GYStopTypeAll) && (globalData.companyStatus.appStatu == companyStatu_request_stopPointAct || globalData.companyStatus.appStatu == companyStatu_stopPointAct)){
          [self loadTipView:@"您已经提交了停止积分活动，无权操作此业务！"];
      }else{
        load();
      }
    }
}

- (void)loadTipView:(NSString *)tipString
{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"gyhs_warn_icon"];
    imageView.size = CGSizeMake(50, 45);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];

    UILabel* tipLabel = [[UILabel alloc] init];
    tipLabel.text = tipString;
    tipLabel.font = kFont32;
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = kGray333333;
    CGSize tipSize = [tipLabel.text boundingRectWithSize:CGSizeMake(tipLabel.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont32, NSFontAttributeName, nil] context:nil].size;
    tipLabel.size = tipSize;
    tipLabel.centerX = self.view.centerX;
    tipLabel.y = CGRectGetMaxY(imageView.frame) + 15;
    [self.view addSubview:tipLabel];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
