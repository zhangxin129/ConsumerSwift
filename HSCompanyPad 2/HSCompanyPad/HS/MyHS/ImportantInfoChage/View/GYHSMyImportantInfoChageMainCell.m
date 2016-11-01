//
//  GYHSMyImportantInfoChageMainCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyImportantInfoChageMainCell.h"

static float space = 20.0;
static float rowHight = 40.0;

@interface GYHSMyImportantInfoChageMainCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UIButton* contentButton;
@property (weak, nonatomic) IBOutlet UITextField* modifyContentTextFiled;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;
@property (weak, nonatomic) IBOutlet UIButton* comfirmButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* leftSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* midSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* rowHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* contentButtonHeight;

@property (nonatomic, assign) BOOL isShowLineTwo;
@property (nonatomic, copy) NSString* oldContent;
@property (nonatomic, assign) BOOL haveOldContent;

/**文本变化时产生的高度*/
@property (assign, nonatomic) CGFloat oldSpace;

@end

@implementation GYHSMyImportantInfoChageMainCell

- (void)awakeFromNib
{
    self.modifyContentTextFiled.placeholder = kLocalized(@"GYHS_Myhs_PleaseInputContent");
    _topConstraint.constant = kDeviceProportion(_topConstraint.constant);
    _leftSpaceConstraint.constant = kDeviceProportion(_leftSpaceConstraint.constant);
    
    _rowHeight.constant = kDeviceProportion(_rowHeight.constant);
    _contentButtonHeight.constant = kDeviceProportion(_contentButtonHeight.constant);
    
    self.titleLabel.textColor = kGray666666;
    [self.contentButton setTitleColor:kGray333333 forState:UIControlStateNormal];
    self.modifyContentTextFiled.textColor = kGray333333;
    self.modifyContentTextFiled.delegate = self;
    self.isShowLineTwo = [self hideLineTwo];
    
    [self.contentButton.titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    self.contentButton.titleLabel.numberOfLines = 0;
}

- (void)dealloc
{
    [self.contentButton.titleLabel removeObserver:self forKeyPath:@"text"];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    
    if ([keyPath isEqualToString:@"text"]) {
        //    //计算地址行的高度
        CGFloat addressRowHeight = [self.contentButton.currentTitle boundingRectWithSize:CGSizeMake(self.contentButton.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : kFont32 } context:nil].size.height;
        
        if (ceil(addressRowHeight) + 10 > kDeviceProportion(rowHight)) {
            self.contentButtonHeight.constant = ceil(addressRowHeight) + 10;
            //标记oldSpace的高度大小
            self.oldSpace = self.contentButtonHeight.constant - kDeviceProportion(rowHight);
            //更新cell的总高度
            self.cellHeight = self.cellHeight + self.oldSpace;
        }
        else {
            self.contentButtonHeight.constant = kDeviceProportion(rowHight);
            //更新cell的总高度，去除之前增加的高度
            self.cellHeight = self.cellHeight - self.oldSpace;
            //去除完成设置为0
            self.oldSpace = 0;
        }
    }
}

#pragma mark - event respose
- (IBAction)cancelAction:(id)sender
{
    if (self.isShowLineTwo) {
        self.cellHeight = self.cellHeight - (kDeviceProportion(space + rowHight));
        self.isShowLineTwo = [self hideLineTwo];
        [self removeLine:self.contentButton];
        [self removeLine:self.modifyContentTextFiled];
    }
}

- (IBAction)comfirmAction:(id)sender
{
    if (self.isShowLineTwo) {
        if ([self.delegate respondsToSelector:@selector(updateContent:indexPath:)]) {
            BOOL succuss = [self.delegate updateContent:self.modifyContentTextFiled indexPath:self.indexPath];
            if (succuss) {
                self.cellHeight = self.cellHeight - (kDeviceProportion(space + rowHight));
                [self.contentButton setTitle:self.modifyContentTextFiled.text forState:UIControlStateNormal];
                self.isShowLineTwo = [self hideLineTwo];
                [self removeLine:self.contentButton];
                [self removeLine:self.modifyContentTextFiled];
            }
        }
    }
}

- (IBAction)contentAction:(id)sender
{
    if (!self.isShowLineTwo) {
        self.cellHeight = self.cellHeight + (kDeviceProportion(space + rowHight));
        [self addLine:self.contentButton];
        [self addRedLine:self.modifyContentTextFiled];
        self.isShowLineTwo = [self showLineTwo];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    switch (self.indexPath.row) {
        case 2:
            //营业执照注册号
        case 4:
            //联系人手机号
        case 6:
            //法人手机号
        {
            
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
            
        case 0:
            //企业名称
        case 1:
            //企业注册地址
        case 3:
            //法人代表
        case 5:
            //联系人姓名
        default:
            textField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
    return YES;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (self.indexPath.row) {
        case 0: {
            //企业名称
            if (text.length > 60) {
                textField.text = [text substringToIndex:60];
                return NO;
            }
        } break;
            
        case 1: {
            //企业注册地址
            if (text.length > 128) {
                textField.text = [text substringToIndex:128];
                return NO;
            }
        } break;
            
        case 2: {
            //营业执照注册号
            if (![string isValidNumberAndLetter]) {
                return NO;
            }
            
            if (text.length > 30) {
                textField.text = [text substringToIndex:30];
                return NO;
            }
        } break;
            
        case 3: {
            //联系人姓名
            if (text.length > 20) {
                textField.text = [text substringToIndex:20];
                return NO;
            }
        } break;
            
        case 4: {
            //联系人手机号
            if (![text isValidNumber]) {
                return NO;
            }
            if (text.length > 11) {
                textField.text = [text substringToIndex:11];
                return NO;
            }
        } break;
        case 5: {
            //法人代表姓名
            if (text.length > 20) {
                textField.text = [text substringToIndex:20];
                return NO;
            }
        } break;
        case 6: {
            //法人代表手机
            if (![text isValidNumber]) {
                return NO;
            }
            if (text.length > 11) {
                textField.text = [text substringToIndex:11];
                return NO;
            }
        } break;
        default:
            break;
    }
    return YES;
}

#pragma mark -  private method

- (void)setCellHeight:(CGFloat)cellHeight
{
    if (_cellHeight != cellHeight) {
        _cellHeight = cellHeight;
        [self resposeHeightDelegate];
    }
}

- (void)setIndexPath:(NSIndexPath*)indexPath
{
    _indexPath = indexPath;
    switch (indexPath.row) {
        case 0: {
            self.contentView.customBorderColor = kGrayE3E3EA;
            self.contentView.customBorderLineWidth = @1;
            self.contentView.customBorderType = UIViewCustomBorderTypeTop | UIViewCustomBorderTypeLeft | UIViewCustomBorderTypeRight;
        } break;
        case 1:
        case 2:
        case 3:
        case 4:
        case 5: {
            self.contentView.customBorderColor = kGrayE3E3EA;
            self.contentView.customBorderLineWidth = @1;
            self.contentView.customBorderType = UIViewCustomBorderTypeLeft | UIViewCustomBorderTypeRight;
        } break;
        case 6: {
            self.contentView.customBorderColor = kGrayE3E3EA;
            self.contentView.customBorderLineWidth = @1;
            self.contentView.customBorderType = UIViewCustomBorderTypeLeft | UIViewCustomBorderTypeRight | UIViewCustomBorderTypeBottom;
            
        } break;
            
        default:
            break;
    }
}

- (void)resposeHeightDelegate
{
    if ([self.delegate respondsToSelector:@selector(updateCellHeight:indexPath:)]) {
        [self.delegate updateCellHeight:self.cellHeight indexPath:self.indexPath];
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
    view.customBorderColor = kGrayE3E3EA;
    view.customBorderLineWidth = @0;
    view.customBorderType = UIViewCustomBorderTypeAll;
}

- (void)setTitle:(NSString*)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setContent:(NSString*)content
{
    _content = content;
    if (!self.haveOldContent) {
        self.haveOldContent = YES;
        _oldContent = content;
    }
    [self.contentButton setTitle:content forState:UIControlStateNormal];
}

- (BOOL)hideLineTwo
{
    self.midSpaceConstraint.constant = kDeviceProportion(0);
    self.cancelButton.hidden = YES;
    self.comfirmButton.hidden = YES;
    self.modifyContentTextFiled.hidden = YES;
    return NO;
}

- (BOOL)showLineTwo
{
    self.midSpaceConstraint.constant = kDeviceProportion(20);
    self.cancelButton.hidden = NO;
    self.comfirmButton.hidden = NO;
    self.modifyContentTextFiled.hidden = NO;
    return YES;
}

- (BOOL)isModify
{
    return ![_oldContent isEqualToString:self.contentButton.currentTitle];
}

- (NSDictionary*)paramter
{
    if (self.isModify) {
        return @{ [_key stringByAppendingString:@"Old"] : kSaftToNSString(_oldContent),
                  [_key stringByAppendingString:@"New"] : kSaftToNSString(self.contentButton.currentTitle) };
    }else {
        return @{};
    }
    
}
@end
