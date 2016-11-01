//
//  GYCommentViewController.m
//  HSConsumer
//
//  Created by appleliss on 15/9/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
///////填写备注

#import "GYCommentViewController.h"
#import "GYConfirmOrdersController.h"
@interface GYCommentViewController () <UITextViewDelegate>

@property (nonatomic, strong) NSString* commstring;
@end

@implementation GYCommentViewController

/**
 *  页面初始化
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHE_Food_WriteRemarks");
    self.commstring = kLocalized(@"GYHE_Food_BusinessMessageEnterRequirements");
    [self initView];
}

/**
 *  具体控件 布局
 */
- (void)initView
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:kLocalized(@"GYHE_Food_MakeSure") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 60, 40);
    UIBarButtonItem* rightbar = [[UIBarButtonItem alloc] initWithCustomView:btn];

    self.navigationItem.rightBarButtonItem = rightbar;
    _mycommenttext = ({
        UITextView *text = [[UITextView alloc] initWithFrame:({
            CGRect frame = CGRectMake(10, 15, kScreenWidth-20, 120);
            frame;
        })];
        text.delegate = self;
        text.layer.masksToBounds = YES;
        text.layer.borderColor = [kCorlorFromRGBA(160, 160, 160, 1) CGColor];
        text.layer.borderWidth = 0.5f;
        text.textColor = kCorlorFromRGBA(160, 160, 160, 1);
        text.layer.cornerRadius = 0.8f;
        text.text = _str;
        text.font = [UIFont systemFontOfSize:15];
        text.backgroundColor = [UIColor whiteColor];
        text;
    });

    _lab = ({
        UILabel *lab = [[UILabel alloc] initWithFrame:({
            CGRect fr = CGRectMake(20, 15, 300, 20);
            fr;
        })];
        lab.text = [GYUtils isBlankString:_str] == YES ? _commstring : @"";
        lab.textColor = kCorlorFromRGBA(160, 160, 160, 1);
        lab.font = [UIFont systemFontOfSize:13];
        lab;
    });
    self.view.backgroundColor = kCorlorFromRGBA(239, 239, 239, 1);
    [self.view addSubview:_mycommenttext];
    [self.view addSubview:_lab];
}

- (void)click
{
    if ([self stringContainsEmoji:_mycommenttext.text]) {
        
        [GYUtils showMessage:kLocalized(@"GYHE_Food_NoEnterEmoticons") confirm:^{
            
        }];
        
    }
    else {
        if (_mycommenttext.text.length > 128) { 
            [GYUtils showMessage:kLocalized(@"GYHE_Food_LengthLimitPrompt") confirm:nil];
        }
        else {
            if ([_gydelegate respondsToSelector:@selector(setValut:)]) {
                [_gydelegate setValut:_mycommenttext.text];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark textDelegate
- (void)textViewDidEndEditing:(UITextView*)textView
{
    if ([self stringContainsEmoji:textView.text]) {
        
        [GYUtils showMessage:kLocalized(@"GYHE_Food_NoEnterEmoticons") confirm:^{
            
        }];
    }
}

- (void)textViewDidBeginEditing:(UITextView*)textView
{
    _lab.text = @"";
}

- (BOOL)stringContainsEmoji:(NSString*)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
                                                                                                                                   ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];

                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else { // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
                                                                                                                                   }];
    return returnValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
