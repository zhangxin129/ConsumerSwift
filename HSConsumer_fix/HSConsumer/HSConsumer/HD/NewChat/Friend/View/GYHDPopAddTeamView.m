//
//  GYHDPopAddTeamView.m
//  HSConsumer
//
//  Created by shiang on 16/3/21.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYHDPopAddTeamView.h"
#import "GYHDMessageCenter.h"

@interface GYHDPopAddTeamView () <UITextFieldDelegate>
@property (nonatomic, weak) UITextField* searchTextField;
@property (nonatomic, weak) UILabel* titleLabel;
@property (nonatomic, assign) NSInteger sendState;
@end

@implementation GYHDPopAddTeamView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)dealloc
{

    [_searchTextField removeObserver:self forKeyPath:@"attributedText"];
    [_searchTextField removeObserver:self forKeyPath:@"text"];
}
- (void)setup
{

    self.backgroundColor = [UIColor whiteColor];
    //1. 标题
    UILabel* titleLabel = [[UILabel alloc] init];

    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    titleLabel.textColor = [UIColor colorWithRed:251 / 255.0f green:99 / 255.0f blue:83 / 255.0f alpha:1];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;

    //. 数据库
    UITextField* searchTextField = [[UITextField alloc] init];
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.textAlignment = NSTextAlignmentCenter;
    searchTextField.placeholder = [GYUtils localizedStringWithKey:@"GYHD_input_team_name"];
    searchTextField.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    //    [searchTextField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    searchTextField.delegate = self;
    [self addSubview:searchTextField];

    _searchTextField = searchTextField;

    UIButton* defineButton = [[UIButton alloc] init];
    [defineButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_confirm"] forState:UIControlStateNormal];
    [defineButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_left_btn_normal"] forState:UIControlStateNormal];
    [defineButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_left_btn_Highlighted"] forState:UIControlStateHighlighted];
    [defineButton addTarget:self action:@selector(defineButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:defineButton];

    UIButton* cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_cancel"] forState:UIControlStateNormal];
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_right_btn_normal"] forState:UIControlStateNormal];
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_right_btn_highlighted"] forState:UIControlStateHighlighted];
    [cancleButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleButton];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(35);
    }];
    [searchTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(32);
    }];
    [defineButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(42);
        make.right.equalTo(cancleButton.mas_left).offset(-1);
        make.width.equalTo(cancleButton);
    }];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(42);
        make.left.equalTo(defineButton.mas_right).offset(1);
        make.width.equalTo(defineButton);
    }];
}
- (void)textFieldDidEndEditing:(UITextField*)textField
{

    if (self.sendState == 1) {
        if (_maxCharCount > 0) {
            if (self.searchTextField.text.length > _maxCharCount ) {
                self.searchTextField.text = [self.searchTextField.text substringToIndex:_maxCharCount];
            }
        }

        if (self.block && self.searchTextField.text.length > 0) {
            self.block(self.searchTextField.text);
        }
        else {
        }
    }
    else if (self.sendState == 2) {
        if (self.block) {
            self.block(nil);
        }
    }
}
//- (void)textFieldChange {
//    NSLog(@"%lu",self.searchTextField.text.length);
//    if (_maxCharCount > 0) {
//        if (self.searchTextField.text.length > _maxCharCount) {
//            self.searchTextField.text = [self.searchTextField.text substringToIndex:_maxCharCount];
//        }
//    }
//
//}
/**等待字*/
- (void)setPlaceholder:(NSString*)placeholder
{
    self.searchTextField.placeholder = placeholder;
}

/**默认字*/
- (void)setDefaulText:(NSString*)string
{
    self.searchTextField.text = string;
}

- (void)setTitle:(NSString*)title
{
    self.titleLabel.text = title;
}

- (void)defineButtonClick
{
    self.sendState = 1;
    [self.searchTextField becomeFirstResponder];
    [self.searchTextField resignFirstResponder];
    //    if (self.block) {
    //        self.
    ////        self.block(self.searchTextField.text);
    //    }
}

- (void)cancleButtonClick
{
    self.sendState = 2;
    [self.searchTextField becomeFirstResponder];
    [self.searchTextField resignFirstResponder];
    //    if (self.block) {
    //        if (self.block) {
    //            self.block(nil);
    //        }
    ////        self.block(GYHDPopAddClickCancle);
    //    }
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
   }
 */

@end
