//
//  XCActionSheetConfigure.m
//  XCActionSheetExample
//
//  Created by 樊小聪 on 2017/3/13.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


/*
 *  备注：actionSheet 配置类 🐾
 */

#import "XCActionSheetConfigure.h"

@implementation XCActionSheetConfigure

/**
 默认配置
 */
+ (instancetype)defaultConfigure
{
    XCActionSheetConfigure *configure = [[XCActionSheetConfigure alloc] init];
    
    configure.titleFontSize   = 17;
    configure.titleTextColor  = [UIColor blackColor];
    configure.normalContentTextColor = [UIColor blackColor];
    configure.selectedContentTextColor = [UIColor redColor];
    configure.contentFontSize = 15;
    configure.cancelTextColor = [UIColor blackColor];
    configure.cancelFontSize  = 15;
    
    return configure;
}

@end
