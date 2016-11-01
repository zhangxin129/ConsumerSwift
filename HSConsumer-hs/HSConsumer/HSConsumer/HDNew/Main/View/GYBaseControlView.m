//
//  GYBaseControlView.m
//  GYBaseController
//
//  Created by kuser on 16/9/8.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import "GYBaseControlView.h"
#import "GYBaseControlCell.h"


#define kGYBaseControlCellCellIdentifier @"GYBaseControlCell"

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

@interface GYBaseControlView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic) CGPoint showPoint;
@property (nonatomic, strong) UIButton *backViewBtn;

@end

@implementation GYBaseControlView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.borderColor = RGB(200, 199, 204);
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
    }
    return self;
}

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images width:(CGFloat)width selectName:(NSString *)name
{
    if (self = [super init]) {
        self.width = width;
        self.showPoint = point;
        self.titleArray = titles;
        self.imageArray = images;
        self.name = name;
        self.frame = [self getViewFrame];
        [self addSubview:self.tableView];
    }
    return self;
}

-(CGRect)getViewFrame
{
    CGRect frame = CGRectZero;
    frame.size.height = [self.titleArray count] * 46;
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        CGFloat width =  self.width;
        frame.size.width = width;
    }
    
    frame.origin.x = self.showPoint.x;
    frame.origin.y = self.showPoint.y;
//    frame.origin.x = self.showPoint.x - frame.size.width/2;
//    frame.origin.y = self.showPoint.y;
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
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_backViewBtn];
    
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

#pragma mark - UITableView

-(UITableView *)tableView
{
    if (!_tableView) {
        CGRect rect = self.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYBaseControlCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kGYBaseControlCellCellIdentifier];
    }
    return _tableView;
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYBaseControlCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYBaseControlCellCellIdentifier];
    if (!cell) {
        cell = [[GYBaseControlCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYBaseControlCellCellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.inputArrowBtn.hidden = NO;
    }else{
        cell.inputArrowBtn.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.inputLabel.font = [UIFont systemFontOfSize:14];
    cell.inputLabel.text = [_titleArray objectAtIndex:indexPath.row];
    
    if ([cell.inputLabel.text isEqualToString:self.name]) {
        cell.inputLabel.textColor = [UIColor redColor];
    }
    
    [cell.inputArrowBtn setBackgroundImage:[UIImage imageNamed:@"gy_hd_red_up_arrow"] forState:UIControlStateNormal];
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.selectRowAtIndex) {
        self.selectRowAtIndex(indexPath.row);
    }
    [self dismiss:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

@end
