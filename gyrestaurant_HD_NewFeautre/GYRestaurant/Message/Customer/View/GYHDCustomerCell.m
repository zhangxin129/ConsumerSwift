//
//  GYCustomerCell.m
//  GYRestaurant
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCustomerCell.h"
#import "GYHDCustomerViewController.h"
#import "GYHDMessageCenter.h"
@implementation GYHDCustomerCell

- (void)awakeFromNib {

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
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
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

-(void)refreshUIWithModle:(GYHDCustomerModel *)model{
    
    _model=model;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.Friend_Icon]] placeholder:[UIImage imageNamed:@"defaultheadimg"] options:kNilOptions completion:nil];
    self.nameLabel.text=model.Friend_Name;
    
    NSData*jsData=[model.MSG_Body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:jsData options:NSJSONReadingMutableContainers error:nil];
    
//    DDLogCInfo(@"dict=%@",dict);
    
    if (dict[@"msg_content"] != nil ) {
        
        self.lastMsgLabel.attributedText=[[GYHDMessageCenter sharedInstance] attStringWithString:dict[@"msg_content"] imageFrame:CGRectMake(0, -2, 15, 15) attributes:nil];
    }
    
    switch ([dict[@"msg_code"]integerValue]) {
        case 10:{
            //图片
        self.lastMsgLabel.text=@"[图片]";
        }
            break;
        case 13:{
            
//            音频
            self.lastMsgLabel.text=@"[音频]";
            
        }break;
        case 14:{
        
//            视频
            
            self.lastMsgLabel.text=@"[视频]";
            
        }break;
        case 15:{
            
            self.lastMsgLabel.text=@"商品消息";
        }break;
        case 16:{
            self.lastMsgLabel.text=@"订单消息";
        }break;
        default:
            break;
    }
   
    
    if ([model.messageUnreadCount integerValue]==0) {
        
        self.unreadMessageCountLabel.hidden=YES;
    }
    if ([model.messageUnreadCount integerValue]>=99) {
        
        self.unreadMessageCountLabel.text=@"99+";
        
    }else{
    
      self.unreadMessageCountLabel.text=model.messageUnreadCount;
        
    }
    
    if (model.isSelect) {
        
         self.backgroundColor = [UIColor colorWithRed:196.0/255.0 green:235.0/255.0 blue:255.0/255.0 alpha:1.0];
    }else{
    
        self.backgroundColor=[UIColor clearColor];
    
    }
  
  
}
//-(void)headClick:(UIGestureRecognizer*)tap{

//    if (_headBlock) {
//        _headBlock(_model);
//    }

//}
@end
