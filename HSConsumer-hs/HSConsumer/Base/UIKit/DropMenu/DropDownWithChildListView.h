//
//  DropDownListView.h
//  DropDownDemo
//
//  Created by 童明城 on 14-5-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownWithChildChooseProtocol.h"
#import "GYEasyBuyViewController.h"
#import "GYEasyBuyFirstTableViewCell.h"
#import "GYEasyBuySecondeTableViewCell.h"
#import "GYEasyBuyThirdTableViewCell.h"
#define SECTION_BTN_TAG_BEGIN 1000
#define SECTION_IV_TAG_BEGIN 3000
#define SECTION_LB_TAG_BEGIN 4000

//@protocol deleteTableviewInSectionOne <NSObject>
//
//-(void)deleteTableviewInSectionOne;
//
//@end

typedef enum {
    surroundShopType = 1,
    surroundGoodsType,
    easyBuyListType,
    easyBuySearchType,
    arroundGoodStype, // songjk
    arroundGoodsListType, // songjk

} kUseType;

@interface DropDownWithChildListView : UIView <UITableViewDelegate, UITableViewDataSource, sendTitleText, ThirdCellSendData, setSelectedPicture> {
@public
    NSInteger currentExtendSection; //当前展开的section ，默认－1时，表示都没有展开
    // modify by songjk
    UIButton* sectionBtn;
}

@property (nonatomic, assign) id<DropDownWithChildChooseDelegate> dropDownDelegate;
@property (nonatomic, assign) id<DropDownWithChildChooseDataSource> dropDownDataSource;
@property (nonatomic, assign) id<deleteTableviewInSectionOne> deleteTableview;

@property (nonatomic, strong) UIView* mSuperView;

@property (nonatomic, strong) UIView* mTableBaseView;
@property (nonatomic, strong) UITableView* mTableView;
@property (nonatomic, assign) kUseType ItemuseType;
@property (nonatomic, strong) UIView* footerViewInSectionTwo;
@property (nonatomic, strong) UIButton* BtnConfirm;
@property (nonatomic, assign) BOOL has;
@property (nonatomic, assign) BOOL fromSurroundShopBottom;
//是否从抵扣卷进入，默认为5
@property (nonatomic, assign) NSInteger typeNumber;

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id)delegate WithUseType:(kUseType)type WithOther:(id)other;
- (void)setTitle:(NSString*)title inSection:(NSInteger)section;

- (BOOL)isShow;
- (void)hideExtendedChooseView;

- (void)reloadDatasoureArray:(NSMutableArray*)datasource;
// add by songjk
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)sectionBtnTouch:(UIButton*)btn;
// songjk
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isHaveConfrimButton;
// add songjk 设置按钮文字
- (void)setBtnText:(NSString*)text section:(NSInteger)section;
- (void)setBtnTextColor:(UIColor*)color section:(NSInteger)section;
@end
