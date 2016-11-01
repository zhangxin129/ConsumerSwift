//
//  GYHDRightLocationCell.m
//  company
//
//  Created by User on 16/7/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRightLocationCell.h"

@implementation GYHDRightLocationCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
        
        [self setAudolayout];
    }
    
    return self;
}

-(void)setup{

    self.contentView.backgroundColor = [UIColor colorWithRed:245 / 255.0f
                                                       green:245 / 255.0f
                                                        blue:245 / 255.0f
                                                       alpha:1];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    // 1. 聊天背景
   _chatbackgroundView = [[UIImageView alloc] init];
    _chatbackgroundView.image = [UIImage imageNamed:@"gyhd_location_icon"];
    [self.contentView addSubview:_chatbackgroundView];

 
    //聊天白色背景
    _chatWhiteView =[[UIView alloc]init];
    _chatWhiteView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_chatWhiteView];
    
    //   客服显示
    
    self.customerServiceLabel=[[UILabel alloc]init];
    
    self.customerServiceLabel.font=[UIFont systemFontOfSize:12.0];
    
    self.customerServiceLabel.textAlignment=NSTextAlignmentRight;
    
    self.customerServiceLabel.backgroundColor=[UIColor clearColor];
    
    [self.contentView addSubview:self.customerServiceLabel];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chatLocationTap:)];
    
    [_chatWhiteView addGestureRecognizer:tap];
    
    // 发送时间
    self.chatRecvTimeLabel = [[UILabel alloc] init];
    self.chatRecvTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.chatRecvTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.chatRecvTimeLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:self.chatRecvTimeLabel ];
    

    //2.地图固定图片
    _locImageView =[[UIImageView alloc]init];
    
    _locImageView.image =kLoadPng(@"gyhd_chat_map");
    
    [self.contentView addSubview:_locImageView];
    
    // 3 .头像
   _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = kLoadPng(@"gyhd_defaultheadimg");
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 3;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self
                                     action:@selector(iconImageViewClick:)];
    [_iconImageView addGestureRecognizer:tapGR];
    
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel =[[UILabel alloc]init];
    
    _nameLabel.text=@"";
    
    _nameLabel.font=[UIFont systemFontOfSize:15];
    _nameLabel.textColor =[UIColor blackColor];
    
    _contentLabel =[[UILabel alloc]init];
    _contentLabel.numberOfLines=0;
    _contentLabel.text=@"";
    _contentLabel.font=[UIFont systemFontOfSize:14];
    _contentLabel.textColor =[UIColor lightGrayColor];
    
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_contentLabel];


    // 3. 消息状态
    _chatStateButton = [[UIButton alloc] init];
    [_chatStateButton addTarget:self
                        action:@selector(chatStateButtonClick:)
              forControlEvents:UIControlEventTouchUpInside];
    _chatStateButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _chatStateButton.imageView.animationDuration = 1.4f;
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i < 13; i++) {
        UIImage *image =
        [UIImage imageNamed:[NSString stringWithFormat:@"gyhd_loading_icon_%d", i]];
        if (image != nil) {
            [imageArray addObject:image];
        }
    }
    _chatStateButton.imageView.animationImages = imageArray;
    [_chatStateButton setImage:[UIImage imageNamed:@"gyhd_chat_failue_btn_normal"]
                     forState:UIControlStateNormal];
    [self.contentView addSubview:_chatStateButton];
   

}

-(void)setAudolayout{

    @weakify(self);
    
    [self.chatRecvTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.width.mas_equalTo(44);
        @strongify(self);
        make.top.equalTo(self.chatRecvTimeLabel.mas_bottom).offset(20);
    }];
    
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.customerServiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.iconImageView).offset(0);
        make.right.equalTo(self.iconImageView.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    
    [self.chatbackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.customerServiceLabel.mas_bottom).offset(6);
        make.right.equalTo(self.iconImageView.mas_left).offset(-5);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(120);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.chatWhiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.equalTo(self.chatbackgroundView).offset(1);
        make.bottom.equalTo(self.chatbackgroundView).offset(-1);
        make.right.equalTo(self.chatbackgroundView).offset(-9);
    }];
    
    self.chatWhiteView.layer.cornerRadius=10;
    self.chatWhiteView.clipsToBounds=YES;
    
    [self.chatStateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.chatbackgroundView);
        make.right.equalTo(self.chatbackgroundView.mas_left).offset(-10);
    }];
    
    [self.locImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        @strongify(self);
        
        make.left.top.equalTo(self.chatbackgroundView).offset(12);
        
        make.bottom.equalTo(self.chatbackgroundView).offset(-12);
        
        make.height.mas_equalTo(self.locImageView.width).multipliedBy(1);
        
        make.width.mas_equalTo(80);
    }];
    
//    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        
        make.top.equalTo(self.locImageView);
        make.left.equalTo(self.locImageView.mas_right).offset(5);
        
        make.right.equalTo(self.chatbackgroundView.mas_right).offset(-10);
        
        make.height.mas_equalTo(25);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.locImageView.mas_right).offset(5);
        
        make.right.equalTo(self.chatbackgroundView.mas_right).offset(-10);
        
        make.bottom.equalTo(self.locImageView);
    }];
}

- (void)chatStateButtonClick:(UIButton *)button {
    
    
    if ([self.delegate
         respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self
                            tapType:GYHDChatTapResendButton
                          chatModel:self.chatModel];
    }
}

- (void)iconImageViewClick:(UITapGestureRecognizer *)tap {
    if ([self.delegate
         respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self
                            tapType:GYHDChatTapUserIcon
                          chatModel:self.chatModel];
    }
}



-(void)setChatModel:(GYHDChatModel *)chatModel{

      _chatModel = chatModel;
    
    [self.customerServiceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.iconImageView).offset(0);
        make.right.equalTo(self.iconImageView.mas_left).offset(-10);
        make.height.mas_equalTo(0);
    }];
    
   [self.iconImageView setImageWithURL:[NSURL URLWithString:chatModel.infoModel.iconString] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    
    self.chatRecvTimeLabel.text = chatModel.messageRecvTimeString;
    
    NSDictionary *bodyDict = [GYHDUtils stringToDictionary:chatModel.body];
    
    self.nameLabel.text=bodyDict[@"map_name"];
    
    self.contentLabel.text= bodyDict[@"map_address"];
    
    if (chatModel.messageSendState == GYHDDataBaseCenterMessageSendStateSending) {
        self.chatStateButton.hidden = NO;
        [self.chatStateButton.imageView startAnimating];
    }else if (chatModel.messageSendState == GYHDDataBaseCenterMessageSendStateFailure) {
        [self.chatStateButton.imageView stopAnimating];
        self.chatStateButton.hidden = NO;
    }else if (chatModel.messageSendState == GYHDDataBaseCenterMessageSendStateSuccess) {
        [self.chatStateButton.imageView stopAnimating];
        self.chatStateButton.hidden = YES;
    }
}

- (void)setSessionModel:(GYHDSessionRecordModel *)sessionModel {
    _sessionModel = sessionModel;
    self.customerServiceLabel.text=[NSString stringWithFormat:@"%@(%@)",sessionModel.senderNickName,sessionModel.csOperNo];
    
    self.chatRecvTimeLabel.text = sessionModel.sendTimeFormat;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,sessionModel.senderHeadIcon]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    
    NSDictionary *bodyDict = [GYHDUtils stringToDictionary:sessionModel.msgContent ];
    
    self.nameLabel.text=bodyDict[@"map_name"];
    
    self.contentLabel.text= bodyDict[@"map_address"];
    
    self.chatStateButton.hidden = YES;
}


- (void)chatLocationTap:(UITapGestureRecognizer *)longTap {
    if ([self.delegate
         respondsToSelector:@selector(GYHDChatView:tapType:chatModel:)]) {
        [self.delegate GYHDChatView:self
                            tapType:GYHDChatTapChatMap
                          chatModel:self.chatModel];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(GYHDChatView:tapType:sessionModel:)]) {
        
        [self.delegate GYHDChatView:self tapType:GYHDChatTapChatMap sessionModel:self.sessionModel];
    }
}

@end
