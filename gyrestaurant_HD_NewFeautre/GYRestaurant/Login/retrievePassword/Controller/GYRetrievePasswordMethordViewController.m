//
//  GYRetrievePasswordMethordViewController.m
//  GYRestaurant
//
//  Created by apple on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYRetrievePasswordMethordViewController.h"
#import "GYPhoneMethordViewController.h"
#import "GYEmailMethordViewController.h"
#import "GYQuestionMethordViewController.h"

@interface GYRetrievePasswordMethordViewController ()

@property(nonatomic, strong) UIScrollView *svBackView;
@property(nonatomic, strong) UIButton *phoneBtn;
@property(nonatomic, strong) UIButton *emailBtn;
@property(nonatomic, strong) UIButton *questionBtn;
@end

@implementation GYRetrievePasswordMethordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

-(void)createView{
    
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:@"登录密码找回" withTarget:self withAction:@selector(popBack)];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    lineView.backgroundColor=kRedFontColor;
    [self.view addSubview:lineView];
    
    
    _svBackView = [[UIScrollView alloc ] initWithFrame:self.view.bounds];
    _svBackView.showsVerticalScrollIndicator = NO;
    _svBackView.contentSize = CGSizeMake(kScreenWidth,kScreenHeight);
    _svBackView.userInteractionEnabled = YES;
    [self.view addSubview:_svBackView];
    
    UIView *v1 = [self createdViewWithX:0 y:0 width:kScreenWidth height:kScreenHeight ];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"02"]];
    [v1 addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(100);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth - 800)/2.0);
        make.width.equalTo(@800);
        make.height.equalTo(@40);
    }];
    
    UILabel *remarkLable = [self createdLableWithText:@"请选择您找回登录密码的方式" textColor:[UIColor darkGrayColor]];
    remarkLable.textAlignment = NSTextAlignmentLeft;
    remarkLable.font = [UIFont systemFontOfSize:30.0];
    [v1 addSubview:remarkLable];
    
    [remarkLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(180);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth - 800)/2.0 );
        make.width.equalTo(@800);
        make.height.equalTo(@40);
    }];

    UIImageView *phoneView =[[UIImageView alloc] init];
    [phoneView setImage:[UIImage imageNamed:@"phonenumber"]];
    [v1 addSubview:phoneView];
    
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(240);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth - 3 * 101 - 2 * 100)/2.0 );
        make.width.equalTo(@101);
        make.height.equalTo(@101);
    }];
    
    UIImageView *emailView =[[UIImageView alloc] init];
    [emailView setImage:[UIImage imageNamed:@"email"]];
    [v1 addSubview:emailView];
    
    [emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(240);
        make.left.equalTo(phoneView.mas_left).offset(201);
        make.width.equalTo(@101);
        make.height.equalTo(@101);
    }];

    
    UIImageView *questionView =[[UIImageView alloc] init];
    [questionView setImage:[UIImage imageNamed:@"question"]];
    [v1 addSubview:questionView];
    
    [questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(240);
        make.left.equalTo(emailView.mas_left).offset(201);
        make.width.equalTo(@101);
        make.height.equalTo(@101);
    }];
    
    _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_phoneBtn setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
    [_phoneBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_phoneBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _phoneBtn.tag = 100;
    [v1 addSubview:_phoneBtn];
    
    [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailView.mas_top).offset(101 + 20);
        make.left.equalTo(v1.mas_left).offset(220);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    UILabel *phoneMthordLable = [self createdLableWithText:@"通过手机号码找回" textColor:[UIColor darkGrayColor]];
    phoneMthordLable.textAlignment = NSTextAlignmentLeft;
    [v1 addSubview:phoneMthordLable];
    [phoneMthordLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailView.mas_top).offset(101 + 20);
        make.left.equalTo(_phoneBtn.mas_left).offset(20);
        make.width.equalTo(@160);
        make.height.equalTo(@20);
    }];

    
    
    _emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_emailBtn setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
    [_emailBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_emailBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _emailBtn.tag = 101;
    [v1 addSubview:_emailBtn];

    [_emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailView.mas_top).offset(101 + 20);
        make.left.equalTo(v1.mas_left).offset(420);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    UILabel *emailMthordLable = [self createdLableWithText:@"通过安全邮箱找回" textColor:[UIColor darkGrayColor]];
    emailMthordLable.textAlignment = NSTextAlignmentLeft;
    [v1 addSubview:emailMthordLable];
    [emailMthordLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailView.mas_top).offset(101 + 20);
        make.left.equalTo(_emailBtn.mas_left).offset(20);
        make.width.equalTo(@160);
        make.height.equalTo(@20);
    }];

    _questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_questionBtn setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
    [_questionBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_questionBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _questionBtn.tag = 102;
    [v1 addSubview:_questionBtn];
    
    [_questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailView.mas_top).offset(101 + 20);
        make.left.equalTo(v1.mas_left).offset(620);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    UILabel *questionMthordLable = [self createdLableWithText:@"通过密保问题找回" textColor:[UIColor darkGrayColor]];
    questionMthordLable.textAlignment = NSTextAlignmentLeft;
    [v1 addSubview:questionMthordLable];
    [questionMthordLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailView.mas_top).offset(101 + 20);
        make.left.equalTo(_questionBtn.mas_left).offset(20);
        make.width.equalTo(@160);
        make.height.equalTo(@20);
    }];

    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"dottedline.png"];
    [v1 addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneBtn.mas_top).offset(100);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@2);
    }];
    
    
    UIButton *nextBtn = [self createdButtonTitle:@"下一步" titleColor:[UIColor colorWithRed:0.0/225.0 green:91.0/255.0 blue:168.0/255.0 alpha:0.8] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:30.0];
    
    nextBtn.tag = 103;
    [v1 addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_top).offset(50);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth-150)/2.0);
        make.width.equalTo(@(150));
        make.height.equalTo(@40);
    }];
    

    
}

#pragma mark -----点击事件
- (void)select:(UIButton *)btn
{
    if (btn.tag == 100){
        _phoneBtn.selected = YES;
        _emailBtn.selected = NO;
        _questionBtn.selected = NO;
    }else if(btn.tag == 101){
        _phoneBtn.selected = NO;
        _emailBtn.selected = YES;
        _questionBtn.selected = NO;
        
    }else if (btn.tag == 102){
        _phoneBtn.selected = NO;
        _emailBtn.selected = NO;
        _questionBtn.selected = YES;
        
    }
 
    if ((btn.tag == 103) && (_phoneBtn.selected == YES)) {
        GYPhoneMethordViewController *phoneCtl = [[GYPhoneMethordViewController alloc] init];
        [self.navigationController pushViewController:phoneCtl animated:YES];
    }else if ((btn.tag == 103) && (_emailBtn.selected == YES)){
        GYEmailMethordViewController *emailCtl = [[GYEmailMethordViewController alloc] init];
        [self.navigationController pushViewController:emailCtl animated:YES];
    }else if ((btn.tag == 103) && (_questionBtn.selected == YES)){
        GYQuestionMethordViewController *questionCtl = [[GYQuestionMethordViewController alloc] init];
        [self.navigationController pushViewController:questionCtl animated:YES];
    
    }
}


-(void)popBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark-------创建lab
- (UILabel *)createdLableWithText:(NSString *)text
                        textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:20.0];
    return label;
}


#pragma mark-------创建btn
/**
 *	@param 	title           标题
 *	@param 	titleColor      标题颜色
 *	@param 	backgroundColor btn背景颜色
 *	@param 	fontSize        标题字体大小
 */
- (UIButton *)createdButtonTitle:(NSString *)title
                      titleColor:(UIColor *)titleColor
                 backgroundColor:(UIColor *)backgroundColor
                        fontSize:(CGFloat)fontSize

{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [button addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark - －－－－－创建一个View
/**
 *	@param 	x           x点坐标
 *	@param 	y           y点坐标
 *	@param 	width       view宽度
 *	@param 	height      view的高度
 */

- (UIView *)createdViewWithX:(int)x
                           y:(int)y
                       width:(int)width
                      height:(int)height
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(x, y, width, height);
    [_svBackView addSubview:view];
    return view;
}


@end
