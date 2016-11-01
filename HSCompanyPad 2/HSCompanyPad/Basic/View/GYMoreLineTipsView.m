//
//  GYMoreLineTipsView1.m
//  HSCompanyPad
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYMoreLineTipsView.h"

static NSString* idCell = @"cell";
@interface GYMoreLineTipsView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSourceArray;

@end

@implementation GYMoreLineTipsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - initView 初始化视图
- (void)initView
{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UITableViewDelegate
- (nullable UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableParagraphStyle* style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    style.lineHeightMultiple = 1.5;
    style.firstLineHeadIndent = kDeviceProportion(5);
    style.lineBreakMode = NSLineBreakByCharWrapping;
    UILabel* label = [[UILabel alloc] init];
    label.attributedText = [[NSAttributedString alloc] initWithString:kLocalized(@"GYHS_ExchageHSB_Tips_Title") attributes:@{ NSFontAttributeName : kFont24, NSForegroundColorAttributeName : kGray666666, NSParagraphStyleAttributeName : style }];
    return label;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat height = [self.dataSourceArray[indexPath.row] boundingRectWithSize:CGSizeMake(self.width - 10, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    DDLogInfo(@"%f", ceil(height));
    return ceil(height);
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYMoreLineTipsViewCell* cell = [tableView dequeueReusableCellWithIdentifier:idCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[GYMoreLineTipsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label.attributedText = self.dataSourceArray[indexPath.row];
    return cell;
}

#pragma mark - private methods
NSAttributedString* chageAttributedString(id textString)
{
    
    NSMutableParagraphStyle* style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    style.lineHeightMultiple = 1.5;
    style.headIndent = 10;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSMutableAttributedString* strAtt = nil;
    
    NSAttributedString* symbolAttributesString = [[NSAttributedString alloc] initWithString:@"＊" attributes:@{
                                                                                                              NSFontAttributeName : kFont24,
                                                                                                              NSForegroundColorAttributeName : kRedE50012,
                                                                                                              NSParagraphStyleAttributeName : style
                                                                                                              }];
    
    if ([textString isKindOfClass:[NSString class]] || [textString isKindOfClass:[NSMutableString class]]) {
        NSString* text = [NSString stringWithFormat:@"＊%@", textString];
        NSRange range = [text rangeOfString:@"＊"];
        strAtt = [[NSAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName : kFont24, NSForegroundColorAttributeName : kGray999999, NSParagraphStyleAttributeName : style }].mutableCopy;
        [strAtt replaceCharactersInRange:range withAttributedString:symbolAttributesString];
    }
    
    if ([textString isKindOfClass:[NSAttributedString class]] || [textString isKindOfClass:[NSMutableAttributedString class]]) {
        strAtt = [[NSAttributedString alloc] initWithAttributedString:textString].mutableCopy;
        [strAtt insertAttributedString:symbolAttributesString atIndex:0];
        [strAtt addAttribute:NSFontAttributeName value:kFont24 range:NSMakeRange(0, strAtt.length)];
        [strAtt addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, strAtt.length)];
    }
    return strAtt;
}

- (void)setDataArray:(NSArray*)dataArray
{
    _dataArray = dataArray;
    [self.dataSourceArray removeAllObjects];
    for (id content in dataArray) {
        [self.dataSourceArray addObject:chageAttributedString(content)];
    }
    [self.tableView reloadData];
}

#pragma mark - lazy load
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[GYMoreLineTipsViewCell class] forCellReuseIdentifier:idCell];
    }
    return _tableView;
}

- (NSMutableArray*)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

@end

@implementation GYMoreLineTipsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self).offset(kDeviceProportion(5));
            make.right.equalTo(self).offset(kDeviceProportion(-5));
            make.top.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - label;
- (UILabel*)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
    }
    return _label;
}

@end
