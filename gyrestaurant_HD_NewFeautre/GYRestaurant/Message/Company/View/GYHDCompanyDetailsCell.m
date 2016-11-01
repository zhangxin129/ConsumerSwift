//
//  GYHDCompanyDetailsCell.m
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDCompanyDetailsCell.h"
#import "AppDelegate.h"
#import "GYHDSaleListModel.h"
#import "GYHDMessageCenter.h"

@interface GYHDCompanyDetailsCell()
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *departmentLabel;
@property(nonatomic,strong) UILabel *phoneLabel;

@end

@implementation GYHDCompanyDetailsCell


-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        self.iconImageView = [[UIImageView alloc]init];
        //    iconImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.mas_equalTo(61);
            make.width.height.mas_equalTo(78);
        }];
        self.unreadMessageCountLabel=[[UILabel alloc]init];
//        self.unreadMessageCountLabel.text=@"99+";
        self.unreadMessageCountLabel.textColor=[UIColor whiteColor];
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
        
        UIButton *phoneBtn = [[UIButton alloc]init];
        phoneBtn.tag = 100;
        //    [phoneBtn setImage:[UIImage imageNamed:@"btn_dh_n"] forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:phoneBtn];
        [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        UIButton *sendMsgBtn = [[UIButton alloc]init];
        sendMsgBtn.tag = 101;
        [sendMsgBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [sendMsgBtn setImage:[UIImage imageNamed:@"btn_xx_n"] forState:UIControlStateNormal];
        [self addSubview:sendMsgBtn];
        [sendMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.right.equalTo(phoneBtn.mas_left).offset(-15);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        self.nameLabel.font = [UIFont systemFontOfSize:20.0];
        [self addSubview:self.nameLabel];
        WS(weakSelf);
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(32);
            make.left.equalTo(weakSelf.iconImageView.mas_right).offset(20);
            make.height.mas_equalTo(20);
            make.right.equalTo(sendMsgBtn.mas_left);
        }];
        
        self.departmentLabel = [[UILabel alloc]init];
        self.departmentLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        self.departmentLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:self.departmentLabel];
        [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(15);
            make.left.equalTo(weakSelf.iconImageView.mas_right).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 16));
            make.height.mas_equalTo(16);
        }];
        
        self.phoneLabel = [[UILabel alloc]init];
        self.phoneLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        self.phoneLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:self.phoneLabel];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.departmentLabel.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.iconImageView.mas_right).offset(20);
            make.height.mas_equalTo(16);
        }];
        
    }


    return self;
}

- (void)initUIWithModel:(GYHDSaleListModel *)model{
  
        _model=model;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.headImage]] placeholder:[UIImage imageNamed:@"defaultheadimg"] options:kNilOptions completion:nil];
        self.nameLabel.text =model.operName;
    
        self.departmentLabel.text = model.roleName;
    
        self.phoneLabel.text = [NSString stringWithFormat:@"电话:%@",model.operPhone];
    
    if ([model.messageUnreadCount integerValue]>=99) {
        
        self.unreadMessageCountLabel.text=@"99+";
        self.unreadMessageCountLabel.backgroundColor=[UIColor redColor];
        
    }else if([model.messageUnreadCount integerValue]>=1){
        
        self.unreadMessageCountLabel.text=model.messageUnreadCount;
        
        self.unreadMessageCountLabel.backgroundColor=[UIColor redColor];
        
    }else{
        
        self.unreadMessageCountLabel.text=@"";
        self.unreadMessageCountLabel.backgroundColor=[UIColor clearColor];
    }

}
-(void)initUIWithOperatorModel:(GYHDOpereotrListModel *)model{
    
    NSDictionary*dic=model.searchUserInfo;
    NSArray*arr=model.saleAndOperatorRelationList;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,dic[@"headImage"]]] placeholder:[UIImage imageNamed:@"defaultheadimg"] options:kNilOptions completion:nil];
    self.nameLabel.text=dic[@"operName"];
    
//    NSMutableArray*roleNameArr=[NSMutableArray array];
    NSMutableArray*sale_networkNameArr=[NSMutableArray array];
    if (arr.count>0) {
        
        for (NSDictionary*dict in arr) {
            
//            [roleNameArr addObject:dict[@"roleName"]];
            
            [sale_networkNameArr addObject:dict[@"sale_networkName"]];
        }
        
    }
//    NSString*roleNameStr=[roleNameArr componentsJoinedByString:@","];
    
    NSString*roleNameStr=model.roleName;
    self.departmentLabel.text=roleNameStr;
    self.phoneLabel.text=[NSString stringWithFormat:@"电话:%@",dic[@"operPhone"]];
    
    if ([model.messageUnreadCount integerValue]>=99) {
        
        self.unreadMessageCountLabel.text=@"99+";
        self.unreadMessageCountLabel.backgroundColor=[UIColor redColor];
        
    }else if([model.messageUnreadCount integerValue]>=1){
        
        self.unreadMessageCountLabel.text=model.messageUnreadCount;
        
        self.unreadMessageCountLabel.backgroundColor=[UIColor redColor];
        
    }else{
    
        self.unreadMessageCountLabel.text=@"";
        self.unreadMessageCountLabel.backgroundColor=[UIColor clearColor];
    }
    
}

- (void)click :(UIButton*)btn{
   
    switch (btn.tag) {
//            进入聊天
        case 101:
        {
        
            DDLogCInfo(@"聊天");
            
            
        }
            break;
//            打电话
        case 100:{
        
            DDLogCInfo(@"电话");
//            AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
//            [Utils callPhoneWithPhoneNumber:self.model.telPhone showInView:delegate.window];
            
        }break;
        default:
            break;
    }
    
    
}
@end
