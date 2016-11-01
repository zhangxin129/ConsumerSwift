//
//  GYHDMessageCell.m
//  HSCompanyPad
//
//  Created by shiang on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDMessageGroupCell.h"
#import "GYHDMessageCenter.h"

@interface GYHDMessageGroupCell ()
@property(nonatomic, strong)UIImageView *iconImageView;//头像
@property(nonatomic, strong)UIButton *unreandButton;//未读
@property(nonatomic, strong)UILabel *titleLabel;//名字
@property(nonatomic, strong)UILabel *detailLabel;//最后一条消息内容
@property(nonatomic, strong)UILabel *timeLabel;//时间
@property(nonatomic, strong)UIButton *cardholderButton;//持卡人标志
@property(nonatomic, strong)UIView *selectShowView;//选择蓝条显示
@end

@implementation GYHDMessageGroupCell
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
    
    [self.selectShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(3);
        
    }];

    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:self.iconImageView];
    
    self.unreandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unreandButton.userInteractionEnabled = NO;
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
-(void)refreshUIWithModle:(GYHDAllMsgListModel *)model{
    
    if ([model.msgType integerValue]==GYHDMessageTpyePush) {
        
        if ([model.pushMsgType integerValue]==GYHDPushMessageTpyeHuSheng) {
            
            self.iconImageView.image=[UIImage imageNamed:@"gyhd_message_icon_xtxx"];
//            self.titleLabel.textColor=[UIColor colorWithRed:250/255.0 green:100/255.0 blue:81/255.0 alpha:1.0];
            
        }else if ([model.pushMsgType integerValue]==GYHDPushMessageTpyeDingDan){
            
            self.iconImageView.image=[UIImage imageNamed:@"gyhd_message_icon_ddxx"];
//            self.titleLabel.textColor=[UIColor colorWithRed:255/255.0 green:133/255.0 blue:95/255.0 alpha:1.0];
            
        }else if([model.pushMsgType integerValue]==GYHDPushMessageTpyeFuWu) {
            
            self.iconImageView.image=[UIImage imageNamed:@"gyhd_message_icon_fwxx"];
            
//            self.titleLabel.textColor=[UIColor colorWithRed:36/255.0 green:178/255.0 blue:86/255.0 alpha:1.0];
        }
        self.detailLabel.text=model.content;
        [self.cardholderButton setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        
        [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.iconUrl]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
        
        if (model.content != nil ) {
            
            self.detailLabel.attributedText=[GYHDUtils EmojiAttributedStringFromString:model.content];
        }
//        self.titleLabel.textColor=[UIColor blackColor];
        
        if ([model.friendUserType isEqualToString:@"c"]) {
            
            [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@"gyhd_card_icon"] forState:UIControlStateNormal];
            
        }else if ([model.friendUserType isEqualToString:@"nc"]){
        
        [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@"gyhd_nocard_icon"] forState:UIControlStateNormal];
        
        }else{
        
         [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
    }
    self.titleLabel.text=model.titlName;
    
    self.timeLabel.text=[GYHDUtils messageTimeStrFromTimerString:model.timeStr];
    
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
    
//    if (model.messageState) {
//        
//        self.contentView.backgroundColor=[UIColor clearColor];
//        
//    }else{
//        
//        self.contentView.backgroundColor =kDefaultVCBackgroundColor;
//    }
    
    if (model.isSelect || !model.messageState) {
        
        if (model.isSelect) {
            
            self.selectShowView.hidden=NO;
        }
        
        self.contentView.backgroundColor=kDefaultVCBackgroundColor;
        
    }else{
        
        self.selectShowView.hidden=YES;
        
        self.contentView.backgroundColor=[UIColor whiteColor];
    }
    

    
}

@end
