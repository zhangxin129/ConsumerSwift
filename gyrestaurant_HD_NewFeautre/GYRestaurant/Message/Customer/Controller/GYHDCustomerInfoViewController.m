//
//  GYHDCustomerInfoViewController.m
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDCustomerInfoViewController.h"
#import "GYHDNavView.h"
#import "GYHDCustomerInfoView.h"
#import "GYHDCustomerOrderListView.h"
#import "GYHDNetWorkTool.h"
#import "GYHDCustomerDetailModel.h"
#import "GYHDDataBaseCenter.h"
#import "GYGIFHUD.h"
#import "GYRefreshFooter.h"
#import "GYRefreshHeader.h"
#import "GYHDCustomerOrderListModel.h"
#import "GYOrderInDetailViewController.h"
#import "NSObject+HXAddtions.h"
#import "GYHDCompanyPersonInfoCell.h"
#import "GYNetRequest.h"
#import "GYLoginEn.h"
#import "GYHDPopView.h"
#import "GYHDSearchAgeView.h"
#import "GYAddressData.h"
#import "GYHDAddressView.h"
#import "GYCityAddressModel.h"
#import "GYPhotoListViewController.h"
#import "GYHDMessageSetView.h"
@interface GYHDCustomerInfoViewController ()<GYHDNavViewDelegate,UITableViewDataSource,UITableViewDelegate,GYHDCompanyPersonInfoCellDelegate,GYHDCustomerInfoViewDelegate,UIAlertViewDelegate,GYNetRequestDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GYHDMessageSetViewDelegate>
@property(nonatomic,strong)GYHDCustomerInfoView *customerInfoView;
@property(nonatomic,strong)GYHDCustomerOrderListView *customerOrderListView;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,copy)NSString*resNoStr;
@property(nonatomic,strong)UITableView*personInfoTabelView;
@property(nonatomic,strong)NSMutableArray*personInfoArr;
@property(nonatomic,copy)NSString*nickName;
@property(nonatomic,copy)NSString*age;
@property(nonatomic,copy)NSString*sex;
@property(nonatomic,copy)NSString*hobby;
@property(nonatomic,copy)NSString*sign;
@property(nonatomic,copy)NSString*countryNo;
@property(nonatomic,copy)NSString*provinceNo;
@property(nonatomic,copy)NSString*cityNo;
@property(nonatomic,copy)NSString*area;
@property(nonatomic, copy) NSString *picUrlStr;
@property(nonatomic,strong)NSDictionary*personInfoDict;
@property(nonatomic,strong)NSMutableArray*provinceAry;
@property(nonatomic,strong)NSMutableArray*cityArr;
@property(nonatomic,strong)UIButton *saveBtn;
@property(nonatomic,strong)GYHDMessageSetView*setView;
@end

@implementation GYHDCustomerInfoViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=YES;
    

}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden=NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage=1;
    [self setupNav];
    [self loadCustomerDetailData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImgFromAlbum:) name:@"upLoadImg" object:nil];
}

-(GYHDCustomerInfoView *)customerInfoView{

    if (!_customerInfoView) {
        
        _customerInfoView = [[GYHDCustomerInfoView alloc]initWithFrame:CGRectMake(0, 64, 350, kScreenHeight)];
        _customerInfoView.delegate=self;
        [self.view addSubview:_customerInfoView];
        [_customerInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(350, kScreenHeight-64));
        }];
        
        
    }

    return _customerInfoView;

}

-(GYHDCustomerOrderListView *)customerOrderListView{


    if (!_customerOrderListView) {
        
        
        _customerOrderListView = [[GYHDCustomerOrderListView alloc]initWithFrame:CGRectMake(350, 64, kScreenWidth - 350, kScreenHeight - 64)];
        _customerOrderListView.dataSource =[NSMutableArray array];
        _customerOrderListView.delegate=self;
        [self.view addSubview:_customerOrderListView];
        [_customerOrderListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.left.equalTo(self.customerInfoView.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - 350, kScreenHeight - 64));
        }];
        
        [self setFresh];
    }

    return _customerOrderListView;
}
-(GYHDMessageSetView *)setView{

    if (!_setView) {
        
        _setView=[[GYHDMessageSetView alloc]initWithFrame:CGRectMake(360, 64, kScreenWidth-360, kScreenHeight-64)];
        _setView.delegate=self;
        [self.view addSubview:_setView];
    }

    return _setView;
}

-(NSMutableArray *)personInfoArr{

    if (!_personInfoArr) {
        
        _personInfoArr=[NSMutableArray array];
    }
    return _personInfoArr;
}

-(UITableView *)personInfoTabelView{

    if (!_personInfoTabelView) {
        
        [self setPersonInfo];
    }
    return _personInfoTabelView;
}

-(NSMutableArray *)cityArr{

    if (!_cityArr) {
        
        _cityArr=[NSMutableArray array];
    }
    return _cityArr;
    
}

-(NSMutableArray *)provinceAry{

    if (!_provinceAry) {
        
        _provinceAry=[NSMutableArray array];
    }
    return _provinceAry;
}
-(void)setPersonInfo{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-360, 75)];
    UIImageView *blueImageView = [[UIImageView alloc]init];
    blueImageView.image = [UIImage imageNamed:@"icon_ts"];
    [headerView addSubview:blueImageView];
    [blueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(4, 20));
    }];
    
    UILabel *baceInfoLabel = [[UILabel alloc]init];
    baceInfoLabel.text = @"个人资料";
    baceInfoLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    baceInfoLabel.font = [UIFont systemFontOfSize:22];
    [headerView addSubview:baceInfoLabel];
    [baceInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blueImageView.mas_right).offset(18);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    self.personInfoTabelView=[[UITableView alloc]initWithFrame:CGRectMake(360, 64, kScreenWidth-360, kScreenHeight-64) style:UITableViewStylePlain];
    [self.personInfoTabelView registerClass:[GYHDCompanyPersonInfoCell class] forCellReuseIdentifier:@"GYHDCompanyPersonInfoCell"];
    self.personInfoTabelView.dataSource=self;
    self.personInfoTabelView.delegate=self;
    self.personInfoTabelView.tableHeaderView=headerView;
    self.personInfoTabelView.rowHeight=60;
    self.personInfoTabelView.scrollEnabled=NO;
    self.personInfoTabelView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:self.personInfoTabelView];
}

-(void)loadPersonInfoData{
    
    if (self.personInfoDict==nil || [self.personInfoDict isKindOfClass:[NSNull class]]) {
        
        return;
    }
    
    NSDictionary*dict=self.personInfoDict[@"searchUserInfo"];
    self.nickName=kSaftToNSString(dict[@"nickName"]) ;
    self.age=kSaftToNSString( dict[@"age"]);
    self.sex=kSaftToNSString( dict[@"sex"]);
    self.area=kSaftToNSString(dict[@"area"]);
    self.hobby=kSaftToNSString(dict[@"hobby"]);
    self.sign=kSaftToNSString(dict[@"sign"]);
    self.picUrlStr=kSaftToNSString(dict[@"headImage"]);
    [self loadSubPerInfo];
    [self loadCityInfo];
}
-(void)loadSubPerInfo{

    NSMutableDictionary*dic1=[NSMutableDictionary dictionary];
    
    [dic1 setObject:@"昵称" forKey:@"rowName"];
    
    [dic1 setObject:self.nickName forKey:@"rowTFStr"];
    
    NSMutableDictionary*dic2=[NSMutableDictionary dictionary];
    
    [dic2 setObject:@"年龄" forKey:@"rowName"];
    [dic2 setObject:self.age forKey:@"rowTFStr"];
    
    NSMutableDictionary*dic3=[NSMutableDictionary dictionary];
    
    [dic3 setObject:@"性别" forKey:@"rowName"];
    [dic3 setObject:self.sex forKey:@"rowTFStr"];
    
    NSMutableDictionary*dic4=[NSMutableDictionary dictionary];
    
    [dic4 setObject:@"地区" forKey:@"rowName"];
    [dic4 setObject:self.area forKey:@"rowTFStr"];
    
    NSMutableDictionary*dic5=[NSMutableDictionary dictionary];
    
    [dic5 setObject:@"爱好" forKey:@"rowName"];
    [dic5 setObject:self.hobby forKey:@"rowTFStr"];
    
    NSMutableDictionary*dic6=[NSMutableDictionary dictionary];
    
    [dic6 setObject:@"签名" forKey:@"rowName"];
    [dic6 setObject:self.sign forKey:@"rowTFStr"];
    
    [self.personInfoArr addObject:dic1];
    [self.personInfoArr addObject:dic2];
    [self.personInfoArr addObject:dic3];
    [self.personInfoArr addObject:dic4];
    [self.personInfoArr addObject:dic5];
    [self.personInfoArr addObject:dic6];
    [self.personInfoTabelView reloadData];
}
#pragma mark - 获取城市信息
-(void)loadCityInfo{
//   先从本地获取地区信息
    [[GYAddressData shareInstance]receiveCityInfoBlock:^(NSArray *array) {
        
         [self.cityArr addObjectsFromArray:array];
    }];
    
    [[GYAddressData shareInstance] receiveProvinceInfoBlock:^(NSArray *array) {
        
        [self.provinceAry addObjectsFromArray:array];
    }];
    
    if (self.cityArr.count>0 && self.provinceAry.count>0) {
        
        return;
    }
//网络获取地区信息
    [[GYAddressData shareInstance] netRequestAddressInfo:^(NSArray *provinceAry, NSArray *cityAry) {
        
        [self.provinceAry addObjectsFromArray:provinceAry];
        
        [self.cityArr addObjectsFromArray:cityAry];

    }];

}
#pragma mark - 添加刷新控件
-(void)setFresh{

    GYRefreshHeader *header=[GYRefreshHeader headerWithRefreshingBlock:^{
        self.currentPage=1;
        [self.customerOrderListView.dataSource removeAllObjects];
        [self loadQueryOrderDataWithResNo:self.resNoStr];
    
    }];
   
    
    self.customerOrderListView.tableView.mj_header=header;
    
    GYRefreshFooter*footer=[GYRefreshFooter footerWithRefreshingBlock:^{
    self.currentPage++;
    [self loadQueryOrderDataWithResNo:self.resNoStr];
        
    }];
    
 
    self.customerOrderListView.tableView.mj_footer=footer;
}
- (void)setupNav {
    
    GYHDNavView *navView = [[GYHDNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , 64)];
    
    if (self.isClickSelf) {
        
        if (![globalData.loginModel.userName isEqualToString:@"0000"]) {
            
            //    保存
           self.saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
            [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.saveBtn.titleLabel.font=[UIFont systemFontOfSize:20];
            [self.saveBtn addTarget:self action:@selector(savePersonInfo) forControlEvents:UIControlEventTouchUpInside];
            
            [navView addSubview:self.saveBtn];
            
            [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.mas_equalTo(-20);
                make.size.mas_equalTo(CGSizeMake(44, 44));
                make.top.mas_equalTo(15);
                
            }];

        }
        
         [navView segmentViewLable:kLocalized(@"个人信息")];
        
    }else{
    
       [navView segmentViewLable:kLocalized(@"客户资料")];
    }
 
    navView.delegate = self;
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 64));
    }];
}
#pragma mark - 查询消费者订单详情
-(void)loadQueryOrderDataWithResNo:(NSString*)resNoStr{
    
    [GYGIFHUD show];
    
    NSString*shopId;

    if (kGetNSUser(@"shopId")==nil) {
        
        shopId=@"";
        
    }else{
    
        shopId=kGetNSUser(@"shopId");
    }
    
    if (resNoStr==nil) {
        
        resNoStr=@"";
    }

    NSDictionary *dict ;
           dict = @{@"curPageNo":[NSString stringWithFormat:@"%ld",self.currentPage],
                 @"orderStatusStr":@"",
                 @"dateStatus":@"6",
                 @"orderType":@"1,2,3",
                 @"rows":@"10",
                 @"shopId":shopId,
                 @"resNo":resNoStr
                 };

    NSString *paramsStr = [NSObject jsonStringWithDictionary:dict];
    
    NSDictionary *paramsDic=@{@"key":globalData.loginModel.token,@"params":paramsStr};

    
    [Network GET:GY_FOODOMAINAPP(GYHEFoodQueryOrder) parameter:paramsDic success:^(id returnValue) {
        
    [GYGIFHUD dismiss];
        
//    DDLogCInfo(@"returnValue11111=%@",returnValue);
        
    NSDictionary*dict=returnValue;
        
        if ([dict[@"retCode"] integerValue]==200 ) {
            
            if ([dict[@"data"] isKindOfClass:[NSNull class]]) {
                
                
                [self.customerOrderListView.tableView.mj_header endRefreshing];
                [self.customerOrderListView.tableView.mj_footer endRefreshing];
                return ;
              
            }else{
            
                NSArray*arr=dict[@"data"];
                
                for (NSDictionary*dic in arr) {
                    
                    GYHDCustomerOrderListModel*model=[[GYHDCustomerOrderListModel alloc]init];
                    
                    [model initModelWithDict:dic];
                    
                    [self.customerOrderListView.dataSource addObject:model];
                    [self.customerOrderListView.tableView reloadData];
                    
                }

            }
            
        }else{
        
            UIAlertView*alterView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取客户订单列表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alterView show];
        
        }
        [self.customerOrderListView.tableView.mj_header endRefreshing];
        [self.customerOrderListView.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
    DDLogCInfo(@"error111==%@",error);
        
        
        UIAlertView*alterView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取客户订单列表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alterView show];
        
    [GYGIFHUD dismiss];
    [self.customerOrderListView.tableView.mj_header endRefreshing];
    [self.customerOrderListView.tableView.mj_footer endRefreshing];
        
    }];
    
}
#pragma mark - 根据custid查询信息
-(void)loadCustomerDetailData{
//    点击自己头像进入
    if (self.isClickSelf) {
        
        [[GYHDNetWorkTool sharedInstance] postQueryUserInfoByCustId:globalData.loginModel.custId RequetResult:^(NSArray *resultArry) {
            [GYGIFHUD dismiss];
            NSDictionary*dic=[resultArry firstObject];
            self.personInfoDict=dic;
//            DDLogCInfo(@"dic11111==%@",dic);
            
            GYHDCustomerDetailModel*model=[[GYHDCustomerDetailModel alloc]init];
            
            model.isClickSelf=YES;
            
            [model initWithDic:dic];
            
            self.customerInfoView.model=model;
            
            [self updateFirendInfoWithDic:dic];
            
            if (![globalData.loginModel.userName isEqualToString:@"0000"]) {
                
                [self loadPersonInfoData];
            }
            
        }];

    }else{
//    点击消费者头像进入
        [[GYHDNetWorkTool sharedInstance] postQueryUserInfoByCustId:self.model.Friend_CustID RequetResult:^(NSArray *resultArry) {
            NSDictionary*dic=[resultArry firstObject];
            self.personInfoDict=dic;
            DDLogCInfo(@"dic==%@",dic);
            
            GYHDCustomerDetailModel*model=[[GYHDCustomerDetailModel alloc]init];
            
            [model initWithDic:dic];
            
            self.customerInfoView.model=model;
            
            [self updateFirendInfoWithDic:dic];
            self.resNoStr=model.resNo;
            [self loadQueryOrderDataWithResNo:model.resNo];

        }];
        
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.personInfoArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GYHDCompanyPersonInfoCell*cell=[tableView dequeueReusableCellWithIdentifier:@"GYHDCompanyPersonInfoCell"];
    cell.delegate=self;
    [cell refreshWithDict:self.personInfoArr[indexPath.row]];
    return cell;

}
-(void)getRowName:(NSString *)rowName TFtext:(NSString *)tfStr{
  
    DDLogCInfo(@"%@ %@",rowName,tfStr);
    if ([rowName isEqualToString:@"昵称"]) {
        self.nickName=tfStr;
        return;
    }
    if ([rowName isEqualToString:@"年龄"]) {
        self.age=tfStr;
        return;
    }
    if ([rowName isEqualToString:@"性别"]) {
        [self selectPopSexView];
        return;
    }
    
    if ([rowName isEqualToString:@"地区"]) {
        
        [self selectPopAddressView];
        
        return;
    }

    if ([rowName isEqualToString:@"爱好"]) {
        self.hobby=tfStr;
        return;
    }
    
    if ([rowName isEqualToString:@"签名"]) {
        self.sign=tfStr;
        return;
    }
}

-(void)selectPopSexView{
    kWEAKSELF;
    NSArray* array = [[Utils localizedStringWithKey:@"不限|男|女"] componentsSeparatedByString:@"|"];
    GYHDSearchAgeView* sexView = [[GYHDSearchAgeView alloc] init];
    sexView.chooseAgeArray = array;
    sexView.chooseTips = [Utils localizedStringWithKey:@"选择性别"];
    [sexView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(270, 276));
    }];
    
    GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:sexView];
    [popView show];
    
    sexView.block = ^(NSString* chooseString) {
        
    if ([chooseString isEqualToString:@"男"]) {
            
            weakSelf.sex= @"1";
        
        }else if([chooseString isEqualToString:@"女"]){
            
            weakSelf.sex= @"0";
        }else{
        
           weakSelf.sex=@"";
        }
        
    [popView disMiss];
    [weakSelf.personInfoArr removeAllObjects];
    [weakSelf loadSubPerInfo];
    
    };
    
}

-(void)selectPopAddressView{

    kWEAKSELF;
    GYHDAddressView* addressView = [[GYHDAddressView alloc] init];
    addressView.provinceArray=self.provinceAry;
    addressView.cityArray=self.cityArr;
    addressView.cityFullName = self.area;
    [addressView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(270, 276));
    }];
    GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:addressView];
    
        [popView  show];

    addressView.block = ^(NSString* cityNo) {

        for (GYCityAddressModel*model in weakSelf.cityArr) {
            
            if ([model.cityNo isEqualToString:cityNo]) {
                
                weakSelf.area=model.cityFullName;
                [weakSelf.personInfoArr removeAllObjects];
                [weakSelf loadSubPerInfo];
            }
        }
        [popView disMiss];
    };

    
}
#pragma mark - 同步更新数据到好友数据库
-(void)updateFirendInfoWithDic:(NSDictionary*)dic{
    
    NSMutableDictionary*tempDic=[NSMutableDictionary dictionary];
    NSString*iconUrl=[NSString stringWithFormat:@"%@",dic[@"searchUserInfo"][@"headImage"]];
    [tempDic setObject:iconUrl forKey:GYHDDataBaseCenterFriendIcon];
    [tempDic setObject:dic[@"searchUserInfo"][@"nickName"] forKey:GYHDDataBaseCenterFriendName];
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    
    [dict setObject:dic[@"searchUserInfo"][@"custId"] forKey:GYHDDataBaseCenterFriendCustID];
    
    [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:tempDic conditionDict:dict TableName:@"T_FRIENDS"];
    
    
}

#pragma mark - 保存个人信息
-(void)savePersonInfo{
  
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:globalData.loginModel.custId forKey:@"perCustId"];
    [dict setObject:self.nickName forKey:@"nickname"];
    [dict setObject:self.sex forKey:@"sex"];
    [dict setObject:self.age forKey:@"age"];
    [dict setObject:self.hobby forKey:@"hobby"];
    [dict setObject:self.area forKey:@"area"];
    [dict setObject:self.sign forKey:@"individualSign"];
    [dict setObject:self.picUrlStr forKey:@"headShot"];
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = dict;
    sendDict[@"channelType"] = @"8";
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/updateNetworkInfo",globalData.loginModel.hdbizDomain];
    
//     NSString *urlString =@"http://192.168.41.193:1098/hsim-bservice/userCenter/updateNetworkInfo";
    
    [Network POST: urlString parameter:sendDict success:^(id returnValue) {
        
         DDLogCInfo(@"returnValue=%@",returnValue);
        
        if ([returnValue[@"retCode"]integerValue] ==200) {
            
//            更新好友图片信息到数据库
            NSMutableDictionary*tempDic=[NSMutableDictionary dictionary];
            
            [tempDic setObject:self.picUrlStr forKey:GYHDDataBaseCenterFriendIcon];
            NSMutableDictionary*dic=[NSMutableDictionary dictionary];
            
            [dic setObject:globalData.loginModel.custId forKey:GYHDDataBaseCenterFriendCustID];
            
            [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:tempDic conditionDict:dic TableName:@"T_FRIENDS"];
            
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            [window makeToast:@"保存成功" duration:0.25f position:CSToastPositionCenter];
        }
        
    } failure:^(NSError *error) {
        
         DDLogCInfo(@"error=%@",error);
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        [window makeToast:@"保存失败" duration:0.25f position:CSToastPositionCenter];
    }];

}
#pragma mark - 上传头像
-(void)uploadImg{

    if (![globalData.loginModel.userName isEqualToString:@"0000"]) {
        
        UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"修改头像" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
        
        [alertView show];
        
        
    }

}
#pragma mark - 设置
-(void)loadSetView{
    
    
    self.personInfoTabelView.hidden=YES;
    self.setView.hidden=NO;
    self.customerInfoView.setView.backgroundColor=[UIColor colorWithRed:0/255.0 green:143.0/255.0 blue:215.0/255.0 alpha:0.3];

    self.saveBtn.hidden=YES;

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    

    if (buttonIndex==1) {
//        拍照
        
        [self pickImageFromCamera];
    }
    
    if (buttonIndex==2) {
        
//        从相册中选择
        [self pickImageFromAlbum];
        
    }
//    点击头像切换到个人资料页面
    self.customerInfoView.setView.backgroundColor=[UIColor clearColor];
    self.personInfoTabelView.hidden=NO;
    self.setView.hidden=YES;
    self.saveBtn.hidden=NO;
    
}


#pragma mark - 从摄像头获取照片上传
- (void)pickImageFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pickCtl = [[UIImagePickerController alloc] init];
        pickCtl.delegate = self;
        pickCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickCtl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        pickCtl.allowsEditing = YES;
        
        [self presentViewController:pickCtl animated:YES completion:nil];
    }
    else {
        [[UIApplication sharedApplication].delegate.window  makeToast:kLocalized(@"DeviceDoesNotSupportCameraFunctions") duration:1.f position:CSToastPositionBottom ];
    }
    
}

#pragma mark - 从相册选取照片上传
-(void)pickImageFromAlbum{

    GYPhotoListViewController*vc=[[GYPhotoListViewController alloc]init];
    if (self.isFromCustomer) {
        vc.isFromCustomer=YES;
    }else{
        vc.isFromCustomer=NO;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark- 接收从相册发过来的通知
-(void)uploadImgFromAlbum:(NSNotification*)noti{
    UIImage*image=noti.object;
    self.customerInfoView.iconsImageView.image=image;
    NSString* URLString = [NSString stringWithFormat:@"%@?isPub=%@&token=%@&custId=%@", @"fileController/fileUpload", @"1", globalData.loginModel.token, globalData.loginModel.custId];
    
    GYNetRequest* request = [[GYNetRequest alloc] initWithUploadDelegate:self baseURL:[GYLoginEn sharedInstance].getLoginUrl URLString:URLString parameters:nil constructingBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if ((float)data.length > 1024 * 100) {
            data = UIImageJPEGRepresentation(image, 1024*100.0/(float)data.length);
        }
        
        [formData appendPartWithFileData:data name:@"1" fileName:@"1.jpeg" mimeType:@"image/jpeg"];
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request setValue:@"8" forHTTPHeaderField:@"channelType"];
    request.tag = 3;
    [request start];
    
}
#pragma mark - UIImagePickerControllerDelegate的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 获取图片名称
    NSURL * Url =[info objectForKey:UIImagePickerControllerReferenceURL];
    NSString * strUrl = [Url absoluteString];
    
    // 得到文件名称
    NSRange one = [strUrl rangeOfString:@"="];
    NSRange two = [strUrl rangeOfString:@"&"];
    NSString * name = [strUrl substringWithRange:NSMakeRange(one.location+1, two.location - one.location-1)];
    NSString * strType = [strUrl substringFromIndex:strUrl.length - 3];
    DDLogCInfo(@"%@,%@,%@",strType,strUrl,name);
    NSString * imageName = [NSString stringWithFormat:@"%@.%@",name,strType];
    //换成二进制数据
    NSData *imageData = UIImageJPEGRepresentation(image1, 0.75);
    // 获取沙盒目录
    NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    // 检查文件大小 不能大于1M
    NSFileManager * fm = [NSFileManager defaultManager];
    long long fSize = 0;
    if ([fm fileExistsAtPath:fullPath]) {
        fSize = [[fm attributesOfItemAtPath:fullPath error:nil] fileSize];
    }
    if (fSize >  1024 * 1024) {
        [self notifyWithText:kLocalized(@"UploadImageCanNotBeGreaterThan 1M,UploadFailed,PleaseRe-selectPicture")];
        
        
        [fm removeItemAtPath:fullPath error:nil];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIImage *image = info[@"UIImagePickerControllerEditedImage"];
        self.customerInfoView.iconsImageView.image=image;
        
        [self saveImage:image1 withName:imageName];
    }
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        [params setValue:@"1" forKey:@"isPub"];
        [params setValue:globalData.loginModel.custId forKey:@"custId"];
        [params setValue:globalData.loginModel.token forKey:@"token"];
        NSString* URLString = [NSString stringWithFormat:@"%@?isPub=%@&token=%@&custId=%@", @"fileController/fileUpload", @"1", globalData.loginModel.token, globalData.loginModel.custId];
        
        GYNetRequest* request = [[GYNetRequest alloc] initWithUploadDelegate:self baseURL:[GYLoginEn sharedInstance].getLoginUrl URLString:URLString parameters:nil constructingBlock:^(id<AFMultipartFormData> formData) {
            NSData *data = UIImageJPEGRepresentation(image1, 1.0);
            if ((float)data.length > 1024 * 100) {
                data = UIImageJPEGRepresentation(image1, 1024*100.0/(float)data.length);
            }
            
            [formData appendPartWithFileData:data name:@"1" fileName:@"1.jpeg" mimeType:@"image/jpeg"];
        }];
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [request setValue:@"8" forHTTPHeaderField:@"channelType"];
        request.tag = 3;
        [request start];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
/**
 *  点击取消销毁控制器
 *
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GYNetRequestDelegate

- (void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject {
    DDLogCInfo(@"打印结果 ======= %@",responseObject);
    if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
        kNotice(kLocalized(@"UploadSuccessful"));
        NSString *url = responseObject[@"data"];
        _picUrlStr = url;
    }else{
        kNotice(kLocalized(@"UploadFailed"));
    }
    
}

- (void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    
    kNotice(kLocalized(@"UploadFailed"));
}

//保存图片至沙盒
#pragma mark - save
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}
#pragma mark - 返回个人资料界面
-(void)backPersonInfo{
    
    self.customerInfoView.setView.backgroundColor=[UIColor clearColor];
    if ([globalData.loginModel.userName isEqualToString:@"0000"]) {
        
    }else{
        
     self.personInfoTabelView.hidden=NO;
        
    }
    self.setView.hidden=YES;
    self.saveBtn.hidden=NO;
}


- (void)GYHDNavViewGoBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"upLoadImg" object:nil];
    
}
@end
