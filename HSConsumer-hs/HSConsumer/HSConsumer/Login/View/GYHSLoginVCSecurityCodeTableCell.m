//
//  GYHSLoginVCButtonActionTableCellTableViewCell.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginVCSecurityCodeTableCell.h"
#import "GYHSConstant.h"
#import "GYRandomCodeView.h"

@interface GYHSLoginVCSecurityCodeTableCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField* securityCodeTextTield;
@property (weak, nonatomic) IBOutlet GYRandomCodeView* securityView;
@property (weak, nonatomic) IBOutlet UIButton* securityBtn;
@property (strong, nonatomic) NSIndexPath* indexPath;

@end

@implementation GYHSLoginVCSecurityCodeTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.securityCodeTextTield.inputView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellName:(NSString*)placeHodler
            btnName:(NSString*)btnName
          indexPath:(NSIndexPath*)indexPath
{
    self.securityCodeTextTield.placeholder = placeHodler;
    self.securityCodeTextTield.delegate = self;
    [self.securityBtn setTitle:btnName forState:UIControlStateNormal];
    self.indexPath = indexPath;

    self.securityView.randColor = NO;
    self.securityView.interferingLine = NO;
    self.securityView.interferingPoint = NO;
    self.securityView.randomPointY = NO;

    [self getCodeText];
}

- (void)refreshVerifyCode
{
    [self getCodeText];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if ([self.cellDelegate respondsToSelector:@selector(inputAnswer:indexPath:)]) {
        [self.cellDelegate inputAnswer:textField indexPath:self.indexPath];
    }

    return YES;
}

#pragma mark - Action
- (IBAction)securityBtnAction:(id)sender
{
    [self getCodeText];
}

- (void)getCodeText
{
    [self.securityView refreshVerifyCode];

    if ([self.cellDelegate respondsToSelector:@selector(securityGenCode:)]) {
        [self.cellDelegate securityGenCode:self.securityView.currentVerifyCode];
    }
}

@end
