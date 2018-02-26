//
//  XCActionSheet.h
//  XCActionSheetExample
//
//  Created by 樊小聪 on 2017/3/13.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


/*
 *  备注：自定义 actionSheet 🐾
 */


#import <UIKit/UIKit.h>

#import "XCActionSheetConfigure.h"

@interface XCActionSheet : UIView

#pragma mark - 👀 中间的内容只有文字 👀 💤


/**
 弹出一个 Action
 
 @param title           标题
 @param titles          内容的标题
 @param didClickHandle  点击的回调
 @param dismissHandle   消失后的回调
 */
+ (void)showActionSheetWithTitle:(NSString *)title
                   contentTitles:(NSArray<NSString *> *)titles
                  didClickHandle:(void(^)(NSInteger index, NSString *title))didClickHandle
                   dismissHandle:(void(^)(void))dismissHandle;


/**
 弹出一个 Action
 
 @param title           标题
 @param titles          内容的标题
 @param configure       参数配置选项
 @param selectedIndex   默认选中的下标
 @param didClickHandle  点击的回调
 @param dismissHandle   消失后的回调
 */
+ (void)showActionSheetWithTitle:(NSString *)title
                   contentTitles:(NSArray<NSString *> *)titles
                       configure:(XCActionSheetConfigure *)configure
                   selectedIndex:(NSInteger)selectedIndex
                  didClickHandle:(void(^)(NSInteger index, NSString *title))didClickHandle
                   dismissHandle:(void(^)(void))dismissHandle;



/**
 弹出一个 Action
 
 @param title           标题
 @param titles          内容的标题
 @param cancelTitle     取消按钮怕标题
 @param configure       参数配置选项
 @param selectedIndex   默认选中的下标
 @param didClickHandle  点击的回调
 @param dismissHandle   消失后的回调
 */
+ (void)showActionSheetWithTitle:(NSString *)title
                   contentTitles:(NSArray<NSString *> *)titles
                     cancelTitle:(NSString *)cancelTitle
                       configure:(XCActionSheetConfigure *)configure
                   selectedIndex:(NSInteger)selectedIndex
                  didClickHandle:(void(^)(NSInteger index, NSString *title))didClickHandle
                   dismissHandle:(void(^)(void))dismissHandle;


#pragma mark - 👀 中间的内容为自定义 👀 💤

/**
 弹出一个 Action 自定义
 
 @param title                   标题
 @param cellCount               配置cell的个数
 @param cellConfigure           配置cell
 @param configure               参数配置选项
 @param selectedIndex           默认选中的下标
 @param didSelectRowHandle      点击的回调
 @param dismissHandle           消失后的回调
 */
+ (void)showActionSheetWithTitle:(NSString *)title
                       cellCount:(NSInteger)cellCount
                   cellConfigure:(UITableViewCell *(^)(UITableView *tableView, NSIndexPath *indexPath))cellConfigure
                       configure:(XCActionSheetConfigure *)configure
                   selectedIndex:(NSInteger)selectedIndex
              didSelectRowHandle:(void(^)(NSInteger index))didSelectRowHandle
                   dismissHandle:(void(^)(void))dismissHandle;


@end



