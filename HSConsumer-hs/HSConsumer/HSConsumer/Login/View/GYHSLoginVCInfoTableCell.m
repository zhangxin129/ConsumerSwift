//
//  GYHSLoginVCInfoTableCell.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginVCInfoTableCell.h"

@interface GYHSLoginVCInfoTableCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView* userImageView;
@property (weak, nonatomic) IBOutlet UITextField* inputTextField;
@property (weak, nonatomic) IBOutlet UIButton* downButton;
@property (weak, nonatomic) IBOutlet UIImageView* downImageView;

@property (strong, nonatomic) NSIndexPath* indexPath;
@property (assign, nonatomic) BOOL pwdTextField;

@end

#pragma mark - public methods
@implementation GYHSLoginVCInfoTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.inputTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setCellValue:(NSString*)imageName
               value:(NSString*)value
         placeHolder:(NSString*)placeHolder
        pwdTextField:(BOOL)pwdTextField
           indexPath:(NSIndexPath*)indexPath
{

    self.userImageView.image = [UIImage imageNamed:imageName];
    self.inputTextField.text = value;
    self.inputTextField.placeholder = placeHolder;
    self.inputTextField.delegate = self;

    self.pwdTextField = pwdTextField;

    if (self.pwdTextField) {
        self.inputTextField.secureTextEntry = YES;

        self.downButton.hidden = YES;
        self.downImageView.hidden = YES;
    }

    self.indexPath = indexPath;
}

- (UITextField*)cellInputTextField
{
    return self.inputTextField;
}

- (IBAction)downButtonAction:(UIButton*)sender
{
    DDLogDebug(@"%s", __FUNCTION__);
    if ([self.cellDelegate respondsToSelector:@selector(pullDownBtnAction:indexPath:)]) {
        [self.cellDelegate pullDownBtnAction:self.downImageView indexPath:self.indexPath];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if ([self.cellDelegate respondsToSelector:@selector(inputTextField:indexPath:)]) {
        [self.cellDelegate inputTextField:textField indexPath:self.indexPath];
    }

    return YES;
}

@end
