//
//  DemoListViewController.m
//  AssetsLibraryDemo
//
//  Created by coderyi on 14-10-16.
//  Copyright (c) 2014年 coderyi. All rights reserved.
//

#import "GYPhotoListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "GYPhotoViewController.h"
#import "GYHDNavView.h"
@interface GYPhotoListViewController ()<UITableViewDataSource,UITableViewDelegate,GYHDNavViewDelegate>
@property(nonatomic,strong)ALAssetsLibrary *assetsLibrary;
@property(nonatomic,strong)NSMutableArray *groupArray;
@property(nonatomic,strong)UITableView  *photoGrouptableView;
@end

@implementation GYPhotoListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=YES;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self setupNav];
    self.photoGrouptableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.photoGrouptableView];
    [self.photoGrouptableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.photoGrouptableView.dataSource=self;
    self.photoGrouptableView.delegate=self;
    self.photoGrouptableView.rowHeight=80;
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.groupArray=[[NSMutableArray alloc] initWithCapacity:1];

    [self getGroups];

   
}

-(void)setupNav{

GYHDNavView *navView = [[GYHDNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , 64)];
    [navView segmentViewLable:kLocalized(@"相册")];
    navView.delegate = self;
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 64));
    }];


}
-(void)getGroups{
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [self.groupArray addObject:group];
            [self.photoGrouptableView reloadData];
            //            通过这个可以知道相册的名字，从而也可以知道安装的部分应用
            //例如 Name:柚子相机, Type:Album, Assets count:1
        }
    } failureBlock:^(NSError *error) {
      
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text=[((ALAssetsGroup *)[self.groupArray objectAtIndex:indexPath.section]) valueForProperty:ALAssetsGroupPropertyName];
    cell.imageView.image=[UIImage imageWithCGImage:((ALAssetsGroup *)[self.groupArray objectAtIndex:indexPath.section]).posterImage];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld",[((ALAssetsGroup *)[self.groupArray objectAtIndex:indexPath.section]) numberOfAssets]] ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GYPhotoViewController *vc=[[GYPhotoViewController alloc] init];
    if (self.isFromCustomer) {
        vc.isFromCustomer=YES;
    }else{
        vc.isFromCustomer=NO;
    }
    vc.group=((ALAssetsGroup *)[self.groupArray objectAtIndex:indexPath.section]);
    [self.navigationController pushViewController:vc animated:YES];
  
}
- (void)GYHDNavViewGoBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
