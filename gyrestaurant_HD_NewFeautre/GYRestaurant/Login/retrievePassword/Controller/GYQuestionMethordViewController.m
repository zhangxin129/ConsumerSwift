//
//  GYQuestionMethordViewController.m
//  GYRestaurant
//
//  Created by apple on 15/12/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYQuestionMethordViewController.h"
#import "GYSelectedButton.h"

@interface GYQuestionMethordViewController () <GYSelectedButtonDelegate>

@property(nonatomic, strong) UIScrollView *svBackView;
@property(nonatomic, strong) GYSelectedButton *selectQuestionBtn;
@property(nonatomic, strong) UITextField *answerTF;

@end

@implementation GYQuestionMethordViewController

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
    
    UILabel *remarkLable = [self createdLableWithText:@"请选择您设置的密保问题并输入密保答案" textColor:[UIColor darkGrayColor]];
    remarkLable.textAlignment = NSTextAlignmentLeft;
    remarkLable.font = [UIFont systemFontOfSize:25.0];
    [v1 addSubview:remarkLable];
    
    [remarkLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(150);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth - 800)/2.0 );
        make.width.equalTo(@800);
        make.height.equalTo(@40);
    }];

    
    UILabel *questionLable = [self createdLableWithText:@"选择密保问题" textColor:[UIColor darkGrayColor]];
    questionLable.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:questionLable];
    
    [questionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(240);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth - 2 * (kScreenWidth / 4 - 30) )/2.0 - 100);
        make.width.equalTo(@(kScreenWidth / 4 - 30));
        make.height.equalTo(@40);
    }];
    
    
    _selectQuestionBtn = [[GYSelectedButton alloc]init];
    _selectQuestionBtn.delegate = self;
    _selectQuestionBtn.tag = 100;
    [_selectQuestionBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:_selectQuestionBtn];
    [_selectQuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(240);
        make.left.equalTo(questionLable.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth / 3 - 30));
        make.height.equalTo(@40);
    }];
    NSString *companyUserName = @"-请选择密保问题-";
    if (companyUserName.length > 0) {
        [_selectQuestionBtn setTitle:@"-请选择密保问题-" forState:UIControlStateNormal];
    }
    
    UILabel *answerLable = [self createdLableWithText:@"输入密保问题答案" textColor:[UIColor darkGrayColor]];
    answerLable.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:answerLable];
    
    [answerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(330);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth - 2 * (kScreenWidth / 4 - 30) )/2.0 - 100);
        make.width.equalTo(@(kScreenWidth / 4 - 30));
        make.height.equalTo(@40);
    }];

    _answerTF = [[UITextField alloc]init];
    _answerTF.background = [UIImage imageNamed:@"blueBox.png"];
    _answerTF.keyboardType =  UIKeyboardTypeDefault;
    _answerTF.placeholder = @"请输入密保问题答案";
    _answerTF.delegate = self;
    if (!_answerTF.text) {
        [self notifyWithText:@"密保问题答案不能为空" ];
    }
    
    [v1 addSubview:_answerTF];
    
    [_answerTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(330);
        make.left.equalTo(answerLable.mas_left).offset((kScreenWidth / 4 - 30) + 10);
        make.width.equalTo(@(kScreenWidth / 4 - 30));
        make.height.equalTo(@40);
    }];
    
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"dottedline.png"];
    [v1 addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(answerLable.mas_top).offset(150);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@2);
    }];
    
    
    UIButton *confirmBtn = [self createdButtonTitle:@"确认 " titleColor:[UIColor colorWithRed:0.0/225.0 green:91.0/255.0 blue:168.0/255.0 alpha:0.8] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:30.0];
    
    confirmBtn.tag = 101;
    [v1 addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_top).offset(50);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth-150)/2.0);
        make.width.equalTo(@(150));
        make.height.equalTo(@40);
    }];
    

    
}
#pragma mark -----点击事件
- (void)select:(UIButton *)btn
{
    if (btn.tag == 101) {
        
        GYAlertView *alert = [[GYAlertView alloc] initWithTitle:@"找回密码成功" contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        
        
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
