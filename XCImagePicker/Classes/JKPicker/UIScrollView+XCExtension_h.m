//
//  UIScrollView+XCExtension_h.m
//  ELImagePicker
//
//  Created by 樊小聪 on 2017/11/3.
//

#import "UIScrollView+XCExtension_h.h"

@implementation UIScrollView (XCExtension_h)

- (void)scrollToBottomAnimated:(BOOL)animated
{
    /// 如果 当前的 contentSize 不足不屏，则直接返回
    if (self.contentSize.height < self.bounds.size.height)  return;
    
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}


@end
