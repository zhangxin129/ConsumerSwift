//
//  GYHSMySecondSectionCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyContactInfoSecondSectionCell.h"
#import "GYHSMyContactInfoMainModel.h"

static float space = 20.0;
static float rowHight = 40.0;

@interface GYHSMyContactInfoSecondSectionCell () <UITextFieldDelegate>
//联系信息等控件
@property (weak, nonatomic) IBOutlet UILabel* contactAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton* contactAddressbutton;
@property (weak, nonatomic) IBOutlet UIButton* contactAddressCancelButton;
@property (weak, nonatomic) IBOutlet UIButton* contactAddressComfirmButton;
@property (weak, nonatomic) IBOutlet UITextField* contactAddressModifyTextField;
//邮政编码等控件
@property (weak, nonatomic) IBOutlet UILabel* postCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton* postCodebutton;
@property (weak, nonatomic) IBOutlet UIButton* postCodeCancelButton;
@property (weak, nonatomic) IBOutlet UIButton* postCodeComfirmButton;
@property (weak, nonatomic) IBOutlet UITextField* postCodeModifyTextField;
//企业邮箱等控件
@property (weak, nonatomic) IBOutlet UILabel* companyEmailLabel;
@property (weak, nonatomic) IBOutlet UIView* companyEmailBaseView;
@property (weak, nonatomic) IBOutlet UILabel* companyEmaiContentLabel;
@property (weak, nonatomic) IBOutlet UILabel* companyEmaiAuthLabel;
@property (weak, nonatomic) IBOutlet UIButton* toGoEmailButton;
@property (weak, nonatomic) IBOutlet UIButton* companyEmailCancelButton;
@property (weak, nonatomic) IBOutlet UIButton* companyEmailComfirmButton;
@property (weak, nonatomic) IBOutlet UITextField* companyEmailModifyTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* postCodeTopConstaint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* companyEmailTopConstaint;

@property (nonatomic, assign) float cellHeight;

@property (nonatomic, assign) BOOL lineTwoShow;
@property (nonatomic, assign) BOOL lineFourShow;
@property (nonatomic, assign) BOOL lineSixShow;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* addressRowHeight;

/**文本变化时产生的高度*/
@property (assign, nonatomic) CGFloat oldSpace;

@end

@implementation GYHSMyContactInfoSecondSectionCell

- (void)awakeFromNib
{
    self.contactAddressLabel.text = kLocalized(@"GYHS_Myhs_Contact_Address_Colon");
    self.postCodeLabel.text = kLocalized(@"GYHS_Myhs_Post_Code_Colon");
    self.companyEmailLabel.text = kLocalized(@"GYHS_Myhs_Company_Saft_Email_Colon");
    
    self.contactAddressModifyTextField.placeholder = kLocalized(@"GYHS_Myhs_PleaseInputContent");
    self.postCodeModifyTextField.placeholder = kLocalized(@"GYHS_Myhs_PleaseInputContent");
    self.companyEmailModifyTextField.placeholder = kLocalized(@"GYHS_Myhs_PleaseInputContent");
    
    //设置字体颜色等
    [self someTextAttLabel:self.contactAddressLabel button:self.contactAddressbutton textField:self.contactAddressModifyTextField];
    [self someTextAttLabel:self.postCodeLabel button:self.postCodebutton textField:self.postCodeModifyTextField];
    [self someTextAttLabel:self.companyEmailLabel button:nil textField:self.companyEmailModifyTextField];
    self.companyEmaiContentLabel.textColor = kGray333333;
    //设置访问邮箱的字体颜色及隐藏
    [self.toGoEmailButton setTitleColor:kBlue0A59C2 forState:UIControlStateNormal];
    self.toGoEmailButton.hidden = YES;
    
    //企业地址太长换行
    self.contactAddressbutton.titleLabel.numberOfLines = 0;
    
    self.contactAddressModifyTextField.delegate = self;
    self.postCodeModifyTextField.delegate = self;
    self.companyEmailModifyTextField.delegate = self;
    
    self.lineTwoShow = [self hideLineTwo];
    self.lineFourShow = [self hideLineFour];
    self.lineSixShow = [self hideLineSix];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyEmailButtonAction)];
    [self.companyEmailBaseView addGestureRecognizer:tap];
    
    [self.contactAddressbutton.titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addLine:self.contentView];
    
    self.cellHeight = self.size.height;
}

- (void)dealloc
{
    [self.contactAddressbutton.titleLabel removeObserver:self forKeyPath:@"text"];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"text"]) {
        //    //计算地址行的高度
        CGFloat addressRowHeight = [self.contactAddressbutton.currentTitle boundingRectWithSize:CGSizeMake(self.contactAddressbutton.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : kFont32 } context:nil].size.height;
        
        if (ceil(addressRowHeight) + 10 > 40) {
            self.addressRowHeight.constant = ceil(addressRowHeight) + 10;
            //标记oldSpace的高度大小
            self.oldSpace = self.addressRowHeight.constant - 40;
            //更新cell的总高度
            self.cellHeight = self.cellHeight + self.oldSpace;
        }
        else {
            self.addressRowHeight.constant = 40;
            //更新cell的总高度，去除之前增加的高度
            self.cellHeight = self.cellHeight - self.oldSpace;
            //去除完成设置为0
            self.oldSpace = 0;
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.contactAddressModifyTextField) {
        if (text.length > 128) {
            textField.text = [text substringToIndex:128];
            [textField tipWithContent:kLocalized(@"GYHS_Myhs_Contact_Address_Max_Length_128") animated:YES];
            [textField resignFirstResponder];
            return NO;
        }
    }
    
    if (textField == self.postCodeModifyTextField) {
        if (![string isValidNumber]) {
            return NO;
        }
        
        if (text.length > 6) {
            textField.text = [text substringToIndex:6];
            [textField tipWithContent:kLocalized(@"GYHS_Myhs_Post_Code_Max_6") animated:YES];
            [textField resignFirstResponder];
            return NO;
        }
    }
    
    if (textField == self.companyEmailModifyTextField) {
        if (text.length > 30) {
            textField.text = [text substringToIndex:30];
            [textField tipWithContent:kLocalized(@"GYHS_Myhs_Email_Format_Lengh_30") animated:YES];
            [textField resignFirstResponder];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -  event respose
- (IBAction)toGoEmailButtonActon:(UIButton*)sender
{
    //去验证邮箱
    NSRange emailRange = [self.model.email rangeOfString:@"@"];
    NSString* urlTail = [self.model.email substringFromIndex:emailRange.location + 1];
    NSString* httpsUrl = [NSString stringWithFormat:@"https://mail.%@", urlTail];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:httpsUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:httpsUrl]];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://"]];
    }
}

- (IBAction)contactAddressButtonAction
{
    //点击地址行
    if (!self.lineTwoShow) {
        [self addRedLine:self.contactAddressModifyTextField];
        [self addLine:self.contactAddressbutton];
        self.cellHeight = self.cellHeight + rowHight + space;
        self.lineTwoShow = [self showLineTwo];
    }
}

- (IBAction)contactAddressCancelAction
{
    //点击地址取消
    [self removeLine:self.contactAddressModifyTextField];
    [self removeLine:self.contactAddressbutton];
    self.cellHeight = self.cellHeight - rowHight - space;
    self.lineTwoShow = [self hideLineTwo];
}

- (IBAction)contactAddressComfirmAction
{
    //点击地址确定
    if ([self.delegate respondsToSelector:@selector(updateContactAddress:complete:)]) {
        [self.delegate updateContactAddress:self.contactAddressModifyTextField
                                   complete:^{
                                       
                                       [self removeLine:self.contactAddressModifyTextField];
                                       [self removeLine:self.contactAddressbutton];
                                       self.cellHeight = self.cellHeight - rowHight - space;
                                       self.lineTwoShow = [self hideLineTwo];
                                       
                                   }];
    }
}

- (IBAction)postCodeButtonAction
{
    //点击邮政行
    if (!self.lineFourShow) {
        [self addRedLine:self.postCodeModifyTextField];
        [self addLine:self.postCodebutton];
        self.cellHeight = self.cellHeight + rowHight + space;
        self.lineFourShow = [self showLineFour];
    }
}

- (IBAction)postCodeCancelAction
{
    //点击邮政取消
    [self removeLine:self.postCodeModifyTextField];
    [self removeLine:self.postCodebutton];
    self.cellHeight = self.cellHeight - rowHight - space;
    self.lineFourShow = [self hideLineFour];
}

- (IBAction)postCodeComfirmAction
{
    //点击邮政确定
    
    if ([self.delegate respondsToSelector:@selector(updatePostCode:complete:)]) {
        [self.delegate updatePostCode:self.postCodeModifyTextField
                             complete:^{
                                 
                                 [self removeLine:self.postCodeModifyTextField];
                                 [self removeLine:self.postCodebutton];
                                 self.cellHeight = self.cellHeight - rowHight - space;
                                 self.lineFourShow = [self hideLineFour];
                             }];
    }
}

- (void)companyEmailButtonAction
{
    //点击企业邮箱行
    if (!self.lineSixShow) {
        [self addRedLine:self.companyEmailModifyTextField];
        [self addLine:self.companyEmailBaseView];
        self.cellHeight = self.cellHeight + rowHight + space;
        self.lineSixShow = [self showLineSix];
    }
}

- (IBAction)companyEmailCancelAction
{
    //点击企业邮箱取消
    [self removeLine:self.companyEmailModifyTextField];
    [self removeLine:self.companyEmailBaseView];
    self.cellHeight = self.cellHeight - rowHight - space;
    self.lineSixShow = [self hideLineSix];
}

- (IBAction)companyEmailComfirmAction
{
    //点击企业邮箱确定
    
    if ([self.delegate respondsToSelector:@selector(updateCompanyEmail:complete:)]) {
        [self.delegate updateCompanyEmail:self.companyEmailModifyTextField
                                 complete:^{
                                     
                                     [self removeLine:self.companyEmailModifyTextField];
                                     [self removeLine:self.companyEmailBaseView];
                                     self.cellHeight = self.cellHeight - rowHight - space;
                                     self.lineSixShow = [self hideLineSix];
                                 }];
    }
}

#pragma mark -  pravite method
- (void)setCellHeight:(float)cellHeight
{
    if (_cellHeight != cellHeight) {
        _cellHeight = cellHeight;
        [self resposeHeightDelegate];
    }
}

- (void)setModel:(GYHSMyContactInfoMainModel*)model
{
    _model = model;
    
    [self.contactAddressbutton setTitle:model.contactAddr forState:UIControlStateNormal];
    
    [self.postCodebutton setTitle:model.postCode forState:UIControlStateNormal];
    
    self.companyEmaiContentLabel.text = [NSString stringWithFormat:@"%@", model.email];
    
    if (model.isAuthEmail.boolValue) {
        self.companyEmaiAuthLabel.attributedText = [[NSAttributedString alloc] initWithString:kLocalized(@"GYHS_Myhs_Verified_Two") attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kBlue0C69E9 }];
        self.companyEmaiAuthLabel.hidden = NO;
        self.toGoEmailButton.hidden = YES;
    }
    else {
        if (model.email.length != 0) {
            self.companyEmaiAuthLabel.attributedText = [[NSAttributedString alloc] initWithString:kLocalized(@"GYHS_Myhs_No_Verified_Two") attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kRedE50012 }];
            self.toGoEmailButton.hidden = NO;
            self.companyEmaiAuthLabel.hidden = NO;
        }
        else {
            self.toGoEmailButton.hidden = YES;
            self.companyEmaiAuthLabel.hidden = YES;
        }
    }
}

- (void)addLine:(UIView*)view
{
    view.customBorderColor = kGrayE3E3EA;
    view.customBorderLineWidth = @1;
    view.customBorderType = UIViewCustomBorderTypeAll;
}

- (void)addRedLine:(UIView*)view
{
    view.customBorderColor = kRedE50012;
    view.customBorderLineWidth = @1;
    view.customBorderType = UIViewCustomBorderTypeAll;
}

- (void)removeLine:(UIView*)view
{
    view.customBorderColor = [UIColor clearColor];
    view.customBorderLineWidth = @0;
    view.customBorderType = UIViewCustomBorderTypeAll;
}

- (void)someTextAttLabel:(UILabel*)label button:(UIButton*)button textField:(UITextField*)textField
{
    if (label) {
        label.textColor = kGray666666;
    }
    if (button) {
        button.titleLabel.font = kFont32;
        [button setTitleColor:kGray333333 forState:UIControlStateNormal];
    }
    if (textField) {
        textField.textColor = kGray333333;
    }
}

- (BOOL)hideLineTwo
{
    self.postCodeTopConstaint.constant = space;
    self.contactAddressCancelButton.hidden = YES;
    self.contactAddressComfirmButton.hidden = YES;
    self.contactAddressModifyTextField.hidden = YES;
    return NO;
}

- (BOOL)showLineTwo
{
    self.postCodeTopConstaint.constant = 2 * space + rowHight;
    self.contactAddressCancelButton.hidden = NO;
    self.contactAddressComfirmButton.hidden = NO;
    self.contactAddressModifyTextField.hidden = NO;
    return YES;
}

- (BOOL)showLineFour
{
    self.companyEmailTopConstaint.constant = 2 * space + rowHight;
    self.postCodeModifyTextField.hidden = NO;
    self.postCodeComfirmButton.hidden = NO;
    self.postCodeCancelButton.hidden = NO;
    return YES;
}

- (BOOL)hideLineFour
{
    self.companyEmailTopConstaint.constant = space;
    self.postCodeModifyTextField.hidden = YES;
    self.postCodeComfirmButton.hidden = YES;
    self.postCodeCancelButton.hidden = YES;
    return NO;
}

- (BOOL)hideLineSix
{
    self.companyEmailModifyTextField.hidden = YES;
    self.companyEmailComfirmButton.hidden = YES;
    self.companyEmailCancelButton.hidden = YES;
    return NO;
}

- (BOOL)showLineSix
{
    self.companyEmailModifyTextField.hidden = NO;
    self.companyEmailComfirmButton.hidden = NO;
    self.companyEmailCancelButton.hidden = NO;
    return YES;
}

- (void)resposeHeightDelegate
{
    
    if ([self.delegate respondsToSelector:@selector(updateCellHeight:)]) {
        [self.delegate updateCellHeight:self.cellHeight];
    }
}


@end
