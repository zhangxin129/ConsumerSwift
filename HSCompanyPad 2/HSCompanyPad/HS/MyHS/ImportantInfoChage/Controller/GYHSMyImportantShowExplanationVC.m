//
//  GYHSMyImportantShowExplanationVC.m
//
//  Created by apple on 16/9/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyImportantShowExplanationVC.h"
#import "GYHSMyImportantShowExplanationCell.h"

static NSString* idCell = @"cell";

@interface GYHSMyImportantShowExplanationVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* dataSourceArray;

@end

@implementation GYHSMyImportantShowExplanationVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSMyImportantShowExplanationCell* cell = [tableView dequeueReusableCellWithIdentifier:idCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textsLabel.attributedText = chageTextType(self.dataSourceArray[indexPath.row]);
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat width = self.view.width;
    NSArray *cellArray =  [self.tableView visibleCells];
    if (cellArray.count > 0) {
        GYHSMyImportantShowExplanationCell *cell = [cellArray firstObject];
        width = cell.textsLabel.width;
    }
    CGFloat height = [chageTextType(self.dataSourceArray[indexPath.row]) boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size.height;
    return ceil(height);
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - private methods
/*!
 *    将带有*的文字的*标记为红色
 *
 *    @param text 带有*的文字
 *
 *    @return 属性文字
 */
NSAttributedString* chageTextType(NSString* text)
{
    NSMutableParagraphStyle* style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    style.lineHeightMultiple = 1.4;
    style.headIndent = 8;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    NSRange range = [text rangeOfString:@"＊"];
    NSMutableAttributedString* attText = [[NSAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName : kFont30, NSForegroundColorAttributeName : kGray333333, NSParagraphStyleAttributeName : style }].mutableCopy;
    NSAttributedString *symbolAttributesString = [[NSAttributedString alloc] initWithString:@"＊" attributes:@{
                                                                                                              NSFontAttributeName : kFont30,
                                                                                                              NSForegroundColorAttributeName : kRedE50012,
                                                                                                              NSParagraphStyleAttributeName : style }];
    [attText replaceCharactersInRange:range withAttributedString:symbolAttributesString];
    return attText;
}

- (void)initView
{
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - lazy load
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kWhiteFFFFFF;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMyImportantShowExplanationCell class]) bundle:nil] forCellReuseIdentifier:idCell];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (NSArray*)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = @[
                             kLocalized(@"GYHS_Myhs_ImportantInfo_Tip1"),
                             kLocalized(@"GYHS_Myhs_ImportantInfo_Tip2"),
                             kLocalized(@"GYHS_Myhs_ImportantInfo_Tip3"),
                             kLocalized(@"GYHS_Myhs_ImportantInfo_Tip4"),
                             kLocalized(@"GYHS_Myhs_ImportantInfo_Tip5")
                             ];
    }
    return _dataSourceArray;
}



@end
