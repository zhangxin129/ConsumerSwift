//
//  GYDropListView.m
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kBackgroundViewColor [[UIColor blackColor] colorWithAlphaComponent:0.35]
#define kBorderLightGrayColor [UIColor colorWithRed:200 / 255.0f green:200 / 255.0f blue:200 / 255.0f alpha:1]
#import "GYDropListView.h"

@interface GYDropTableView : UITableView
@property (nonatomic, assign) NSInteger titleIndex;
@property (nonatomic, assign) NSInteger groupIndex;
@property (nonatomic, strong) NSArray* dataSourceArray;
@property (nonatomic, assign) GYDropListViewCellType cellType;
@property (nonatomic, strong) NSIndexPath* choosedIndexPath;
@property (nonatomic, strong) NSMutableArray* choosedIndexPaths;
@property (nonatomic, strong) UIColor* cellBackgroundColor;
@end
@implementation GYDropTableView
@end

@interface GYDropListView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* titles;
@property (nonatomic, weak) UIViewController<GYDropListViewDelegate>* delegate;
@property (nonatomic, strong) NSMutableArray* allTableViews;
@property (nonatomic, strong) UIView* backgroundView;
@property (nonatomic, assign) NSInteger currentShowTitleIndex;
@property (nonatomic, strong) NSMutableArray* titleLabels;
@property (nonatomic, assign) NSInteger numberOfShowedTableViews;
@property (nonatomic, strong) NSMutableArray* titleImageViews;
@end

@implementation GYDropListView

#pragma mark publicMethod
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles delegate:(UIViewController<GYDropListViewDelegate>*)delegate
{
    if (self = [super initWithFrame:frame]) {
        _titles = [titles mutableCopy];
        _delegate = delegate;
        _currentShowTitleIndex = -1;
        [self setupBackgroundView];
        [self setupWithTitles:_titles];
        [self setupTable];
        _numberOfShowedTableViews = 0;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)showTableViewAtTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex
{
    @try {
        GYDropTableView* tableView = _allTableViews[titleIndex][groupIndex];
        [self showTableView:tableView animated:YES];
    }
    @catch (NSException* exception) {
    }
    @finally {
    }
}

- (void)hiddenTableViewAtTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex
{
    @try {
        GYDropTableView* tableView = _allTableViews[titleIndex][groupIndex];
        [self hiddenTableView:tableView animated:YES];
        if (_numberOfShowedTableViews == 0) {
            [self hiddenBackgroundViewAnimated:YES];
        }
    }
    @catch (NSException* exception) {
    }
    @finally {
    }
}

- (void)setTitle:(NSString*)title color:(UIColor*)color atTitleIndex:(NSInteger)titleIndex
{
    [_titles replaceObjectAtIndex:titleIndex withObject:title];
    UILabel* label = _titleLabels[titleIndex];
    label.text = title;
    label.textColor = color;
}

- (void)setDataSource:(NSArray*)dataSource atTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex
{
    @try {
        GYDropTableView* tableView = _allTableViews[titleIndex][groupIndex];
        tableView.dataSourceArray = dataSource;
        [tableView reloadData];
    }
    @catch (NSException* exception) {
    }
    @finally {
    }
}

- (void)hiddenAllTableView
{
    [self hiddenAllTableAnimated:YES];
    [self hiddenBackgroundViewAnimated:YES];
}

#pragma setup
- (void)setupBackgroundView
{
    CGFloat originY = self.frame.origin.y + self.frame.size.height;
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.frame.size.width, _delegate.view.frame.size.height)];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.hidden = YES;
    [_delegate.view addSubview:_backgroundView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAllTableView)];
    [_backgroundView addGestureRecognizer:tap];
}

- (void)setupWithTitles:(NSArray*)titles
{
    CGRect frame = self.frame;
    CGFloat width = frame.size.width / titles.count;
    _titleLabels = [[NSMutableArray alloc] init];
    _titleImageViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < titles.count; i++) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(width * i, 0, width, frame.size.height)];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width - 26, frame.size.height)];
        label.text = titles[i];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 26, 0, 16, frame.size.height)];
        imageView.image = [UIImage imageNamed:@"droplist_down"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_titleLabels addObject:label];
        [_titleImageViews addObject:imageView];
        [view addSubview:label];
        [view addSubview:imageView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewDidClicked:)];
        view.tag = 1000 + i;
        [view addGestureRecognizer:tap];
        [self addSubview:view];
    }
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1 / [UIScreen mainScreen].scale, frame.size.width, 1 / [UIScreen mainScreen].scale)];
    line.backgroundColor = kBorderLightGrayColor;
    [self addSubview:line];
}

- (void)setupTable
{

    _allTableViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < _titles.count; i++) {
        NSInteger count = 1;
        if ([_delegate respondsToSelector:@selector(dropListView:numberOfGroupsInTitleIndex:)]) {
            count = [_delegate dropListView:self numberOfGroupsInTitleIndex:i];
            ;
        }
        CGFloat width = self.frame.size.width / count;
        CGFloat originY = self.frame.origin.y + self.frame.size.height;
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (int j = 0; j < count; j++) {
            GYDropTableView* tableView = [[GYDropTableView alloc] initWithFrame:CGRectMake(j * width, originY, width, 0) style:UITableViewStylePlain];
            tableView.cellType = GYDropListViewCellTypeDefault;
            if ([_delegate respondsToSelector:@selector(dropListView:cellTypeForRowAtTitleIndex:groupIndex:)]) {
                tableView.cellType = [_delegate dropListView:self cellTypeForRowAtTitleIndex:i groupIndex:j];
            }
            tableView.cellBackgroundColor = [UIColor whiteColor];
            if ([_delegate respondsToSelector:@selector(dropListView:backgroundColorForCellAtTitleIndex:groupIndex:)]) {
                tableView.cellBackgroundColor = [_delegate dropListView:self backgroundColorForCellAtTitleIndex:i groupIndex:j];
            }
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.titleIndex = i;
            tableView.groupIndex = j;
            tableView.rowHeight = 40;
            tableView.layer.borderColor = kBorderLightGrayColor.CGColor;
            tableView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
            tableView.tableFooterView = [[UIView alloc] init];
            [_delegate.view addSubview:tableView];
            [array addObject:tableView];
        }
        [_allTableViews addObject:array];
    }
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(GYDropTableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.dataSourceArray.count;
}

- (UITableViewCell*)tableView:(GYDropTableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    cell.backgroundColor = tableView.cellBackgroundColor;
    cell.textLabel.text = tableView.dataSourceArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    GYDropListViewCellType cellType = tableView.cellType;
    if (cellType == GYDropListViewCellTypeSelectedRed) {
        if ([indexPath isEqual:tableView.choosedIndexPath]) {
            cell.textLabel.textColor = [UIColor redColor];
        }
        else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    if (cellType == GYDropListViewCellTypeSlider) {
        UIView* slider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, cell.contentView.frame.size.height)];
        slider.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:slider];

        if ([indexPath isEqual:tableView.choosedIndexPath]) {
            cell.textLabel.textColor = [UIColor redColor];
            slider.hidden = NO;
        }
        else {
            cell.textLabel.textColor = [UIColor blackColor];
            slider.hidden = YES;
        }
    }
    if (cellType == GYDropListViewCellTypeCheckmark) {

        if ([indexPath isEqual:tableView.choosedIndexPath]) {
            cell.textLabel.textColor = [UIColor redColor];
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
            imageView.image = [UIImage imageNamed:@"droplist_checkmark"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            cell.accessoryView = imageView;
        }
        else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    if (cellType == GYDropListViewCellTypeMutableCheckmark) {
        BOOL isContain = NO;
        if (tableView.choosedIndexPaths) {
            for (NSIndexPath* choosedIndexPath in tableView.choosedIndexPaths) {
                if ([choosedIndexPath isEqual:indexPath]) {
                    isContain = YES;
                    break;
                }
            }
        }
        if (isContain) {
            cell.textLabel.textColor = [UIColor redColor];
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
            imageView.image = [UIImage imageNamed:@"droplist_checkmark"];
            cell.accessoryView = imageView;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }

    return cell;
}

- (UIView*)tableView:(GYDropTableView*)tableView viewForFooterInSection:(NSInteger)section
{
    GYDropListViewCellType cellType = tableView.cellType;
    if (cellType == GYDropListViewCellTypeMutableCheckmark) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1 / [UIScreen mainScreen].scale)];
        line.backgroundColor = kBorderLightGrayColor;
        [view addSubview:line];

        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(30, 10, tableView.frame.size.width - 60, 35);
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        btn.layer.cornerRadius = 3;
        btn.clipsToBounds = YES;
        btn.tag = 1 + tableView.titleIndex * 1000 + tableView.groupIndex * 100;
        [view addSubview:btn];
        return view;
    }

    return nil;
}

- (CGFloat)tableView:(GYDropTableView*)tableView heightForFooterInSection:(NSInteger)section
{

    if (tableView.cellType == GYDropListViewCellTypeMutableCheckmark) {
        return 60;
    }

    return 0.1f;
}

- (void)tableView:(GYDropTableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYDropListViewCellType cellType = tableView.cellType;
    if (cellType == GYDropListViewCellTypeMutableCheckmark) {
        if (!tableView.choosedIndexPaths) {
            tableView.choosedIndexPaths = [[NSMutableArray alloc] init];
            [tableView.choosedIndexPaths addObject:indexPath];
        }
        else {
            BOOL isContain = NO;
            NSIndexPath* containedIndexPath = nil;
            for (NSIndexPath* choosedIndexPath in tableView.choosedIndexPaths) {
                if ([choosedIndexPath isEqual:indexPath]) {
                    isContain = YES;
                    containedIndexPath = choosedIndexPath;
                }
            }
            if (isContain) {
                [tableView.choosedIndexPaths removeObject:containedIndexPath];
            }
            else {
                [tableView.choosedIndexPaths addObject:indexPath];
            }
        }
    }
    else {
        NSIndexPath* lastIndexPath = tableView.choosedIndexPath;
        tableView.choosedIndexPath = indexPath;
        if (lastIndexPath) {
            [tableView reloadRowsAtIndexPaths:@[ lastIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];

    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

    if (cellType != GYDropListViewCellTypeMutableCheckmark) {
        if (tableView.groupIndex == [_allTableViews[tableView.titleIndex] count] - 1) {
            [self hiddenAllTableView];
            [self setTitle:cell.textLabel.text color:[UIColor redColor] atTitleIndex:tableView.titleIndex];
        }
    }

    if ([_delegate respondsToSelector:@selector(dropListView:didSelectRowAtTitleIndex:groupIndex:indexPath:rowText:)]) {

        [_delegate dropListView:self didSelectRowAtTitleIndex:tableView.titleIndex groupIndex:tableView.groupIndex indexPath:indexPath rowText:cell.textLabel.text];
    }
}

#pragma mark hidden & show
- (void)hiddenTableView:(GYDropTableView*)tableView animated:(BOOL)animated
{
    CGRect rect = tableView.frame;
    rect.size.height = 0;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            tableView.frame = rect;
        }];
    }
    else {
        tableView.frame = rect;
    }
    _numberOfShowedTableViews--;
}

- (void)showTableView:(GYDropTableView*)tableView animated:(BOOL)animated
{
    [_delegate.view bringSubviewToFront:tableView];
    CGFloat maxHeight = _delegate.view.frame.size.height - self.frame.origin.y - self.frame.size.height;
    CGRect rect = tableView.frame;
    NSArray* array = tableView.dataSourceArray;
    rect.size.height = tableView.rowHeight * array.count;

    if (tableView.cellType == GYDropListViewCellTypeMutableCheckmark) {
        rect.size.height += 60;
    }

    if (rect.size.height > maxHeight) {
        rect.size.height = maxHeight;
    }
    if (!tableView.dataSourceArray || tableView.dataSourceArray.count == 0) {
        rect.size.height = 0;
    }
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            tableView.frame = rect;
        }];
    }
    else {
        tableView.frame = rect;
    }
    _numberOfShowedTableViews++;
}

- (void)showBackgroundViewAnimated:(BOOL)animated
{
    [_delegate.view bringSubviewToFront:_backgroundView];
    _backgroundView.hidden = NO;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            _backgroundView.backgroundColor = kBackgroundViewColor;
        }];
    }
    else {
        _backgroundView.backgroundColor = kBackgroundViewColor;
    }
}

- (void)hiddenBackgroundViewAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            _backgroundView.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            _backgroundView.hidden = YES;
        }];
    }
    else {
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.hidden = YES;
    }
    _currentShowTitleIndex = -1;
    [_titleImageViews enumerateObjectsUsingBlock:^(UIImageView* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        obj.transform = CGAffineTransformMakeRotation(0);
    }];
}

- (void)hiddenAllTableAnimated:(BOOL)animated
{
    for (int i = 0; i < _allTableViews.count; i++) {
        NSArray* array = _allTableViews[i];
        for (int j = 0; j < array.count; j++) {
            GYDropTableView* tableView = array[j];
            [self hiddenTableView:tableView animated:animated];
        }
    }
    _numberOfShowedTableViews = 0;
}

#pragma mark ClickEvent
- (void)titleViewDidClicked:(UITapGestureRecognizer*)tap
{

    UIView* titleView = tap.view;
    NSInteger titleIndex = titleView.tag - 1000;
    UIImageView* imageView = _titleImageViews[titleIndex];
    if (_currentShowTitleIndex == titleIndex) {
        [self hiddenAllTableAnimated:YES];
        [self hiddenBackgroundViewAnimated:YES];
        imageView.transform = CGAffineTransformMakeRotation(0);
    }
    else {
        [self hiddenAllTableAnimated:NO];
        if (_currentShowTitleIndex != -1) {
            UIImageView* imageView2 = _titleImageViews[_currentShowTitleIndex];
            imageView2.transform = CGAffineTransformMakeRotation(0);
        }
        GYDropTableView* tableView = _allTableViews[titleIndex][0];
        if (tableView.dataSourceArray && tableView.dataSourceArray.count > 0) {
            _currentShowTitleIndex = titleIndex;
            [self showBackgroundViewAnimated:YES];
            [self showTableView:tableView animated:YES];
            imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }
}

- (void)confirmBtnClicked:(UIButton*)btn
{
    NSInteger titleIndex = btn.tag / 1000;
    NSInteger groupIndex = (btn.tag % 1000) / 100;
    @try {
        GYDropTableView* tableView = _allTableViews[titleIndex][groupIndex];
        [self hiddenTableViewAtTitleIndex:titleIndex groupIndex:groupIndex];
        if ([_delegate respondsToSelector:@selector(dropListView:didClickConfirmButtonAtTitleIndex:groupIndex:choosedIndexPaths:)]) {
            [_delegate dropListView:self didClickConfirmButtonAtTitleIndex:titleIndex groupIndex:groupIndex choosedIndexPaths:tableView.choosedIndexPaths];
        }
    }
    @catch (NSException* exception) {
    }
    @finally {
    }
}

@end
