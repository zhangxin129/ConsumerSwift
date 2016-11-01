//
//  GYHDStaffInfoView.m
//  HSEnterprise
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDStaffInfoView.h"
#import "GYHDStaffInfoViewCell.h"
@interface GYHDStaffInfoView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UIScrollView *mainScrollView;
@property (nonatomic,strong)  UIImageView *iconsImageView;
@property (nonatomic,strong)  UILabel *userName;
@property (nonatomic,strong)  UILabel *HSCardNumLabel;
@property (nonatomic,strong)  UILabel *hsResNoLabel;
@property (nonatomic,strong)  UILabel *businessPointLabel;
@property (nonatomic,strong)  UILabel *postLabel;
@property (nonatomic,strong)  UILabel *areaLabel;
@property (nonatomic,strong)  UILabel *phoneLabel;
@property (nonatomic,strong) UITableView*businessinfoTableView;
@property (nonatomic,strong) UITableView*roleInfoTableView;
@property (nonatomic,strong) NSMutableArray*businessinfoArry;
@property (nonatomic,strong) NSMutableArray*roleArry;
@end
@implementation GYHDStaffInfoView
#pragma mark - 懒加载
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        UIScrollView *mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 350, kScreenHeight)];
        mainScrollView.backgroundColor = [UIColor whiteColor];
        mainScrollView.scrollEnabled=NO;
        [self addSubview:mainScrollView];
        _mainScrollView = mainScrollView;
    }
    return _mainScrollView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void) setup {
    self.businessinfoArry=[NSMutableArray array];
    self.roleArry=[NSMutableArray array];
    UIImageView *blueImageView = [[UIImageView alloc]init];
    blueImageView.image = [UIImage imageNamed:@"icon_ts"];
    [self.mainScrollView addSubview:blueImageView];
    [blueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.left.mas_equalTo(10);
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
    self.iconsImageView.layer.cornerRadius = 3;
    self.iconsImageView.layer.masksToBounds = YES;
    self.iconsImageView.backgroundColor = [UIColor yellowColor];
    [self.mainScrollView addSubview:self.iconsImageView];
    [self.iconsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baceInfoLabel.mas_bottom).offset(36);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(56.0, 56.0));
    }];
    @weakify(self);
   self.userName = [[UILabel alloc]init];
    self.userName.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
    self.userName.font = [UIFont systemFontOfSize:18];
    [self.mainScrollView addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(350-76, 22));
        make.top.equalTo(baceInfoLabel.mas_bottom).offset(36);
    }];
    
    self.HSCardNumLabel = [[UILabel alloc]init];
    self.HSCardNumLabel.font = [UIFont systemFontOfSize:18];
    self.HSCardNumLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    [self.mainScrollView addSubview:self.HSCardNumLabel];
    [self.HSCardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.equalTo(self.userName.mas_bottom).offset(5);
    }];
    
    self.hsResNoLabel=[[UILabel alloc]init];
    self.hsResNoLabel.font = [UIFont systemFontOfSize:18];
    self.hsResNoLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    [self.mainScrollView addSubview:self.hsResNoLabel];
    [self.hsResNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.equalTo(self.HSCardNumLabel.mas_bottom).offset(3);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = kDefaultVCBackgroundColor;
    [self.mainScrollView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconsImageView.mas_bottom).offset(20);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(350);
    }];
    

    UIView *bottomView = [[UIView alloc]init];
    [self.mainScrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(350, 180));
        make.top.equalTo(lineView.mas_bottom).offset(0);
    }];
    
    NSArray *arr = [NSArray arrayWithObjects:@"营业点",@"角色",@"职务",@"电话", nil];
    
    for (int i = 0 ; i < arr.count; i ++) {
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(10, i * 80, 60, 80);
        label.text = arr[i];
        label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:20.0];
        label.tag=i+100;
        [bottomView addSubview:label];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(0, (i + 1) * 80 - 1, 350, 1);
        lineView.backgroundColor = kDefaultVCBackgroundColor;
        [bottomView addSubview:lineView];
    }
    
//    self.businessPointLabel = [[UILabel alloc]init];
//    self.businessPointLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
//    self.businessPointLabel.font = [UIFont systemFontOfSize:20.0];
//    self.businessPointLabel.lineBreakMode=NSLineBreakByWordWrapping;
//    [bottomView addSubview:self.businessPointLabel];
//    [self.businessPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.iconsImageView.mas_right).offset(20);
//        make.top.mas_equalTo(0);
//        make.height.mas_equalTo(80);
//    }];
    
    self.businessinfoTableView=[[UITableView alloc]initWithFrame:CGRectMake(70, CGRectGetMaxY(lineView.frame)+22, 280, 50) style:UITableViewStylePlain];
    self.businessinfoTableView.delegate=self;
    self.businessinfoTableView.dataSource=self;
    [self.businessinfoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.businessinfoTableView.separatorStyle=0;
    [bottomView addSubview:self.businessinfoTableView];
    
//   self.postLabel = [[UILabel alloc]init];
//    self.postLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
//    self.postLabel.text = @"广东深圳";
//    self.postLabel.font = [UIFont systemFontOfSize:20.0];
//    self.postLabel.lineBreakMode=NSLineBreakByWordWrapping;
//    [bottomView addSubview:self.postLabel];
//    [self.postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.iconsImageView.mas_right).offset(20);
//        make.top.equalTo(weakSelf.businessinfoTableView.mas_bottom).offset(20);
//        make.height.mas_equalTo(80);
//    }];
    
    self.roleInfoTableView=[[UITableView alloc]initWithFrame:CGRectMake(70, CGRectGetMaxY(self.businessinfoTableView.frame)+25, 280, 50) style:UITableViewStylePlain];
    self.roleInfoTableView.delegate=self;
    self.roleInfoTableView.dataSource=self;
    [self.roleInfoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"roleCell"];
    self.roleInfoTableView.separatorStyle=0;
    [bottomView addSubview:self.roleInfoTableView];
    
    self.areaLabel = [[UILabel alloc]init];
    self.areaLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
//    areaLabel.text = @"广东深圳";
    self.areaLabel.font = [UIFont systemFontOfSize:20.0];
    [bottomView addSubview:self.areaLabel];
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.equalTo(self.roleInfoTableView.mas_bottom).offset(12);
        make.height.mas_equalTo(80);
    }];
    
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1];
    self.phoneLabel.font = [UIFont systemFontOfSize:20.0];
    [bottomView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconsImageView.mas_right).offset(20);
        make.top.equalTo(self.areaLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(80);
    }];
}

-(void)setModel:(GYHDSaleListModel *)model{

    _model=model;
    [self.iconsImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.headImage]] placeholder:[UIImage imageNamed:@"defaultheadimg"] options:kNilOptions completion:nil];
    self.userName.text=model.operName;
    
    self.HSCardNumLabel.text=[NSString stringWithFormat:@"用户名:%@",model.operatorId];
    
     NSString*resNoStr=[self segmentationHuShengCardWithCard:model.resNo];
    
    if (model.resNo.length>0) {
        
        self.hsResNoLabel.text=[NSString stringWithFormat:@"互生卡:%@",resNoStr];
    }else{
        
        self.hsResNoLabel.hidden=YES;
    }

    [self.businessinfoArry addObject:model.sale_networkName];
    
    [self.roleArry addObject:model.roleName];
//    self.businessPointLabel.text=model.sale_networkName;
//    self.postLabel.text=model.roleName;
    
    self.areaLabel.text=model.operDuty;
    
    self.phoneLabel.text=model.operPhone;
    self.roleInfoTableView.scrollEnabled=NO;
    self.roleInfoTableView.frame=CGRectMake(70, 100, 280, 50);
    [self.roleInfoTableView reloadData];
    self.businessinfoTableView.scrollEnabled=NO;
    self.businessinfoTableView.frame=CGRectMake(70, 20, 280, 50);
    [self.businessinfoTableView reloadData];
}

-(void)setOperatorModel:(GYHDOpereotrListModel *)operatorModel{
    
    _operatorModel=operatorModel;
    
    NSDictionary*dic=operatorModel.searchUserInfo;
    NSArray*arr=operatorModel.saleAndOperatorRelationList;
    [self.iconsImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,dic[@"headImage"]]] placeholder:[UIImage imageNamed:@"defaultheadimg"] options:kNilOptions completion:nil];
    self.userName.text=dic[@"operName"];
    NSString*resNoStr=[self segmentationHuShengCardWithCard:dic[@"resNo"]];
    if (resNoStr.length>0) {
        
        self.hsResNoLabel.text=[NSString stringWithFormat:@"互生卡:%@",resNoStr];
    }else{
        
        self.hsResNoLabel.hidden=YES;
    }
    
    self.hsResNoLabel.text=[NSString stringWithFormat:@"互生卡:%@",dic[@"resNo"]];
    self.HSCardNumLabel.text=[NSString stringWithFormat:@"用户名:%@",dic[@"username"]];
    
//    NSMutableArray*roleNameArr=[NSMutableArray array];
//    NSMutableArray*sale_networkNameArr=[NSMutableArray array];
    
    if (arr.count>0) {
        
        for (NSDictionary*dict in arr) {
            
            [self.businessinfoArry addObject:dict[@"sale_networkName"]];
        }
        
    }
    
//    NSString*str=[sale_networkNameArr componentsJoinedByString:@"\n"];
//  
//    self.businessPointLabel.numberOfLines=0;
//    
//    [self.businessPointLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        make.height.mas_equalTo(60);
//        
//    }];
//    self.businessPointLabel.text=str;
    self.roleArry =[[operatorModel.roleName componentsSeparatedByString:@","]mutableCopy];
//    NSString*roleNameStr=[roleNameArr componentsJoinedByString:@"\n"];
//    self.postLabel.numberOfLines=0;
//    [self.postLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//
//        make.height.mas_equalTo(60);
//        
//    }];
    
//    self.postLabel.text=roleNameStr;
    
    self.areaLabel.text=dic[@"operDuty"];
    
    self.phoneLabel.text=[NSString stringWithFormat:@"%@",dic[@"operPhone"]];

    if (self.businessinfoArry.count==1) {
        
        self.businessinfoTableView.scrollEnabled=NO;
    }
    
    if (self.roleArry.count==1) {
        
        self.roleInfoTableView.scrollEnabled=NO;
    }
    
    [self.businessinfoTableView reloadData];
    
    [self.roleInfoTableView reloadData];
    
//    
//    [self.areaLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        make.height.mas_equalTo(60);
//        
//    }];
    
//    self.areaLabel.textAlignment=NSTextAlignmentCenter;
//    
//    [self.phoneLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        make.height.mas_equalTo(60);
//        
//    }];
    self.phoneLabel.textAlignment=NSTextAlignmentCenter;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView==self.businessinfoTableView) {
        
        return self.businessinfoArry.count;
    }
    
    return self.roleArry.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell*cell=nil;
    
    if (tableView==self.businessinfoTableView) {
        
         cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (indexPath.row==0 && self.businessinfoArry.count>1) {
            
            NSString*str=self.businessinfoArry[indexPath.row];
            
            str=[NSString stringWithFormat:@"%@(上拉更多营业点信息)",str];
            
            cell.textLabel.text=str;
        }else{
            cell.textLabel.text=self.businessinfoArry[indexPath.row];
        }
        
    }else{
    
        cell=[tableView dequeueReusableCellWithIdentifier:@"roleCell"];
        if (indexPath.row==0 && self.roleArry.count>1) {
            
            NSString*str=self.roleArry[indexPath.row];
            
            str=[NSString stringWithFormat:@"%@(上拉更多角色信息)",str];
            
            cell.textLabel.text=str;
        }else{
          cell.textLabel.text=self.roleArry[indexPath.row];
        }
      
    }
    cell.textLabel.numberOfLines=0;
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    cell.selectionStyle=0;
    cell.textLabel.font=[UIFont systemFontOfSize:18];
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40;
}
/**根据互生卡 返回分段互生卡*/
- (NSString *)segmentationHuShengCardWithCard:(NSString *)card {
    if (card.length > 10) {
        NSString *sub1 = [card substringWithRange:NSMakeRange(0, 2)];
        NSString *sub2 = [card substringWithRange:NSMakeRange(2, 3)];
        NSString *sub3 = [card substringWithRange:NSMakeRange(5, 2)];
        NSString *sub4 = [card substringWithRange:NSMakeRange(7, 4)];
        card = [NSString stringWithFormat:@"%@ %@ %@ %@",sub1,sub2,sub3,sub4];
    }
    return card;
}
@end
