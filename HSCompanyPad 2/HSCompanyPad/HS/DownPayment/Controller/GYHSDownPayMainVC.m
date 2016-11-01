//
//  GYHSDownPayMainVC.m
//
//  Created by apple on 16/8/2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSDownPayMainVC.h"
#import "GYHSDownPayCell.h"
#import "GYHSDownPaymentCancelVC.h"
#import "GYHSDownPaymentSettleVC.h"
#import "GYHSDownPaymentVC.h"
#import "GYHSPointHttpTool.h"
#import "GYPointTool.h"
#import "GYSettingHttpTool.h"
NSString* const paymentPoint = @"pointDataSource";
@interface GYHSDownPayMainVC () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) GYPointTool* rateTool;
@property (nonatomic, strong) GYPOSBatchModel* batchCodeModel;
@property (nonatomic, strong) NSArray* pointArray;

@end

@implementation GYHSDownPayMainVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_Down_Payment");
    @weakify(self);
    [self loadInitViewType:GYStopTypeAll :^{
        @strongify(self);
        [self initView];
        [self getPoint];
    }];
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

#pragma mark - private methods
- (void)initView
{
    // 获取批次号信息
    [self.rateTool setBatchNoAndPosRunCode];
    [self.rateTool getBatchNoAndPosRunCode:^(id model) {
        self.batchCodeModel = model;
    }];
    //获取消费积分的配置项
    [GYHSPointHttpTool custGloabalCouponWithSuccess:^(id responsObject) {
        [GlobalData shareInstance].couponMax = responsObject[@"couponMax"];
        [GlobalData shareInstance].couponRate = responsObject[@"couponRate"];
        [GlobalData shareInstance].couponAmount = responsObject[@"couponAmount"];
    }
        failure:^{
        
        }];
        
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

#pragma mark - 积分比例
- (void)getPoint
{
    [GYSettingHttpTool getEntPointRateList:^(id responsObject) {
        self.pointArray = [NSMutableArray arrayWithArray:responsObject];
        if (self.pointArray.count == 0) {
            self.pointArray = @[ @"0.0100",
                @"0.0200",
                @"0.0300",
                @"0.0400",
                @"0.0500" ];
        }
        kSetNSUser(paymentPoint, self.pointArray);
    }
        failure:^{
        
        }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray* arr = self.dataArray[0];
    
    return [arr count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSDownPayCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:downPaymentCell forIndexPath:indexPath];
    cell.imageName = self.dataArray[0][indexPath.row];
    cell.titleName = self.dataArray[1][indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* classname = self.dataArray[2][indexPath.row];
    Class classVC = NSClassFromString(classname);
    UIViewController* vc = [[classVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake(kScreenWidth / 3, self.view.height / 2);
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - lazy load
- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height) collectionViewLayout:flowLayOut];
        [_collectionView registerClass:[GYHSDownPayCell class] forCellWithReuseIdentifier:downPaymentCell];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (GYPointTool*)rateTool
{
    if (_rateTool == nil) {
        _rateTool = [GYPointTool shareInstance];
    }
    return _rateTool;
}

/**
 *  批次号&终端流水
 *
 *  @return GYBatchNoAndPosRunCode
 */
- (GYPOSBatchModel*)batchCodeModel
{
    if (_batchCodeModel == nil) {
        _batchCodeModel = [GYPOSBatchModel shareInstance];
    }
    return _batchCodeModel;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        //图片
        NSArray* imageArr = @[
            @"gyhs_payment_icon",
            @"gyhs_payment_settle",
            @"gyhs_point_cancel",
        ];
        //标题
        NSArray* titieArr = @[ kLocalized(@"GYHS_Down_Hsb_Down"),
            kLocalized(@"GYHS_Down_Payment_Settle"),
            kLocalized(@"GYHS_Down_Payment_Cancel") ];
        //控制器
        NSArray* controllerArr = @[ NSStringFromClass([GYHSDownPaymentVC class]),
            NSStringFromClass([GYHSDownPaymentSettleVC class]),
            NSStringFromClass([GYHSDownPaymentCancelVC class]) ];
        _dataArray = [NSMutableArray arrayWithArray:@[ imageArr, titieArr, controllerArr ]];
    }
    return _dataArray;
}


@end
