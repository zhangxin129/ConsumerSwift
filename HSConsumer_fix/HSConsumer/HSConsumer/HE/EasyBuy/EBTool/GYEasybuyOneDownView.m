//
//  GYEasybuyOneDownView.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyOneDownView.h"

#define kCell @"EasyCell"

@interface GYEasybuyOneDownView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString* cellName;
@property (nonatomic, strong) UIView* footerView;

@end

@implementation GYEasybuyOneDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withCellName:(NSString*)cellName withFooterView:(UIView*)footer
{
    self = [super initWithFrame:frame];
    if (self) {
        _cellName = cellName;
        _footerView = footer;
    }
    return self;
}

- (void)setArray:(NSArray*)array
{
    _array = array;
    if (array) {
        if (!_hasHeight) {
            //没有高度，动态计算高度
            CGRect rect = self.tabView.frame;
            rect.size.height = self.array.count * 44 + _footerView.frame.size.height;
            if (rect.size.height > self.frame.size.height) {
                rect.size.height = self.frame.size.height;
            }
            self.tabView.frame = rect;
        }
        self.tabView.tableFooterView = _footerView;

        [self.tabView reloadData];
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.array.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
    }

    if ([cell isMemberOfClass:[UITableViewCell class]]) {
        if (self.tabViewCellKey && self.array.count > indexPath.row) {
            cell.textLabel.text = [self.array[indexPath.row] valueForKey:_tabViewCellKey];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
    }
    else {
        if (self.tabViewCellKey && self.array.count > indexPath.row) {
            [cell setValue:self.array[indexPath.row] forKey:_tabViewCellKey];
        }
    }

    for (UIView* v in cell.subviews) {
        v.backgroundColor = [UIColor whiteColor];
    }

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.delegate respondsToSelector:@selector(easybuyOneDownTabViewDidSelected:Index:withArray:)]) {
        [self.delegate easybuyOneDownTabViewDidSelected:self Index:indexPath.row withArray:self.array];
    }
}

- (UITableView*)tabView
{
    if (!_tabView) {
        UITableView* tabView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        tabView.backgroundColor = [UIColor whiteColor];
        tabView.dataSource = self;
        tabView.delegate = self;
        tabView.showsVerticalScrollIndicator = NO;
        tabView.showsHorizontalScrollIndicator = NO;

        //footerView

        [self addSubview:tabView];
        _tabView = tabView;

        if ([[NSBundle mainBundle] pathForResource:_cellName ofType:@"nib"]) {
            [_tabView registerNib:[UINib nibWithNibName:_cellName bundle:nil] forCellReuseIdentifier:@"searchCell"];
        }
        else {
            [_tabView registerClass:NSClassFromString(_cellName) forCellReuseIdentifier:@"searchCell"];
        }
    }
    return _tabView;
}

@end
