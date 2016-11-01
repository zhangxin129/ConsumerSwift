//
//  GYHDMessageSetView.m
//  GYRestaurant
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMessageSetView.h"
#import "GYHDPushSetCell.h"
#define  SET_KEY @"setKey"

@interface GYHDMessageSetView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableDictionary *setDic;//设置字典

@property(nonatomic,strong)NSArray *nameArray1;//
@property(nonatomic,strong)NSArray *nameArray2;//
@property(nonatomic,strong)NSArray *contentArray1;//
@property(nonatomic,strong)NSArray *setArray1;//设置数组1
@property(nonatomic,strong)NSArray *setArray2;//设置数组2
@property(nonatomic,strong)NSMutableArray *pushArray;//临时设置数组
@end
@implementation GYHDMessageSetView


-(instancetype)initWithFrame:(CGRect)frame{



    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        [self getSetInfo];
        [self setUp];
    }

    return self;
}
-(void)getSetInfo{
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    
    NSString *key = globalData.loginModel.custId;

    self.pushArray =[NSMutableArray new];
    
    NSArray *tempArray = [def objectForKey:key];
    
    [self.pushArray addObjectsFromArray:tempArray];
    
    if (self.pushArray.count==4) {
        
        self.setArray1=@[self.pushArray[0],self.pushArray[1]];
        
        self.setArray2=@[self.pushArray[2],self.pushArray[3]];
    }
    
    
}


-(NSArray*)nameArray1{
    
    if (!_nameArray1) {
        
        _nameArray1 =@[@"免打扰",@""];
    }
    return _nameArray1;
}

-(NSArray*)nameArray2{
    
    if (!_nameArray2) {
        
        _nameArray2 =@[@"声音",@"震动"];
    }
    return _nameArray2;
}

-(NSArray*)contentArray1{
    
    if (!_contentArray1) {
        
        _contentArray1 =@[@"全天",@"夜晚(22:00-8:00)"];
    }
    return _contentArray1;
}

-(void)setUp{
    kWEAKSELF;
    self.bgView=[[UIView alloc]init];
    
    self.bgView.backgroundColor=[UIColor whiteColor];
    
    [self addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(300);
        
    }];

    UIImageView *blueImageView = [[UIImageView alloc]init];
    blueImageView.image = [UIImage imageNamed:@"icon_ts"];
    [self.bgView addSubview:blueImageView];
    [blueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(4, 20));
    }];
    
    UILabel *baceInfoLabel = [[UILabel alloc]init];
    baceInfoLabel.text = @"设置";
    baceInfoLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    baceInfoLabel.font = [UIFont systemFontOfSize:22.0];
    [self.bgView addSubview:baceInfoLabel];
    [baceInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blueImageView.mas_right).offset(18);
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-12);
    }];
    
    UIView*lineView=[[UIView alloc]init];
    
    lineView.backgroundColor=[UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    [self.bgView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(baceInfoLabel.mas_bottom).offset(29);
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);

    }];
    
    self.tableView =[[UITableView alloc]init];
    [self.tableView registerClass:[GYHDPushSetCell class] forCellReuseIdentifier:@"GYHDPushSetCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.bgView addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baceInfoLabel.mas_bottom).offset(30);
        make.left.right.bottom.mas_equalTo(0);
        
    }];
    [self setExtraCellLineHidden:self.tableView];
   
    UIButton*backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [backBtn setImage:[UIImage imageNamed:@"hd_nav_leftView_back"] forState:UIControlStateNormal];
    
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.top.equalTo(weakSelf.bgView.mas_bottom).offset(0);
        
    }];
    
    
}

#pragma mark - UISwitch method
-(void)configPush:(GYHDSwitch*)switchBtn{
    NSIndexPath *indexPath = switchBtn.indexPath;
    
    NSNumber *curNumber=switchBtn.isOn?@1:@0;
    
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            //设置免打扰全天
            
            //  self.pushArray[0]=curNumber;//
            
            [self.pushArray replaceObjectAtIndex:0 withObject:curNumber];
            //如果全天打开，则夜晚必须关闭,反之一样
            if (switchBtn.isOn) {
                [self.pushArray replaceObjectAtIndex:1 withObject:@0];
                
            }
        }
        else{
            //设置免打扰夜晚
            
            [self.pushArray replaceObjectAtIndex:1 withObject:curNumber];
            if (switchBtn.isOn) {
                
                [self.pushArray replaceObjectAtIndex:0 withObject:@0];
            }
        }
    }
    
    else if (indexPath.section==1){
        if (indexPath.row==0) {
            //设置声音
            
            [self.pushArray replaceObjectAtIndex:2 withObject:curNumber];
        }
        else{
            //设置震动
            
            [self.pushArray replaceObjectAtIndex:3 withObject:curNumber];
        }
        
    }
    
    NSString *key  =globalData.loginModel.custId;
    
    
    
    [[NSUserDefaults standardUserDefaults]setObject:self.pushArray forKey:key];
    
    BOOL flag =[[NSUserDefaults standardUserDefaults]synchronize];
    
    if (flag) {
        [self getSetInfo];
        
        [self.tableView reloadData];
    }
    
}

#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==1) {
        
        return 1;
    }
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GYHDPushSetCell *cell =[tableView dequeueReusableCellWithIdentifier:@"GYHDPushSetCell"];
    
    [cell.switchView addTarget:self action:@selector(configPush:) forControlEvents:UIControlEventValueChanged];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.switchView.indexPath = indexPath;
    
    if (indexPath.section==0) {
        
        cell.nameLabel.text = self.nameArray1[indexPath.row];
        cell.contentLabel.text = self.contentArray1[indexPath.row];
        
        NSNumber *number =self.setArray1[indexPath.row];
        
        if ([number isEqualToNumber:@1]) {
            
            [cell.switchView setOn:YES];
        }
        else{
            [cell.switchView setOn:NO];
        }
    }
    else if (indexPath.section==1){
        cell.nameLabel.text = self.nameArray2[indexPath.row];
        
        NSNumber *number =self.setArray2[indexPath.row];
        
        if ([number isEqualToNumber:@1]) {
            
            [cell.switchView setOn:YES];
            
        }
        else{
            [cell.switchView setOn:NO];
        }
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

#pragma mark - method
- (void)setExtraCellLineHidden:(UITableView*)tableView
{
    
    UIView* view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)back{

    if (_delegate && [_delegate respondsToSelector:@selector(backPersonInfo)]) {
        
        [_delegate backPersonInfo];
    }

}
@end
