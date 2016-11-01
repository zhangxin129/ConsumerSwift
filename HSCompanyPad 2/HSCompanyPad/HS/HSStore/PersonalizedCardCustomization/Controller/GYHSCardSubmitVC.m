//
//  GYHSCardSubmitVC.m
//
//  Created by apple on 16/8/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  上传个性卡样，可以输入个性卡样的名称，以及设计的需求
 */
#import "GYHSCardSubmitVC.h"
#import "GYHSMemberProgressView.h"
#import "GYHSUploadPerCardStyleView.h"
#import "GYHSStoreHttpTool.h"
#import "GYHSToolPayModel.h"
#import "GYPayViewController.h"


@interface GYHSCardSubmitVC ()<GYHSUploadPerCardStyleDelegate, GYPayViewDelegate>

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, weak) GYHSMemberProgressView* progressView;
@property (nonatomic, weak) UIScrollView* scroll;
@property (nonatomic, strong) UIView* bottomBackView;
@property (nonatomic, strong) UIButton* nextButton;
@property (nonatomic, strong) GYHSUploadPerCardStyleView *uploadPerCardStyleView;
@property (nonatomic, copy) NSString *cardNameStr;
@property (nonatomic, copy) NSString *remarkStr;
@property (nonatomic, strong) GYHSToolPayModel *toolPayModel;
@property (nonatomic, copy) NSString *passwordStr;
@property (nonatomic, strong) GYPayViewController *payVC;

@end

@implementation GYHSCardSubmitVC

/**
 *  懒加载上传个性卡样的步骤名称
 */
#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithArray: @[kLocalized(@"GYHS_HSStore_PerCardCustomization_UploadPersonalizedCardStyleFile"),
//                                                       kLocalized(@"GYHS_HSStore_PerCardCustomization_ChooseThePaymentMethod"),kLocalized(@"GYHS_HSStore_PerCardCustomization_CompleteCustomPersonalizedCard")
                                                       ]];
    }
    return _dataArray;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
}

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
// #pragma mark - event response

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_HSStore_PerCardCustomization_PersonalizedCardCustomization");
    self.view.backgroundColor = kWhiteFFFFFF;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhs_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    [self createLeftView];
    [self createRightView];
    [self createBottomView];

}
/**
 *  创建个性卡定制服务的步骤名称视图
 */
#pragma mark - event
-(void)createLeftView{
    self.num = 0;
    GYHSMemberProgressView* progressView = [[GYHSMemberProgressView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kDeviceProportion(201), kScreenHeight - kNavigationHeight - kDeviceProportion(70)) array:self.dataArray];
    progressView.index = 1;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    self.progressView.customBorderType = UIViewCustomBorderTypeRight;
}
/**
 *  创建个性卡定制服务的步骤视图
 */
- (void)createRightView{
    
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.progressView.frame) + 16, kNavigationHeight, kScreenWidth - self.progressView.width, kScreenHeight - kNavigationHeight - kDeviceProportion(70))];
    scroll.scrollEnabled = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scroll];
    self.scroll = scroll;
    self.scroll.contentSize = CGSizeMake(scroll.width * (self.dataArray.count - 1), 0);
    
    _uploadPerCardStyleView = [[GYHSUploadPerCardStyleView alloc] initWithFrame:CGRectMake(0, 0, self.scroll.width - 32 , self.scroll.height - kNavigationHeight - kDeviceProportion(70)) ];
    [self.scroll addSubview:_uploadPerCardStyleView];
    _uploadPerCardStyleView.delegate = self;
    
}
/**
 *  创建底部按钮视图
 */
- (void)createBottomView{
    
    UIView* bottomBackView = [[UIView alloc] init];
    bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:bottomBackView];
    self.bottomBackView = bottomBackView;
    [self.bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.borderWidth = 1;
    nextButton.layer.borderColor = kRedE50012.CGColor;
    nextButton.layer.masksToBounds = YES;
    [nextButton setTitle:kLocalized(@"GYHS_HSStore_PerCardCustomization_Next") forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundColor:kRedE50012];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addSubview:nextButton];
    self.nextButton = nextButton;
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(bottomBackView);
    }];
    self.num = 1;
    
}
/**
 *  左边步骤的逻辑
 */
- (void)leftClick
{
    if (self.progressView.index == self.dataArray.count) {
        self.progressView.hidden = YES;
        self.bottomBackView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.progressView.index--;
    self.scroll.contentOffset = CGPointMake((self.progressView.index - 1) * self.scroll.width, 0);
    if (self.progressView.index < 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self setBtnTitle];
}
/**
 *  底部视图按钮的触发事件
 */
- (void)nextButtonAction
{
    [self setBtnTitle];
    if (![self isDataAllRight]) {
        return;
    }
    if (self.progressView.index == 1) {
        [self requestSubmit];
    }else{
        self.progressView.index++;
        self.scroll.contentOffset = CGPointMake((self.progressView.index - 1) * self.scroll.width, 0);
        self.progressView.hidden = NO;
        self.bottomBackView.hidden = NO;
    }
}
/**
 *  底部按钮的名称
 */
- (void)setBtnTitle
{
    if (self.progressView.index == 1) {
        [self.nextButton setTitle:kLocalized(@"GYHS_HSStore_PerCardCustomization_ConfirmPaied") forState:UIControlStateNormal];
    }else if (self.progressView.index == 2){
        [self.nextButton setTitle:kLocalized(@"GYHS_HSStore_PerCardCustomization_Paid") forState:UIControlStateNormal];
    }else {
        [self.nextButton setTitle:kLocalized(@"GYHS_HSStore_PerCardCustomization_Next") forState:UIControlStateNormal];
    }
}
/**
 *  判断是否能够进去下一个步骤的先决条件
 */
- (BOOL)isDataAllRight{
    if (self.progressView.index == 1) {
        if (self.cardNameStr.length == 0) {
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_PerCardCustomization_PleaseEnterPersonalizedCardName")];
            return NO;
        }
        if (self.remarkStr.length == 0) {
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_PerCardCustomization_PleaseEnterTheDesignRequirements")];
            return NO;
        }
    }
    
    return YES;
}

/**
 *  提交个性卡定制服务订单的网络请求
 */
#pragma mark - request
- (void)requestSubmit{
    @weakify(self);
    [GYHSStoreHttpTool submitCardStyleOrderCardStyleName:self.cardNameStr remark:self.remarkStr materialSourceFile:nil success:^(id responsObject) {
        GYHSToolPayModel *model = (GYHSToolPayModel *)responsObject;
        if (model.hsbAmount.doubleValue < 1) {//如果为零则无需支付
            return ;
        }
        @strongify(self);
        GYPayViewController *vc =  [[GYPayViewController alloc]initWithNibName:NSStringFromClass([GYPayViewController class]) bundle:nil];
        vc.model = model;
        vc.type = GYPaymentServiceTypePersonalCard;
        [self.navigationController pushViewController:vc animated:YES];    } failure:^{
        
    }];

}

/**
 *  通过代理来传值
 */
#pragma mark -- GYHSUploadPerCardStyleDelegate
-(void)transCardName:(NSString *)cardName Remark:(NSString *)remark{
    self.cardNameStr = cardName;
    self.remarkStr = remark;
}
#pragma mark -- GYPayViewDelegate
- (void)transPassword:(NSString *)password{
    self.passwordStr = password;
}
@end
