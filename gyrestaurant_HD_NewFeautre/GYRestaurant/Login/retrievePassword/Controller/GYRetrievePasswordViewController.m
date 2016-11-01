//
//  GYRetrievePasswordViewController.m
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYRetrievePasswordViewController.h"
#import "GYRetrievePasswordMethordViewController.h"

@interface GYRetrievePasswordViewController ()

@property(nonatomic, strong) UIScrollView *svBackView;
@property(nonatomic, strong) UITextField *resNoTF;

@end

@implementation GYRetrievePasswordViewController

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
    [imageView setImage:[UIImage imageNamed:@"01"]];
    [v1 addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(100);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth - 800)/2.0);
        make.width.equalTo(@800);
        make.height.equalTo(@40);
    }];
    
    
    UILabel *resNoLable = [self createdLableWithText:@"互生卡号" textColor:[UIColor darkGrayColor]];
    resNoLable.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:resNoLable];
    
    [resNoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(300);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth - 100 - (kScreenWidth / 4 - 30))/2.0 );
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    _resNoTF = [[UITextField alloc]init];
    _resNoTF.background = [UIImage imageNamed:@"blueBox.png"];
    _resNoTF.keyboardType =  UIKeyboardTypeDefault;
    
    _resNoTF.delegate = self;
    if (!_resNoTF.text) {
        [self notifyWithText:@"互生卡号不能为空"];
    }
    
    [v1 addSubview:_resNoTF];
   
    [_resNoTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(300);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth - 100 - (kScreenWidth / 4 - 30))/2.0 + 100 + 10);
        make.width.equalTo(@(kScreenWidth / 4 - 30));
        make.height.equalTo(@40);
    }];
    
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"dottedline.png"];
    [v1 addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resNoLable.mas_top).offset(200);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@2);
    }];

    
    UIButton *nextBtn = [self createdButtonTitle:@"下一步" titleColor:[UIColor colorWithRed:0.0/225.0 green:91.0/255.0 blue:168.0/255.0 alpha:0.8] backgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:0.8] fontSize:30.0];

    nextBtn.tag = 100;
    [v1 addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top).offset(550);
        make.left.equalTo(v1.mas_left).offset((kScreenWidth-150)/2.0);
        make.width.equalTo(@(150));
        make.height.equalTo(@40);
    }];

    
}

#pragma mark -----点击事件
- (void)select:(UIButton *)btn
{
    if (btn.tag == 100) {
        GYRetrievePasswordMethordViewController *ctl = [[GYRetrievePasswordMethordViewController alloc] init];
        
            [self.navigationController pushViewController:ctl animated:YES];
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
