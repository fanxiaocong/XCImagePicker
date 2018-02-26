//
//  BrowserConfigure.h
//  ELImagePicker
//
//  Created by 樊小聪 on 2017/11/3.
//


/*
 *  备注：配置 🐾
 */

#import <UIKit/UIKit.h>

@interface BrowserConfigure : NSObject

/** 导航栏的背景颜色：默认 白色 */
@property (strong, nonatomic) UIColor *navigationBackgroundColor;
/** 👀 标题颜色：默认 黑色 👀 */
@property (strong, nonatomic) UIColor *titleColor;

/** 👀 导航栏左边按钮普通状态下的文字颜色：默认 黑色 👀 */
@property (strong, nonatomic) UIColor *leftButtonTitleColor;
/** 👀 导航栏右边按钮普通状态下的文字颜色：默认 黑色 👀 */
@property (strong, nonatomic) UIColor *rightButtonTitleColor;

/** 👀 照片排列的列数：默认 3 👀 */
@property (assign, nonatomic) NSInteger column;
/** 👀 照片的 段间距（上、左、下、右）：默认 (15, 15, 15, 15) 👀 */
@property (assign, nonatomic) UIEdgeInsets sectionInsets;
/** 👀 每个照片的列间距（x之间的间距)：默认 10 👀 */
@property (assign, nonatomic) CGFloat itemColumnMargin;
/** 👀 每个照片的行间距（y之间的间距）：默认 10 👀 */
@property (assign, nonatomic) CGFloat itemRowMargin;


+ (instancetype)defaultConfigure;

@end
