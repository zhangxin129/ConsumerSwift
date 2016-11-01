//
//  GYHDRelatedGoodsCell.m
//  HSConsumer
//
//  Created by shiang on 16/7/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRelatedGoodsCell.h"
#import "GYHDMessageCenter.h"

@interface GYHDRelatedGoodsCell ()
@property(nonatomic, strong)UIView *backView;
/**图片View*/
@property(nonatomic, strong)UIImageView *goodsImageView;
/**商品标题*/
@property(nonatomic, strong)UILabel *goodsTitleLabel;
/**商品详情*/
@property(nonatomic, strong)UILabel *goodsDetailLabel;
/**订单金额*/
@property(nonatomic, strong)UIButton *goodsPriceButton;
/**订单积分*/
@property(nonatomic, strong)UIButton *goodsPVButton;
@end

@implementation GYHDRelatedGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:245 / 255.0f green:245 / 255.0f blue:245 / 255.0f alpha:1];
        self.contentView.userInteractionEnabled = NO;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backView = [[UIView alloc] init];
        self.backView .layer.masksToBounds = YES;
        self.backView .layer.cornerRadius = 10;
        self.backView.layer.borderWidth = 1;
        self.backView.layer.borderColor =[UIColor colorWithRed:0/255.0 green:143.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        /**图片View*/
        self.goodsImageView = [[UIImageView alloc] init];
        self.goodsImageView.layer.masksToBounds = YES;
        self.goodsImageView.layer.cornerRadius = 10;
        [self.backView addSubview:self.goodsImageView];
        /**商品标题*/
        self.goodsTitleLabel = [[UILabel alloc] init];
        self.goodsTitleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
        self.goodsTitleLabel.numberOfLines = 2;
        [self.backView addSubview:self.goodsTitleLabel];
        /**商品详情*/
        self.goodsDetailLabel = [[UILabel alloc] init];
        self.goodsDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(28)];
        self.goodsDetailLabel.numberOfLines = 2;
        self.goodsDetailLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        [self.backView addSubview:self.goodsDetailLabel];
//        /**订单金额*/
//        self.goodsPriceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.goodsPriceButton setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:60/255.0f blue:40/255.0f alpha:1] forState:UIControlStateNormal];
//        [self.goodsPriceButton setImage:[UIImage imageNamed:@"yghd_huSheng_monery_icon"] forState:UIControlStateNormal];
//        [self.backView addSubview:self.goodsPriceButton];
//        
//        self.goodsPVButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.goodsPVButton setTitleColor:[UIColor colorWithRed:0 green:169/255.0f blue:249/255.0f alpha:1] forState:UIControlStateNormal];
//        [self.goodsPVButton setImage:[UIImage imageNamed:@"gyhd_husheng_integral_icon"] forState:UIControlStateNormal];
        [self.backView addSubview:self.goodsPVButton];
        @weakify(self)
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(12);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(100);
        }];
        
        [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        [self.goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.equalTo(self.goodsImageView);
            make.left.equalTo(self.goodsImageView.mas_right).offset(10);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(40);
            
        }];
        
        [self.goodsDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.equalTo(self.goodsTitleLabel).offset(25);
            make.left.equalTo(self.goodsImageView.mas_right).offset(10);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(30);
        }];
//        
//        [self.goodsPriceButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            @strongify(self)
//            make.left.equalTo(self.goodsTitleLabel);
//            make.top.mas_equalTo(self.goodsDetailLabel.mas_bottom).offset(10);
//        }];
//        
//        [self.goodsPVButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            @strongify(self)
//            make.left.equalTo(self.goodsPriceButton.mas_right).offset(40);
//            make.top.equalTo(self.goodsPriceButton);
//        }];
    }
    return self;
}

- (void)setModel:(GYHDChatModel *)model {
    _model = model;
    NSDictionary *goodsDict = [GYHDUtils stringToDictionary:model.body];
    [self.goodsImageView setImageWithURL:[NSURL URLWithString:goodsDict[@"imageNailsUrl"]] placeholder:[UIImage imageNamed:@"gyhd_placeholder_image_type"]];
    self.goodsTitleLabel.text = goodsDict[@"prod_name"];
    self.goodsDetailLabel.text = goodsDict[@"prod_des"];
    [self.goodsPriceButton setTitle:goodsDict[@"prod_price"] forState:UIControlStateNormal];
    [self.goodsPVButton setTitle:goodsDict[@"prod_pv"] forState:UIControlStateNormal];
}

-(void)setSessionModel:(GYHDSessionRecordModel *)sessionModel{

    _sessionModel=sessionModel;
    
    NSDictionary *goodsDict = [GYHDUtils stringToDictionary:sessionModel.msgContent];
    [self.goodsImageView setImageWithURL:[NSURL URLWithString:goodsDict[@"imageNailsUrl"]] placeholder:[UIImage imageNamed:@"gyhd_placeholder_image_type"]];
    self.goodsTitleLabel.text = goodsDict[@"prod_name"];
    self.goodsDetailLabel.text = goodsDict[@"prod_des"];
    [self.goodsPriceButton setTitle:goodsDict[@"prod_price"] forState:UIControlStateNormal];
    [self.goodsPVButton setTitle:goodsDict[@"prod_pv"] forState:UIControlStateNormal];


}

@end
