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
//        *订单信息内容
//        self.orderMessageDetailLabel = [[UILabel alloc] init];
//        self.orderMessageDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
//        self.orderMessageDetailLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
//        [self.backView addSubview: self.orderMessageDetailLabel];
        self.orderPriceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.orderPriceButton setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:60/255.0f blue:40/255.0f alpha:1] forState:UIControlStateNormal];
        [self.orderPriceButton setImage:[UIImage imageNamed:@"HD_HSB"] forState:UIControlStateNormal];
        [self.backView addSubview:self.orderPriceButton];
        
        self.orderPVButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.orderPVButton setTitleColor:[UIColor colorWithRed:0 green:169/255.0f blue:249/255.0f alpha:1] forState:UIControlStateNormal];
        [self.orderPVButton setImage:[UIImage imageNamed:@"HD_PV"] forState:UIControlStateNormal];
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
        
        self.orderNumberTitleLabel.text = @"订单编号 : ";
        self.orderTypeTitleLabel.text = @"订单类型 : ";
        self.orderTimeTitleLabel.text = @"订单时间 : ";
        self.orderMessageTitleLabel.text = @"支付信息 : ";
        self.orderStateTitleLabel.text = @"订单状态 : ";
        WS(weakSelf);
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(12);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-12);
        }];
        [self.orderNumberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(16);
        }];
        [self.orderTypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.orderNumberTitleLabel);
            make.top.equalTo(weakSelf.orderNumberTitleLabel.mas_bottom);
        }];
        [self.orderTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.orderNumberTitleLabel);
            make.top.equalTo(weakSelf.orderTypeTitleLabel.mas_bottom);
        }];
        [self.orderMessageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.orderNumberTitleLabel);
            make.top.equalTo(weakSelf.orderTimeTitleLabel.mas_bottom);
        }];
        [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.orderNumberTitleLabel);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(1);
            make.top.equalTo(weakSelf.orderMessageTitleLabel.mas_bottom).offset(15);
        }];
//        self.lineImageView.backgroundColor = [UIColor redColor];
        [self.orderStateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.orderNumberTitleLabel);
            make.top.equalTo(weakSelf.lineImageView.mas_bottom).offset(15);
        }];
        
        [self.orderNumberDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.orderNumberTitleLabel);
            make.left.equalTo(weakSelf.orderNumberTitleLabel.mas_right);
        }];
        [self.orderTypeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.orderNumberDetailLabel);
            make.top.equalTo(weakSelf.orderNumberDetailLabel.mas_bottom);
        }];
        [self.orderTimeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.orderNumberDetailLabel);
            make.top.equalTo(weakSelf.orderTypeDetailLabel.mas_bottom);
        }];
//        [self.orderMessageDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf.orderNumberDetailLabel);
//            make.top.equalTo(weakSelf.orderTimeDetailLabel.mas_bottom);
//        }];
        [self.orderPriceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.orderNumberDetailLabel);
            make.top.equalTo(weakSelf.orderTimeDetailLabel.mas_bottom);
            make.height.equalTo(weakSelf.orderMessageTitleLabel);
        }];
        [self.orderPVButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.orderPriceButton.mas_right).offset(20);
            make.top.equalTo(weakSelf.orderTimeDetailLabel.mas_bottom);
            make.height.equalTo(weakSelf.orderMessageTitleLabel);
        }];
        [self.orderStateDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.orderNumberDetailLabel);
            make.top.equalTo(weakSelf.orderStateTitleLabel);
        }];

    }
    return self;
}

- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
- (void)setModel:(GYHDNewChatModel *)model {
    _model = model;
    [self drawDashLine:self.lineImageView lineLength:3 lineSpacing:3 lineColor:[UIColor grayColor]];
    NSDictionary *bodyDict = [Utils stringToDictionary:model.chatBody];
    self.orderNumberDetailLabel.text = bodyDict[@"order_no"];
    self.orderTypeDetailLabel.text = bodyDict[@"order_type"];
    self.orderTimeDetailLabel.text = bodyDict[@"order_time"];
    [self.orderPriceButton setTitle: [NSString stringWithFormat:@" %@",bodyDict[@"order_price"]] forState:UIControlStateNormal];
    [self.orderPVButton setTitle:[NSString stringWithFormat:@" %@",bodyDict[@"order_pv"]]  forState:UIControlStateNormal];
    self.orderStateDetailLabel.text = bodyDict[@"order_state"];
}
@end
