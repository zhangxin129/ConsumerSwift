//
//  GYLockView.m
//  HSCompanyPad
//
//  Created by User on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYLockView.h"
#import <GYKit/UIView+Extension.h>
#import "AppDelegate.h"
#import "GYLoginHttpTool.h"
#import <QuartzCore/QuartzCore.h>

#import "GYLoginHttpTool.h"
#import <YYKit/UIButton+YYWebImage.h>
@interface GYLockView ()
@property (weak, nonatomic) IBOutlet UIView* topBackView;
@property (weak, nonatomic) IBOutlet UIView* numberBackView;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray* numberBtnArray;
@property (weak, nonatomic) IBOutlet UIButton* passOneBtn;
@property (weak, nonatomic) IBOutlet UIButton* passTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton* passThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton* passFourBtn;
@property (weak, nonatomic) IBOutlet UIButton* passFiveBtn;
@property (weak, nonatomic) IBOutlet UIButton* passSixBtn;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) NSArray* passArray;
@property (weak, nonatomic) IBOutlet UIButton* cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton* deleteBtn;

@end

@implementation GYLockView {

    NSMutableArray* inputArray; //输入数字数组
}

- (void)awakeFromNib
{

    inputArray = [NSMutableArray new];
    for (UIButton* numberBtn in self.numberBtnArray) {

        [self setRoundView:numberBtn];

        [numberBtn addTarget:self action:@selector(selectNumber:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.passArray = @[ _passOneBtn, _passTwoBtn, _passThreeBtn, _passFourBtn, _passFiveBtn, _passSixBtn ];

    for (UIButton* btn in self.passArray) {

        [self setRoundView:btn];
    }
    [self setRoundView:_cancelBtn];
    [self setRoundView:_deleteBtn];

    _topBackView.backgroundColor = [UIColor clearColor];
    _numberBackView.backgroundColor = [UIColor clearColor];
    [kDefaultNotificationCenter addObserver:self selector:@selector(dismiss) name:GYCommonLogoutNotification object:nil];
    
    
}

- (void)dealloc
{
    [kDefaultNotificationCenter removeObserver:self];
}



#pragma mark - method

- (void)setRoundView:(UIView*)view
{

    view.layer.cornerRadius = view.frame.size.width / 2.0;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.backgroundColor = [UIColor clearColor];
}

- (void)setBtnSelect:(UIButton*)btn
{

    btn.backgroundColor = [UIColor whiteColor];
}

- (void)setBtnDeSelect:(UIButton*)btn
{

    btn.backgroundColor = [UIColor clearColor];
}

+ (void)show
{

    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIViewController* rootVC = delegate.window.rootViewController;
    UIView* maskView = [[UIView alloc] initWithFrame:rootVC.view.bounds];
    maskView.backgroundColor = kMaskViewColor;
    GYLockView* lockView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(GYLockView.class) owner:self options:nil][0];
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    [maskView addSubview:lockView];
    [lockView setCenter:maskView.center];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (globalData.isLocked) {
            if (lockView.superview) {
                [lockView.superview removeFromSuperview];
            }
            [lockView removeFromSuperview];
            [GYLockShowTipView show];
        }

    });
}

- (void)dismiss
{
    if (self.superview) {
        [self.superview removeFromSuperview];
    }
    [self removeFromSuperview];
    [globalData.timer invalidate];
    globalData.timer = nil;
    [globalData.timer isValid];
    globalData.isLocked = NO;
}

//注销
- (IBAction)cancelAction:(id)sender
{
    [GYLoginHttpTool clearData];
    if (self.superview) {
        [self.superview removeFromSuperview];
    }
    [self removeFromSuperview];
}
//删除
- (IBAction)deleteBackAction:(id)sender
{

    [self deleteInput];
}

- (void)selectNumber:(UIButton*)selectBtn
{

    NSNumber* number = @(selectBtn.tag);

    [self addInput:number];
}

- (void)addInput:(NSNumber*)number
{

    //输入完成框加1
    if (inputArray.count == 6) {
        //6个已经输满，不能再输入了
        return;
    }
    //选中数字
    [inputArray addObject:number];
    UIButton* passBtn = self.passArray[inputArray.count - 1];
    [self setBtnSelect:passBtn];
    //再判断一次
    if (inputArray.count == 6) {
        [self checkLockCode];
    }
}

- (void)deleteInput
{
    //输入完成框减1
    if (inputArray.count == 0) {
        return;
    }
    UIButton* passBtn = self.passArray[inputArray.count - 1];
    [self setBtnDeSelect:passBtn];
    [inputArray removeLastObject];
}

//校验锁屏密码
- (void)checkLockCode
{
    NSString* codeString = [inputArray componentsJoinedByString:@""];
    [GYLoginHttpTool checkPassWordWithPassword:codeString Success:^(id responsObject) {
         [self dismiss];
    } failure:^{
         [self shake];
        [inputArray removeAllObjects];
    }];
}

- (void)shake
{

    self.passArray = @[ _passOneBtn, _passTwoBtn, _passThreeBtn, _passFourBtn, _passFiveBtn, _passSixBtn ];
    for (UIButton* btn in self.passArray) {

        CAKeyframeAnimation* kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        [self setBtnDeSelect:btn];
        CGFloat s = 16;
        kfa.values = @[ @(-s), @(0), @(s), @(0), @(-s), @(0), @(s), @(0) ];
        //时长
        kfa.duration = .1f;
        //重复
        kfa.repeatCount = 2;
        //移除
        kfa.removedOnCompletion = YES;
        [btn.layer addAnimation:kfa forKey:@"shake"];
    }
}

#pragma mark - 重写此方法 不可以调用super 否则会在appdelege中进行相应 切记
- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
}

@end
@interface GYLockShowTipView ()

@property (weak, nonatomic) IBOutlet UILabel* companyName;
@property (weak, nonatomic) IBOutlet UIButton* showButton;
@property (weak, nonatomic) IBOutlet UILabel* resNo;
@property (weak, nonatomic) IBOutlet UILabel* user;

@end
@implementation GYLockShowTipView

- (IBAction)showInputPassWord:(id)sender
{

    [self dismiss];
    [GYLockView show];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
     [kDefaultNotificationCenter addObserver:self selector:@selector(dismiss) name:GYCommonLogoutNotification object:nil];

}

- (void)dealloc
{
    [kDefaultNotificationCenter removeObserver:self];
}



+ (void)show
{

    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    UIViewController* rootVC = delegate.window.rootViewController;

    UIView* maskView = [[UIView alloc] initWithFrame:rootVC.view.bounds];

    maskView.backgroundColor = kMaskViewColor;

    GYLockShowTipView* lockView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(GYLockView.class) owner:self options:nil][1];
    lockView.companyName.text = globalData.loginModel.entCustName;
    lockView.resNo.text = [GYUtils formatCardNo:globalData.loginModel.entResNo];
    [lockView.showButton setBackgroundImageWithURL:[NSURL URLWithString:GYHE_PICTUREAPPENDING(globalData.loginModel.vshopLogo)] forState:UIControlStateNormal placeholder: [UIImage imageNamed:@"gy_login_person"]];
    lockView.showButton.layer.cornerRadius = 45;
    lockView.showButton.layer.borderColor = kWhiteFFFFFF.CGColor;
    lockView.showButton.layer.borderWidth = 1.0f;
    lockView.showButton.clipsToBounds = YES;
    lockView.user.text = globalData.loginModel.operName;
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    [maskView addSubview:lockView];
    [lockView setCenter:maskView.center];
    [globalData.timer invalidate];
    globalData.timer = nil;
    globalData.isLocked = YES;
}

- (void)dismiss
{

    if (self.superview) {

        [self.superview removeFromSuperview];
    }
    [self removeFromSuperview];
  
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{


}


@end

