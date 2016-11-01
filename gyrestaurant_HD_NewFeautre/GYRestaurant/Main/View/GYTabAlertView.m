//
//  GYTabAlertView.m
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYTabAlertView.h"

#define Alertwidth 200.0f
#define Alertheigth 300.0f
#define XWtitleofheigth 25.0f
#define XWtitlegap 50.0f

#define XWSinglebuttonWidth 160.0f
//        单个按钮时的宽度
#define XWdoublebuttonWidth 100.0f
//        双个按钮的宽度
#define XWbuttonHeigth 50.0f
//        按钮的高度
#define XWbuttonbttomgap 20.0f
//        设置按钮距离底部的边距


@interface GYTabAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tabAlert;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, strong)UIView *backimageView;
@property(nonatomic, strong)UILabel *alertTitleLabel;
@property (nonatomic, strong) UIButton *leftbtn;
@property (nonatomic, strong) UIButton *rightbtn;

@end

@implementation GYTabAlertView

+ (CGFloat)alertWidth
{
    return Alertwidth;
}

+ (CGFloat)alertHeight
{
    return Alertheigth;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self) {
        
    }

    return self;
}

-(id)initWithTitle:(NSString *)title contentView:(UIView *)contentView leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle{

    if (self = [super init]) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, XWtitlegap, Alertwidth, XWtitleofheigth)];
        self.alertTitleLabel.font = [UIFont systemFontOfSize:18];
        self.alertTitleLabel.textColor=[UIColor lightGrayColor];
        self.alertTitleLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.alertTitleLabel];
        
       
        
        CGFloat contentViewWidth = Alertwidth;
        self.tabAlert = [[UITableView alloc] initWithFrame:CGRectMake((Alertwidth - contentViewWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame)-15, Alertwidth, 200)];
       
        self.tabAlert.backgroundColor = [UIColor greenColor];
       // self.alertContentLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.tabAlert];
        //        设置对齐方式
        //  self.alertContentLabel.textAlignment = self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        CGRect leftbtnFrame;
        CGRect rightbtnFrame;
        
        if (!leftTitle) {
            rightbtnFrame = CGRectMake((Alertwidth - XWSinglebuttonWidth) * 0.5, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth, XWSinglebuttonWidth, XWbuttonHeigth);
            self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightbtn.frame = rightbtnFrame;
            
        }else {
            leftbtnFrame = CGRectMake(100, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth, 100, XWbuttonHeigth);
            
            rightbtnFrame = CGRectMake(300, Alertheigth - XWbuttonbttomgap - XWbuttonHeigth, 100, XWbuttonHeigth);
            self.leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftbtn.frame = leftbtnFrame;
            self.rightbtn.frame = rightbtnFrame;
        }
        
        [self.rightbtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.leftbtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.rightbtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftbtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftbtn.titleLabel.font = self.rightbtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.leftbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftbtn addTarget:self action:@selector(leftbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightbtn addTarget:self action:@selector(rightbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftbtn.layer.masksToBounds = self.rightbtn.layer.masksToBounds = YES;
        self.leftbtn.layer.cornerRadius = self.rightbtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftbtn];
        [self addSubview:self.rightbtn];
        self.alertTitleLabel.text = title;
        self.tabAlert = contentView;
        
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

//-(void)createView{
//
//    _dataArr=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
//    _tabAlert = [[UITableView alloc] init];
//    _tabAlert.delegate=self;
//    _tabAlert.dataSource=self;
//    _tabAlert.frame=self.bounds;
//    [self addSubview:_tabAlert];
//    
////    UIView *headView=[[UIView alloc] init];
////    headView.frame=CGRectMake(0, 0, Alertwidth, 20);
////    headView.backgroundColor=[UIColor redColor];
////    UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, Alertwidth, 20)];
////    titleLable.text=@"请选择送餐员";
////    titleLable.textAlignment=NSTextAlignmentCenter;
////    [headView addSubview:titleLable];
//    
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //实例化UITableViewCell对象
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    for (NSInteger i = 0 ; i < _dataArr.count; i ++) {
        //UITableViewCell自带一个控件textLabel
        cell.textLabel.text = _dataArr[i];
    }
    //返回cell对象
    return cell;
}

- (void)leftbtnclicked:(id)sender
{
    
    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dismissAlert];
}

- (void)rightbtnclicked:(id)sender
{
    
    if (self.rightBlock) {
        self.rightBlock();
    }
    [self dismissAlert];
}

- (void)show
{   //获取第一响应视图视图
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - Alertwidth) * 0.5-30, (CGRectGetHeight(topVC.view.bounds) - Alertheigth) * 0.5-20, Alertwidth, Alertheigth);
    self.alpha=0;
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [self.backimageView removeFromSuperview];
    self.backimageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - Alertwidth) * 0.5+30, (CGRectGetHeight(topVC.view.bounds) - Alertheigth) * 0.5-30, Alertwidth, Alertheigth);
    
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        self.alpha=0;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}
//添加新视图时调用（在一个子视图将要被添加到另一个视图的时候发送此消息）
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    //     获取根控制器
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backimageView) {
        self.backimageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backimageView.backgroundColor = [UIColor lightGrayColor];
        self.backimageView.alpha = 0.6f;
        self.backimageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    //    加载背景背景图,防止重复点击
    [topVC.view addSubview:self.backimageView];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - Alertwidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - Alertheigth) * 0.5, Alertwidth, Alertheigth);
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = afterFrame;
        self.alpha=0.9;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}


@end
