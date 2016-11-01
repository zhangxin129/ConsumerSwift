//
//  GYHSMyContactInfoThirdCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyContactInfoThirdCell.h"
#import "GYHSMyContactInfoMainModel.h"
#import <YYKit/UIButton+YYWebImage.h>
#import <YYKit/UIControl+YYAdd.h>

@interface GYHSMyContactInfoThirdCell ()

@property (weak, nonatomic) IBOutlet UIButton* helpBusinessFileButton;

@property (weak, nonatomic) IBOutlet UILabel* helpBusinessFileLabel;

@property (weak, nonatomic) IBOutlet UIButton* linkManPowerAttorneyFileButton;

@property (weak, nonatomic) IBOutlet UILabel* linkManPowerAttorneyFileLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* linkManCenterXContraint;
/*!
 *    是否为创业资源
 */
@property (assign, nonatomic) BOOL isEntrepreneurshipResouce;

@end

@implementation GYHSMyContactInfoThirdCell

- (void)awakeFromNib
{
    [self.helpBusinessFileButton removeAllTargets];
    [self.linkManPowerAttorneyFileButton removeAllTargets];
    
    self.helpBusinessFileLabel.textColor = kGray333333;
    self.linkManPowerAttorneyFileLabel.textColor = kGray333333;
    
    self.helpBusinessFileLabel.text = kLocalized(@"GYHS_Myhs_Help_Business_File");
    self.linkManPowerAttorneyFileLabel.text = kLocalized(@"GYHS_Myhs_Contact_Power_Of_Attorney");
    
    
    if ([globalData.loginModel.startResType isEqualToString:@"2"]) {
        self.isEntrepreneurshipResouce = YES;
    }
    else {
        self.isEntrepreneurshipResouce = NO;
    }
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.customBorderColor = kGrayE3E3EA;
    self.contentView.customBorderLineWidth = @1;
    self.contentView.customBorderType = UIViewCustomBorderTypeAll;
}

- (void)setNeedsUpdateConstraints
{
    [super setNeedsUpdateConstraints];
    NSLayoutConstraint* conCenterX = [NSLayoutConstraint constraintWithItem:self.linkManPowerAttorneyFileButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    conCenterX.priority = UILayoutPriorityDefaultHigh;
    [self.contentView addConstraint:conCenterX];
}

#pragma mark -  pravite method
- (void)hideHelpBusinessFile
{
    self.helpBusinessFileButton.hidden = YES;
    self.helpBusinessFileLabel.hidden = YES;
    [self setNeedsUpdateConstraints];
}

- (void)setIsEntrepreneurshipResouce:(BOOL)isEntrepreneurshipResouce
{
    _isEntrepreneurshipResouce = isEntrepreneurshipResouce;
    if (!isEntrepreneurshipResouce) {
        [self hideHelpBusinessFile];
    }
}

- (void)setModel:(GYHSMyContactInfoMainModel*)model
{
    _model = model;
    //下2行debug用的
//    _model.authProxyFile = @"";
//     _model.helpAgreement = @"";
    
    if (self.helpBusinessFileButton.allTargets.count > 0) {
        [self.helpBusinessFileButton removeAllTargets];
    }
    if (self.linkManPowerAttorneyFileButton.allTargets.count > 0) {
        [self.linkManPowerAttorneyFileButton removeAllTargets];
    }
    
    if (model.authProxyFile.length == 0) {
        self.linkManPowerAttorneyFileButton.enabled = YES;
        [self.linkManPowerAttorneyFileButton addTarget:self action:@selector(linkManPowerAttorneyFileButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self.linkManPowerAttorneyFileButton addTarget:self action:@selector(linkManPowerAttorneyFileButtonBrower:) forControlEvents:UIControlEventTouchUpInside];
    }
    DDLogInfo(@"%@",GY_PICTUREAPPENDING(model.authProxyFile));
    [self.linkManPowerAttorneyFileButton setBackgroundImageWithURL:[NSURL URLWithString:GY_PICTUREAPPENDING(model.authProxyFile)] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"gyhs_addImage"]];
    [self.linkManPowerAttorneyFileButton setBackgroundImageWithURL:[NSURL URLWithString:GY_PICTUREAPPENDING(model.authProxyFile)] forState:UIControlStateHighlighted placeholder:[UIImage imageNamed:@"gyhs_addImage"]];
    
    if (!self.helpBusinessFileButton.isHidden) {
        if (model.helpAgreement.length == 0) {
            self.helpBusinessFileButton.enabled = YES;
            [self.helpBusinessFileButton addTarget:self action:@selector(helpBusinessFileButtonAct:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [self.helpBusinessFileButton addTarget:self action:@selector(helpBusinessFileButtonBrower:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.helpBusinessFileButton setBackgroundImageWithURL:[NSURL URLWithString:GY_PICTUREAPPENDING(model.helpAgreement)] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"gyhs_addImage"]];
        [self.helpBusinessFileButton setBackgroundImageWithURL:[NSURL URLWithString:GY_PICTUREAPPENDING(model.helpAgreement)] forState:UIControlStateHighlighted placeholder:[UIImage imageNamed:@"gyhs_addImage"]];
    }
}

#pragma mark - event response
- (IBAction)helpBusinessFileButtonBrower:(id)sender {
    //浏览创业帮扶文件
    if (self.toBrowerHelpFileBlock) {
        self.toBrowerHelpFileBlock(sender);
    }
}

- (IBAction)helpBusinessFileButtonAct:(UIButton*)sender
{
    //上传创业帮扶
    if (self.toUploadHelpFileBlock) {
        self.toUploadHelpFileBlock(sender);
    }
}

- (IBAction)linkManPowerAttorneyFileButtonBrower:(id)sender {
    //浏览联系人授权书
    if (self.toBrowerLinkFileBlock) {
        self.toBrowerLinkFileBlock(sender);
    }
}

- (IBAction)linkManPowerAttorneyFileButtonAct:(UIButton*)sender
{
    //上传联系人授权书
    if (self.toUploadLinkFileBlock) {
        self.toUploadLinkFileBlock(sender);
    }
}

@end
