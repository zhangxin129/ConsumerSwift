//
//  GYHSMedicalInstructionViewController.m
//
//  Created by lizp on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSMedicalInstructionViewController.h"
#import "YYKit.h"
#import "GYHSTools.h"

@interface GYHSMedicalInstructionViewController ()

@property (nonatomic,strong) UILabel *titleLabel;//标题
@property (nonatomic,strong) UILabel *contentLabel;//内容
@property (nonatomic,strong) UILabel *noteLabel;//备注

@property (nonatomic,strong) UIScrollView *scrollView;


@end

@implementation GYHSMedicalInstructionViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate   
// #pragma mark TableView Delegate    
// #pragma mark - CustomDelegate  
// #pragma mark - event response  

#pragma mark - private methods 
- (void)initView
{

    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    [self setUp];
}


-(void)setUp {

    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:self.scrollView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, kScreenWidth, 40)];
    self.titleLabel.text = self.strTitle;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = UIColorFromRGB(0xef4136);
    self.titleLabel.font = kMedicalInstructionTitleBoldFont;
    self.titleLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.titleLabel];
    
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.strContent == nil ? @"" :self.strContent];
    attributedStr.font = kMedicalInstructionContentFont;
    attributedStr.color = UIColorFromRGB(0x333333);
    attributedStr.lineSpacing = 15;
    attributedStr.alignment = NSTextAlignmentLeft;
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.titleLabel.bottom + 20, kScreenWidth - 60, self.scrollView.height)];
    self.contentLabel.attributedText = attributedStr;
    self.contentLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.contentLabel];
    
    CGSize size = [self adaptTextWidth:kScreenWidth -60 label:self.contentLabel];
    self.contentLabel.frame = CGRectMake(self.contentLabel.origin.x, self.contentLabel.origin.y, size.width, size.height);
    
    
    NSMutableAttributedString *noteAttribued  = [[NSMutableAttributedString alloc] initWithString:self.strNote == nil ? @"":self.strNote];
    noteAttribued.font = kMedicalInstructionContentBoldFont;
    noteAttribued.color = UIColorFromRGB(0x333333);
    noteAttribued.lineSpacing = 12;
    noteAttribued.alignment = NSTextAlignmentLeft;
    
    self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentLabel.left, self.contentLabel.bottom + 15, self.contentLabel.width, 100)];
    self.noteLabel.attributedText = noteAttribued;
    self.noteLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.noteLabel];
    
    size = [self adaptTextWidth:self.noteLabel.width label:self.noteLabel];
    self.noteLabel.frame = CGRectMake(self.noteLabel.origin.x, self.noteLabel.origin.y, size.width, size.height);
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.noteLabel.top + size.height+30);
}

-(CGSize)adaptTextWidth:(CGFloat)width label:(UILabel *)label {
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
}

#pragma mark - getters and setters  


@end
