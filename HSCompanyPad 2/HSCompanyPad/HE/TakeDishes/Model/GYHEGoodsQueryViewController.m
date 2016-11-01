//
//  GYHEGoodsQueryViewController.m
//
//  Created by apple on 16/8/8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHEGoodsQueryViewController.h"
#import "GYSettingSafeSetPiecewiseView.h"
#import "GYHERetailGoodsListVC.h"
#import "GYHEFoodDishesVC.h"
#import "UILabel+Category.h"
#import "GYSelectedButton.h"

@interface GYHEGoodsQueryViewController ()<PiecewiseViewDelegate,UITextFieldDelegate, GYSelectedButtonDelegate>

@property (nonatomic, strong) NSMutableArray* controllerArray;
@property (nonatomic, weak) GYBaseViewController *curruentVC;
@property (nonatomic, strong) UITextField *goodsNameTextField;
@property (nonatomic, strong) UITextField *goodsNumTextField;
@property (nonatomic, strong) GYSelectedButton *selectClassButton;
@property (nonatomic, strong) GYSelectedButton *selectShopNameButton;
@property (nonatomic, strong) GYSelectedButton *selectStaButton;


@end

@implementation GYHEGoodsQueryViewController

#pragma mark - lazy load
-(NSMutableArray *)controllerArray{
    if (!_controllerArray) {
        _controllerArray = [[NSMutableArray alloc] init];
    }
    return _controllerArray;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
// #pragma mark - event response

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    for (GYBaseViewController *vc in self.controllerArray) {
        vc.view.frame = CGRectMake(0, 44 + kDeviceProportion(62) + kDeviceProportion(50) + kDeviceProportion(50), kScreenWidth, self.view.frame.size.height - 44 - kDeviceProportion(62) - kDeviceProportion(50) - kDeviceProportion(50));
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.customBorderColor = kGrayE3E3EA;
    lineView.customBorderType = UIViewCustomBorderTypeRight;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(144);
        make.left.equalTo(_selectClassButton.mas_left).offset(120 + 10);
        make.width.equalTo(@(kDeviceProportion(1)));
        make.height.equalTo(@(kDeviceProportion(50)));
    }];
}

#pragma mark - PiecewiseViewDelegate
/**
 *  按钮点击事件
 */
- (void)piecewiseView:(GYSettingSafeSetPiecewiseView*)piecewiseView index:(NSInteger)index
{
    GYBaseViewController *vc = self.controllerArray[index];
    if (vc != self.curruentVC) {
        [self transitionFromViewController:self.curruentVC toViewController:vc duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
            if (finished) {
                self.curruentVC = vc;
            }
        }];
    }
}


#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"商品管理");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self initViewWithGoodsQuery];
    [self initHeaderView];
}

- (void)initViewWithGoodsQuery{
    UIImageView* topBackgroundView = [[UIImageView alloc] init];
    topBackgroundView.image = [UIImage imageNamed:@"gycom_nav_background"];
    topBackgroundView.userInteractionEnabled = YES;
    [self.view addSubview:topBackgroundView];
    [topBackgroundView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(44);
        make.height.equalTo(@(kDeviceProportion(50)));
    }];
    
    GYSettingSafeSetPiecewiseView* segControlView = [[GYSettingSafeSetPiecewiseView alloc] initWithFrame:CGRectMake(kDeviceProportion(377), kDeviceProportion(12), kDeviceProportion(270), kDeviceProportion(38))];
    segControlView.type = PiecewiseInterfaceTypeBackgroundChange;
    segControlView.delegate = self;
    segControlView.textFont = kFont24;
    segControlView.backgroundSeletedColor = kBlue0D6AEA;
    segControlView.backgroundNormalColor = kWhiteFFFFFF;
    segControlView.textNormalColor = kGray535362;
    segControlView.textSeletedColor = kWhiteFFFFFF;
    [segControlView loadTitleArray:@[ @"零售商品列表", @"餐饮菜品列表" ]];
    [topBackgroundView addSubview:segControlView];
    
    UIImageView* navBottomGroundView = [[UIImageView alloc] init];
    navBottomGroundView.image = [UIImage imageNamed:@"gycom_nav_bottom"];
    [self.view addSubview:navBottomGroundView];
    [navBottomGroundView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(topBackgroundView.mas_bottom);
        make.height.equalTo(@(kDeviceProportion(12)));
    }];
    
    GYHERetailGoodsListVC* retailGoodsListVC = [[GYHERetailGoodsListVC alloc] init];
    [self addChildViewController:retailGoodsListVC];
    
    GYHEFoodDishesVC* foodDishesVC = [[GYHEFoodDishesVC alloc] init];
    [self addChildViewController:foodDishesVC];
    
    
    [self.controllerArray addObject: retailGoodsListVC];
    [self.controllerArray addObject: foodDishesVC];
   
    self.curruentVC = retailGoodsListVC;
    [self.view addSubview:self.curruentVC.view];
    
    UIImageView* midBackgroundView = [[UIImageView alloc] init];
    midBackgroundView.image = [UIImage imageNamed:@"gycom_nav_background"];
    midBackgroundView.userInteractionEnabled = YES;
    [self.view addSubview:midBackgroundView];
    [midBackgroundView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(94);
        make.height.equalTo(@(kDeviceProportion(50)));
    }];
    float goodsNameTitleLableW = 80;
    float goodsNameTextFieldW = 150;
    float goodsNumTitleLableW = 80;
    float goodsNumTextFieldW = 150;
    
    UILabel *goodsNameTitleLable = [[UILabel alloc] init];
    [goodsNameTitleLable initWithText:kLocalized(@"商品名称") TextColor:kGray777777 Font:kFont24 TextAlignment:1];
    [midBackgroundView addSubview:goodsNameTitleLable];
    [goodsNameTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midBackgroundView.mas_top).offset(20);
        make.left.equalTo(midBackgroundView.mas_left).offset(20);
        make.width.equalTo(@(kDeviceProportion(goodsNameTitleLableW)));
        make.height.equalTo(@(kDeviceProportion(20)));
    }];
    
    _goodsNameTextField = [[UITextField alloc] init];
    _goodsNameTextField.delegate = self;
    _goodsNameTextField.placeholder = kLocalized(@"请输入商品名称");
    _goodsNameTextField.layer.borderColor = kGrayE3E3EA.CGColor;
    _goodsNameTextField.layer.borderWidth = 1.0f;
    [midBackgroundView addSubview:_goodsNameTextField];
    [_goodsNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midBackgroundView.mas_top).offset(10);
        make.left.equalTo(goodsNameTitleLable.mas_left).offset(goodsNameTitleLableW + 20);
        make.width.equalTo(@(kDeviceProportion(goodsNameTextFieldW)));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    UILabel *goodsNumTitleLable = [[UILabel alloc] init];
    [goodsNumTitleLable initWithText:kLocalized(@"商品编号") TextColor:kGray777777 Font:kFont24 TextAlignment:1];
    [midBackgroundView addSubview:goodsNumTitleLable];
    [goodsNumTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midBackgroundView.mas_top).offset(20);
        make.left.equalTo(_goodsNameTextField.mas_left).offset(goodsNameTextFieldW + 40);
        make.width.equalTo(@(kDeviceProportion(goodsNumTitleLableW)));
        make.height.equalTo(@(kDeviceProportion(20)));
    }];
    
    _goodsNumTextField = [[UITextField alloc] init];
    _goodsNumTextField.delegate = self;
    _goodsNumTextField.placeholder = kLocalized(@"请输入商品编号");
    _goodsNumTextField.layer.borderColor = kGrayE3E3EA.CGColor;
    _goodsNumTextField.layer.borderWidth = 1.0f;
    [midBackgroundView addSubview:_goodsNumTextField];
    [_goodsNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midBackgroundView.mas_top).offset(10);
        make.left.equalTo(goodsNumTitleLable.mas_left).offset(goodsNumTitleLableW + 20);
        make.width.equalTo(@(kDeviceProportion(goodsNumTextFieldW)));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    UILabel *recommendLable = [[UILabel alloc] init];
    [recommendLable initWithText:kLocalized(@"掌柜推荐") TextColor:kGray777777 Font:kFont24 TextAlignment:1];
    [midBackgroundView addSubview:recommendLable];
    [recommendLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midBackgroundView.mas_top).offset(20);
        make.left.equalTo(_goodsNumTextField.mas_left).offset(goodsNumTextFieldW + 20);
        make.width.equalTo(@(kDeviceProportion(goodsNameTitleLableW)));
        make.height.equalTo(@(kDeviceProportion(20)));
    }];
    
    UIButton *recomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recomButton setBackgroundImage:[UIImage imageNamed:@"gyhs_normal"] forState:UIControlStateNormal];
    [recomButton setBackgroundImage:[UIImage imageNamed:@"gyhs_select"] forState:UIControlStateSelected];
    [midBackgroundView addSubview:recomButton];
    [recomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midBackgroundView.mas_top).offset(20);
        make.left.equalTo(recommendLable.mas_left).offset(goodsNameTitleLableW + 20);
        make.width.equalTo(@(kDeviceProportion(20)));
        make.height.equalTo(@(kDeviceProportion(20)));
    }];
    
    UIButton *queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [queryButton setImage:[UIImage imageNamed:@"gyhs_point_check"] forState:UIControlStateNormal];
    [midBackgroundView addSubview:queryButton];
    [queryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midBackgroundView.mas_top).offset(15);
        make.left.equalTo(recomButton.mas_left).offset(20 + 40);
        make.width.equalTo(@(kDeviceProportion(30)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];
    
    UILabel *queryLable = [[UILabel alloc] init];
    [queryLable initWithText:kLocalized(@"查询") TextColor:kRedE50012 Font:kFont32 TextAlignment:1];
    [midBackgroundView addSubview:queryLable];
    [queryLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midBackgroundView.mas_top).offset(15);
        make.left.equalTo(queryButton.mas_left).offset(20 + 10);
        make.width.equalTo(@(kDeviceProportion(50)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];
}

- (void)initHeaderView{
    UIImageView* headBackgroundView = [[UIImageView alloc] init];
    headBackgroundView.image = [UIImage imageNamed:@"gycom_nav_background"];
    headBackgroundView.userInteractionEnabled = YES;
    [self.view addSubview:headBackgroundView];
    [headBackgroundView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(144);
        make.height.equalTo(@(kDeviceProportion(50)));
    }];
    
    float selcetClassBtnW = 120;
    float goodsNameLabW = 120;
    float goodsNumLabW = 115;
    float priceLabW = 93;
    float PointsProLabW = 112;
    float selectShopNameBtnW = 120;
    float selectStaBtnW = 120;
    float operateLabW = 120;
    
    _selectClassButton = [[GYSelectedButton alloc] init];
    _selectClassButton.delegate = self;
    [_selectClassButton setTitle:kLocalized(@"全部分类") forState:UIControlStateNormal];
    _selectClassButton.layer.borderColor = kGrayE3E3EA.CGColor;
    _selectClassButton.layer.borderWidth = 1.0f;
    [headBackgroundView addSubview:_selectClassButton];
    [_selectClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBackgroundView.mas_top).offset(15);
        make.left.equalTo(headBackgroundView.mas_left).offset(10);
        make.width.equalTo(@(kDeviceProportion(selcetClassBtnW)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];
    
    UILabel *goodNameLable = [[UILabel alloc] init];
    [goodNameLable initWithText:kLocalized(@"商品名称") TextColor:kGray777777 Font:kFont24 TextAlignment:1];
    [headBackgroundView addSubview:goodNameLable];
    [goodNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBackgroundView.mas_top).offset(15);
        make.left.equalTo(_selectClassButton.mas_left).offset( selcetClassBtnW + 10);
        make.width.equalTo(@(kDeviceProportion(goodsNameLabW)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];

    UILabel *goodNumLable = [[UILabel alloc] init];
    [goodNumLable initWithText:kLocalized(@"商品编号") TextColor:kGray777777 Font:kFont24 TextAlignment:1];
    [headBackgroundView addSubview:goodNumLable];
    [goodNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBackgroundView.mas_top).offset(15);
        make.left.equalTo(goodNameLable.mas_left).offset( goodsNameLabW);
        make.width.equalTo(@(kDeviceProportion(goodsNumLabW)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];

    UIView *priceView = [[UIView alloc] init];
    [headBackgroundView addSubview:priceView];
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBackgroundView.mas_top).offset(0);
        make.left.equalTo(goodNumLable.mas_left).offset(goodsNumLabW);
        make.width.equalTo(@(kDeviceProportion(priceLabW)));
        make.height.equalTo(@(kDeviceProportion(50)));
    }];
    
    UIImageView *coinImageview = [[UIImageView alloc] init];
    [coinImageview setImage:[UIImage imageNamed:@"gyhe_coin_icon"]];
    coinImageview.frame = CGRectMake(9, 15, kDeviceProportion(30), kDeviceProportion(30));
    [priceView addSubview:coinImageview];
    
    UILabel *goodsPriceLable = [[UILabel alloc] init];
    [goodsPriceLable initWithText:@"价格" TextColor:kGray777777 Font:kFont24 TextAlignment:0];
    goodsPriceLable.frame = CGRectMake(CGRectGetMaxX(coinImageview.frame) + 5, 15, 40, 30);
    [priceView addSubview:goodsPriceLable];
    
    UIView *pointView = [[UIView alloc] init];
    [headBackgroundView addSubview:pointView];
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBackgroundView.mas_top).offset(0);
        make.left.equalTo(priceView.mas_left).offset(priceLabW);
        make.width.equalTo(@(kDeviceProportion(PointsProLabW)));
        make.height.equalTo(@(kDeviceProportion(50)));
    }];
    
    UIImageView *pointImageview = [[UIImageView alloc] init];
    [pointImageview setImage:[UIImage imageNamed:@"gyhe_point_icon"]];
    pointImageview.frame = CGRectMake(0, 15, kDeviceProportion(30), kDeviceProportion(30));
    [pointView addSubview:pointImageview];
    
    UILabel *goodsPointLable = [[UILabel alloc] init];
    [goodsPointLable initWithText:@"积分比例" TextColor:kGray777777 Font:kFont24 TextAlignment:0];
    goodsPointLable.frame = CGRectMake(CGRectGetMaxX(pointImageview.frame) + 5, 15, 80, 30);
    [pointView addSubview:goodsPointLable];
    
    _selectShopNameButton = [[GYSelectedButton alloc] init];
    _selectShopNameButton.delegate = self;
    [_selectShopNameButton setTitle:kLocalized(@"已关联营业点") forState:UIControlStateNormal];
    _selectShopNameButton.layer.borderColor = kGrayE3E3EA.CGColor;
    _selectShopNameButton.layer.borderWidth = 1.0f;
    [headBackgroundView addSubview:_selectShopNameButton];
    [_selectShopNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBackgroundView.mas_top).offset(15);
        make.left.equalTo(pointView.mas_left).offset(PointsProLabW + 10);
        make.width.equalTo(@(kDeviceProportion(selectShopNameBtnW)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];

    
    _selectStaButton = [[GYSelectedButton alloc] init];
    _selectStaButton.delegate = self;
    [_selectStaButton setTitle:kLocalized(@"全部状态") forState:UIControlStateNormal];
    _selectStaButton.layer.borderColor = kGrayE3E3EA.CGColor;
    _selectStaButton.layer.borderWidth = 1.0f;
    [headBackgroundView addSubview:_selectStaButton];
    [_selectStaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBackgroundView.mas_top).offset(15);
        make.left.equalTo(_selectShopNameButton.mas_left).offset(selectShopNameBtnW + 10);
        make.width.equalTo(@(kDeviceProportion(selectStaBtnW)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];

    UILabel *operateLable = [[UILabel alloc] init];
    [operateLable initWithText:kLocalized(@"操作") TextColor:kGray777777 Font:kFont24 TextAlignment:1];
    [headBackgroundView addSubview:operateLable];
    [operateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBackgroundView.mas_top).offset(15);
        make.left.equalTo(_selectStaButton.mas_left).offset(selectStaBtnW + 10);
        make.width.equalTo(@(kDeviceProportion(operateLabW)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];

    
    
}



#pragma mark - GYSelectedButtondelegate
-(void)GYSelectedButtonDidClick:(GYSelectedButton *)btn withContent:(NSString *)content{


}
#pragma mark - event

#pragma mark - request

@end
