//
//  GYHSQQuickPaymentVC.m
//
//  Created by apple on 16/8/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSQuickPaymentVC.h"
#import "GYHSPublicMethod.h"
#import "GYHSQuickListModel.h"
#import "GYHSQuickPamentCollectCell.h"
#import "GYHSmyhsHttpTool.h"
#define kTopHeight 70
#define kMargin 37
#define kCollectItemHeight 193
@interface GYHSQuickPaymentVC () <UICollectionViewDataSource, UICollectionViewDelegate, GYHSQuickBankDelegate, GYNetworkReloadDelete>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, weak) UIView* tipView; //背景
@end

@implementation GYHSQuickPaymentVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout :^{
        @strongify(self);
        [self initView];
        [self request];
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
    self.title = kLocalized(@"GYHS_Myhs_Quick_Bank_Card");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    @weakify(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - 快捷支付卡列表
- (void)request
{
    [GYNetwork sharedInstance].delegate = self;
    @weakify(self);
    [GYHSmyhsHttpTool ListQkBanks:^(id responsObject) {
        @strongify(self);
        [self.dataArray removeAllObjects];
        for (NSDictionary* temp in responsObject) {
            GYHSQuickListModel* model = [[GYHSQuickListModel alloc] initWithDictionary:temp error:nil];
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tipView.hidden = (self.dataArray && self.dataArray.count > 0 ? YES : NO);
        });
    }
                          failure:^{
                          
                          }];
}

#pragma mark - GYNetworkReloadDelete
- (void)gyNetworkDidTapReloadBtn
{
    [self request];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSQuickPamentCollectCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:quickPaymentCollectCell forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake((self.view.width - 4 * kMargin) / 3, kCollectItemHeight);
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kTopHeight, kMargin, 0, kMargin);
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectQuickBankWithModel:)]) {
        [_delegate selectQuickBankWithModel:self.dataArray[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - GYHSQuickBankDelegate
- (void)deleteQuickBankWithModel:(GYHSQuickListModel*)model
{
    [GYAlertView alertWithTitle:kLocalized(@"GYHS_Myhs_Warm_Tip") Message:kLocalized(@"GYHS_Myhs_Is_Delete_Quick_Bank") topColor:TopColorRed comfirmBlock:^{
        @weakify(self);
        [GYHSmyhsHttpTool deleteQiuckBankWithAccId:model.accId
                                         bindingNo:model.signNo
                                           success:^(id responsObject) {
                                               @strongify(self);
                                               [self request];
                                               [kDefaultNotificationCenter postNotification:[NSNotification notificationWithName:GYChangeBankCardOrChageMainHSNotification object:nil]];
                                                [kDefaultNotificationCenter postNotification:[NSNotification notificationWithName:GYDeleteQuickCardSNotification object:model]];
                                           }
                                           failure:^{
                                               
                                           }];
      
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!self.tipView) {
        UIView* tipView = [GYHSPublicMethod noDataTipWithSuperView:self.collectionView];
        tipView.hidden = YES;
        self.tipView = tipView;
    }
}
#pragma mark - lazy load
- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayOut];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSQuickPamentCollectCell class]) bundle:nil] forCellWithReuseIdentifier:quickPaymentCollectCell];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
