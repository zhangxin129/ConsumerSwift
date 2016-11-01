//
//  GYHETakeDishesViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHETakeDishesViewController.h"
#import "GYHeTakeDishesCollectionView.h"
#import "GYHETakeDishesCollectionViewCell.h"
#import "GYHEAlTakeDishesViewController.h"
#import "GYNotificationHub.h"
static NSString* GYHEtakeDishesCollectionViewCell= @"takeDishesCollectionViewCell";

@interface GYHETakeDishesViewController ()

@property (nonatomic, strong) GYHeTakeDishesCollectionView *collectionView;
@property (nonatomic, strong) GYNotificationHub  *hubMsg;

@end

@implementation GYHETakeDishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createDishesUI];
}

- (void)createUI{
    self.title = kLocalized(@"点菜");
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 50)];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [searchImageView setImage:[UIImage imageNamed:@"gyhs_staff_searchBackground"]];
    [searchView addSubview:searchImageView];
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
    searchTextField.placeholder = kLocalized(@"请输入菜品名称");
    searchTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchTextField.layer.borderWidth = 1.0f;
    [searchView addSubview:searchTextField];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(searchTextField.frame) + 10, 10, 30, 30);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_check"] forState:UIControlStateNormal];
    [searchView addSubview:searchBtn];
    UILabel *searchLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchBtn.frame), 10, 40, 30)];
    searchLab.text = kLocalized(@"搜索");
    searchLab.textColor = [UIColor redColor];
    [searchView addSubview:searchLab];
    
}

- (void)createDishesUI{
    UIView *dishView = [[UIView alloc] initWithFrame:CGRectMake(0, 94, kScreenWidth, kScreenHeight)];
    [self.view addSubview:dishView];
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(kScreenWidth - 54, 20, 44, 107);
    [clearButton setBackgroundImage:[UIImage imageNamed:@"gyhe_clear_normal"] forState:UIControlStateNormal];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"gyhe_clear_select"] forState:UIControlStateSelected];
    [clearButton addTarget:self action:@selector(clearDishes) forControlEvents:UIControlEventTouchUpInside];
    [dishView addSubview:clearButton];
    
    UIButton *takeDishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    takeDishButton.frame = CGRectMake(kScreenWidth - 54, CGRectGetMaxY(clearButton.frame) + 20, 44, 107);
    [takeDishButton setBackgroundImage:[UIImage imageNamed:@"gyhe_take_normal"] forState:UIControlStateNormal];
    [takeDishButton setBackgroundImage:[UIImage imageNamed:@"gyhe_take_select"] forState:UIControlStateSelected];
    [takeDishButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [dishView addSubview:takeDishButton];
    self.hubMsg = [[GYNotificationHub alloc] initWithView:takeDishButton];
    self.hubMsg.count = 3;
    [self.hubMsg moveCircleByX:-30 Y:0];
    [self.hubMsg showCount];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[GYHeTakeDishesCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 64, kScreenHeight) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[GYHETakeDishesCollectionViewCell   class] forCellWithReuseIdentifier:GYHEtakeDishesCollectionViewCell];
    [dishView addSubview:self.collectionView];
}

- (void)clearDishes{

    [self.hubMsg hideCount];

}

-(void)buttonAction:(UIButton *)sender{
    GYHEAlTakeDishesViewController *alTakeDishesViewController = [[GYHEAlTakeDishesViewController alloc] init];
    [self.navigationController pushViewController:alTakeDishesViewController animated:YES];
}

@end
