//
//  GYHDNewFriendsCell.m
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDNewFriendsCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDSDK.h"
@implementation GYHDNewFriendsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImgView=[[UIImageView alloc]init];
        self.iconImgView.userInteractionEnabled=YES;
        [self.contentView addSubview:self.iconImgView];
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(44);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(44);
        }];
        
        self.addStateBtn=[[UIButton alloc]init];
        
        [self.addStateBtn addTarget:self action:@selector(addStateBtnClick)forControlEvents:UIControlEventTouchUpInside];
        self.addStateBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.addStateBtn];
        
        [self.addStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(44, 26));
        }];
        self.nameLabel=[[UILabel alloc]init];
        
        self.nameLabel.font= [UIFont systemFontOfSize:20.0];
        
        [self.contentView addSubview:self.nameLabel];
        __weak __typeof(self) wself = self;
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.iconImgView.mas_right).offset(10);
            make.right.equalTo(wself.addStateBtn.mas_left).offset(5);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(20);
            
        }];
        
        self.contentLabel=[[UILabel alloc]init];
        
        self.contentLabel.textColor=[UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1];
        
        self.contentLabel.font=[UIFont systemFontOfSize:14.0];
        
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(wself.iconImgView.mas_right).offset(10);
            make.right.equalTo(wself.addStateBtn.mas_left).offset(5);
            make.top.mas_equalTo(wself.nameLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(20);
            
        }];
        
    }
    return self;
}

-(void)refreshUIWith:(GYHDContactsListModel*)model{
    
    _model=model;
    
    [self.iconImgView setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholder:[UIImage imageNamed:@"gyhd_contants_deafultheadportrait_icon"]];
    
    self.nameLabel.text=model.name;
    
    self.contentLabel.text=model.content;
    
    if ([model.addState isEqualToString:@"1"]){
        
        //        已添加
        [self.addStateBtn setTitle:@"已添加" forState:UIControlStateNormal];
        [self.addStateBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.addStateBtn.backgroundColor=[UIColor clearColor];
        self.addStateBtn.enabled=NO;
        
    }else {
        
        //        接受
        [self.addStateBtn setTitle:@"接受" forState:UIControlStateNormal];
        self.addStateBtn.backgroundColor=[UIColor colorWithHexString:@"#ef4136"];
        self.addStateBtn.layer.cornerRadius=6;
        self.addStateBtn.layer.masksToBounds=YES;
        self.addStateBtn.enabled=YES;
        
    }

}


-(void)addStateBtnClick{

        
DDLogInfo(@"点击接受请求");
    
    NSDictionary *dict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    NSMutableDictionary *insideDict = [NSMutableDictionary dictionary];
    //            insideDict[@"accountId"] =  dict[@"Friend_ID"];
    //            insideDict[@"accountNickname"] = dict[@"Friend_Name"];
    //            insideDict[@"accountHeadPic"] = dict[@"Friend_Icon"];
    //            insideDict[@"req_info"] = string;
    //            insideDict[@"friendId"] =self.userModel.custID;
    //            insideDict[@"friendNickname"] =self.userModel.nameString;
    //            insideDict[@"friendStatus"] = @"1";
    //            insideDict[@"friendHeadPic"] = self.userModel.iconString;
    NSString *string = @"我同意加你为好友";
    insideDict[@"msg_icon"] = dict[@"Friend_Icon"];
    insideDict[@"msg_note"] = dict[@"Friend_Name"];
    insideDict[@"sex"] = globalData.loginModel.sex;
    insideDict[@"reqInfo"] = string;
    insideDict[@"msg_subject"] = [NSString stringWithFormat:@"%@ 同意添加你为好友",globalData.loginModel.custId];
    insideDict[@"msgContent"] = string;
    
    [[GYHDSDK sharedInstance] verifyFriendWithFriendID:[NSString stringWithFormat:@"%@",self.model.custid] agree:0 content:[GYUtils dictionaryToString:insideDict]];
//    [[GYHDMessageCenter sharedInstance] addFriendWithFriendID:[NSString stringWithFormat:@"%@",self.model.custid] verify:[GYUtils dictionaryToString:insideDict]];

}
@end
