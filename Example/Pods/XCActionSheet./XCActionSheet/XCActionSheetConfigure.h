//
//  XCActionSheetConfigure.h
//  XCActionSheetExample
//
//  Created by 樊小聪 on 2017/3/13.
//  Copyright © 2017年 樊小聪. All rights reserved.
//



/*
 *  备注：actionSheet 配置类 🐾
 */


#import <UIKit/UIKit.h>


@interface XCActionSheetConfigure : NSObject


/** 👀 标题的颜色：默认 blackColor 👀 */
@property (weak, nonatomic) UIColor *titleTextColor;
/** 👀 标题字体大小：默认 17 👀 */
@property (assign, nonatomic) CGFloat titleFontSize;


/** 👀 内容普通状态下的文字颜色 默认 blackColor 👀 */
@property (weak, nonatomic) UIColor *normalContentTextColor;
/** 👀 内容选中状态下的文字颜色 默认 redColor 👀 */
@property (weak, nonatomic) UIColor *selectedContentTextColor;
/** 👀 内容文字大小：默认 15 👀 */
@property (assign, nonatomic) CGFloat contentFontSize;


/** 👀 取消按钮的颜色：默认 blackColor 👀 */
@property (weak, nonatomic) UIColor *cancelTextColor;
/** 👀 取消按钮的文字大小：默认 15 👀 */
@property (assign, nonatomic) CGFloat cancelFontSize;



/**
    默认配置
 */
+ (instancetype)defaultConfigure;

@end




