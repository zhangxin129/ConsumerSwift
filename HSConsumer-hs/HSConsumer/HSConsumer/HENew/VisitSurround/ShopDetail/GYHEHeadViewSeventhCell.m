//
//  GYHEHeadViewSeventhCell.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEHeadViewSeventhCell.h"
#import "Masonry.h"

@interface GYHEHeadViewSeventhCell()
@property (nonatomic, strong) UIButton* headBtn;
@property (nonatomic, strong) UIButton* bottomBtn;
@end

@implementation GYHEHeadViewSeventhCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
  //采用两个Button来做小控件
//    UIButton* bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(200.0,10.0,130.0,30.0)];
    _bottomBtn = [[UIButton alloc] init];
    _bottomBtn.backgroundColor = [UIColor whiteColor];
    _bottomBtn.layer.borderWidth = 1;
    _bottomBtn.layer.borderColor = UIColorFromRGB(0x1d7dd6).CGColor;
    
    NSString* titleStr = @"在线支付";
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0x1d7dd6)}];
    
    [_bottomBtn setAttributedTitle:placeholder forState:UIControlStateNormal];
    _bottomBtn.layer.cornerRadius = 15;
    _bottomBtn.selected = NO;
    [self.contentView addSubview:_bottomBtn];
    [_bottomBtn addTarget:self action:@selector(clickBottom:) forControlEvents:UIControlEventTouchUpInside];
    //大小再重新定义下
        WS(weakSelf);
        [_bottomBtn mas_makeConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(103);//80
            make.right.equalTo(weakSelf.contentView).offset(-15);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
    
 //上面的
    _headBtn = [[UIButton alloc] init];
    _headBtn.backgroundColor = UIColorFromRGB(0x1d7dd6);
    _headBtn.layer.borderWidth = 1;
    _headBtn.layer.borderColor = UIColorFromRGB(0x1d7dd6).CGColor;
    _headBtn.selected = YES;
    NSString* titleStr1 = @"货到付款";
    
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:titleStr1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [_headBtn setAttributedTitle:placeholder1 forState:UIControlStateSelected];
    _headBtn.layer.cornerRadius = 15;
    
    [self.contentView addSubview:_headBtn];
    [_headBtn addTarget:self action:@selector(clickHead:) forControlEvents:UIControlEventTouchUpInside];
    //大小再重新定义下
    
    [_headBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(103);//80
        make.right.equalTo(weakSelf.contentView).offset(-95);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    
    
    
    //添加一个自定义的开关控件
//    self.cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200.0,10.0,130.0,30.0)];
////    self.cellSwitch = [[UISwitch alloc] init];
//    [self.contentView addSubview:self.cellSwitch];
//    [self.cellSwitch setOn:YES animated:YES];
//    [self.cellSwitch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
//    self.cellSwitch.onTintColor = [UIColor blueColor];
//    self.cellSwitch.tintColor = [UIColor whiteColor];
    
    //大小再重新定义下
//    WS(weakSelf);
//    [self.cellSwitch mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(kScreenWidth/3);
//        make.right.equalTo(weakSelf.contentView).offset(-15);
//        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
//    }];
    
}

//要传递 在线支付 状态
-(void)clickBottom:(UIButton*)sender{
    _headBtn.selected = NO;
    _bottomBtn.selected = YES;
    
    NSString* titleStr1 = @"货到付款";
    
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:titleStr1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0x1d7dd6)}];
    [_headBtn setAttributedTitle:placeholder1 forState:UIControlStateNormal];
    _headBtn.backgroundColor = [UIColor whiteColor];
    
    //
    NSString* titleStr = @"在线支付";
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [_bottomBtn setAttributedTitle:placeholder forState:UIControlStateSelected];
    _bottomBtn.backgroundColor = UIColorFromRGB(0x1d7dd6);
    [self.contentView bringSubviewToFront:_bottomBtn];
    if (_delegate && [_delegate respondsToSelector:@selector(transmitPayType:)]) {
        [_delegate transmitPayType:kPaymentTypeOnInternet];
    }
}

//要传递 货到付款 状态
-(void)clickHead:(UIButton*)sender{
    _headBtn.selected = YES;
    _bottomBtn.selected = NO;
    
    NSString* titleStr1 = @"货到付款";
    
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:titleStr1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [_headBtn setAttributedTitle:placeholder1 forState:UIControlStateSelected];
    _headBtn.backgroundColor = UIColorFromRGB(0x1d7dd6);//[UIColor whiteColor];
    
    //
    NSString* titleStr = @"在线支付";
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0x1d7dd6)}];
    
    [_bottomBtn setAttributedTitle:placeholder forState:UIControlStateNormal];
    _bottomBtn.backgroundColor = [UIColor whiteColor];
    [self.contentView bringSubviewToFront:_headBtn];
    if (_delegate && [_delegate respondsToSelector:@selector(transmitPayType:)]) {
        [_delegate transmitPayType:kPaymentTypeArriveGoods];
    }
}





//- (void) switchValueChanged:(id)sender{
//    
//    UISwitch* control = (UISwitch*)sender;
//    if(control == self.cellSwitch){
//        BOOL on = control.on;
//        //添加自己要处理的事情代码
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
