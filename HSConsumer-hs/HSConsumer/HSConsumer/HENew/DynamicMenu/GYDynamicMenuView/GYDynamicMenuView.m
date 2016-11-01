//
//  GYDynamicMenuView.m
//  GYDynamicMenu
//
//  Created by xiaoxh on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GYDynamicMenuView.h"
#import "ImageTableViewCell.h"

@interface GYDynamicMenuView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *imageArray;//图片数组
@property (nonatomic,assign)CGPoint point;//点击弹出视图起点
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, assign) CGFloat tableViewHeight;//弹出视图高
@property (nonatomic, assign) CGFloat tableViewWidth;//弹出视图宽
@property (nonatomic, strong) UIButton *backViewBtn;//收回弹出视图按钮

@end
@implementation GYDynamicMenuView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
    }
    return self;
}
-(id)initWithBtn:(UIButton *)btn
{
    if (self == [super init]) {
        self.tableViewWidth = btn.frame.size.width;
        self.tableViewHeight = btn.frame.size.height;
        self.point = CGPointMake(btn.frame.origin.x, btn.frame.origin.y);
        self.frame = [self getViewFrame];
        [self addSubview:self.tableView];
    }
    return self;
}
-(CGRect)getViewFrame
{
    CGRect frame = CGRectZero;
    frame.size.height = [self.imageArray count] * self.tableViewHeight;
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        CGFloat width =  self.tableViewWidth;
        frame.size.width = width;
    }
    frame.origin.x = self.point.x;
    frame.origin.y = self.point.y + 64;
    return frame;
}
-(void)show
{
    self.backViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backViewBtn setFrame:[UIScreen mainScreen].bounds];
    [_backViewBtn setBackgroundColor:[UIColor clearColor]];
    [_backViewBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_backViewBtn addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backViewBtn];
    
    CGPoint arrowPoint = [self convertPoint:self.point fromView:_backViewBtn];
    
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, arrowPoint.y / self.frame.size.height);
    self.frame = [self getViewFrame];
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}
-(void)dismiss
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [_backViewBtn removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_backViewBtn removeFromSuperview];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    ImageTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell"];
    cell.myImage.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableViewHeight;
}
#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_menuViewDelegate respondsToSelector:@selector(imageIndex:)]) {
        [self.menuViewDelegate imageIndex:indexPath.row];
    }
    [self dismiss];
}

-(UITableView*)tableView
{
    if (!_tableView) {
        CGRect rect = self.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        _tableView =[[UITableView alloc] initWithFrame:rect];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ImageTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"ImageTableViewCell"];
    }
    return _tableView;
}
-(NSArray*)imageArray
{
    if (!_imageArray) {
        _imageArray = @[@"gyhe_mousebtn",
                        @"gyhe_like",
                        @"gyhe_collection",
                        @"gyhe_timing"];
    }
    return _imageArray;
}
@end
