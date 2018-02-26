//
//  BrowserConfigure.m
//  ELImagePicker
//
//  Created by 樊小聪 on 2017/11/3.
//


/*
 *  备注：配置 🐾
 */

#import "BrowserConfigure.h"

@implementation BrowserConfigure

+ (instancetype)defaultConfigure
{
    BrowserConfigure *configure = [[BrowserConfigure alloc] init];
    
    configure.navigationBackgroundColor = [UIColor whiteColor];
    configure.titleColor = [UIColor blackColor];
    
    configure.leftButtonTitleColor = [UIColor blackColor];
    configure.rightButtonTitleColor = [UIColor blackColor];
    
    configure.column = 3;
    configure.sectionInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    configure.itemRowMargin = 10;
    configure.itemColumnMargin = 10;
    
    return configure;
}

@end
