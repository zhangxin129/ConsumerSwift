//
//  GYHEShopFoodCartView.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopFoodCartView.h"
#import "Masonry.h"
#import "GYHEShopFoodCartCell.h"

#define kGYHEShopFoodCartCell @"GYHEShopFoodCartCell"

@interface GYHEShopFoodCartView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *downBtn;
@property (weak, nonatomic) IBOutlet UIView *trashBtn;

@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (nonatomic , strong)UIView *backView;


@end

@implementation GYHEShopFoodCartView

- (void)awakeFromNib {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downCart)];
    _downBtn.layer.cornerRadius = 22;
    _downBtn.clipsToBounds = YES;
    [_downBtn addGestureRecognizer:tap];
    
    _trashBtn.layer.cornerRadius = 12.5;
    
    _countLab.layer.cornerRadius = 7;
    _countLab.clipsToBounds = YES;
    
    
    _tabView.tableFooterView = [[UIView alloc] init];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopFoodCartCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopFoodCartCell];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYHEShopFoodCartCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopFoodCartCell forIndexPath:indexPath];
    if(self.arr.count > indexPath.row) {
        cell.num = self.arr[indexPath.row];
    }
    
    WS(weakSelf);
    cell.deleteRowBlock = ^ {
        if(weakSelf.arr.count > indexPath.row) {
            [weakSelf.arr removeObjectAtIndex:indexPath.row];
            [weakSelf.tabView reloadData];
            if(weakSelf.arr.count == 0) {
                if(_foodCartClearBlock) {
                    _foodCartClearBlock();
                }
                [self removeFromWindow];
            }
        }
        
    };
    return cell;
}

- (void)downCart {
    [self removeFromWindow];
}
- (IBAction)toTrash:(UIButton *)sender {
    [self.arr removeAllObjects];
    [self.tabView reloadData];
    [self performSelector:@selector(clearCart) withObject:nil afterDelay:0.5];
    
}
- (void)clearCart {
    if(_foodCartClearBlock) {
        _foodCartClearBlock();
    }
    [self removeFromWindow];
}
- (void)addToParentVC:(UIViewController *)parentVC {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromWindow)];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [parentVC.view addSubview:view];
    [view addGestureRecognizer:tap];
    _backView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-49);
    }];
    
    [parentVC.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(270);
        make.bottom.mas_equalTo(-49);
        make.left.right.mas_equalTo(0);
    }];
}
- (void)removeFromWindow {
    [_backView removeFromSuperview];
    [self removeFromSuperview];
}
- (void)setArr:(NSMutableArray *)arr {
    _arr = arr;
    _tabView.delegate = self;
    _tabView.dataSource = self;
}


@end
