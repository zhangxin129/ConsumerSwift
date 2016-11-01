//
//  GYHSCollectBankOpenCell.m
//  HSCompanyPad
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCollectBankOpenCell.h"

@interface GYHSCollectBankOpenCell()
@property (weak, nonatomic) IBOutlet UIButton *upLoadButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end
@implementation GYHSCollectBankOpenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.openLabel.text = @"开户许可证";
    self.openLabel.textColor = kGray666666;
    [self.upLoadButton setTitle:@"上传" forState:UIControlStateNormal];
    [self.upLoadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.upLoadButton.backgroundColor = kRedE40011;
    self.upLoadButton.layer.cornerRadius = 5;
    [self.checkButton setTitle:@"查看示例图片" forState:UIControlStateNormal];
    [self.checkButton setTitleColor:kBlue3793FF forState:UIControlStateNormal];
    self.checkButton.titleLabel.font = kFont40;
    self.openImage.userInteractionEnabled = YES;
    self.openImage.tag = 3;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
    [self.openImage addGestureRecognizer:tap];
}

#pragma mark - click
- (IBAction)click:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(clickWithButtonTag: cell:)]) {
        [_delegate clickWithButtonTag:sender.tag cell:self];
    }
}

#pragma mark - 点击图片
- (void)clickImage:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickWithButtonTag: cell:)]) {
        [_delegate clickWithButtonTag:self.openImage.tag cell:self];
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeAll;
}

@end
