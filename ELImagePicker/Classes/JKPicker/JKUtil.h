//
//  JKUtil.h
//  JKImagePicker
//
//  Created by Jecky on 15/1/10.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JKUtil : NSObject

+ (UIImage*)loadImageFromBundle:(NSString*)relativePath;
+ (UIImage *)stretchImage:(UIImage *)image
                capInsets:(UIEdgeInsets)capInsets
             resizingMode:(UIImageResizingMode)resizingMode;

+ (UIColor *)getColor:(NSString *)hexColor;


/**
 *  从当前 bundle 中加载图片
 */
+ (UIImage *)imageNamed:(NSString *)imageName;

@end
