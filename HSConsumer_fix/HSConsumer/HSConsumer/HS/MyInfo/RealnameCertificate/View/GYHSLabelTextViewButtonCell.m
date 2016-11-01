//
//  GYHSLabelTextViewButtonCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/8/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLabelTextViewButtonCell.h"

@interface GYHSLabelTextViewButtonCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tfTextView;
@property (weak, nonatomic) IBOutlet UILabel *LbLeftlabel;
@property (weak, nonatomic) IBOutlet UILabel *Lbplaceholder;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, strong) NSIndexPath* cellIndexPath;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
@implementation GYHSLabelTextViewButtonCell

- (void)awakeFromNib {
    self.topLineView.backgroundColor = [UIColor lightGrayColor];
    self.bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.tfTextView setTextColor:kCellItemTitleColor];
    [self.LbLeftlabel setTextColor:kCellItemTitleColor];
    [self.Lbplaceholder setTextColor:kTextFieldPlaceHolderColor];
    self.topLineView.frame = CGRectMake(0, 0, kScreenWidth, 1 / [UIScreen mainScreen].scale);
    self.bottomLineView.frame = CGRectMake(0, kScreenHeight - 1 / [UIScreen mainScreen].scale, kScreenWidth, 1 / [UIScreen mainScreen].scale);
    self.tfTextView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTap)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)LbLeftlabel:(NSString*)LbLeftlabeltext
               tfTextView:(NSString*)TextViewText
               Lbplaceholder:(NSString*)LbplaceholderText
               setBackgroundImageSelectButton:(NSString*)imageName
               tag:(NSIndexPath*)indexPath
               showSelectButton:(BOOL)showSelectButton
               textViewClick:(BOOL)textViewClick
{
    self.tfTextView.text = TextViewText;
    self.Lbplaceholder.text = LbplaceholderText;
    [self.selectButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.cellIndexPath = indexPath;
    self.LbLeftlabel.text = LbLeftlabeltext;
    self.selectButton.hidden = !showSelectButton;
    self.tfTextView.editable = !showSelectButton;
    if (indexPath.row !=0) {
        self.topLineView.hidden = YES;
    }
    if (self.tfTextView.text.length >0) {
        self.Lbplaceholder.hidden = YES;
    }else {
        self.Lbplaceholder.hidden = NO;
    }
    if (indexPath.row == 0 || indexPath.row == 3) {
         self.selectButton.hidden =YES;
    }
    if (![globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
        self.tfTextView.editable =NO;
        self.selectButton.hidden =YES;
        self.Lbplaceholder.hidden = YES;
    }
}
-(void)LicenceLbLeftlabel:(NSString *)LbLeftlabeltext tfTextView:(NSString *)TextViewText Lbplaceholder:(NSString *)LbplaceholderText setBackgroundImageSelectButton:(NSString *)imageName tag:(NSIndexPath *)indexPath showSelectButton:(BOOL)showSelectButton textViewClick:(BOOL)textViewClick
{
    self.tfTextView.text = TextViewText;
    self.Lbplaceholder.text = LbplaceholderText;
    [self.selectButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.cellIndexPath = indexPath;
    self.LbLeftlabel.text = LbLeftlabeltext;
    self.selectButton.hidden = !showSelectButton;
    self.tfTextView.editable = !textViewClick;
    if (indexPath.row !=0 ) {
        self.topLineView.hidden = YES;
    }
    if (indexPath.section == 1 && indexPath.row !=0) {
        self.topLineView.hidden = YES;
    }
    if (self.tfTextView.text.length >0) {
        self.Lbplaceholder.hidden = YES;
    }else {
        self.Lbplaceholder.hidden = NO;
    }
}
#pragma mark - UITextViewDelegate
//占位符逻辑
- (void)textViewDidChange:(UITextView *)textView
{
        if (textView.text.length == 0) {
            self.Lbplaceholder.hidden=NO;
        }
        else {
            self.Lbplaceholder.hidden = YES;
        }
    [self reloadInputViews];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.realNameDelegate respondsToSelector:@selector(inputRealNameValue:indexPath:)]) {
        [self.realNameDelegate inputRealNameValue:textView.text indexPath:self.cellIndexPath];
    }
}

-(void)textViewTap
{
    if ([self.realNameDelegate respondsToSelector:@selector(textViewDidBeginindexPath:)]) {
        [self.realNameDelegate textViewDidBeginindexPath:self.cellIndexPath];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.realNameDelegate respondsToSelector:@selector(emptyStarText:textView:)]) {
        [self.realNameDelegate emptyStarText:self.cellIndexPath textView:textView];
    }
}
- (IBAction)selectButton:(id)sender {
    if ([self.realNameDelegate respondsToSelector:@selector(chooseSelectButton:)]) {
        [self.realNameDelegate chooseSelectButton:self.cellIndexPath];
    }
}

@end
