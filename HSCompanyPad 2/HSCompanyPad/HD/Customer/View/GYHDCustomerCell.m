//
//  GYHDCustomerCell.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDCustomerCell.h"
#import "GYHDMessageCenter.h"
@interface GYHDCustomerCell ()
@property(nonatomic, strong)UIImageView *iconImageView;
@property(nonatomic, strong)UIButton *unreandButton;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *detailLabel;
@property(nonatomic, strong)UILabel *timeLabel;
/**持卡人状态*/
@property(nonatomic, strong)UIButton *cardholderButton;
@property(nonatomic, strong)UIView      *selectShowView;//选择蓝条显示
@end

@implementation GYHDCustomerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    
    self.selectShowView=[[UIView alloc]init];
    self.selectShowView.backgroundColor=[UIColor colorWithRed:48/255.0 green:152/255.0 blue:229/255.0 alpha:1.0];
    self.selectShowView.hidden=YES;
    [self.contentView addSubview:self.selectShowView];
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:self.iconImageView];
    
    self.unreandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unreandButton.userInteractionEnabled = NO;
    self.unreandButton.hidden=YES;
    [self.unreandButton setBackgroundImage:[UIImage imageNamed:@"gyhd_unread_count_icon"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.unreandButton];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont systemFontOfSize:14.0f];
    self.detailLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.contentView addSubview:self.detailLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.timeLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.contentView addSubview:self.timeLabel];
    
    self.cardholderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.contentView addSubview:self.cardholderButton];
    
    [self.selectShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(3);
        
    }];
    @weakify(self);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(22);
        make.bottom.mas_equalTo(-22);
        make.size.mas_equalTo(CGSizeMake(46, 46));
        
    }];
    
    [self.unreandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.iconImageView.mas_right);
        make.centerY.equalTo(self.iconImageView.mas_top);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconImageView);
        make.right.mas_equalTo(-10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);

        make.height.equalTo(self.detailLabel);
        make.bottom.equalTo(self.detailLabel.mas_top);
    }];
    
    [self.cardholderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-10);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.bottom.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.right.mas_equalTo(-10);
        make.height.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    
}

-(void)setModel:(GYHDCustomerModel *)model{

    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.Friend_Icon]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    self.titleLabel.text=model.Friend_Name;
    
    NSData*jsData=[model.MSG_Body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:jsData options:NSJSONReadingMutableContainers error:nil];
    
    if (model.content != nil ) {
        
        self.detailLabel.attributedText=[GYHDUtils EmojiAttributedStringFromString:model.content];
        
    }
    
    self.timeLabel.text=[GYHDUtils messageTimeStrFromTimerString:model.timeStr];
    
    switch ([dict[@"msg_code"]integerValue]) {
            
        case GYHDDataBaseCenterMessageChatPicture:{
            //图片
            self.detailLabel.text=kLocalized(@"GYHD_Picture");
        }
            break;
        case GYHDDataBaseCenterMessageChatAudio:{
            
            //            音频
            self.detailLabel.text=kLocalized(@"GYHD_Audio");
            
        }break;
        case GYHDDataBaseCenterMessageChatVideo:{
            
            //            视频
            
            self.detailLabel.text=kLocalized(@"GYHD_Video");
            
        }break;
        case GYHDDataBaseCenterMessageChatGoods:{
            
            self.detailLabel.text=kLocalized(@"GYHD_GoodsMessage");
        }break;
        case GYHDDataBaseCenterMessageChatOrder:{
            self.detailLabel.text=kLocalized(@"GYHD_OrderMessage");
        }break;
        case GYHDDataBaseCenterMessageChatMap:{
            
            self.detailLabel.text=kLocalized(@"GYHD_Location");
            
        }break;
        default:
            break;
    }
//    消息未读数量显示
    if ([model.messageUnreadCount integerValue]==0) {
        
        self.unreandButton.hidden=YES;
    }else{
        
        self.unreandButton.hidden=NO;
    }
    if ([model.messageUnreadCount integerValue]>=99) {
        
        [self.unreandButton setTitle:@"99+" forState:UIControlStateNormal];
        
    }else{
        
        [self.unreandButton setTitle:model.messageUnreadCount forState:UIControlStateNormal];
        
    }
//    选定状态判定
    if (model.isSelect) {
         self.selectShowView.hidden=NO;
        self.backgroundColor = kDefaultVCBackgroundColor;
    }else{
         self.selectShowView.hidden=YES;
        self.backgroundColor=[UIColor clearColor];
        
    }
//    持卡人与非持卡人区分
    if ([model.Friend_UserType isEqualToString:@"c"]) {
        
        [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@"gyhd_card_icon"] forState:UIControlStateNormal];
        
    }else if ([model.Friend_UserType isEqualToString:@"nc"]){
        
        [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@"gyhd_nocard_icon"] forState:UIControlStateNormal];
        
    }
    
}

@end
