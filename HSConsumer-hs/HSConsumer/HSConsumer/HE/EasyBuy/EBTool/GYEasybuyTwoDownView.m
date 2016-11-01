//
//  GYEasybuyTwoDownView.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyTwoDownView.h"

@interface GYEasybuyTwoDownView () <GYEasybuyOneDownViewDelegate>

@property (nonatomic, copy) NSString* firstCellName;

@property (nonatomic, assign) float width;
//一级目录选中下标及数组
@property (nonatomic, strong) NSArray* currentArray;

@end

@implementation GYEasybuyTwoDownView

//
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withFirstCellName:(NSString*)cellName withFirstViewWidth:(float)width
{

    self = [super initWithFrame:frame];
    if (self) {
        _firstCellName = cellName;
        _width = width;
    }
    return self;
}

//
- (void)setFirstArray:(NSArray*)firstArray
{
    _firstArray = firstArray;
    if (_firstArray) {
        self.firstTabView.array = firstArray;

        _currentArray = firstArray;
    }
}

- (void)setSecondArray:(NSArray*)secondArray
{
    _secondArray = secondArray;
    if (_secondArray) {
        self.secondTabView.array = secondArray;
    }
}

#pragma mark - GYEasybuyOneDownViewDelegate
- (void)easybuyOneDownTabViewDidSelected:(GYEasybuyOneDownView*)easybuyOneDownView Index:(NSInteger)index withArray:(NSArray*)arr
{

    if (easybuyOneDownView == _firstTabView) {
        if ([self.delegate respondsToSelector:@selector(firstTabViewDidSelect:Index:withArray:)]) {

            _currentArray = arr;
            _currentSelectIndex = index;
            [self.delegate firstTabViewDidSelect:self Index:index withArray:arr];
        }
    }
    else if (easybuyOneDownView == _secondTabView) {
        if ([self.delegate respondsToSelector:@selector(secondTabViewDidSelect:Index:withArray:)]) {
            //如果选择二级全部，显示一级目录对应值
            if (!index) {
                [self.delegate secondTabViewDidSelect:self Index:self.currentSelectIndex withArray:self.currentArray];
            }
            else {
                [self.delegate secondTabViewDidSelect:self Index:index withArray:arr];
            }
        }
    }
}

- (GYEasybuyOneDownView*)firstTabView
{
    if (!_firstTabView) {
        _firstTabView = [[GYEasybuyOneDownView alloc] initWithFrame:CGRectMake(0, 0, _width, self.frame.size.height) withCellName:_firstCellName withFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _firstTabView.hasHeight = YES;
        _firstTabView.delegate = self;
        _firstTabView.array = self.firstArray;

        _firstTabView.tabViewCellKey = _oneTabViewCellKey;

        [self addSubview:_firstTabView];
    }
    return _firstTabView;
}

- (GYEasybuyOneDownView*)secondTabView
{
    if (!_secondTabView) {
        if (_secondCellName) {
            _secondTabView = [[GYEasybuyOneDownView alloc] initWithFrame:CGRectMake(_firstTabView.frame.size.width, 0, self.frame.size.width - _width, self.frame.size.height) withCellName:_secondCellName withFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        }
        else {
            _secondTabView = [[GYEasybuyOneDownView alloc] initWithFrame:CGRectMake(_firstTabView.frame.size.width, 0, self.frame.size.width - _width, self.frame.size.height) withCellName:@"UITableViewCell" withFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        }
        _secondTabView.hasHeight = YES;
        _secondTabView.delegate = self;
        _secondTabView.array = _secondArray;
        _secondTabView.tabViewCellKey = _twoTabViewCellKey;

        [self addSubview:_secondTabView];
    }
    return _secondTabView;
}

- (NSArray*)currentArray
{
    if (!_currentArray) {
        _currentArray = [[NSArray alloc] init];
    }
    return _currentArray;
}

@end
