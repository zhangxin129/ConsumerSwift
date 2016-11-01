//
//  GYHDLeftLocationCell.m
//  company
//
//  Created by User on 16/7/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDLeftLocationCell.h"


@implementation GYHDLeftLocationCell

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
    _chatbackgroundView.image = [UIImage imageNamed:@"gyhd_chat_other_back"];
    _chatWhiteView.userInteractionEnabled=YES;
    [self.contentView addSubview:_chatbackgroundView];
    
    
    //聊天白色背景
    _chatWhiteView =[[UIView alloc]init];
    _chatWhiteView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_chatWhiteView];
    _chatWhiteView.userInteractionEnabled=YES;
  
    // 发送时间
    self.chatRecvTimeLabel = [[UILabel alloc] init];
    self.chatRecvTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.chatRecvTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.chatRecvTimeLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:self.chatRecvTimeLabel ];
    
    //2.地图固定图片
    _locImageView =[[UIImageView alloc]init];
    
    _locImageView.image =kLoadPng(@"gyhd_chat_map");
    _locImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chatLocationTap:)];
    
    [_locImageView addGestureRecognizer:tap];
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
    _nameLabel.numberOfLines=0;

    _nameLabel.font=[UIFont systemFontOfSize:14];
    _nameLabel.textColor =[UIColor blackColor];
    
    _contentLabel =[[UILabel alloc]init];
    _contentLabel.numberOfLines=0;
    _contentLabel.text=@"";
    _contentLabel.font=[UIFont systemFontOfSize:13];
    _contentLabel.textColor =[UIColor lightGrayColor];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_contentLabel];
   
}

-(void)setAudolayout{
    
    @weakify(self);
    
    [self.chatRecvTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.width.mas_equalTo(44);
        @strongify(self);
        make.top.equalTo(self.chatRecvTimeLabel.mas_bottom).offset(20);
    }];
    
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.chatbackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(120);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.chatWhiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.equalTo(self.chatbackgroundView).offset(1);
        make.bottom.equalTo(self.chatbackgroundView).offset(-1);
        make.left.equalTo(self.chatbackgroundView).offset(9);
    }];
    
    self.chatWhiteView.layer.cornerRadius=10;
    self.chatWhiteView.clipsToBounds=YES;
    
    [self.chatStateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.chatbackgroundView);
        make.left.equalTo(self.chatbackgroundView.mas_right).offset(10);
    }];
    
    [self.locImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        
        make.left.top.equalTo(self.chatbackgroundView).offset(12);
        
        make.bottom.equalTo(self.chatbackgroundView).offset(-12);
        
        make.height.mas_equalTo(self.locImageView.width);
        
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
    
    if ([chatModel.infoModel.iconString hasPrefix:@"http"]) {
        
        [self.iconImageView setImageWithURL:[NSURL URLWithString:chatModel.infoModel.iconString] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    }else{
        
        
        [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,chatModel.infoModel.iconString]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    }

    self.chatRecvTimeLabel.text = chatModel.messageRecvTimeString;
    NSDictionary *bodyDict = [GYHDUtils stringToDictionary:chatModel.body ];
    
    self.nameLabel.text=bodyDict[@"map_name"];
    
    self.contentLabel.text= bodyDict[@"map_address"];

    
}

- (void)setSessionModel:(GYHDSessionRecordModel *)sessionModel {
    _sessionModel = sessionModel;
    
    self.chatRecvTimeLabel.text = sessionModel.sendTimeFormat;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,sessionModel.senderHeadIcon]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    
    NSDictionary *bodyDict = [GYHDUtils stringToDictionary:sessionModel.msgContent ];
    
    self.nameLabel.text=bodyDict[@"map_name"];
    
    self.contentLabel.text= bodyDict[@"map_address"];
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
