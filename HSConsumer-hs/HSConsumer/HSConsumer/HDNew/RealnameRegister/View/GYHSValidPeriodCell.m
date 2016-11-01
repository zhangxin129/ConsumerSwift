//
//  GYHSValidPeriodCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/8/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSValidPeriodCell.h"
#import "GYHSTools.h"

@interface GYHSValidPeriodCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *LbLeftlabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, strong) NSIndexPath* cellIndexPath;
@property (nonatomic) BOOL isTextViewClick;
@end
@implementation GYHSValidPeriodCell

- (void)awakeFromNib {
    // Initialization code
    self.LbLeftlabel.font = kButtonCellFont;
    self.textField.font = kButtonCellFont;
    [self.textField setTextColor:kcurrencyBalanceCorlor];
    [self.LbLeftlabel setTextColor:kcurrencyBalanceCorlor];
    self.textField.delegate = self;
    [self.selectButton setImage:[UIImage imageNamed:@"hs_btn_round_noclick.png"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"hs_btn_round_click.png"] forState:UIControlStateSelected];
    [self.selectButton setTitle:kLocalized(@"GYHS_RealName_Long_Time") forState:UIControlStateNormal];
    [self.selectButton setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    self.selectButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 45);
    self.selectButton.titleEdgeInsets = UIEdgeInsetsMake(5, -10, 5, 1);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldTap)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)LbLeftlabelText:(NSString *)LbLeftlabel placeholderlbText:(NSString *)placeholderlb tftextFieldText:(NSString *)tftextField textFieldClick:(BOOL)textViewClick tag:(NSIndexPath *)indexPath
{
    self.LbLeftlabel.text = LbLeftlabel;
    self.textField.placeholder = placeholderlb;
    self.textField.text = tftextField;
    self.cellIndexPath = indexPath;
    self.isTextViewClick = textViewClick;
    self.textField.enabled = NO;
    if (textViewClick == YES) {
        self.textField.placeholder = @"";
        self.textField.text = @"";
    }else {
        self.textField.placeholder = placeholderlb;
        self.textField.text = tftextField;
    }
}
-(void)textFieldTap
{
    if (self.isTextViewClick == YES)
    {
        return;
    }
    else {
        if ([self.periodDelegate respondsToSelector:@selector(tfDidBegin:)]) {
            [self.periodDelegate tfDidBegin:self.cellIndexPath];
        }
    }
    
}
- (IBAction)selectButton:(id)sender {
    if ([self.periodDelegate respondsToSelector:@selector(chooseSelectButtonValidPeriod:)]) {
        [self.periodDelegate chooseSelectButtonValidPeriod:sender];
    }
}

@end
