//
//  GYHSMyComanyFooterViewNewCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyComanyFooterViewCell.h"
#import "GYHSMyCompanyInfoModel.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <GYKit/GYPlaceholderTextView.h>

static float space = 20.0;
static float rowHight = 40.0;
static float textViewHight = 120.0;

@interface GYHSMyComanyFooterViewCell () <UITextFieldDelegate, UITextViewDelegate>

//成立日期相关控件
@property (weak, nonatomic) IBOutlet UILabel* standDateTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton* standDateButton;
@property (weak, nonatomic) IBOutlet UIButton* standdDateCancelButton;

//经营期限相关控制
@property (weak, nonatomic) IBOutlet UILabel* BusinessTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton* businessDetebutton;
@property (weak, nonatomic) IBOutlet UIButton* businessCancelbutton;
@property (weak, nonatomic) IBOutlet UITextField* businessModifytextField;
@property (weak, nonatomic) IBOutlet UIButton* businessModifyComfirmbutton;

//经营范围相关控件
@property (weak, nonatomic) IBOutlet UILabel* runAreaLabl;
@property (weak, nonatomic) IBOutlet UIButton* runAreaButton;
@property (weak, nonatomic) IBOutlet UIButton* runAreaCancerButton;
@property (weak, nonatomic) IBOutlet GYPlaceholderTextView* runAreaModifyTextView;
@property (weak, nonatomic) IBOutlet UIButton* runAreaModifyComfirmButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* businessDateTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* runAreaTopSpace;

@property (nonatomic, assign) float cellHeight;

@property (nonatomic, assign) BOOL lineFourShow;
@property (nonatomic, assign) BOOL lineSixShow;

@end

@implementation GYHSMyComanyFooterViewCell

- (void)awakeFromNib
{
    
    self.standDateTitleLabel.text = kLocalized(@"GYHS_Myhs_StandDate_Colon");
    self.BusinessTimeLabel.text = kLocalized(@"GYHS_Myhs_Bussiness_To_Date_Colon");
    self.runAreaLabl.text = kLocalized(@"GYHS_Myhs_Run_Area_Colon");
    
    self.businessModifytextField.placeholder = kLocalized(@"GYHS_Myhs_PleaseInputContent");
    
    self.standDateTitleLabel.textColor = kGray666666;
    self.standDateButton.titleLabel.font = kFont32;
    [self.standDateButton setTitleColor:kGray333333 forState:UIControlStateNormal];
    
    self.BusinessTimeLabel.textColor = kGray666666;
    self.businessDetebutton.titleLabel.font = kFont32;
    [self.businessDetebutton setTitleColor:kGray333333 forState:UIControlStateNormal];
    self.businessModifytextField.textColor = kGray333333;
    
    self.runAreaLabl.textColor = kGray666666;
    [self.runAreaButton setTitleColor:kGray333333 forState:UIControlStateNormal];
    self.runAreaButton.titleLabel.font = kFont32;
    self.runAreaButton.titleLabel.numberOfLines = 0;
    self.runAreaModifyTextView.textColor = kGray333333;
    
    [self hideLineFour];
    [self hideLineSix];
    self.runAreaModifyTextView.delegate = self;
    
    self.standdDateCancelButton.customBorderColor = kGrayE3E3EA;
    self.standdDateCancelButton.customBorderLineWidth = @0;
    self.standdDateCancelButton.customBorderType = UIViewCustomBorderTypeRight|UIViewCustomBorderTypeTop|UIViewCustomBorderTypeBottom;
    self.standdDateCancelButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.runAreaModifyTextView.placeholder = kLocalized(@"GYHS_Myhs_PleaseInputContent");
    [self.runAreaModifyTextView setPlaceholderFont:kFont32];
    self.cellHeight = self.size.height;
    
    self.contentView.customBorderType = UIViewCustomBorderTypeAll;
    self.contentView.customBorderColor = kGrayE3E3EA;
    self.contentView.customBorderLineWidth = @1;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    return YES;
}

#pragma mark - pravite method

- (void)setModel:(GYHSMyCompanyInfoModel*)model
{
    _model = model;
    //UI赋值
    [self.standDateButton setTitle:model.buildDate forState:UIControlStateNormal];
    [self.businessDetebutton setTitle:model.endDate forState:UIControlStateNormal];
    [self.runAreaButton setTitle:model.businessScope forState:UIControlStateNormal];
}

/*!
 *    显示营业期限的输入框
 *
 *    @return 是否显示
 */
- (BOOL)showLineFour
{
    self.runAreaTopSpace.constant = 2 * space + rowHight;
    self.businessModifytextField.hidden = NO;
    self.businessModifyComfirmbutton.hidden = NO;
    self.businessCancelbutton.hidden = NO;
    return YES;
}

/*!
 *    隐藏营业期限的输入框
 *
 *    @return 是否隐藏
 */
- (BOOL)hideLineFour
{
    self.runAreaTopSpace.constant = space;
    self.businessModifytextField.hidden = YES;
    self.businessModifyComfirmbutton.hidden = YES;
    self.businessCancelbutton.hidden = YES;
    return NO;
}

/*!
 *    是否显示经营范围的输入框
 *
 *    @return 是否显示
 */
- (BOOL)showLineSix
{
    self.runAreaCancerButton.hidden = NO;
    self.runAreaModifyTextView.hidden = NO;
    self.runAreaModifyComfirmButton.hidden = NO;
    return YES;
}

/*!
 *    是否隐藏经营范围的输入框
 *
 *    @return 是否隐藏
 */
- (BOOL)hideLineSix
{
    self.runAreaCancerButton.hidden = YES;
    self.runAreaModifyTextView.hidden = YES;
    self.runAreaModifyComfirmButton.hidden = YES;
    return NO;
}

/*!
 *    添加灰色边框线
 *
 *    @param view 要添加边框线视图
 */
- (void)addLine:(UIView*)view
{
    view.customBorderColor = kGrayE3E3EA;
    view.customBorderLineWidth = @1;
    view.customBorderType = UIViewCustomBorderTypeAll;
}

/*!
 *    添加红色边框线
 *
 *    @param view 要添加边框线视图
 */
- (void)addRedLine:(UIView*)view
{
    view.customBorderColor = kRedE50012;
    view.customBorderLineWidth = @1;
    view.customBorderType = UIViewCustomBorderTypeAll;
}

/*!
 *    隐藏边框线
 *
 *    @param view 要隐藏边框线视图
 */
- (void)removeLine:(UIView*)view
{
    view.customBorderColor = [UIColor clearColor];
    view.customBorderLineWidth = @0;
    view.customBorderType = UIViewCustomBorderTypeAll;
}

/*!
 *    高度代理
 */
- (void)resposeHeightDelegate
{
    
    if ([self.delegate respondsToSelector:@selector(updateCellHeight:)]) {
        [self.delegate updateCellHeight:self.height];
    }
}

- (void) hideButton:(BOOL)isHide {
    if (isHide) {
        [self.standdDateCancelButton setImage:kLoadPng(@"") forState:UIControlStateNormal];
        self.standdDateCancelButton.customBorderColor = kGrayE3E3EA;
        self.standdDateCancelButton.customBorderLineWidth = @0;
        self.standdDateCancelButton.customBorderType = UIViewCustomBorderTypeRight|UIViewCustomBorderTypeTop|UIViewCustomBorderTypeBottom;
        self.standdDateCancelButton.hidden = YES;
    } else {
        [self.standdDateCancelButton setImage:kLoadPng(@"gycom_date_icon") forState:UIControlStateNormal];
        self.standdDateCancelButton.customBorderColor = kGrayE3E3EA;
        self.standdDateCancelButton.customBorderLineWidth = @1;
        self.standdDateCancelButton.customBorderType = UIViewCustomBorderTypeRight|UIViewCustomBorderTypeTop|UIViewCustomBorderTypeBottom;
        self.standdDateCancelButton.hidden = NO;
    }
}

#pragma mark - event respose
- (IBAction)standdateTapAction
{
    //显示成立日期的按钮
    self.standDateButton.customBorderType = UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeTop|UIViewCustomBorderTypeBottom;
    self.standDateButton.customBorderColor = kGrayE3E3EA;
    self.standDateButton.customBorderLineWidth = @1;
    //显示日期小图标
    [self hideButton:NO];
    
    if ([self.delegate respondsToSelector:@selector(updateStandDateComplete:)]) {
        [self.delegate updateStandDateComplete:^{
            
            self.standDateButton.customBorderLineWidth = @1;
            self.standDateButton.customBorderType = UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeTop|UIViewCustomBorderTypeBottom;
            self.standDateButton.customBorderColor = kWhiteFFFFFF;
            [self hideButton:YES];
            
        }];
    }
}


- (IBAction)businessTapAction
{
    if (!self.lineFourShow) {
        [self addLine:self.businessDetebutton];
        [self addRedLine:self.businessModifytextField];
        
        self.height = self.cellHeight + rowHight + space;
        self.lineFourShow = [self showLineFour];
        [self resposeHeightDelegate];
    }
}

- (IBAction)businessCancelAction:(id)sender
{
    [self removeLine:self.businessDetebutton];
    [self removeLine:self.businessModifytextField];
    self.height = self.cellHeight - rowHight - space;
    self.lineFourShow = [self hideLineFour];
    [self resposeHeightDelegate];
}

- (IBAction)businessComfirm:(id)sender
{
    
    if ([self.delegate respondsToSelector:@selector(updateBusinessTime:complete:)]) {
        [self.delegate updateBusinessTime:self.businessModifytextField.text
                                 complete:^{
                                     [self removeLine:self.businessDetebutton];
                                     [self removeLine:self.businessModifytextField];
                                     self.lineFourShow = [self hideLineFour];
                                     self.height = self.cellHeight - rowHight - space;
                                     [self resposeHeightDelegate];
                                 }];
    }
}

- (IBAction)runAreaTapAction
{
    if (!self.lineSixShow) {
        [self addRedLine:self.runAreaModifyTextView];
        [self addLine:self.runAreaButton];
        self.height = self.cellHeight + textViewHight + space;
        self.lineSixShow = [self showLineSix];
        [self resposeHeightDelegate];
    }
}

- (IBAction)runCancelAction:(id)sender
{
    [self removeLine:self.runAreaModifyTextView];
    [self removeLine:self.runAreaButton];
    self.height = self.cellHeight - textViewHight - space;
    self.lineSixShow = [self hideLineSix];
    [self resposeHeightDelegate];
}

- (IBAction)runComfirmAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(updateRunArea:complete:)]) {
        [self.delegate updateRunArea:self.runAreaModifyTextView.text
                            complete:^{
                                [self removeLine:self.runAreaModifyTextView];
                                [self removeLine:self.runAreaButton];
                                self.lineSixShow = [self hideLineSix];
                                self.height = self.height - textViewHight - space;
                                [self resposeHeightDelegate];
                            }];
    }
}

@end
