//
//  UIViewController+Category.h
//  HSCompanyPad
//
//  Created by User on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *    @控制器扩展 :控制器扩展
 控制器
 *
 *    @Created :jianglincen
 *    @Modify  : 1.
 *               2.
 *               3.
 */

@interface UIViewController (Category)<UIDocumentInteractionControllerDelegate>

/**
 *  读取本地word或者excel文档
 *
 *  @param localPath 沙盒路径
 *
 *  @return 返回是否成功打开文件
 */
-(BOOL)readFile:(NSString*)fileName FromLocalPath:(NSString*)localPath;
#warning 手机可以运行，平板上无法正常打开文件!!!
-(BOOL)readFileFromLocalURL:(NSURL*)localUrl;

@end
