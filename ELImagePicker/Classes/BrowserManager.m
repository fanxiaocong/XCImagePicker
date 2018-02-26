//
//  BrowserManager.m
//  封装照片选择器
//
//  Created by 樊小聪 on 16/3/21.
//  Copyright © 2016年 樊小聪. All rights reserved.
//

#import "BrowserManager.h"
#import "JKImagePickerController.h"
#import "PhotoAlbumManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import <XCActionSheet/XCActionSheet.h>
#import <XCMacros/XCMacros.h>


#define MAX_COUNT 9     // 默认的最大选择照片数量
#define MIN_COUNT 1     // 默认的最小选择照片数量


@interface BrowserManager () <UIImagePickerControllerDelegate, JKImagePickerControllerDelegate, UINavigationControllerDelegate>

@end


@implementation BrowserManager

static id _browserManager = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _browserManager = [[self alloc] init];
    });
    
    return _browserManager;
}

#pragma mark -- 初始化方法

- (instancetype)init
{
    if (self = [super init])
    {
        // 设置默认配置
        [self setUpDefaults];
    }
    
    return self;
}

// 设置默认配置
- (void)setUpDefaults
{
    _maxCount = MAX_COUNT;
    _minCount = MIN_COUNT;
    
    _configure = [BrowserConfigure defaultConfigure];
}

#pragma mark -- 公共方法

/**
 *  更新相关配置
 */
+ (void)updateConfigure:(void(^)(BrowserConfigure *configure))configure
{
    BrowserManager *mgr = [BrowserManager shareInstance];
    
    if (configure)
    {
        configure(mgr.configure);
    }
}

/** 打开相册 */
- (void)openBrowser
{
    NSMutableArray *selectedPhotoes = [NSMutableArray arrayWithArray:self.selectedPhotoes];
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = self.minCount;
    imagePickerController.maximumNumberOfSelection = self.maxCount;
    imagePickerController.selectedAssetArray = selectedPhotoes;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self.fromVc presentViewController:navigationController animated:YES completion:NULL];
}

/**
 *  对象方法创建一个 照片管理类的实例
 *
 *  @param fromVc          源控制器(要进行弹框的控制器)
 *  @param minCount        允许最小选择的相片数(默认为 1张)
 *  @param maxCount        允许最大选择的相片数(默认为 9张)
 *  @param selectedPhotoes 已经选中的相片数量(初始状态下的照片，默认为空)
 *  @param completion      选择完成之后的回调，selectedImgs 表示已经选择好的照片(JKAsset类型)
 *
 */
- (instancetype)openBrowserWithFromVc:(UIViewController *)fromVc
                             minCount:(NSInteger)minCount
                             maxCount:(NSInteger)maxCount
                      selectedPhotoes:(NSArray<JKAssets *> *)selectedPhotoes
                           completion:(void (^)(NSArray<JKAssets *> *selectedImgs))completion
{
    BrowserManager *browserManager = [BrowserManager shareInstance];
    
    browserManager.fromVc = fromVc;
    browserManager.minCount = minCount;
    browserManager.maxCount = maxCount;
    browserManager.selectedPhotoes = selectedPhotoes;
    browserManager.completionHandle = completion;
    
    [XCActionSheet showActionSheetWithTitle:NULL contentTitles:@[@"拍照", @"从相册中选择"] didClickHandle:^(NSInteger index, NSString *title) {
        
        if (0 == index)
        {
            // 拍照
            [browserManager openCamara];
        }
        else if (1 == index)
        {
            // 从相册中选择
            [browserManager openBrowser];
        }
        
    } dismissHandle:^{
        
        browserManager.fromVc = nil;
        browserManager.selectedPhotoes = nil;
    }];
    
    return browserManager;
}

/**
 *  类方法打开照片进行照片选择
 *
 *  @param fromVc          源控制器(要进行弹框的控制器)
 *  @param minCount        允许最小选择的相片数(默认为 1张)
 *  @param maxCount        允许最大选择的相片数(默认为 9张)
 *  @param selectedPhotoes 已经选中的相片数量(初始状态下的照片，默认为空)
 *  @param completion      选择完成之后的回调，selectedImgs 表示已经选择好的照片(JKAsset类型)
 *
 */
+ (void)openBrowserWithFromVc:(UIViewController *)fromVc
                     minCount:(NSInteger)minCount
                     maxCount:(NSInteger)maxCount
              selectedPhotoes:(NSArray<UIImage *> *)selectedPhotoes
                   completion:(void (^)(NSArray<UIImage *> *selectedImgs))completion
{
     [[BrowserManager shareInstance] openBrowserWithFromVc:fromVc
                                                  minCount:minCount
                                                  maxCount:maxCount
                                           selectedPhotoes:NULL
                                                completion:completion];
}

#pragma mark - 👀 UIImagePickerControllerDelegate 👀 💤

/**
 *  选取照片结束后的回调
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (self.completionHandle)
    {
        self.completionHandle(@[image]);
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
    DispatchAscyncOnMainQueue(^{
        [picker dismissViewControllerAnimated:YES completion:NULL];
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        DLog(@"保存失败");
    }else{
        DLog(@"保存成功");
    }
}

#pragma mark - JKImagePickerControllerDelegate

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    NSMutableArray<UIImage *> *imgs = [NSMutableArray arrayWithArray:[assets valueForKeyPath:@"photo"]];
    
    if (self.completionHandle)
    {
        DispatchAscyncOnMainQueue(^{
            self.completionHandle(imgs);
        });
    }
    
    [imagePicker.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:NULL];
}


/**
 *  拍照
 */
- (void)openCamara
{
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    pc.delegate = self;
    [pc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [pc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [pc setAllowsEditing:YES];
 
    [pc setSourceType:UIImagePickerControllerSourceTypeCamera];

    [self.fromVc presentViewController:pc animated:YES completion:nil];
}


@end
