//
//  GYHSMyImportantCommitCellTableViewCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyImportantCommitCell.h"
#import <GYKit/GYPlaceholderTextView.h>

@interface GYHSMyImportantCommitCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton* businessLicenseBtn;
@property (weak, nonatomic) IBOutlet UILabel* businessLicenseTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton* businessLicenseExampleBtn;

@property (weak, nonatomic) IBOutlet UIButton* contactPowerOfAttorneyBtn;
@property (weak, nonatomic) IBOutlet UILabel* contactPowerOfAttorneyTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton* contactPowerOfAttorneyExampleBtn;

@property (weak, nonatomic) IBOutlet UIButton* businessProcessApplicationBtn;
@property (weak, nonatomic) IBOutlet UILabel* businessProcessApplicationTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton* businessProcessApplicationExampleBtn;

@property (weak, nonatomic) IBOutlet UILabel* resonTitleLabel;
@property (weak, nonatomic) IBOutlet GYPlaceholderTextView* inputReasonTextView;
@property (weak, nonatomic) IBOutlet UILabel* codeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel* codeLabel;

@property (weak, nonatomic) IBOutlet UITextField* codeTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* businessLicenseBtnCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* contactPowerOfAttorneyBtnCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* businessProcessApplicationBtnCenter;

@property (nonatomic, assign) BOOL businessLicenseShow;
@property (nonatomic, assign) BOOL contactPowerOfAttorneyShow;

@end

@implementation GYHSMyImportantCommitCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.businessLicenseTitleLabel.text = kLocalized(@"GYHS_Myhs_Business_License");
    self.contactPowerOfAttorneyTitleLabel.text = kLocalized(@"GYHS_Myhs_Contact_Power_Of_Attorney");
    self.businessProcessApplicationTitleLabel.text = kLocalized(@"GYHS_Myhs_Bussiness_Apply");
    self.resonTitleLabel.text = kLocalized(@"GYHS_Myhs_Chage_Reason_Colon");
    self.codeTitleLabel.text = kLocalized(@"GYHS_Myhs_Code_Colon");
    
    self.businessLicenseTitleLabel.textColor = kGray333333;
    self.contactPowerOfAttorneyTitleLabel.textColor = kGray333333;
    self.businessProcessApplicationTitleLabel.textColor = kGray333333;
    self.resonTitleLabel.textColor = kGray333333;
    self.codeTitleLabel.textColor = kGray333333;
    
    [self getRandomCode];
    
    self.codeTextField.delegate = self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.codeTextField.customBorderType = UIViewCustomBorderTypeAll;
    self.codeTextField.customBorderColor = kGrayE3E3EA;
    self.codeTextField.customBorderLineWidth = @1;
    
    self.inputReasonTextView.customBorderType = UIViewCustomBorderTypeAll;
    self.inputReasonTextView.customBorderColor = kGrayE3E3EA;
    self.inputReasonTextView.customBorderLineWidth = @1;
    self.inputReasonTextView.placeholder = kLocalized(@"GYHS_Myhs_Input_Reason_Max_Tip");
    [self.inputReasonTextView setPlaceholderFont:kFont32];
}

- (void)updateConstraints
{
    [super updateConstraints];
    if (!self.contactPowerOfAttorneyShow && self.businessLicenseShow) {
        self.businessLicenseBtnCenter.constant = kDeviceProportion(-140);
        self.businessProcessApplicationBtnCenter.constant = kDeviceProportion(140);
    }
    
    if (self.contactPowerOfAttorneyShow && !self.businessLicenseShow) {
        self.contactPowerOfAttorneyBtnCenter.constant = kDeviceProportion(-140);
        self.businessProcessApplicationBtnCenter.constant = kDeviceProportion(140);
    }
    
    if (self.contactPowerOfAttorneyShow && self.businessLicenseShow) {
        self.contactPowerOfAttorneyBtnCenter.constant = kDeviceProportion(0);
        self.businessProcessApplicationBtnCenter.constant = kDeviceProportion(250);
        self.businessLicenseBtnCenter.constant = kDeviceProportion(-250);
    }
    if (!self.contactPowerOfAttorneyShow && !self.businessLicenseShow) {
        self.businessProcessApplicationBtnCenter.constant = kDeviceProportion(0);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *codeText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (codeText.length > 4) {
        textField.text = [codeText substringToIndex:4];
        return NO;
    }
    return YES;
}

#pragma mark - event respose
- (IBAction)refreshCodeButton:(id)sender
{
    //随机验证码
    [self getRandomCode];
}

- (IBAction)loadDownBusinessProcessApplication:(id)sender
{
    //下载业务办理申请书模板
    if ([self.delegate respondsToSelector:@selector(loadDownBusinessProcessApplication)]) {
        [self.delegate loadDownBusinessProcessApplication];
    }
}

- (IBAction)uploadBusinessProcessApplication:(UIButton*)sender
{
    //上传业务办理申请书
    if ([self.delegate respondsToSelector:@selector(uploadTheBusinessProcessApplication:)]) {
        [self.delegate uploadTheBusinessProcessApplication:sender];
    }
}

- (IBAction)loadDownBusinessLicense:(id)sender
{
    //下载营业执照模板
    if ([self.delegate respondsToSelector:@selector(loadDownBusinessLicense)]) {
        [self.delegate loadDownBusinessLicense];
    }
}

- (IBAction)uploadBusinessLicense:(UIButton*)sender
{
    //上传营业执照
    if ([self.delegate respondsToSelector:@selector(uploadTheBusinessLicense:)]) {
        [self.delegate uploadTheBusinessLicense:sender];
    }
}

- (IBAction)loadDownContactPowerOfAttorney:(id)sender
{
    //下载联系人授权书模板
    if ([self.delegate respondsToSelector:@selector(loadDownContactPowerOfAttorney)]) {
        [self.delegate loadDownContactPowerOfAttorney];
    }
}

- (IBAction)uploadContactPowerOfAttorney:(UIButton*)sender
{
    //上传联系人授权书
    if ([self.delegate respondsToSelector:@selector(uploadTheContactPowerOfAttorney:)]) {
        [self.delegate uploadTheContactPowerOfAttorney:sender];
    }
}

#pragma mark - private methods
- (void)setBusinessLicenseImage:(UIImage*)businessLicenseImage
{
    _businessLicenseImage = businessLicenseImage;
    if (businessLicenseImage) {
        [self.businessLicenseBtn setBackgroundImage:businessLicenseImage forState:UIControlStateNormal];
    }
}

- (void)setContactPowerOfAttorneyIamge:(UIImage*)contactPowerOfAttorneyIamge
{
    _contactPowerOfAttorneyIamge = contactPowerOfAttorneyIamge;
    if (contactPowerOfAttorneyIamge) {
        [self.contactPowerOfAttorneyBtn setBackgroundImage:contactPowerOfAttorneyIamge forState:UIControlStateNormal];
    }
}

- (void)setBusinessProcessApplicationImage:(UIImage*)businessProcessApplicationImage
{
    _businessProcessApplicationImage = businessProcessApplicationImage;
    if (businessProcessApplicationImage) {
        [self.businessProcessApplicationBtn setBackgroundImage:businessProcessApplicationImage forState:UIControlStateNormal];
    }
}

- (void)setRequestDict:(NSDictionary*)requestDict
{
    _requestDict = requestDict;
    
    NSArray* keyArray = [requestDict allKeys];
    
    BOOL showContactPower = NO;
    BOOL showBusiness = NO;
    
    for (NSString* key in keyArray) {
        if ([key containsString:@"linkmanOld"] || [key containsString:@"linkmanMobileOld"]) {
            showContactPower = YES;
        }
        
        if ([key containsString:@"legalRepOld"] || [key containsString:@"custNameOld"] || [key containsString:@"custAddressOld"]) {
            showBusiness = YES;
        }
        
        
    }
    
    if (showContactPower == YES && showBusiness == NO) {
        self.businessLicenseShow = [self hideBusinessLicense];
        self.contactPowerOfAttorneyShow = [self showContactPowerOfAttorney];
        [self updateConstraints];
    }
    
    if (showContactPower == NO && showBusiness == YES) {
        self.businessLicenseShow = [self showBusinessLicense];
        self.contactPowerOfAttorneyShow = [self hideContactPowerOfAttorney];
        [self updateConstraints];
    }
    
    if (showContactPower == YES && showBusiness == YES) {
        self.businessLicenseShow = [self showBusinessLicense];
        self.contactPowerOfAttorneyShow = [self showContactPowerOfAttorney];
        [self updateConstraints];
    }
    
    if (showContactPower == NO && showBusiness == NO) {
        self.businessLicenseShow = [self hideBusinessLicense];
        self.contactPowerOfAttorneyShow = [self hideContactPowerOfAttorney];
        [self updateConstraints];
    }
}

- (BOOL)hideBusinessLicense
{
    self.businessLicenseBtn.hidden = YES;
    self.businessLicenseExampleBtn.hidden = YES;
    self.businessLicenseTitleLabel.hidden = YES;
    return NO;
}
- (BOOL)showBusinessLicense
{
    self.businessLicenseBtn.hidden = NO;
    self.businessLicenseExampleBtn.hidden = NO;
    self.businessLicenseTitleLabel.hidden = NO;
    return YES;
}

- (BOOL)hideContactPowerOfAttorney
{
    self.contactPowerOfAttorneyBtn.hidden = YES;
    self.contactPowerOfAttorneyExampleBtn.hidden = YES;
    self.contactPowerOfAttorneyTitleLabel.hidden = YES;
    return NO;
}

- (BOOL)showContactPowerOfAttorney
{
    self.contactPowerOfAttorneyBtn.hidden = NO;
    self.contactPowerOfAttorneyExampleBtn.hidden = NO;
    self.contactPowerOfAttorneyTitleLabel.hidden = NO;
    return YES;
}

- (NSString*)textViewsText
{
    _textViewsText = self.inputReasonTextView.text;
    return _textViewsText;
}

- (BOOL)isRightCode
{
    if ([_codeLabel.text compare:_codeTextField.text options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

-(BOOL)isEmptyCode {
    if (_codeLabel.text.length == 0) {
        return YES;
    }
    return NO;
}

- (NSString*)randomString:(int)length
{
    const char list[] = "0123456789";
    char sele[24], *p;
    p = sele;
    int len = (int)strlen(list);
    for (int i = 0; i < length; i++) {
        *p++ = list[arc4random() % len];
    }
    *p = 0;
    NSString* str = [NSString stringWithFormat:@"%s", sele];
    return str;
}

- (void)getRandomCode
{
    self.codeLabel.text = [self randomString:4];
    NSInteger i = random() % 10;
    NSNumber* number;
    if (rand() % 2 == 0) {
        number = [NSNumber numberWithFloat:-i * .1];
    }
    else {
        number = [NSNumber numberWithFloat:i * .1];
    }
    self.codeLabel.attributedText = [[NSAttributedString alloc] initWithString:self.codeLabel.text attributes:@{ NSKernAttributeName : number, NSForegroundColorAttributeName : kGray000000, NSFontAttributeName : kFont40 }];
}

@end
