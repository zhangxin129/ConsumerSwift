//
//  PhotoViewController.m
//  AssetsLibraryDemo
//
//  Created by coderyi on 14-10-16.
//  Copyright (c) 2014年 coderyi. All rights reserved.
//

#import "GYPhotoViewController.h"
#import "GYHDNavView.h"
@interface GYPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,GYHDNavViewDelegate>
@property(nonatomic,strong)UICollectionView *cv;
@property(nonatomic,strong)NSMutableArray *imageArray;
@end
@implementation GYPhotoViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=YES;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    self.view.backgroundColor=[UIColor whiteColor];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake(120.0f, 120.0f);
   
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing=10.0f;
    layout.minimumLineSpacing=10.0f;
    self.cv=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    [self.cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.cv.backgroundColor=[UIColor clearColor];

    [self.cv setUserInteractionEnabled:YES];
    self.cv.dataSource=self;
    self.cv.delegate=self;
    [self.view addSubview:self.cv];
    self.imageArray=[[NSMutableArray alloc] initWithCapacity:1];
    [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [self.imageArray addObject:result];
            [self.cv reloadData];
        }
    }];
}
-(void)setupNav{
    
    GYHDNavView *navView = [[GYHDNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , 64)];
    [navView segmentViewLable:kLocalized(@"选择照片")];
    navView.delegate = self;
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 64));
    }];
    
    
}
#pragma mark collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [cell.contentView addSubview:iv];
    iv.image=[UIImage imageWithCGImage:((ALAsset *)[self.imageArray objectAtIndex:indexPath.row]).thumbnail];
    NSString *type=[((ALAsset *)[self.imageArray objectAtIndex:indexPath.row]) valueForProperty:ALAssetPropertyType];
    if ([type isEqualToString:@"ALAssetTypeVideo"]) {
        UIImageView *iv1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 15, 8)];
        [cell.contentView addSubview:iv1];
        iv1.image=[UIImage imageNamed:@"AssetsPickerVideo@2x"];
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(10, 55, 55, 15)];
        label1.textAlignment=NSTextAlignmentRight;
        label1.textColor=[UIColor whiteColor];
        label1.font=[UIFont systemFontOfSize:10];
        
        int time=[[((ALAsset *)[self.imageArray objectAtIndex:indexPath.row]) valueForProperty:ALAssetPropertyDuration] intValue];
       
        if (time/60<1) {
            NSString *timeString=[NSString stringWithFormat:@"%d",time];
            label1.text=timeString;
        }else if (time/3600<1){
            NSString *timeString=[NSString stringWithFormat:@"%d:%d",time/60,time%60];
            label1.text=timeString;
        }else{
            NSString *timeString=[NSString stringWithFormat:@"%d:%d:%d",time/3600,((time%3600)/60),time%3600%60];
            label1.text=timeString;
        }
      
        [cell.contentView addSubview:label1];
        
    }
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ALAsset*result=self.imageArray[indexPath.row];
    NSString*type=[result valueForProperty:ALAssetPropertyType];
    if ([type isEqualToString:@"ALAssetTypePhoto"]) {
        //   如果是图片则上传图片
        ALAssetRepresentation *assetRep = [result defaultRepresentation];
        CGImageRef imgRef = [assetRep fullResolutionImage];
        UIImage *img = [UIImage imageWithCGImage:imgRef
                                           scale:assetRep.scale
                                     orientation:(UIImageOrientation)assetRep.orientation];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadImg" object:img];
        if (self.isFromCustomer) {
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
        }else{
        
            [self.navigationController popToViewController:self.navigationController.viewControllers[3] animated:YES];
        }
        
        
    }
    
}
- (void)GYHDNavViewGoBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
