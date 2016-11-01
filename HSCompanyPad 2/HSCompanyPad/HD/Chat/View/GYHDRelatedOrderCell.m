//
//  GYHDRelatedOrderCell.m
//  HSConsumer
//
//  Created by shiang on 16/7/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRelatedOrderCell.h"
#import "GYHDMessageCenter.h"

@interface GYHDRelatedOrderCell ()
/**背景View*/
@property(nonatomic, strong)UIView *backView;
/**订单编号名字*/
@property(nonatomic, strong)UILabel *orderNumberTitleLabel;
/**订单编号内容*/
@property(nonatomic, strong)UILabel *orderNumberDetailLabel;

/**订单类型名字*/
@property(nonatomic, strong)UILabel *orderTypeTitleLabel;
/**订单类型内容*/
@property(nonatomic, strong)UILabel *orderTypeDetailLabel;

/**订单时间名字*/
@property(nonatomic, strong)UILabel *orderTimeTitleLabel;
/**订单时间内容*/
@property(nonatomic, strong)UILabel *orderTimeDetailLabel;

/**订单信息名字*/
@property(nonatomic, strong)UILabel *orderMessageTitleLabel;
/**订单信息内容*/
@property(nonatomic, strong)UILabel *orderMessageDetailLabel;
/**订单金额*/
@property(nonatomic, strong)UIButton *orderPriceButton;
/**订单积分*/
@property(nonatomic, strong)UIButton *orderPVButton;
/**虚线View*/
@property(nonatomic, strong)UIImageView *lineImageView;
/**订单状态名字*/
@property(nonatomic, strong)UILabel *orderStateTitleLabel;
/**订单状态内容*/
@property(nonatomic, strong)UILabel *orderStateDetailLabel;
@end

@implementation GYHDRelatedOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:245 / 255.0f green:245 / 255.0f blue:245 / 255.0f alpha:1];
        self.contentView.userInteractionEnabled = NO;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backView = [[UIView alloc] init];
        self.backView .layer.masksToBounds = YES;
        self.backView .layer.cornerRadius = 10;
        self.backView.layer.borderWidth = 1;
        self.backView.layer.borderColor = [UIColor colorWithRed:0/255.0 green:143.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        /**订单编号名字*/
        self.orderNumberTitleLabel = [[UILabel alloc] init];
        self.orderNumberTitleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
        self.orderNumberTitleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        [self.backView addSubview: self.orderNumberTitleLabel];
        /**订单编号内容*/
        self.orderNumberDetailLabel = [[UILabel alloc] init];
        self.orderNumberDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
        self.orderNumberDetailLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        [self.backView addSubview: self.orderNumberDetailLabel];;
        
        /**订单类型名字*/
        self.orderTypeTitleLabel = [[UILabel alloc] init];
        self.orderTypeTitleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
        self.orderTypeTitleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        [self.backView addSubview: self.orderTypeTitleLabel];;
        
        /**订单类型内容*/
        self.orderTypeDetailLabel = [[UILabel alloc] init];
        self.orderTypeDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
        self.orderTypeDetailLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        [self.backView addSubview: self.orderTypeDetailLabel];
        
        /**订单时间名字*/
        self.orderTimeTitleLabel = [[UILabel alloc] init];
        self.orderTimeTitleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
        self.orderTimeTitleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        [self.backView addSubview: self.orderTimeTitleLabel];
        /**订单时间内容*/
        self.orderTimeDetailLabel  = [[UILabel alloc] init];
        self.orderTimeDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
        self.orderTimeDetailLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        [self.backView addSubview: self.orderTimeDetailLabel];
        
        /**订单信息名字*/
        self.orderMessageTitleLabel = [[UILabel alloc] init];
        self.orderMessageTitleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
        self.orderMessageTitleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        [self.backView addSubview: self.orderMessageTitleLabel];
        
        self.orderPriceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.orderPriceButton setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:60/255.0f blue:40/255.0f alpha:1] forState:UIControlStateNormal];
        [self.orderPriceButton setImage:[UIImage imageNamed:@"yghd_huSheng_monery_icon"] forState:UIControlStateNormal];
        [self.backView addSubview:self.orderPriceButton];
        
        self.orderPVButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.orderPVButton setTitleColor:[UIColor colorWithRed:0 green:169/255.0f blue:249/255.0f alpha:1] forState:UIControlStateNormal];
        [self.orderPVButton setImage:[UIImage imageNamed:@"gyhd_husheng_integral_icon"] forState:UIControlStateNormal];
        [self.backView addSubview:self.orderPVButton];
        
        /**虚线View*/
        self.lineImageView = [[UIImageView alloc] init];
        [self.backView addSubview: self.lineImageView];
        /**订单状态名字*/
        self.orderStateTitleLabel  = [[UILabel alloc] init];
        self.orderStateTitleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
        self.orderStateTitleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        [self.backView addSubview: self.orderStateTitleLabel];
        /**订单状态内容*/
        self.orderStateDetailLabel = [[UILabel alloc] init];
        self.orderStateDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
        self.orderStateDetailLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        [self.backView addSubview: self.orderStateDetailLabel];
        
        self.orderNumberTitleLabel.text = kLocalized(@"GYHD_OrderNumber");
        self.orderTypeTitleLabel.text = kLocalized(@"GYHD_OrderType");
        self.orderTimeTitleLabel.text = kLocalized(@"GYHD_OrderTime");
        self.orderMessageTitleLabel.text = kLocalized(@"GYHD_PayInfo");
        self.orderStateTitleLabel.text = kLocalized(@"GYHD_OrderState");
        @weakify(self);
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(12);
            make.bottom.mas_equalTo(-5);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(100);
        }];
        
        [self.orderNumberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        
        [self.orderTypeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.top.equalTo(self.orderNumberTitleLabel.mas_top);
        }];
        
        [self.orderTypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.orderTypeDetailLabel.mas_left).offset(0);
            make.top.equalTo(self.orderNumberTitleLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        
        [self.orderNumberDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(8);
            make.left.equalTo(self.orderNumberTitleLabel.mas_right).offset(0);
            make.right.equalTo(self.orderTypeDetailLabel.mas_left).offset(0);
            make.height.equalTo(self.orderNumberTitleLabel);
        }];
        
        
        [self.orderTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(self.orderNumberTitleLabel);
            make.top.equalTo(self.orderNumberTitleLabel.mas_bottom);
            make.height.equalTo(self.orderNumberTitleLabel);
            
        }];
        
        
        [self.orderStateDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.orderTypeDetailLabel);
            make.top.equalTo(self.orderTypeDetailLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(100, 30));
            
        }];
        
        [self.orderStateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.orderStateDetailLabel.mas_left);
            make.top.equalTo(self.orderTypeTitleLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        
        
        [self.orderTimeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.orderNumberDetailLabel);
            make.top.equalTo(self.orderNumberDetailLabel.mas_bottom);
            make.right.equalTo(self.orderStateTitleLabel.mas_left).offset(0);
            make.height.equalTo(self.orderNumberTitleLabel);
        }];
        
        
        [self.orderMessageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(self.orderNumberTitleLabel);
            make.top.equalTo(self.orderTimeTitleLabel.mas_bottom);
            make.height.equalTo(self.orderNumberTitleLabel);
        }];
        
        [self.orderPriceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.orderNumberDetailLabel);
            make.top.equalTo(self.orderTimeDetailLabel.mas_bottom);
            make.height.equalTo(self.orderMessageTitleLabel);
        }];
        [self.orderPVButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.orderPriceButton.mas_right).offset(20);
            make.top.equalTo(self.orderTimeDetailLabel.mas_bottom);
            make.height.equalTo(self.orderMessageTitleLabel);
        }];
        
    }
    return self;
}

- (void)setModel:(GYHDChatModel *)model {
    _model = model;
    
    NSDictionary *bodyDict = [GYHDUtils stringToDictionary:model.body];
    self.orderNumberDetailLabel.text = bodyDict[@"order_no"];
    self.orderTypeDetailLabel.text = bodyDict[@"order_type"];
    self.orderTimeDetailLabel.text = bodyDict[@"order_time"];
    [self.orderPriceButton setTitle: [NSString stringWithFormat:@" %@",bodyDict[@"order_price"]] forState:UIControlStateNormal];
    [self.orderPVButton setTitle:[NSString stringWithFormat:@" %@",bodyDict[@"order_pv"]]  forState:UIControlStateNormal];
    self.orderStateDetailLabel.text =kSaftToNSString(bodyDict[@"order_state"]) ;
}

-(void)setSessionModel:(GYHDSessionRecordModel *)sessionModel{

    _sessionModel = sessionModel;
    
    NSDictionary *bodyDict = [GYHDUtils stringToDictionary:sessionModel.msgContent];
    self.orderNumberDetailLabel.text = bodyDict[@"order_no"];
    self.orderTypeDetailLabel.text = bodyDict[@"order_type"];
    self.orderTimeDetailLabel.text = bodyDict[@"order_time"];
    [self.orderPriceButton setTitle: [NSString stringWithFormat:@" %@",bodyDict[@"order_price"]] forState:UIControlStateNormal];
    [self.orderPVButton setTitle:[NSString stringWithFormat:@" %@",bodyDict[@"order_pv"]]  forState:UIControlStateNormal];
    self.orderStateDetailLabel.text =kSaftToNSString(bodyDict[@"order_state"]);
    
}
@end
