
//
//  GYHDCustomerInfoView.m
//  HSEnterprise
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDCustomerInfoView.h"
@interface GYHDCustomerInfoView()
@property (nonatomic, weak) UIScrollView *mainScrollView;
@property(nonatomic,strong) UILabel *userNameLabel;
@property(nonatomic,strong) UIImageView *sexImageView;
@property(nonatomic,strong) UILabel *HSCardNumLabel;
@property(nonatomic,strong) UILabel *nickNameLabel;
@property(nonatomic,strong) UILabel *ageLabel;
@property(nonatomic,strong) UILabel *sexLabel;
@property(nonatomic,strong) UILabel *areaLabel;
@property(nonatomic,strong) UILabel *hobbyLabel;
@property(nonatomic,strong) UILabel *signLabel;
@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong) NSArray * arr;
@property(nonatomic,strong) UILabel*resNoLabel;
@end
@implementation GYHDCustomerInfoView

#pragma mark - 懒加载
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        UIScrollView *mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 350, kScreenHeight)];
        mainScrollView.backgroundColor = [UIColor whiteColor];
        mainScrollView.userInteractionEnabled=YES;
        [self addSubview:mainScrollView];
        _mainScrollView = mainScrollView;
    }
    return _mainScrollView;
}

- (void) setup {
    @weakify(self);
    UIImageView *blueImageView = [[UIImageView alloc]init];
    blueImageView.image = [UIImage imageNamed:@"icon_ts"];
    [self.mainScrollView addSubview:blueImageView];
    [blueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(4, 20));
    }];

    UILabel *baceInfoLabel = [[UILabel alloc]init];
    baceInfoLabel.text = @"基本信息";
    baceInfoLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    baceInfoLabel.font = [UIFont systemFontOfSize:22.0];
    [self.mainScrollView addSubview:baceInfoLabel];
    [baceInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blueImageView.mas_right).offset(18);
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-12);
    }];
    
    self.iconsImageView = [[UIImageView alloc]init];
    self.iconsImageView .layer.cornerRadius = 3;
    self.iconsImageView .layer.masksToBounds = YES;
    self.iconsImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImg)];
    [self.iconsImageView addGestureRecognizer:tap];
    
    [self.mainScrollView addSubview:self.iconsImageView ];
    [self.iconsImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baceInfoLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(56.0, 56.0));
    }];
    
    self.userNameLabel = [[UILabel alloc]init];
     self.userNameLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
     self.userNameLabel.font = [UIFont systemFontOfSize:18.0];
    self.userNameLabel.numberOfLines=0;
    self.userNameLabel.adjustsFontSizeToFitWidth=YES;
    [self.mainScrollView addSubview: self.userNameLabel];
    [ self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(40);
        make.top.equalTo(baceInfoLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(250);
    }];
    
    self.HSCardNumLabel = [[UILabel alloc]init];
    self.HSCardNumLabel.font = [UIFont systemFontOfSize:16.0];
    self.HSCardNumLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    [self.mainScrollView addSubview:self.HSCardNumLabel];
    [self.HSCardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(2);
        
    }];
    
    self.resNoLabel=[[UILabel alloc]init];
    self.resNoLabel.font = [UIFont systemFontOfSize:16.0];
    self.resNoLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    [self.mainScrollView addSubview:self.resNoLabel];
    [self.resNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.equalTo(self.HSCardNumLabel.mas_bottom).offset(1);
    }];
    self.resNoLabel.hidden=YES;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = kDefaultVCBackgroundColor;
    [self.mainScrollView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconsImageView.mas_bottom).offset(20);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(350);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.userInteractionEnabled=YES;
    [self.mainScrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(350, 360));
        make.top.equalTo(lineView.mas_bottom).offset(0);
    }];
    if (_model.isClickSelf) {
        
         self.arr=@[@"营业点",@"角色",@"职务",@"电话",@"设置"];
        
    }else{
        
       self.arr = [NSArray arrayWithObjects:@"昵称",@"年龄",@"性别",@"地区",@"爱好",@"签名",nil];
        
    }
 
    
    for (int i = 0 ; i < self.arr.count; i ++) {
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(30, i * 60, 80, 60);
        label.text = self.arr[i];
        label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:20.0];
        [bottomView addSubview:label];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(0, (i + 1) * 60 - 1, 350, 1);
        lineView.backgroundColor = kDefaultVCBackgroundColor;
        [bottomView addSubview:lineView];
    }
    self.nickNameLabel = [[UILabel alloc]init];
    self.nickNameLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
    self.nickNameLabel.font = [UIFont systemFontOfSize:20.0];
    self.nickNameLabel.numberOfLines=0;
    self.nickNameLabel.adjustsFontSizeToFitWidth=YES;
    [bottomView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(220);
    }];
    
    self.ageLabel = [[UILabel alloc]init];
    self.ageLabel .textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
    self.ageLabel .font = [UIFont systemFontOfSize:20.0];
    self.ageLabel.numberOfLines=0;
    self.ageLabel.adjustsFontSizeToFitWidth=YES;
    [bottomView addSubview:self.ageLabel];
    [self.ageLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(220);
    }];
    
    self.sexLabel= [[UILabel alloc]init];
    self.sexLabel .textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
    self.sexLabel .font = [UIFont systemFontOfSize:20.0];
    [bottomView addSubview:self.sexLabel ];
    [self.sexLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.equalTo(self.ageLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(60);
    }];

    self.areaLabel = [[UILabel alloc]init];
    self.areaLabel .textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
    self.areaLabel .font = [UIFont systemFontOfSize:20.0];
    [bottomView addSubview:self.areaLabel ];
    [self.areaLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.equalTo(self.sexLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(60);
    }];

    self.hobbyLabel = [[UILabel alloc]init];
    self.hobbyLabel .textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
    self.hobbyLabel .font = [UIFont systemFontOfSize:20.0];
    self.hobbyLabel.numberOfLines=0;
    self.hobbyLabel.adjustsFontSizeToFitWidth=YES;
    [bottomView addSubview:self.hobbyLabel ];
    [self.hobbyLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.equalTo(self.areaLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(220);
    }];
    
    if (_model.isClickSelf) {
        
#warning 增加设置背景View
        self.setView=[[UIView alloc]init];
        self.setView.backgroundColor=[UIColor clearColor];
        
        UITapGestureRecognizer*setTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setGes)];
        [self.setView addGestureRecognizer:setTap];
        [bottomView addSubview:self.setView];
        [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.equalTo(self.areaLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(60);
            make.right.mas_equalTo(0);
        }];
        
        
        UIImageView*arrowView=[[UIImageView alloc]init];
        arrowView.image=[UIImage imageNamed:@"HD_Infoarrow"];
        [self.setView addSubview:arrowView];
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(22);
            make.size.mas_equalTo(CGSizeMake(10, 20));
        }];
        
    }
    
    self.signLabel = [[UILabel alloc]init];
    self.signLabel .textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
    self.signLabel .font = [UIFont systemFontOfSize:20.0];
    self.signLabel.lineBreakMode=NSLineBreakByWordWrapping;
    self.signLabel.numberOfLines=0;
    self.signLabel.adjustsFontSizeToFitWidth=YES;
    [bottomView addSubview:self.signLabel ];
    [self.signLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.equalTo(self.hobbyLabel.mas_bottom).offset(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(220);
    }];
}

-(void)setModel:(GYHDCustomerDetailModel *)model{

    _model=model;
    
    [self setup];
    
    NSString*url=[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.headImage];
    [self.iconsImageView setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"defaultheadimg"] options:kNilOptions completion:nil];
    
//    判断是否进入自身信息界面
    
    if (model.isClickSelf) {
        self.resNoLabel.hidden=NO;
        self.userNameLabel.text=model.operName;
        NSMutableArray*sale_networkNameArr=[NSMutableArray array];
        if (model.saleAndOperatorRelationList.count>0) {
            
            for (NSDictionary*dict in model.saleAndOperatorRelationList) {
                
                [sale_networkNameArr addObject:dict[@"sale_networkName"]];
            }
            
        }
        
        NSString*netWorkStr=[sale_networkNameArr componentsJoinedByString:@","];
        
        self.nickNameLabel.text=netWorkStr;
        self.HSCardNumLabel.text=[NSString stringWithFormat:@"用户名:%@",model.username];
        self.ageLabel.text=model.roleName;
        self.areaLabel.text=model.operPhone;
        self.sexLabel.text=model.operDuty;
        if (model.resNo.length>0) {
        
            self.resNoLabel.text=[NSString stringWithFormat:@"互生卡:%@",model.resNoFormatStr];
        }else{
        
            self.resNoLabel.hidden=YES;
        }
    
    }else{
        self.userNameLabel.text=model.nickName;
        
        if ([model.userType isEqualToString:@"1"]) {
            
            self.HSCardNumLabel.text=[NSString stringWithFormat:@"互生卡:%@",model.resNoFormatStr];
        }
       
        self.nickNameLabel.text=model.nickName;
        if ([model.age isKindOfClass:[NSNull class]]) {
            
            self.ageLabel.text=@"";
        }else{
            
        self.ageLabel.text=[NSString stringWithFormat:@"%@",model.age];
            
        }
        
        if ([model.sex isEqualToString:@"1"]) {
            self.sexLabel.text=@"男";
            
        }else if ([model.sex isEqualToString:@"0"]){
            
            self.sexLabel.text=@"女";
            
            
        }else{
            
            
        }
        
        self.areaLabel.text=model.area;
        self.hobbyLabel.text=model.hobby;
        self.signLabel.text=model.sign;
        
    }

}

-(void)uploadImg{

    if (_delegate && [_delegate respondsToSelector:@selector(uploadImg)] && _model.isClickSelf) {
        
        [_delegate uploadImg];
    }
}
-(void)setGes{

    if (_delegate && [_delegate respondsToSelector:@selector(loadSetView)] && _model.isClickSelf) {
      
        [_delegate loadSetView];
        
    }

}

@end
