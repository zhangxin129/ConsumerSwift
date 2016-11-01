//
//  GYHDUserSetingHeaderCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDUserSetingHeaderCell.h"


@interface GYHDUserSetingHeaderCell ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UITextField *nametextField;
@property (weak, nonatomic) IBOutlet UILabel *hsNumLab;
//@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noteWidth;

@property (weak, nonatomic) IBOutlet UIButton *editNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *editNoteBtn;

@end

@implementation GYHDUserSetingHeaderCell

- (void)awakeFromNib {
    _headerImgV.layer.cornerRadius = _headerImgV.frame.size.width / 2.0;
    _headerImgV.clipsToBounds = YES;
    _headerImgV.image = [UIImage imageNamed:@"gyhd_defaultheadimg"];
    
    _nametextField.userInteractionEnabled = NO;
    _noteTextField.userInteractionEnabled = NO;
    _nametextField.delegate = self;
    _noteTextField.delegate = self;
    [_editNameBtn addTarget:self action:@selector(editName) forControlEvents:UIControlEventTouchUpInside];
    [_editNoteBtn addTarget:self action:@selector(editNote) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_nametextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_noteTextField];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_nametextField];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if(self.model) {
        CGSize size = [_nametextField.text sizeWithAttributes:@{NSFontAttributeName : kfont(15)}];
        size.width = (size.width > (kScreenWidth - 170) * 0.8)? (kScreenWidth - 170) * 0.8 : size.width + 2;
        _nameWidth.constant = size.width;
        
        CGSize sizeNote = [_noteTextField.text sizeWithAttributes:@{NSFontAttributeName : kfont(10)}];
        sizeNote.width = (sizeNote.width > (kScreenWidth - 95) * 0.8)? (kScreenWidth - 95) * 0.8 : sizeNote.width + 2;
        _noteWidth.constant = sizeNote.width;

        
//        CGSize sizeNote = [_noteTextView.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]}];
//        sizeNote.width = (sizeNote.width > (kScreenWidth - 85) * 0.8) ? (kScreenWidth - 85) * 0.8 : sizeNote.width + 10;
//        _noteWidth.constant = sizeNote.width;
    }
}
#pragma mark - UITextFieldDelegate
-(void)textFiledEditChanged:(NSNotification *)obj{
    [self layoutSubviews];
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if(textField == _nametextField) {
                if (toBeString.length > 11) {
                    textField.text = [toBeString substringToIndex:11];
                    
                    [GYUtils showToastOnKeyboard:kLocalized(@"昵称长度不超过11位")];
                }
            }else if (textField == _noteTextField) {
                if (toBeString.length > 25) {
                    textField.text = [toBeString substringToIndex:25];
                    
                    [GYUtils showToastOnKeyboard:kLocalized(@"签名长度不超过25位")];
                }
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(textField == _nametextField) {
            if (toBeString.length > 11) {
                textField.text = [toBeString substringToIndex:11];
                
                [GYUtils showToastOnKeyboard:kLocalized(@"昵称长度不超过11位")];
            }
        }else if (textField == _noteTextField) {
            if (toBeString.length > 25) {
                textField.text = [toBeString substringToIndex:25];
                
                [GYUtils showToastOnKeyboard:kLocalized(@"签名长度不超过25位")];
            }
        }

    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self endEditing:YES];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    [self layoutSubviews];
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self layoutSubviews];
    if(textField == _nametextField) {
        _editNameBtn.hidden = NO;
        _nametextField.userInteractionEnabled = NO;
    }else {
        _editNoteBtn.hidden = NO;
        _noteTextField.userInteractionEnabled = NO;
    }
    if([self.delegate respondsToSelector:@selector(requeatInfo:withName:withSign:)]) {
        [self.delegate requeatInfo:self withName:_nametextField.text withSign:_noteTextField.text];
    }
}
#pragma mark - UITextViewDelegate
//- (void)textViewDidChange:(UITextView *)textView {
//    [self layoutSubviews];
//    
//    if(textView.text.length > 25) {
//        [self endEditing:YES];
//    }
//}
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    _editNoteBtn.hidden = NO;
//    _noteTextView.userInteractionEnabled = NO;
//    if(textView.text.length >= 25) {
//        _noteTextView.text = [textView.text substringToIndex:25];
//        [GYUtils showMessage:kLocalized(@"签名长度不超过25位")];
//    }
//    if([self.delegate respondsToSelector:@selector(requeatInfo:withName:withSign:)]) {
//        [self.delegate requeatInfo:self withName:_nametextField.text withSign:_noteTextView.text];
//    }
//}
#pragma mark - 点击事件
- (void)editName {
    kCheckLoginedToRoot
    _nametextField.userInteractionEnabled = YES;
    [_nametextField becomeFirstResponder];
    
    _editNameBtn.hidden = YES;
}
- (void)editNote {
    kCheckLoginedToRoot
    _noteTextField.userInteractionEnabled = YES;
    [_noteTextField becomeFirstResponder];
    
    _editNoteBtn.hidden = YES;
}

- (IBAction)showQR:(UIButton *)sender {
    kCheckLoginedToRoot
    if([self.delegate respondsToSelector:@selector(showQR:)]) {
        [self.delegate showQR:self];
    }
}
#pragma mark - setting
- (void)setModel:(GYHDUserSetingHeaderModel *)model {
    _model = model;
    NSString *imgUrl;
    if ([model.headImage hasPrefix:@"http"]) {
        imgUrl = model.headImage;
    }else {
        imgUrl = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, model.headImage];
    }
    [_headerImgV setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    _nametextField.text = model.nickName;
    _hsNumLab.text = [GYUtils formatCardNo:model.resNo];
    _noteTextField.text = model.sign;
}


@end
