//
//  GYQueryView.m
//  GYRestaurant
//
//  Created by apple on 15/10/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYQueryView.h"
#import "GYSubmitOrderModel.h"
#import "GYSelectedButton.h"
#import "GYQueryOrderModel.h"
#import "GYQueryViewController.h"
#import "GYSelectedButton.h"
#import "GYQueryViewModel.h"
#import "GYTakeOrderListModel.h"
#import "GYUserInfoModel.h"
#import "GYQueryViewController.h"


#define btnHeight 60.0f
#define navItemHight 64.0f
#define lineViewHeight 1.0f
#define itemHigh 20.0f
#define itemheight 44.0f

@interface GYQueryView ()<GYSelectedButtonDelegate>

@property (nonatomic, strong)UIView *navBarView;
@property (nonatomic, strong)UIButton *orderBtn;
@property (nonatomic, strong)UIButton *listBtn;
@property (nonatomic, strong)UIButton *userBtn;
@property (nonatomic, strong)NSMutableArray *btnArr;
@property (nonatomic, strong)UITableView *dataTabView;
@property(nonatomic, strong)GYSelectedButton *dataBtn;
@property(nonatomic, strong)UIScrollView *svBack;
@property(nonatomic, strong)GYSubmitOrderModel *model;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, strong)NSMutableArray *searchArr;
@property (nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong)UITextField *queryTF;
@property (nonatomic, weak) GYSelectedButton *classBtn;
@property (nonatomic, weak) UIButton *foodCateQueryBtn;
@property (nonatomic, weak) UITextField *foodSearchField;
@property (nonatomic, copy) NSString *classStr;
@property (nonatomic, weak) UIButton *userQueryBtn;
@property (nonatomic, weak) UIButton *orderQueryBtn;
@property (nonatomic, weak) NSString *userActorStr;
@property (nonatomic, weak) NSString *userNameStr;
@property (nonatomic, weak) GYSelectedButton *userActorBtn;
@property (nonatomic, weak) GYSelectedButton *userNameBtn;
@property (nonatomic, weak) UITextField *numberSearchField;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *inBtn;
@property (nonatomic, strong) UIButton *outBtn;
@property(nonatomic,strong)UITextField *nameTF;

@end

@implementation GYQueryView

//代码控制视图，会自动调用这个方法
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self =[super initWithFrame:frame]) {
        // 初始化代码
        
        [self creatView];
    }
    
    return self;
    
}

//初始化视图
-(void)creatView{
    
    _dataBtn=[[GYSelectedButton alloc] init];
    _dataBtn.delegate=self;
    
    [_dataBtn dataSourceArr:[NSMutableArray arrayWithObjects:kLocalized(@"Today"),kLocalized(@"WithinThreeDays"),kLocalized(@"WithinAweek"),kLocalized(@"WithinAMonth"),kLocalized(@"WithinAYear"),kLocalized(@"All"), nil]];
    
    
    _navBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, navItemHight)];
    [self addSubview:_navBarView];
    
    
    
    _meunuTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.width*0.15, CGRectGetMaxY(self.navBarView.frame)+2, self.width, kScreenHeight-navItemHight-2) style:UITableViewStylePlain];
    _meunuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _meunuTableView .layer.borderWidth = 0.5;
    _meunuTableView .layer.borderColor = [UIColor lightGrayColor].CGColor;
    _meunuTableView.backgroundColor=[UIColor clearColor];
    [_meunuTableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self addSubview:_meunuTableView ];
    //隐藏多余的分割线
    [self setExtraCellLineHidden:_meunuTableView ];
    
    [self setUpMenuBtn];
    
}


/**
 *  设置tableView的分割线
 *
 *  @param tableView
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view = [UIView new];
    view.frame=CGRectMake(0, navItemHight, kScreenWidth, lineViewHeight);
    
    view.backgroundColor = [UIColor lightGrayColor];
    
    [tableView setTableFooterView:view];
}

#pragma mark -  创建目录按钮

//设置菜单按钮
-(void)setUpMenuBtn{
    
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, navItemHight+2, kScreenWidth*0.15, kScreenHeight-navItemHight-2)];
    backView.backgroundColor=[UIColor colorWithRed:209/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    [self addSubview:backView];
    [self sendSubviewToBack:backView];
    
    
    //设置订单按钮
    _orderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _orderBtn.frame = CGRectMake(0, navItemHight+2, kScreenWidth*0.15 , btnHeight);
    _orderBtn.backgroundColor=[UIColor colorWithRed:246/255.0 green:207/255.0 blue:147/255.0 alpha:1.0];
    _orderBtn.tag = 10;
    _orderBtn.tintColor=kRedFontColor;
    _orderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    [_orderBtn setTitle:kLocalized(@"Order") forState:UIControlStateNormal];
    [_orderBtn addTarget:self action:@selector(sender:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView1=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.orderBtn.frame), kScreenWidth*0.15, lineViewHeight)];
    lineView1.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:lineView1];
    [self addSubview:self.orderBtn];
    
    //设置菜品按钮
    _listBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _listBtn.frame = CGRectMake(0, CGRectGetMaxY(lineView1.frame), kScreenWidth*0.15 , btnHeight);
    _listBtn.tag = 11;
    _listBtn.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    [_listBtn setTitle:kLocalized(@"Dishes") forState:UIControlStateNormal];
    
    _listBtn.tintColor = [UIColor blackColor];
    [_listBtn addTarget:self action:@selector(sender:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.listBtn];
    UIView *lineView2=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.listBtn.frame), kScreenWidth*0.15, lineViewHeight)];
    lineView2.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:lineView2];
    
    
    //设置用户按钮
    _userBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _userBtn.frame = CGRectMake(0, CGRectGetMaxY(lineView2.frame), kScreenWidth*0.15 , btnHeight);
    _userBtn.tag = 102;
    _userBtn.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    [_userBtn setTitle:kLocalized(@"User") forState:UIControlStateNormal];
    _userBtn.tintColor = [UIColor blackColor];
    [_userBtn addTarget:self action:@selector(sender:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.userBtn];
    
    UIView *lineView3=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_userBtn.frame), kScreenWidth*0.15, lineViewHeight)];
    lineView3.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:lineView3];
    
    if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter ||globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff) {
        _userBtn.hidden = YES;
        lineView3.hidden = YES;
    }else{
        _userBtn.hidden = NO;
        lineView3.hidden = NO;
    }
    
}

#pragma mark - 按钮的点击事件

//点击事件
-(void)sender:(UIButton *)sender{
    
    _orderBtn.tintColor = [UIColor blackColor];
    [_orderBtn setBackgroundColor:[UIColor colorWithRed:209/255.0 green:214/255.0 blue:214/255.0 alpha:1.0]];
    _listBtn.tintColor = [UIColor blackColor];
    [_listBtn setBackgroundColor:[UIColor colorWithRed:209/255.0 green:214/255.0 blue:214/255.0 alpha:1.0]];
    
    _userBtn.tintColor = [UIColor blackColor];
    [_userBtn setBackgroundColor:[UIColor colorWithRed:209/255.0 green:214/255.0 blue:214/255.0 alpha:1.0]];
    
    
    sender.backgroundColor = [UIColor colorWithRed:246/255.0 green:207/255.0 blue:147/255.0 alpha:1.0];
    sender.tintColor = kRedFontColor;
    
    self.sendBlock(sender);
    
    
    
}

#pragma mark ------  创建不同的导航栏

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    _btnArr=[[NSMutableArray alloc]initWithCapacity:50];
    
    if (selectedIndex == 1) { 
        [_navBarView removeFromSuperview];
        _navBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, navItemHight)];
        [self addSubview:_navBarView];
        
        
        UIButton *gybtn = [UIButton buttonWithType:UIButtonTypeCustom];
        gybtn.frame = CGRectMake(20, itemHigh, 150, itemheight);
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"40back"]];
        imageView.frame = CGRectMake(0, 12, 10, 20);
        [gybtn addSubview:imageView];
        [gybtn setTitle:kLocalized(@"Inquire") forState:UIControlStateNormal];
        [gybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [gybtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        gybtn.titleLabel.font = [UIFont systemFontOfSize:kBackFont];
        gybtn.titleEdgeInsets = UIEdgeInsetsMake(10, 25, 10, 10);
        gybtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        gybtn.tag = 1000;
        
       
        [_btnArr addObject:gybtn];
        
        _allBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _allBtn.frame=CGRectMake(CGRectGetMaxX(gybtn.frame) + 20, itemHigh, 20, itemheight);
        [_allBtn setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
        [_allBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [_allBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _allBtn.tag=1002;
        [_btnArr addObject: _allBtn];
        
        _allBtn.selected=YES;
        
        UILabel *allLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_allBtn.frame), itemHigh, 40, itemheight)];
        allLable.text=kLocalized(@"All");
        
        [_btnArr addObject: allLable];
        
        
       
        _inBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _inBtn.frame=CGRectMake(CGRectGetMaxX(allLable.frame), itemHigh, 20, itemheight);
        [_inBtn setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
        [_inBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [_inBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _inBtn.tag=1003;
        [_btnArr addObject:_inBtn];
        
        UILabel *inLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_inBtn.frame), itemHigh, 40, itemheight)];
        inLable.text=kLocalized(@"Store");
        
        [_btnArr addObject:inLable];
        
        _outBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _outBtn.frame=CGRectMake(CGRectGetMaxX(inLable.frame), itemHigh, 20, itemheight);
        [_outBtn setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
        [_outBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [_outBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _outBtn.tag=1004;
        [_btnArr addObject:_outBtn];
        UILabel *outLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_outBtn.frame), itemHigh, 40, itemheight)];
        outLable.text=kLocalized(@"Takeout");
        
        [_btnArr addObject:outLable];
        
        
        
        UILabel *datelable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(outLable.frame)+20, itemHigh, 40, itemheight)];
        datelable.text=kLocalized(@"Date");
        [_btnArr addObject:datelable];
        
        
        _dataBtn.frame=CGRectMake(CGRectGetMaxX(datelable.frame), itemHigh, 178, itemheight);
        [_dataBtn setTitle:kLocalized(@"Today") forState:UIControlStateNormal];
        _dateStr = @"1";
        [_btnArr addObject:_dataBtn];
        
        _queryTF=[[UITextField alloc] init];
        _queryTF.frame=CGRectMake(CGRectGetMaxX(_dataBtn.frame)+32, itemHigh, 240, itemheight-2);
        _queryTF.keyboardType = UIKeyboardTypeNumberPad;
        [_queryTF setBackground:[UIImage imageNamed:@"blueBox"]];
        
        _queryTF.placeholder = kLocalized(@"PleaseEnterTheOrderNumber/AlternateNumber/MobilePhoneNumber");
        [_btnArr addObject:_queryTF];
        
        
        UIButton *orderQueryBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        orderQueryBtn.frame=CGRectMake(kScreenWidth - 80, itemHigh, 75, itemheight-1);
        [orderQueryBtn setBackgroundImage:[UIImage imageNamed:@"query-1"] forState:UIControlStateNormal];
        [orderQueryBtn setBackgroundImage:[UIImage imageNamed:@"query+"] forState:UIControlStateSelected];
        orderQueryBtn.tag=500;
        [orderQueryBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.orderQueryBtn = orderQueryBtn;
        [_btnArr addObject:orderQueryBtn];
        
        for (int i=0; i<11; i++) {
            [_navBarView addSubview:_btnArr[i]];
        }
        
    }else if (selectedIndex == 2){
        
        [_navBarView removeFromSuperview];
        _navBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, navItemHight)];
        [self addSubview:_navBarView];
        
 
        
        UIButton *gybtn = [UIButton buttonWithType:UIButtonTypeCustom];
        gybtn.frame = CGRectMake(20, itemHigh, 150, itemheight);
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"40back"]];
        imageView.frame = CGRectMake(0, 12, 10, 20);
        [gybtn addSubview:imageView];
        [gybtn setTitle:kLocalized(@"Inquire") forState:UIControlStateNormal];
        [gybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [gybtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        gybtn.titleLabel.font = [UIFont systemFontOfSize:kBackFont];
        gybtn.titleEdgeInsets = UIEdgeInsetsMake(10, 25, 10, 10);
        gybtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        gybtn.tag = 1001;
        
        
        [_btnArr addObject:gybtn];
        
        
        
        UILabel *classLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(gybtn.frame) + 20, itemHigh, 80, itemheight)];
        classLable.text=kLocalizedAddParams(kLocalized(@"DishesCategory"), @":");
        [_btnArr addObject:classLable];
        
        GYSelectedButton *classBtn=[[GYSelectedButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(classLable.frame), itemHigh, 178, itemheight-2)];
        [classBtn setTitle:kLocalized(@"All") forState:UIControlStateNormal];
        self.classStr = kLocalized(@"All");
        
        [classBtn setBackgroundImage:[UIImage imageNamed:@"BropBox"] forState:UIControlStateNormal];
        classBtn.hiddenBackGround = YES;
        [_btnArr addObject:classBtn];
        self.classBtn = classBtn;
        self.classBtn.delegate = self;
        GYQueryViewModel *viewModel = [[GYQueryViewModel alloc]init];
        NSMutableArray *array = [NSMutableArray array];
        NSArray *arr = (NSArray *) [viewModel  readFromPath:@"getFoodCategoryList" ];
        for (GYTakeOrderListModel *model1 in arr) {
            [array addObject:model1.itemCustomCategoryName];
            
        }
        self.classBtn.dataSource = array;

        UILabel *nameLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(classBtn.frame)+112, itemHigh, 80, itemheight)];
        nameLable.text=kLocalizedAddParams(kLocalized(@"DishesName"), @":");
        [_btnArr addObject:nameLable];
        
        UITextField *nameTF=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLable.frame), itemHigh, 178, itemheight-2)];
        [nameTF setBackground:[UIImage imageNamed:@"blueBox"]];
        nameTF.keyboardType = UIKeyboardTypeDefault;
        nameTF.placeholder = kLocalized(@"PleaseEnterADishName");
        [_btnArr addObject:nameTF];
        self.foodSearchField = nameTF;
        
        
        UIButton *queryBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        queryBtn.frame=CGRectMake(kScreenWidth - 80, itemHigh, 75, itemheight);
        [queryBtn setBackgroundImage:[UIImage imageNamed:@"query-1"] forState:UIControlStateNormal];
        [queryBtn setBackgroundImage:[UIImage imageNamed:@"query+"] forState:UIControlStateSelected];
        [queryBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArr addObject:queryBtn];
        self.foodCateQueryBtn = queryBtn;
        self.foodCateQueryBtn.tag = 600;
        
        
        for (int j=0; j<6; j++) {
            [_navBarView addSubview:_btnArr[j]];
        }
        
    }else if (selectedIndex == 3){
        [_navBarView removeFromSuperview];
        _navBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, navItemHight)];
        [self addSubview:_navBarView];
        
        UIButton *gybtn = [UIButton buttonWithType:UIButtonTypeCustom];
        gybtn.frame = CGRectMake(20, itemHigh, 150, itemheight);
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"40back"]];
        imageView.frame = CGRectMake(0, 12, 10, 20);
        [gybtn addSubview:imageView];
        [gybtn setTitle:kLocalized(@"Inquire") forState:UIControlStateNormal];
        [gybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [gybtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        gybtn.titleLabel.font = [UIFont systemFontOfSize:kBackFont];
        gybtn.titleEdgeInsets = UIEdgeInsetsMake(10, 25, 10, 10);
        gybtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        gybtn.tag = 1001;
        [_btnArr addObject:gybtn];
     
        
        
        UILabel *actLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(gybtn.frame) + 20, itemHigh, 40, itemheight)];
        actLable.text=kLocalizedAddParams(kLocalized(@"Character"), @":");
        [_btnArr addObject:actLable];
        
        
        GYSelectedButton *actbtn=[[GYSelectedButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(actLable.frame), itemHigh, 178, itemheight-2)];
        [actbtn setTitle:kLocalized(@"All") forState:UIControlStateNormal];
        [actbtn setBackgroundImage:[UIImage imageNamed:@"BropBox"] forState:UIControlStateNormal ];
        //  actbtn.hiddenBackGround = YES;
        self.userActorBtn = actbtn;
        
        self.userActorStr = @"";
        
        [self.userActorBtn dataSourceArr:[NSMutableArray arrayWithObjects:kLocalized(@"SystemAdministrator"),kLocalized(@"BusinessPointAdministrator"),kLocalized(@"Cashier"),kLocalized(@"Waiter"),kLocalized(@"DeliveryStaff"),kLocalized(@"All"),nil]];
        //   [self.userActorBtn dataSourceArr:self.actorArr];
        self.userActorBtn.delegate = self;
        [_btnArr addObject:self.userActorBtn];
        
        
        UILabel *nameLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(actbtn.frame)+12, itemHigh, 40, itemheight)];
        nameLable.text=kLocalizedAddParams(kLocalized(@"Name"), @":");
        [_btnArr addObject:nameLable];

        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLable.frame), itemHigh, 178, itemheight-2)];
        [_nameTF setBackground:[UIImage imageNamed:@"blueBox"]];
        [_btnArr addObject:_nameTF];
        
        UILabel *numLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameTF.frame)+12, itemHigh, 80, itemheight)];
        numLable.text=kLocalizedAddParams(kLocalized(@"PhoneNumber"), @":");
        [_btnArr addObject:numLable];
        
        UITextField *numTF=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numLable.frame), itemHigh, 178, itemheight)];
        [numTF setBackground:[UIImage imageNamed:@"blueBox"]];
        numTF.keyboardType = UIKeyboardTypeNumberPad;
        numTF.placeholder=kLocalized(@"EnterThePhoneNumber");
        [_btnArr addObject:numTF];
        self.numberSearchField = numTF;
        
        UIButton *userQueryBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        userQueryBtn.frame=CGRectMake(kScreenWidth - 80, itemHigh, 75, itemheight);
        userQueryBtn.tag = 700;
        [userQueryBtn setBackgroundImage:[UIImage imageNamed:@"query-1"] forState:UIControlStateNormal];
        [userQueryBtn setBackgroundImage:[UIImage imageNamed:@"query+"] forState:UIControlStateSelected];
        [userQueryBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArr addObject:userQueryBtn];
        self.userQueryBtn = userQueryBtn;
        for (int j=0; j<8; j++) {
            [_navBarView addSubview:_btnArr[j]];
        }
        
    }
    
}

#pragma mark-------创建btn
/**
 *	@param 	title           标题
 *	@param 	titleColor      标题颜色
 *	@param 	backgroundColor btn背景颜色
 *	@param 	fontSize        标题字体大小
 */
- (UIButton *)createdButtonTitle:(NSString *)title
                      titleColor:(UIColor *)titleColor
                 backgroundColor:(UIColor *)backgroundColor
                        fontSize:(CGFloat)fontSize

{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [button addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)select {
    
}

#pragma mark - －－－－－创建一个View
/**
 *	@param 	x           x点坐标
 *	@param 	y           y点坐标
 *	@param 	width       view宽度
 *	@param 	height      view的高度
 */

- (UIView *)createdViewWithX:(int)x
                           y:(int)y
                       width:(int)width
                      height:(int)height
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(x, y, width, height);
    [_svBack addSubview:view];
    return view;
}

- (void)setModel:(GYSubmitOrderModel *)model
{
    if (_model != model) {
        _model = model;
    }
}

- (void)btnAction:(UIButton *)btn{
    
    if (btn.tag == 1002){
        _inBtn.selected = NO;
        _outBtn.selected = NO;
        _allBtn.selected = YES;
    }else if (btn.tag == 1003){
        _allBtn.selected = NO;
        _outBtn.selected = NO;
        _inBtn.selected = YES;
       
    }else if (btn.tag == 1004){
        _inBtn.selected = NO;
        _allBtn.selected = NO;
        _outBtn.selected = YES;
       
    }

    
    self.selectBlock(btn);
   
    if (btn == self.orderQueryBtn){
        
        NSString *orderTypeStr;
        
        if (_allBtn.selected == YES){
           
            orderTypeStr = @"1,2,3";
        }else if (_inBtn.selected == YES){
           
            orderTypeStr = @"1,3";
        }else if (_outBtn.selected == YES){
           
            orderTypeStr = @"2";
        }

        NSString *queryStr  = [_queryTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
       
        if (orderTypeStr.length > 0 && queryStr.length > 0 && self.dateStr.length > 0){
            _searchBlock(orderTypeStr,queryStr,self.dateStr);
        }else if(self.dateStr.length > 0 && orderTypeStr.length == 0 && queryStr.length == 0){
            _searchBlock(@"",@"",self.dateStr);
        }else if(queryStr.length > 0 && orderTypeStr.length == 0 && self.dateStr.length == 0){
            _searchBlock(@"",queryStr,@"");
        }else if (orderTypeStr.length > 0 && self.dateStr.length == 0 ){
            _searchBlock(orderTypeStr,@"",@"");
        }else if (orderTypeStr.length > 0 && queryStr.length > 0 ){
            _searchBlock(orderTypeStr,queryStr,@"");
        }else if (orderTypeStr.length > 0 && _dateStr.length > 0 ){
            _searchBlock(orderTypeStr,@"",self.dateStr);
        }
    }else  if (btn == self.foodCateQueryBtn){
       NSString *foodSerchStr   = [_foodSearchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if (foodSerchStr.length > 0 && self.classStr.length > 0){
            self.foodsearchBlock(foodSerchStr,self.classStr);
        }else if(foodSerchStr.length == 0 && self.classStr.length > 0){
            
            self.foodsearchBlock(@"",self.classStr);
        }else if (foodSerchStr.length > 0 && self.classStr.length == 0){
            self.foodsearchBlock(foodSerchStr,@"");
        }
    }else if (btn == _userQueryBtn){
        NSString *numberSearchStr = [_numberSearchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *nameStr = [_nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (numberSearchStr.length > 0 && self.userActorStr.length > 0 && nameStr.length > 0) {
            self.userSearchBlock(self.userActorStr,nameStr,numberSearchStr);
        }else if(self.userActorStr.length > 0 && nameStr.length > 0){
            self.userSearchBlock(self.userActorStr,nameStr,@"");
            
        }else if(self.userActorStr.length > 0 && numberSearchStr.length > 0){
            self.userSearchBlock(self.userActorStr,@"",numberSearchStr);
            
        }else if (self.userActorStr.length == 0 && nameStr.length > 0 && numberSearchStr.length > 0){
            self.userSearchBlock(@"",nameStr,numberSearchStr);
        }
        else if(numberSearchStr.length > 0){
            self.userSearchBlock(self.userActorStr,@"",numberSearchStr);
            
        }else if(self.userActorStr.length > 0 ){
            self.userSearchBlock(self.userActorStr,@"",@"");
            
        }else if(nameStr.length > 0){
            self.userSearchBlock(self.userActorStr,nameStr,@"");
        
        }else if (self.userActorStr.length == 0 && self.nameTF.text.length == 0 && numberSearchStr.length == 0){
            self.userSearchBlock(@"",@"",@"");
        
        }

    }
}


#pragma mark-------创建lab
- (UILabel *)createdLableWithText:(NSString *)text
                        textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:20.0];
    return label;
}

#pragma mark-------创建btn
/**
 *	@param 	title           标题
 *	@param 	titleColor      标题颜色
 *	@param 	backgroundColor btn背景颜色
 *	@param 	fontSize        标题字体大小
 */

-(UIButton *)createdButtonWhthTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                    backgroundColor:(UIColor *)backgroundColor
                           fontSize:(CGFloat)fontSize{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [button addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - －－－－－创建一个View
/**
 *	@param 	x           x点坐标
 *	@param 	y           y点坐标
 *	@param 	width       view宽度
 *	@param 	height      view的高度
 */

- (UIView *)createdViewX:(int)x
                       y:(int)y
                   width:(int)width
                  height:(int)height
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(x, y, width, height);
    [_svBack addSubview:view];
    return view;
}

#pragma mark -GYSelectedButtonDelegate
- (void)GYSelectedButtonDidClick:(GYSelectedButton *)btn withContent:(NSString *)content
{
        
    if (btn == self.classBtn) {
        self.classStr = content;

    }else if(btn == self.userActorBtn){
        
        self.userActorStr = content;
        if ([globalData.loginModel.entResType isEqualToString:@"3"]) {
            if ([self.userActorStr isEqualToString:kLocalized(@"SystemAdministrator")]) {
                
                self.userActorStr = @"301";
                
            }else if ([self.userActorStr isEqualToString:kLocalized(@"BusinessPointAdministrator")]){
                self.userActorStr = @"302";
                
            }else if ([self.userActorStr isEqualToString:kLocalized(@"Cashier")]){
                self.userActorStr = @"303";
            }else if ([self.userActorStr isEqualToString:kLocalized(@"Waiter")]){
                
                self.userActorStr = @"304";
                
            }else if ([self.userActorStr isEqualToString:kLocalized(@"DeliveryStaff")]){
                
                self.userActorStr = @"305";
                
            }else if ([self.userActorStr isEqualToString:@"全部"]){
                self.userActorStr = @"";
            }

        }else if ([globalData.loginModel.entResType isEqualToString:@"2"]){
            if ([self.userActorStr isEqualToString:kLocalized(@"SystemAdministrator")]) {
                
                self.userActorStr = @"201";
                
            }else if ([self.userActorStr isEqualToString:kLocalized(@"BusinessPointAdministrator")]){
                self.userActorStr = @"202";
                
            }else if ([self.userActorStr isEqualToString:kLocalized(@"Cashier")]){
                self.userActorStr = @"203";
            }else if ([self.userActorStr isEqualToString:kLocalized(@"Waiter")]){
                
                self.userActorStr = @"204";
                
            }else if ([self.userActorStr isEqualToString:kLocalized(@"DeliveryStaff")]){
                
                self.userActorStr = @"205";
                
            }else if ([self.userActorStr isEqualToString:kLocalized(@"All")]){
                self.userActorStr = @"";
            }

        
        }
        
        
    }else if (btn == self.dataBtn){
        
        self.dateStr = content;
        if ([self.dateStr isEqualToString:kLocalized(@"Today")]){
            self.dateStr = @"1";
        }else if ([self.dateStr isEqualToString:kLocalized(@"WithinThreeDays")]){
            self.dateStr = @"2";
        }else if ([self.dateStr isEqualToString:kLocalized(@"WithinAweek")]){
            self.dateStr = @"3";
        }else if ([self.dateStr isEqualToString:kLocalized(@"WithinAMonth")]){
            self.dateStr = @"4";
        }else if ([self.dateStr isEqualToString:kLocalized(@"WithinAYear")]){
            self.dateStr = @"5";
        }else if ([self.dateStr isEqualToString:kLocalized(@"All")]){
            self.dateStr = @"6";
        }
    }
}


@end
