//
//  GYHDNavView.m
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDNavView.h"
@interface GYHDNavView()<UITextFieldDelegate>

@property (nonatomic, weak) UILabel *backLabel;

@end
@implementation GYHDNavView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:143.0/255.0 blue:215.0/255.0 alpha:1.0];
        [self setup];
    }
    return self;
}

- (void)setup {
    
    UIView *backView = [[UIView alloc]init];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"icon_fh"] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];

    UILabel *backLabel = [[UILabel alloc]init];
    backLabel.font = [UIFont systemFontOfSize:24.0];
    backLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    [backView addSubview:backLabel];
    self.backLabel = backLabel;
    [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(backBtn.mas_right).offset(-40);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(35);
    }];
}

- (NSArray *)segmentViewMsgBtn:(UIButton *)msgBtn :(UIButton *)customerBtn :(UIButton *)companyBtn {
    
    UIView *segmentView = [[UIView alloc]init];
    [self addSubview:segmentView];
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo((kScreenWidth- 452) / 2);
        make.size.mas_equalTo(CGSizeMake(452, 36));
    }];
    
    msgBtn = [self setupTitleViewtitle:kLocalized(@"消息列表") imageName:@"nav_5" selectImageName:@"nav_2"];
    msgBtn.selected = YES;
    msgBtn.userInteractionEnabled = NO;
    [segmentView addSubview:msgBtn];
    
    [msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(113);
        make.height.mas_equalTo(36);
    }];
    

//    newsBtn = [self setupTitleViewtitle:kLocalized(@"HD_HsNews") imageName:@"nav_6" selectImageName:@"nav_3"];
//    [segmentView addSubview:newsBtn];
//    [newsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.equalTo(msgBtn.mas_right).offset(0);
//        make.width.mas_equalTo(113);
//        make.height.mas_equalTo(36);
//    }];

    customerBtn = [self setupTitleViewtitle:kLocalized(@"客户咨询") imageName:@"nav_6" selectImageName:@"nav_3"];
    [segmentView addSubview:customerBtn];
    [customerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(msgBtn.mas_right).offset(0);
        make.width.mas_equalTo(113);
        make.height.mas_equalTo(36);
    }];

    companyBtn = [self setupTitleViewtitle:kLocalized(@"企业通讯录") imageName:@"nav_7" selectImageName:@"nav_4"];
    [segmentView addSubview:companyBtn];
    [companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(customerBtn.mas_right).offset(0);
        make.width.mas_equalTo(113);
        make.height.mas_equalTo(36);
    }];
    
    self.msgLabel=[[UILabel alloc]init];
    self.msgLabel.backgroundColor=[UIColor redColor];
    self.msgLabel.textAlignment=NSTextAlignmentCenter;
    self.msgLabel.font=[UIFont boldSystemFontOfSize:10];
    self.msgLabel.hidden=YES;
    [segmentView addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(msgBtn.mas_right);
        make.centerY.equalTo(msgBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        
    }];
    self.msgLabel.layer.cornerRadius=6;
    self.msgLabel.layer.masksToBounds=YES;
    
    self.tipLabel=[[UILabel alloc]init];
    self.tipLabel.backgroundColor=[UIColor redColor];
    self.tipLabel.textAlignment=NSTextAlignmentCenter;
    self.tipLabel.font=[UIFont boldSystemFontOfSize:10];
    self.tipLabel.hidden=YES;
    [segmentView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(companyBtn.mas_right);
        make.centerY.equalTo(companyBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        
    }];
    
    self.tipLabel.layer.cornerRadius=6;
    self.tipLabel.layer.masksToBounds=YES;
    
    self.showLabel=[[UILabel alloc]init];
    self.showLabel.backgroundColor=[UIColor redColor];
    self.showLabel.textAlignment=NSTextAlignmentCenter;
    self.showLabel.font=[UIFont boldSystemFontOfSize:10];
    self.showLabel.hidden=YES;
    [segmentView addSubview:self.showLabel];
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(customerBtn.mas_right);
        make.centerY.equalTo(customerBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        
    }];
    
    self.showLabel.layer.cornerRadius=6;
    self.showLabel.layer.masksToBounds=YES;
    NSArray *arr = [NSArray arrayWithObjects:msgBtn,customerBtn,companyBtn, nil];
    return arr;
}

- (void)segmentViewLable:(NSString *)title {
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:24.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(20);
        make.height.mas_equalTo(36);
    }];

}

- (void)searchTextFiled:(NSString *)imageName :(NSString *)placeholder {
    
    UIView *segmentView = [[UIView alloc]init];
    segmentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_1"]];
    [self addSubview:segmentView];
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo((kScreenWidth - 452) / 2);
        make.size.mas_equalTo(CGSizeMake(452, 36));
    }];
    
    UIImageView *searchImageView = [[UIImageView alloc]init];
    searchImageView.image = [UIImage imageNamed:imageName];
    [segmentView addSubview:searchImageView];
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    UITextField *searchTF = [[UITextField alloc] init];
    searchTF.placeholder = placeholder;
    searchTF.returnKeyType=UIReturnKeySearch;
    searchTF.font = [UIFont systemFontOfSize:12.0];
    searchTF.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    [searchTF addTarget:self action:@selector(search:) forControlEvents:UIControlEventEditingChanged];
    [segmentView addSubview:searchTF];
    
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(searchImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(36);
    }];
}

- (void)searchBtn {
    
    UIButton *search = [[UIButton alloc]init];
//张鑫 屏蔽当前搜索
    [search setImage:[UIImage imageNamed:@"hd_nav_right_search"] forState:UIControlStateNormal];
    [search addTarget: self action: @selector(searchAll) forControlEvents: UIControlEventTouchUpInside];

    [self addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
}

- (UIButton *)setupTitleViewtitle:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.0/255.0 green:143.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    return button;
}

- (void)goBackAction {
    if ([self.delegate respondsToSelector:@selector(GYHDNavViewGoBackAction)]) {
        [self.delegate GYHDNavViewGoBackAction];
    }
}

- (void)searchAll {
    if ([self.delegate respondsToSelector:@selector(GYHDNavViewSearchAll)]) {
        [self.delegate GYHDNavViewSearchAll];
    }
}

- (void)buttonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(GYHDNavViewButtonClick:)]) {
        [self.delegate GYHDNavViewButtonClick:button];
    }
    
}

- (void)setBackTitle:(NSString *)backTitle {
    
    self.backLabel.text = backTitle;
    
}


- (void)search:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(GYHDNavViewSearch:)]) {
        [self.delegate GYHDNavViewSearch:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    
    if (aTextfield.text.length>0) {
        
        if ([self.delegate respondsToSelector:@selector(GYHDNavViewSearch:)]) {
            [self.delegate GYHDNavViewSearch:aTextfield];
        }
        
    }
    [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}
@end
