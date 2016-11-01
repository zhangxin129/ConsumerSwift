//
//  GYHDAllMsgListCell.m
//  GYRestaurant
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAllMsgListCell.h"
#import "GYHDMessageCenter.h"
@implementation GYHDAllMsgListCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        
    }
    return self;
}
-(void)setup {
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.layer.cornerRadius = 3;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.userInteractionEnabled=YES;
    //    UITapGestureRecognizer*iconTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick:)];
    //    [self.iconImageView addGestureRecognizer:iconTap];
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(44);
    }];
    
    self.timeLabel=[[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.timeLabel.textAlignment=NSTextAlignmentRight;
    self.timeLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
        
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    self.lastMsgLabel = [[UILabel alloc]init];
    self.lastMsgLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    self.lastMsgLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.lastMsgLabel];
    [self.lastMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    
    self.unreadMessageCountLabel=[[UILabel alloc]init];
    self.unreadMessageCountLabel.textColor=[UIColor whiteColor];
    self.unreadMessageCountLabel.backgroundColor=[UIColor redColor];
    self.unreadMessageCountLabel.textAlignment=NSTextAlignmentCenter;
    self.unreadMessageCountLabel.font=[UIFont boldSystemFontOfSize:10];
    [self addSubview:self.unreadMessageCountLabel];
    [self.unreadMessageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.iconImageView.mas_right);
        make.centerY.equalTo(self.iconImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        
    }];
    
    self.unreadMessageCountLabel.layer.cornerRadius=12;
    self.unreadMessageCountLabel.layer.masksToBounds=YES;
}

-(void)refreshUIWithModle:(GYHDAllMsgListModel *)model{
    
    if ([model.msgType isEqualToString:@"9"]) {
        
        if ([model.pushMsgType isEqualToString:@"1"]) {
            
            self.iconImageView.image=[UIImage imageNamed:@"icon_xtxx"];
            
        }else if ([model.pushMsgType isEqualToString:@"2"]){
        
        
        self.iconImageView.image=[UIImage imageNamed:@"icon_ddxx"];
        
        }else{
        
        self.iconImageView.image=[UIImage imageNamed:@"icon_fwxx"];
        }
       
    }else{
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.iconUrl]] placeholder:[UIImage imageNamed:@"defaultheadimg"] options:kNilOptions completion:nil];
    }
    self.nameLabel.text=model.titlName;
    self.timeLabel.text=[[GYHDMessageCenter sharedInstance]messageTimeStrFromTimerString:model.timeStr];
    
    if (model.content != nil ) {
        
        self.lastMsgLabel.attributedText=[[GYHDMessageCenter sharedInstance] attStringWithString:model.content imageFrame:CGRectMake(0, -2, 15, 15) attributes:nil];
    }
    
//    self.lastMsgLabel.text=model.content;
    
    if ([model.messageUnreadCount integerValue]==0) {
        
        self.unreadMessageCountLabel.hidden=YES;
    }else{
        
        self.unreadMessageCountLabel.hidden=NO;
    }
    if ([model.messageUnreadCount integerValue]>=99) {
        
        self.unreadMessageCountLabel.text=@"99+";
        
    }else{
        
        self.unreadMessageCountLabel.text=model.messageUnreadCount;
        
    }
    
    if (model.messageState) {
        
         self.backgroundColor=[UIColor clearColor];
        
    }else{
       
        self.backgroundColor =[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    }
    
}

@end
