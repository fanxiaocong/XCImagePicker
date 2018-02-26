//
//  XCViewController.m
//  XCImagePicker
//
//  Created by fanxiaocong on 02/26/2018.
//  Copyright (c) 2018 fanxiaocong. All rights reserved.
//

#import "XCViewController.h"

#import <XCImagePicker/BrowserManager.h>


@interface XCViewController ()

@end

@implementation XCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [BrowserManager openBrowserWithFromVc:self minCount:1 maxCount:9 selectedPhotoes:NULL completion:^(NSArray<UIImage *> *selectedImgs) {
        
        NSLog(@"%@", selectedImgs);
    }];
}

@end
