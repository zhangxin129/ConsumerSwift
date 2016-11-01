//
//  GYSelectedButton.m
//  GYCompany
//
//  Created by apple on 15/10/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSelectedButton.h"
#import "GYTitleViewController.h"


@interface GYSelectedButton()<GYTitleViewControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popVC;
@property (nonatomic, weak) UIImageView *imgInvertedTriangle;

@end

@implementation GYSelectedButton

- (void)awakeFromNib
{

    [super awakeFromNib];
    [self setup];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setBackgroundImage:[UIImage imageNamed:@"blueBox"] forState:UIControlStateNormal];
   
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 15);
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.titleLabel.lineBreakMode = 4;
    UIImageView *imgInvertedTriangle = [[UIImageView alloc]init];
    [self addSubview:imgInvertedTriangle];
   
    self.imgInvertedTriangle = imgInvertedTriangle;
    imgInvertedTriangle.image = [UIImage imageNamed:@"gy_invertedTriangle"];
    [imgInvertedTriangle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-7);
        make.top.equalTo(self.mas_top).offset(15);
        make.width.equalTo(@15);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];
    
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setHiddenBackGround:(BOOL)hiddenBackGround
{
    _hiddenBackGround = hiddenBackGround;
    if (hiddenBackGround) {
        [self.imgInvertedTriangle removeFromSuperview];
    }
}

- (void)createdDropDownBtn
{
  
    GYTitleViewController *vc = [[GYTitleViewController alloc]init];
    vc.delegate = self;
    vc.view.width  = self.width;
    vc.view.height = self.dataSource.count * 40;

    vc.dataSource = self.dataSource;
    if (!self.direction) {
        self.direction = UIPopoverArrowDirectionUp;
    }
    UIPopoverController *popVC = [[UIPopoverController alloc]initWithContentViewController:vc];
    popVC.popoverContentSize = vc.view.size;
    
    if(self.dataSource.count > 0){
        
    [popVC presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:self.direction animated:YES];
        self.popVC = popVC;
    }
    
}

- (void)dataSourceArr:(NSMutableArray *)arr
{
    self.dataSource = [NSMutableArray array];
    self.dataSource = arr;
}

- (void)click
{
    [self createdDropDownBtn];
}
- (void)titleViewController: (GYTitleViewController *) titleVc didSelectedIndex:(int) index
{
    [self.popVC dismissPopoverAnimated:YES];
  
    [self setTitle:self.dataSource[index] forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(GYSelectedButtonDidClick:withContent:)]){
        [self.delegate GYSelectedButtonDidClick:self withContent:self.dataSource[index]];
    }
}

@end
