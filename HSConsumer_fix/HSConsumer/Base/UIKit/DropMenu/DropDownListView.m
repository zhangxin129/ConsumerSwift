//
//  DropDownListView.m
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define ROW_HEIGHT 50 //cell高度
#define kAnimateDuration 0.2 //动画时间

#import "DropDownListView.h"

@interface DropDownListView () {
    NSMutableArray* _seleArray;
    //    BOOL            _keyboardIsShow;
    UITableView* _tableView;
    UIView* mTableBaseView;
    UIView* mSuperView;
    BOOL isShowFlag;
}
@end

@implementation DropDownListView
@synthesize isHideBackground = _isHideBackground;

- (CGRect)getTableViewFrame
{
    CGRect frame = self.frame;

    NSUInteger num = _seleArray.count;
    if (num > 6)
        num = 6;
    CGFloat height = ROW_HEIGHT * num - 1;
    frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, height);
    return frame;
}

- (id)initWithArray:(NSArray*)array parentView:(UIView*)superView widthSenderFrame:(CGRect)ff
{
    if (!array || array.count <= 0 || !superView)
        return nil;
    if (self = [super initWithFrame:ff]) {
        isShowFlag = NO;
        _seleArray = [NSMutableArray arrayWithArray:array];
        [self setBackgroundColor:[UIColor greenColor]];
        mSuperView = superView;
        _isHideBackground = YES;
        _selectedIndex = -1;
    }
    return self;
}

- (BOOL)isHideBackground
{
    return _isHideBackground;
}

- (void)setIsHideBackground:(BOOL)isHideBackground_
{
    if (mTableBaseView) {
        mTableBaseView.hidden = isHideBackground_;
    }
    _isHideBackground = isHideBackground_;
}

- (BOOL)isShow
{
    return isShowFlag;
}

//所有的关闭逻辑操作，均要在代理的类里实现
- (void)hideExtendedChooseView
{
    if (isShowFlag) {
        isShowFlag = NO;
        CGRect rect = _tableView.frame;
        rect.size.height = 0;
        [UIView animateWithDuration:kAnimateDuration animations:^{
            mTableBaseView.alpha = 1.0f;
            _tableView.alpha = 1.0f;

            mTableBaseView.alpha = 0.2f;
            _tableView.alpha = 0.2;

            _tableView.frame = rect;
        } completion:^(BOOL finished) {
            [_tableView removeFromSuperview];
            [mTableBaseView removeFromSuperview];
        }];
    }
}

- (void)showChooseListView
{
    if (!_tableView) {
        mTableBaseView = [[UIView alloc] initWithFrame:CGRectMake(mSuperView.frame.origin.x,
                                                           CGRectGetMaxY(self.frame),
                                                           mSuperView.frame.size.width,
                                                           mSuperView.frame.size.height - CGRectGetMaxY(self.frame))];

        mTableBaseView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];

        UITapGestureRecognizer* bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [mTableBaseView addGestureRecognizer:bgTap];
        _tableView = [[UITableView alloc] initWithFrame:[self getTableViewFrame] style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor grayColor];
    }

    CGRect rect = [self getTableViewFrame];
    CGFloat moveH = CGRectGetHeight(rect);
    rect.size.height = 0;
    [mSuperView addSubview:mTableBaseView];
    [mSuperView addSubview:_tableView];

    //动画设置位置
    rect.size.height = moveH;
    [UIView animateWithDuration:kAnimateDuration animations:^{
        mTableBaseView.alpha = 0.2;
        _tableView.alpha = 0.2;

        mTableBaseView.alpha = 1.0;
        _tableView.alpha = 1.0;
        _tableView.frame = rect;
    }];
    isShowFlag = YES;
    mTableBaseView.hidden = _isHideBackground;

    [_tableView reloadData];
}

- (void)bgTappedAction:(UITapGestureRecognizer*)tap
{
    if ([_delegate respondsToSelector:@selector(menuDidSelectIsChange:withObject:)]) {
        [_delegate menuDidSelectIsChange:NO withObject:self];
    }
}

#pragma mark-- UITableView Delegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    BOOL isChanged = (_selectedIndex != indexPath.row);
    _selectedIndex = indexPath.row;
    if ([_delegate respondsToSelector:@selector(menuDidSelectIsChange:withObject:)]) {
        [_delegate menuDidSelectIsChange:isChanged withObject:self];
    }
}

#pragma mark-- UITableView DataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _seleArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell.textLabel setTextColor:kCellItemTitleColor];
    if (_seleArray.count > indexPath.row) {
        cell.textLabel.text = _seleArray[indexPath.row];
    }
    [GYUtils setFontSizeToFitWidthWithLabel:cell.textLabel labelLines:1];
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    //显示之前选中的行
    if (_selectedIndex != -1 && _selectedIndex == indexPath.row) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

@end
