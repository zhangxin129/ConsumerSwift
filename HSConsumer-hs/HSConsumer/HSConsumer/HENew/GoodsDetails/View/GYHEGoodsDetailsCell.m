//
//  GYHEGoodsDetailsCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEGoodsDetailsCell.h"
#import "YYKit.h"

@interface GYHEGoodsDetailsCell()

@property (nonatomic,strong) UILabel *titleLabel;//商品名称
@property (nonatomic,strong) UIImageView *hsbImageView;//互生币图片
@property (nonatomic,strong) UILabel *hsCurrencyLabel;//互生币金额
@property (nonatomic,strong) UIImageView *pvImageView;//积分图片
@property (nonatomic,strong) UILabel *pvLabel;//积分
@property (nonatomic,strong) UIImageView *couponsImageView;//抵扣券图片
@property (nonatomic,strong) UILabel *couponsLabel;//抵扣券
@property (nonatomic,strong) UILabel *freightLabel;//运费




@end

@implementation GYHEGoodsDetailsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

    self.backgroundColor = UIColorFromRGB(0xffffff);
    //商品名称
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font =  [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = UIColorFromRGB(0x403000);
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    //互生币图片
    self.hsbImageView = [[UIImageView alloc] init];
    self.hsbImageView.image = [UIImage imageNamed:@"gy_he_coin_icon"];
    [self addSubview:self.hsbImageView];
    
    //互生币金额
    self.hsCurrencyLabel = [[UILabel alloc] init];
    self.hsCurrencyLabel.font = [UIFont systemFontOfSize:24];
    self.hsCurrencyLabel.textColor = UIColorFromRGB(0xff5000);
    self.hsCurrencyLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.hsCurrencyLabel];
    
    //积分图片
    self.pvImageView = [[UIImageView alloc] init];
    self.pvImageView.image = [UIImage imageNamed:@"gy_he_pv_icon"];
    [self addSubview:self.pvImageView];
    
    //积分数量
    self.pvLabel = [[UILabel alloc] init];
    self.pvLabel.font = [UIFont systemFontOfSize:16];
    self.pvLabel.textAlignment = NSTextAlignmentLeft;
    self.pvLabel.textColor = UIColorFromRGB(0x1d7dd6);
    [self addSubview:self.pvLabel];
    
    //抵扣券图片
    self.couponsImageView = [[UIImageView alloc] init];
    self.couponsImageView.image = [UIImage imageNamed:@"gy_he_juan_icon"];
    [self addSubview:self.couponsImageView];
    
    //抵扣券信息
    self.couponsLabel = [[UILabel alloc] init];
    self.couponsLabel.font = [UIFont systemFontOfSize:12];
    self.couponsLabel.textColor = UIColorFromRGB(0x999999);
    self.couponsLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.couponsLabel];
    
    //运费
    self.freightLabel = [[UILabel alloc] init];
    self.freightLabel.font = [UIFont systemFontOfSize:12];
    self.freightLabel.textAlignment = NSTextAlignmentLeft;
    self.freightLabel.textColor = UIColorFromRGB(0x999999);
    [self addSubview:self.freightLabel];
    
    //分享
    self.shareControl = [[UIControl alloc] init];
    self.shareControl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.shareControl];
    
    //分享图片
    UIImageView *shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    shareImageView.image = [UIImage  imageNamed:@"gyhe_shop_details_share"];
    [self.shareControl addSubview:shareImageView];
    
    //分享文字
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(-2, shareImageView.bottom + 6, shareImageView.width +4, 10)];
    shareLabel.font = [UIFont systemFontOfSize:10];
    shareLabel.textColor = UIColorFromRGB(0x403000);
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.text = kLocalized(@"GYHE_Good_Share");
    [self.shareControl addSubview:shareLabel];
    
    //收藏
    self.collectControl = [[UIControl alloc] init];
    self.collectControl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectControl];
    
    //收藏图片
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectBtn.frame  = CGRectMake(0, 0, 20, 20);
    self.collectBtn.userInteractionEnabled = NO;
    [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_shop_details_collect_narmal"] forState:UIControlStateNormal];
     [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_shop_details_collect_select"] forState:UIControlStateSelected];
    self.collectBtn.backgroundColor = [UIColor clearColor];
    [self.collectControl addSubview:self.collectBtn];
    
    //收藏文字
    UILabel *collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(-2, self.collectBtn.bottom + 6, self.collectBtn.width +4, 10)];
    collectLabel.font = [UIFont systemFontOfSize:10];
    collectLabel.textColor = UIColorFromRGB(0x403000);
    collectLabel.textAlignment = NSTextAlignmentCenter;
    collectLabel.text = kLocalized(@"GYHE_Good_Collect");
    [self.collectControl addSubview:collectLabel];
    
    //进入店铺
    self.enterShopControl = [[UIControl alloc] init];
    self.enterShopControl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.enterShopControl];
    
    //进入店铺图片
    UIImageView *enterShopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    enterShopImageView.image = [UIImage imageNamed:@"gyhe_enterShop"];
    enterShopImageView.backgroundColor = [UIColor clearColor];
    [self.enterShopControl addSubview:enterShopImageView];
    
    //进入店铺文字
    UILabel *enterShopLabel  = [[UILabel alloc] initWithFrame:CGRectMake(enterShopImageView.right +5, 0, 60, 25)];
    enterShopLabel.textAlignment = NSTextAlignmentLeft;
    enterShopLabel.textColor = UIColorFromRGB(0xfb7d00);
    enterShopLabel.font = [UIFont systemFontOfSize:12];
    enterShopLabel.text = kLocalized(@"GYHE_Good_Enter_Store");
    [self.enterShopControl addSubview:enterShopLabel];
    
    
}

////模仿数据模型   测试
//-(void)setModel:(NSAttributedString *)title {
//    
//    //测试数据
//    self.titleLabel.attributedText = title;
//    self.hsCurrencyLabel.text = @"77,838.00";
//    self.pvLabel.text = @"778.38";
//    self.couponsLabel.text = @"满200使用10元抵扣券1张";
//    self.freightLabel.text = @"运费:包邮";
//    NSInteger i = arc4random()%2;
//    if(i == 0) {
//        self.collectBtn.selected = NO;
//    }else {
//        self.collectBtn.selected = YES;
//    }
//    
//    CGFloat leftEdge = 12;
//    CGRect rect = [title boundingRectWithSize:CGSizeMake(kScreenWidth -24, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    CGSize size = rect.size;
//    
//    self.titleLabel.frame = CGRectMake(12, 10, size.width, size.height);
//    
//    self.hsbImageView.frame = CGRectMake(leftEdge, self.titleLabel.bottom + 16, 16, 16);
//    self.hsCurrencyLabel.frame = CGRectMake(self.hsbImageView.right + 6, self.hsbImageView.frame.origin.y -4, kScreenWidth - self.hsbImageView.right - 6 - 77, 24);
//    self.pvImageView.frame = CGRectMake(leftEdge, self.hsbImageView.bottom + 10, 16, 16);
//    self.pvLabel.frame = CGRectMake(self.pvImageView.right + 6, self.pvImageView.frame.origin.y, kScreenWidth - self.pvImageView.right - 6- 77, 16);
//    self.couponsImageView.frame = CGRectMake(leftEdge, self.pvImageView.bottom + 10, 16, 16);
//    self.couponsLabel.frame = CGRectMake(self.couponsImageView.right + 6, self.couponsImageView.frame.origin.y, kScreenWidth - self.couponsImageView.right - 6 -87 , self.couponsImageView.height);
//    self.freightLabel.frame = CGRectMake(leftEdge, self.couponsImageView.bottom + 10, kScreenWidth - 2*leftEdge, 12);
//    self.shareControl.frame = CGRectMake(kScreenWidth - 77, self.hsbImageView.origin.y, 20, 36);
//    self.collectControl.frame = CGRectMake(self.shareControl.right + 20 , self.shareControl.frame.origin.y, 20, 36);
//    self.enterShopControl.frame = CGRectMake(kScreenWidth -87, self.shareControl.bottom + 16, 80, 25);
//}


-(void)setModel:(GYHEGoodsDetailsModel *)model {

    self.titleLabel.attributedText = model.nameStr;
    self.hsCurrencyLabel.text = [GYUtils formatCurrencyStyle:[model.price doubleValue]];
    self.pvLabel.text = [GYUtils formatCurrencyStyle:[model.pv doubleValue]];

    if (model.supportService.hasSerCoupon) {
        self.couponsLabel.text = [NSString stringWithFormat:@"满%@使用%@元抵扣券1张",model.coupon[0][@"amount"],model.coupon[0][@"faceValue"]];
        self.couponsLabel.hidden = NO;
        self.couponsImageView.hidden = NO;
    }else {
        self.couponsImageView.hidden = YES;
        self.couponsLabel.hidden = YES;
    }
    
    if (model.isFreePostage) {
        self.freightLabel.text = @"运费:包邮";
    }else {
        self.freightLabel.text = [NSString stringWithFormat:@"运费:%@",[GYUtils formatCurrencyStyle:[model.postage doubleValue]]];
    }
    
    //判断是否收藏还未更新 之后替换判断
    NSInteger i = arc4random()%2;
    if(i == 0) {
        self.collectBtn.selected = NO;
    }else {
        self.collectBtn.selected = YES;
    }
    
    CGFloat leftEdge = 12;
    CGRect rect = [model.nameStr boundingRectWithSize:CGSizeMake(kScreenWidth -24, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    
    self.titleLabel.frame = CGRectMake(12, 10, size.width, size.height);
    
    self.hsbImageView.frame = CGRectMake(leftEdge, self.titleLabel.bottom + 16, 16, 16);
    self.hsCurrencyLabel.frame = CGRectMake(self.hsbImageView.right + 6, self.hsbImageView.frame.origin.y -4, kScreenWidth - self.hsbImageView.right - 6 - 77, 24);
    self.pvImageView.frame = CGRectMake(leftEdge, self.hsbImageView.bottom + 10, 16, 16);
    self.pvLabel.frame = CGRectMake(self.pvImageView.right + 6, self.pvImageView.frame.origin.y, kScreenWidth - self.pvImageView.right - 6- 77, 16);
    self.couponsImageView.frame = CGRectMake(leftEdge, self.pvImageView.bottom + 10, 16, 16);
    self.couponsLabel.frame = CGRectMake(self.couponsImageView.right + 6, self.couponsImageView.frame.origin.y, kScreenWidth - self.couponsImageView.right - 6 -87 , self.couponsImageView.height);
    self.freightLabel.frame = CGRectMake(leftEdge, self.couponsImageView.bottom + 10, kScreenWidth - 2*leftEdge, 12);
    self.shareControl.frame = CGRectMake(kScreenWidth - 77, self.hsbImageView.origin.y, 20, 36);
    self.collectControl.frame = CGRectMake(self.shareControl.right + 20 , self.shareControl.frame.origin.y, 20, 36);
    self.enterShopControl.frame = CGRectMake(kScreenWidth -87, self.shareControl.bottom + 16, 80, 25);
}


@end
