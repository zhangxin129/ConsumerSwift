//
//  GYHSPostscriptCertificationCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/8/16.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPostscriptCertificationCell.h"

@interface GYHSPostscriptCertificationCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *postscriptlb;
@property (weak, nonatomic) IBOutlet UITextView *tfTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderlb;



@end
@implementation GYHSPostscriptCertificationCell

- (void)awakeFromNib {
    [self.postscriptlb setTextColor:kCellItemTitleColor];
    [self.placeholderlb setTextColor:kCellItemTextColor];
    self.tfTextView.backgroundColor = kDefaultVCBackgroundColor;
    self.tfTextView.textColor = kCellItemTitleColor;
    self.tfTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)postscriptlbText:(NSString *)postscriptlb placeholderlbText:(NSString *)placeholderlb tfTextViewText:(NSString *)tfTextView
{
    self.postscriptlb.text = postscriptlb;
   
    self.tfTextView.text = tfTextView;
    self.placeholderlb.text = placeholderlb;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.postscriptDelegate respondsToSelector:@selector(inputPostscriptValue:)]) {
        [self.postscriptDelegate inputPostscriptValue:textView.text];
    }
}

#pragma mark - UITextViewDelegate
//占位符逻辑
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeholderlb.hidden=NO;
    }
    else {
        self.placeholderlb.hidden = YES;
    }
}
@end
