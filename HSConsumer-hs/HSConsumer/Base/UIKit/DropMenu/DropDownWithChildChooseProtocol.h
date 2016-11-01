//
//  DropDownChooseProtocol.h
//  DropDownDemo
//
//  Created by 童明城 on 14-5-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol deleteTableviewInSectionOne <NSObject>
@optional
- (void)deleteTableviewInSectionOne;

@end

@protocol DropDownWithChildChooseDelegate <NSObject>

@optional

- (void)chooseAtSection:(NSInteger)section index:(NSInteger)index WithHasChild:(BOOL)has;
- (void)deleteTableviewInSectionOne;
- (void)btnTouch:(NSInteger)section; //用于释放 多选的数组

@end

@protocol DropDownWithChildChooseDataSource <NSObject>
- (NSInteger)numberOfSections;

- (NSInteger)multipleChoiceCount;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (NSString*)titleInSection:(NSInteger)section index:(NSInteger)index;

- (NSInteger)defaultShowSection:(NSInteger)section;

@optional

- (void)didSelectedOneShow:(NSString*)title WithIndexPath:(NSIndexPath*)indexPath WithCurrentSection:(NSInteger)sectionNumber;
//多选项中用于删除 选中的项目
- (void)mutableSelectRemoveObj:(NSIndexPath*)indexPath WithCurrentSectin:(NSInteger)sectionNumber;

@end



