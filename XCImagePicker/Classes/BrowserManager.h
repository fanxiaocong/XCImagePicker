//
//  BrowserManager.h
//  封装照片选择器
//
//  Created by 樊小聪 on 16/3/21.
//  Copyright © 2016年 樊小聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAssets.h"
#import "BrowserConfigure.h"

@interface BrowserManager : NSObject


@property (strong, nonatomic, readonly) BrowserConfigure *configure;


/** 允许最大选择的相片数(默认为 9张) */
@property (assign, nonatomic) NSInteger maxCount;

/** 允许最小选择的相片数(默认为 1张) */
@property (assign, nonatomic) NSInteger minCount;

/** 已经选中的相片数组(初始状态下的照片，默认为空，JKAsset类型) */
@property (strong, nonatomic) NSArray<JKAssets *> *selectedPhotoes;

/** 源控制器(要进行弹框的控制器) */
@property (weak, nonatomic) UIViewController *fromVc;

/** 选择完成之后的回调，selectedImgs 表示已经选择好的照片(JKAsset类型) */
@property (copy, nonatomic) void(^completionHandle)(NSArray<UIImage *> *selectedImgs);


+ (instancetype)shareInstance;

/** 打开相册 */
- (void)openBrowser;


/**
 *  更新相关配置
 */
+ (void)updateConfigure:(void(^)(BrowserConfigure *configure))configure;


/**
 *  对象方法创建一个 照片管理类的实例
 *
 *  @param fromVc          源控制器(要进行弹框的控制器)
 *  @param minCount        允许最小选择的相片数(默认为 1张)
 *  @param maxCount        允许最大选择的相片数(默认为 9张)
 *  @param selectedPhotoes 已经选中的相片数量(初始状态下的照片，默认为空，JKAsset类型)
 *  @param completion      选择完成之后的回调，selectedImgs 表示已经选择好的照片(JKAsset类型)
 *
 */
- (instancetype)openBrowserWithFromVc:(UIViewController *)fromVc
                             minCount:(NSInteger)minCount
                             maxCount:(NSInteger)maxCount
                      selectedPhotoes:(NSArray<JKAssets *> *)selectedPhotoes
                           completion:(void (^)(NSArray<JKAssets *> *selectedImgs))completion;

/**
 *  类方法打开照片进行照片选择
 *
 *  @param fromVc          源控制器(要进行弹框的控制器)
 *  @param minCount        允许最小选择的相片数(默认为 1张)
 *  @param maxCount        允许最大选择的相片数(默认为 9张)
 *  @param selectedPhotoes 已经选中的相片数量(初始状态下的照片，默认为空，UIImage类型)
 *  @param completion      选择完成之后的回调，selectedImgs 表示已经选择好的照片(JKAsset类型)
 *
 */
+ (void)openBrowserWithFromVc:(UIViewController *)fromVc
                     minCount:(NSInteger)minCount
                     maxCount:(NSInteger)maxCount
              selectedPhotoes:(NSArray<JKAssets *> *)selectedPhotoes
                   completion:(void (^)(NSArray<UIImage *> *selectedImgs))completion;

@end
