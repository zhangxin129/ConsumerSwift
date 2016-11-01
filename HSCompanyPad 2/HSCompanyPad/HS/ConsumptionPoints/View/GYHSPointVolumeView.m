//
//  GYHSPointVolumeView.m
//  HSCompanyPad
//
//  Created by 梁晓辉 on 16/7/27.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointVolumeView.h"
#import "GYHSPointVolumeCell.h"
#define kCellBackColor [UIColor colorWithHexString:@"#D5EAD8"]
#define kCellSelectColor [UIColor colorWithHexString:@"#A6D4AE"]
static NSString* const cellIdentifer = @"GYHSPointVolumeCell";
#define kwidth kDeviceProportion(100)
#define kheight kDeviceProportion(48)
#define kLineWidth kDeviceProportion(3)
@interface GYHSPointVolumeView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, copy) NSString* volumeAmount;
@property (nonatomic, strong) UIView* backView; //背景图
@property (nonatomic, copy) NSString* pageVolume; //张数
@property (nonatomic, copy) NSString* couponMax;
@property (nonatomic, copy) NSString* couponAmount;
@end
@implementation GYHSPointVolumeView

#pragma mark - load
- (NSMutableArray*)dataArray
{
    if (_dataArray == nil && self.couponMax) {
        _dataArray = @[].mutableCopy;
        for (int i = 0; i < self.couponMax.intValue; i++) {
            [_dataArray addObject:[@(i + 1) stringValue]];
        }
        [_dataArray addObject:kLocalized(@"GYHS_Point_No_Use")];
    }
    return _dataArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.couponMax = [GlobalData shareInstance].couponMax;
        self.couponAmount = [GlobalData shareInstance].couponAmount;
        self.isShow = YES;
        self.backgroundColor = kGrayc8c8d8;
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    UIViewController* topVC = [self appRootViewController];
    self.size = CGSizeMake(kwidth, kheight * self.dataArray.count + kLineWidth);
    //数据过多处理
    if (self.size.height > 6 * kheight + kLineWidth) {
        self.height = 6 * kheight + kLineWidth;
    }
    [topVC.view addSubview:self];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(kLineWidth, 0, self.size.width - kLineWidth * 2, self.size.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = kheight;
    tableView.backgroundColor = kGrayc8c8d8;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:cellIdentifer bundle:nil] forCellReuseIdentifier:cellIdentifer];
    [self addSubview:tableView];
}

- (void)willMoveToSuperview:(UIView*)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    
    UIViewController* topVC = [self appRootViewController];
    
    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backView.backgroundColor = [UIColor clearColor];
        self.backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [self.backView addGestureRecognizer:tap];
    [topVC.view addSubview:self.backView];
    
    [super willMoveToSuperview:newSuperview];
}

- (void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    if (_isShow) {
        [self show];
    } else {
        [self dismiss];
    }
}

#pragma mark - 显示
- (void)show
{
    self.backView.hidden = NO;
    CGAffineTransform larger = CGAffineTransformMakeScale(1, 1); //放大
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.transform = larger;
                         self.alpha = 1;
                     }];
}

#pragma mark - 消失
- (void)dismiss
{
    self.backView.hidden = YES;
    CGAffineTransform smaller = CGAffineTransformMakeScale(0.01, 0.01); //缩小
    CGAffineTransform move = CGAffineTransformMakeTranslation(self.size.width / 2, -self.size.height / 2); //移动
    CGAffineTransform finall = CGAffineTransformConcat(smaller, move);
    [UIView animateWithDuration:0.2
        animations:^{
            self.transform = finall;
        }
        completion:^(BOOL finished) {
            self.alpha = 0;
        }];
}

- (void)touch
{
    self.isShow = NO;
    if (_block) {
        _block();
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSPointVolumeCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textNumber.text = [NSString stringWithFormat:@"%@%@", self.dataArray[indexPath.row],kLocalized(@"GYHS_Point_Page")];
    cell.faceLabel.text = [NSString stringWithFormat:@"(%@%@)",kLocalized(@"GYHS_Point_Face"),@"10.00"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.dataArray.count - 1) {
        cell.textNumber.text = self.dataArray[indexPath.row];
        cell.faceLabel.text = @"";
        cell.topConstraint.constant = (kheight - cell.textNumber.height) / 2;
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    self.isShow = NO;
    if (indexPath.row != self.dataArray.count - 1) {
        NSDecimalNumber* faceNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", @"10.00".doubleValue]];
        NSDecimalNumber* pageNumber = [NSDecimalNumber decimalNumberWithString:self.dataArray[indexPath.row]];
        NSDecimalNumber* zeroNumber = [NSDecimalNumber decimalNumberWithString:@"0.00"];
        self.volumeAmount = [[zeroNumber decimalNumberBySubtracting:[faceNumber decimalNumberByMultiplyingBy:pageNumber]] stringValue];
        self.volumeAmount = [NSString stringWithFormat:@"%.2f", self.volumeAmount.doubleValue];
        self.pageVolume = self.dataArray[indexPath.row];
        
    } else {
        self.volumeAmount = @"";
        self.pageVolume = @"0";
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectedVolume:pageVolume:)]) {
        [_delegate selectedVolume:self.volumeAmount pageVolume:self.pageVolume];
    }
}

- (UIViewController*)appRootViewController
{
    UIViewController* appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController* topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
