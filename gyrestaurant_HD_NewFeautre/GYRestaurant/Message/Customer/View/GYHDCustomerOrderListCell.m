//
//  GYHDCustomerOrderListCell.m
//  GYRestaurant
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCustomerOrderListCell.h"
@implementation GYHDCustomerOrderListCell

- (void)awakeFromNib {

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{


    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self setUp];
    }
    return self;

}

-(void)setUp{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:224.0/255.0 blue:225.0/255.0 alpha:1.0];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(130);
        make.right.mas_equalTo(-17);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    [backView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    @weakify(self);
    self.orderNumLabel = [[UILabel alloc]init];
    self.orderNumLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
    self.orderNumLabel.adjustsFontSizeToFitWidth = YES;
    [backView addSubview:self.orderNumLabel];
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(30);
        make.left.equalTo(self.timeLabel.mas_right).offset(0);
    }];
    
    self.tradeStateLabel = [[UILabel alloc]init];
    self.tradeStateLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
    self.tradeStateLabel.textAlignment=NSTextAlignmentRight;
    self.tradeStateLabel.adjustsFontSizeToFitWidth = YES;
    [backView addSubview:self.tradeStateLabel];
    [self.tradeStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(30);
        make.left.equalTo(self.orderNumLabel.mas_right).offset(15);
    }];
    
    self.businessPointLabel = [[UILabel alloc]init];
    self.businessPointLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    [backView addSubview:self.businessPointLabel];
    [self.businessPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(30);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(30);
    }];
    
    self.orderDetailsBtn = [[UIButton alloc]init];
    [self.orderDetailsBtn setTitle:@"订单详情" forState:UIControlStateNormal];
    [self.orderDetailsBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:143.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.orderDetailsBtn addTarget:self action:@selector(orderDetailsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.orderDetailsBtn];
    [self.orderDetailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-12);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(30);
    }];

}

-(void)refreshUIWithModel:(GYHDCustomerOrderListModel *)model{
    
    self.model=model;

    self.timeLabel.text = model.createTime;
    self.orderNumLabel.text = [NSString stringWithFormat:@"餐饮订单编号:%@",model.orderId];
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:self.orderNumLabel.text];
    NSRange range = [[hintString string]rangeOfString:model.orderId];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] range:range];
    self.orderNumLabel.attributedText = hintString;
    
    self.tradeStateLabel.text = [self orderStatus];
    if ([model.vshopName isKindOfClass:[NSNull class]]) {
        self.businessPointLabel.text=@"";
    }
    else{
    
        self.businessPointLabel.text = [NSString stringWithFormat:@"营业点:%@",model.vshopName];
    }
    
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc]initWithString:self.businessPointLabel.text];
    NSRange range1 = [[hintString1 string]rangeOfString:@"营业点:"];
    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1] range:range1];
    self.businessPointLabel.attributedText = hintString1;
    
}

-(void)orderDetailsBtnClick{


    if (_delegate && [_delegate respondsToSelector:@selector(pushOrderDetailWithModel:)]) {
        
        [_delegate pushOrderDetailWithModel:self.model];
        
    }

}
//订单状态判断
-(NSString *)orderStatus{
    
    NSString *str;
//   堂食
    if ([_model.orderType isEqualToString:@"1"]) {
        if ([_model.orderStatus isEqualToString:@"1"]||[_model.orderStatus isEqualToString:@"-3"]){
            str = kLocalized(@"未确认");
        }else if ([_model.orderStatus isEqualToString:@"2"]||[_model.orderStatus isEqualToString:@"9"]){
            str = kLocalized(@"待就餐");
        }else if ([_model.orderStatus isEqualToString:@"6"]){
            str = kLocalized(@"待结账,未打单");
        }else if ([_model.orderStatus isEqualToString:@"7"]){
            str = kLocalized(@"待结账,已打单");
        }else if ([_model.orderStatus isEqualToString:@"4"]){
            str = kLocalized(@"已结账");
        }else if ([_model.orderStatus isEqualToString:@"10"]){
            str = kLocalized(@"消费者取消");
        }else if ([_model.orderStatus isEqualToString:@"5"]){
            str = @"交易关闭";
        }else if([_model.orderStatus isEqualToString:@"99"]){
            str = kLocalized(@"已取消");
        }
//        外卖
    }else if ([_model.orderType isEqualToString:@"2"]){
        if([_model.orderStatus isEqualToString:@"1"]||[_model.orderStatus isEqualToString:@"8"]){
            str = kLocalized(@"未确认");
        }else if ([_model.orderStatus isEqualToString:@"2"]){
            str = kLocalized(@"待送餐");
        }else if ([_model.orderStatus isEqualToString:@"3"]||[_model.orderStatus isEqualToString:@"11"]){
            str = kLocalized(@"送餐中");
        }else if ([_model.orderStatus isEqualToString:@"4"]){
            str = @"交易完成";
        }else if ([_model.orderStatus isEqualToString:@"10"]){
            str = @"取消未确认";
        }else if ([_model.orderStatus isEqualToString:@"5"]){
            str = @"交易关闭";
        }else if([_model.orderStatus isEqualToString:@"99"]){
            str = kLocalized(@"已取消");
        }
//        自提
    }else if ([_model.orderType isEqualToString:@"3"]){
        if([_model.orderStatus isEqualToString:@"1"]||[_model.orderStatus isEqualToString:@"8"]){
            str = kLocalized(@"未确认");
        }else if ([_model.orderStatus isEqualToString:@"2"]){
            str = kLocalized(@"待自提");
        }else if ([_model.orderStatus isEqualToString:@"4"]){
            str = kLocalized(@"已结账");
        }else if ([_model.orderStatus isEqualToString:@"10"]){
            str = @"取消未确认";
        }else if ([_model.orderStatus isEqualToString:@"5"]){
            str = @"交易关闭";
        }else if([_model.orderStatus isEqualToString:@"99"]){
            str = kLocalized(@"已取消");
        }
        
    }
    return str;
}

@end
