//
//  XCActionSheet.m
//  XCActionSheetExample
//
//  Created by 樊小聪 on 2017/3/13.
//  Copyright © 2017年 樊小聪. All rights reserved.
//



/*
 *  备注：自定义 actionSheet 🐾
 */


#import "XCActionSheet.h"


#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define RGBA_COLOR(R,G,B,A)     [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#define SEPERATOR_LINE_COLOR    RGBA_COLOR(226, 226, 226, 1)

#define MAX_CONTENT_ROWS_COUNT  5      // 中间内容最大显示的 行数， 超过之后，内容滚动显示
#define CONTENT_CELL_HEIGHT     50.f     // 中间 每行 显示的高度
#define DURATION                .3f
#define CELL_BUTTON_TAG         555



/* 🐖 ***************************** 🐖 XCActionSheetCell 🐖 *****************************  🐖 */

@interface XCActionSheetCell : UITableViewCell
@property (weak, nonatomic) UIButton *titleButton;
@end

@implementation XCActionSheetCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleButton      = titleButton;
        [self.contentView addSubview:titleButton];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleButton.frame = self.contentView.bounds;
}
@end

/* 🐖 ***************************** 🐖 XCActionSheet 🐖 *****************************  🐖 */



@interface XCActionSheet () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) XCActionSheetConfigure *configure;

/** 👀 点击某行的回调 👀 */
@property (copy, nonatomic) void(^didClickHandle)(NSInteger index, NSString *title);
/** 👀 消失后的回调 👀 */
@property (copy, nonatomic) void(^dismissHandle)(void);

/** 👀 标题 👀 */
@property (copy, nonatomic) NSString *title;
/** 👀 内容标题 👀 */
@property (strong, nonatomic) NSArray<NSString *> *contentTitles;
/** 👀 取消标题 👀 */
@property (copy, nonatomic) NSString *cancleTitle;

/** 👀 选中的下标 👀 */
@property (assign, nonatomic) NSInteger selectedIndex;

/** 👀 蒙板 👀 */
@property (weak, nonatomic) UIButton *mask;

/** 👀 内容视图 👀 */
@property (weak, nonatomic) UIView *contentView;

/** 👀 是否是自定义的cell 👀 */
@property (assign, nonatomic) BOOL isCustom;
@property (assign, nonatomic) NSInteger cellCount;
@property (copy, nonatomic) void(^didSelectRowHandle)(NSInteger index);
@property (copy, nonatomic) UITableViewCell *(^cellConfigure)(UITableView *tableView, NSIndexPath *indexPath);

@end


@implementation XCActionSheet

#pragma mark - 👀 Init Method 👀 💤

- (instancetype)initWithTitle:(NSString *)title
                contentTitles:(NSArray<NSString *> *)titles
                  cancelTitle:(NSString *)cancelTitle
                    configure:(XCActionSheetConfigure *)configure
                selectedIndex:(NSInteger)selectedIndex
{
    return [self initWithTitle:title
                 contentTitles:titles
                   cancelTitle:cancelTitle
                     configure:configure
                 selectedIndex:selectedIndex
                      isCustom:NO
                     cellCount:0];
}

- (instancetype)initWithTitle:(NSString *)title
                contentTitles:(NSArray<NSString *> *)titles
                  cancelTitle:(NSString *)cancelTitle
                    configure:(XCActionSheetConfigure *)configure
                selectedIndex:(NSInteger)selectedIndex
                     isCustom:(BOOL)isCustom
                    cellCount:(NSInteger)cellCount
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        self.backgroundColor = [UIColor clearColor];
        self.title         = title;
        self.cancleTitle   = cancelTitle ?: @"取消";
        self.contentTitles = titles;
        self.selectedIndex = selectedIndex;
        self.configure     = configure ?: [XCActionSheetConfigure defaultConfigure];
        self.isCustom      = isCustom;
        self.cellCount     = cellCount;
        
        // 设置 默认参数
        [self setupDefaults];
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }
    
    return self;
}

/**
 设置 默认参数
 */
- (void)setupDefaults
{
    /*⏰ ----- 添加背景蒙板 ----- ⏰*/
    UIButton *maskView = [[UIButton alloc] initWithFrame:self.bounds];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    [maskView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.mask = maskView;
    [self addSubview:maskView];
    
    
    /*⏰ ----- 添加内容视图 ----- ⏰*/
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    [self addSubview:self.contentView];
    
    /// titleView
    CGFloat titleH = 0;
    
    // 存在标题
    if (self.title  &&  self.title.length)
    {
        UIView *titleView = [[UIView alloc] init];
        
        CGFloat titleMaxH = 100;
        CGFloat titleX = 15;
        CGFloat titleY = 15;
        CGFloat titleW = SCREEN_WIDTH - titleX * 2;
        titleH = [self.title boundingRectWithSize:CGSizeMake(titleW, titleMaxH) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.configure.titleFontSize]} context:NULL].size.height;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor     = self.configure.titleTextColor;
        titleLabel.text          = self.title;
        
        [titleView addSubview:titleLabel];
        
        titleH += (titleY * 2);
        
        titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, titleH);
        titleView.backgroundColor = [UIColor whiteColor];
        
        /// 分隔线
        CALayer *speratorLayer = [CALayer layer];
        speratorLayer.backgroundColor = SEPERATOR_LINE_COLOR.CGColor;
        speratorLayer.frame = CGRectMake(0, titleH - .5, SCREEN_WIDTH, .5);
        [titleView.layer addSublayer:speratorLayer];
        
        [self.contentView addSubview:titleView];
    }
    
    /// 中间的 tableView
    NSInteger cellCount = self.contentTitles.count;
    
    if (self.isCustom)
    {
        // 如果是 自定义的cell
        cellCount = self.cellCount;
    }
    
    CGFloat contentTableX = 0;
    CGFloat contentTableY = titleH;
    CGFloat contentTableW = SCREEN_WIDTH;
    CGFloat contentTableH = MIN(cellCount, MAX_CONTENT_ROWS_COUNT) * CONTENT_CELL_HEIGHT;
    UITableView *contentTableView   = [[UITableView alloc] initWithFrame:CGRectMake(contentTableX, contentTableY, contentTableW, contentTableH) style:UITableViewStylePlain];
    contentTableView.dataSource     = self;
    contentTableView.delegate       = self;
    contentTableView.rowHeight      = CONTENT_CELL_HEIGHT;
    contentTableView.scrollEnabled  = (cellCount > MAX_CONTENT_ROWS_COUNT);
    contentTableView.separatorColor = SEPERATOR_LINE_COLOR;
    [self.contentView addSubview:contentTableView];
    
    /// 底部的分隔线
    CGFloat bottomLineLayerX = 0;
    CGFloat bottomLineLayerY = CGRectGetMaxY(contentTableView.frame);
    CGFloat bottomLineLayerW = SCREEN_WIDTH;
    CGFloat bottomLineLayerH = 10;
    CALayer *bottomLineLayer = [CALayer layer];
    bottomLineLayer.frame    = CGRectMake(bottomLineLayerX, bottomLineLayerY, bottomLineLayerW, bottomLineLayerH);
    bottomLineLayer.backgroundColor = SEPERATOR_LINE_COLOR.CGColor;
    [self.contentView.layer addSublayer:bottomLineLayer];
    
    /// 底部取消按钮
    CGFloat cancelButtonX  = 0;
    CGFloat cancelButtonY  = CGRectGetMaxY(contentTableView.frame) + 10;
    CGFloat cancelButtonW  = SCREEN_WIDTH;
    CGFloat cancelButtonH  = CONTENT_CELL_HEIGHT;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(cancelButtonX, cancelButtonY, cancelButtonW, cancelButtonH);
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitle:self.cancleTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:self.configure.titleTextColor forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:self.configure.titleFontSize];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelButton];
    
    CGFloat contentX = 0;
    CGFloat contentW = SCREEN_WIDTH;
    CGFloat contentH = CGRectGetMaxY(cancelButton.frame);
    CGFloat contentY = SCREEN_HEIGHT - contentH;
    contentView.frame = CGRectMake(contentX, contentY, contentW, contentH);
}

#pragma mark - 🎬 👀 Action Method 👀

/**
 显示
 */
- (void)show
{
    __weak typeof(self) weakSelf = self;
    
    CGFloat moveY = CGRectGetHeight(self.contentView.frame);
    
    self.contentView.transform = CGAffineTransformMakeTranslation(0, moveY);
    
    self.mask.alpha = 0;
    
    [UIView animateWithDuration:DURATION animations:^{
        
        weakSelf.mask.alpha = 1.f;
        weakSelf.contentView.transform = CGAffineTransformIdentity;
    }];
}

/**
 消失
 */
- (void)dismiss
{
    __weak typeof(self) weakSelf = self;
    
    self.contentView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:DURATION animations:^{
        
        CGFloat moveY = CGRectGetHeight(weakSelf.contentView.frame);
        
        weakSelf.contentView.transform = CGAffineTransformMakeTranslation(0, moveY);
        weakSelf.mask.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
        
        if (weakSelf.dismissHandle)
        {
            weakSelf.dismissHandle();
        }
    }];
}


/**
 点击了 内容上的某个 cell 的回调
 */
- (void)didClickRowAction:(UIButton *)button
{
    [self dismiss];
    
    NSInteger index = button.tag - CELL_BUTTON_TAG;
    
    if (self.didClickHandle)
    {
        self.didClickHandle(index, button.currentTitle);
    }
}

#pragma mark - 🔓 👀 Public Method 👀

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
                   dismissHandle:(void(^)(void))dismissHandle
{
    [self showActionSheetWithTitle:title
                     contentTitles:titles
                         configure:NULL
                     selectedIndex:NSNotFound
                    didClickHandle:didClickHandle
                     dismissHandle:dismissHandle];
}


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
                   dismissHandle:(void(^)(void))dismissHandle
{
    [self showActionSheetWithTitle:title
                     contentTitles:titles
                       cancelTitle:@"取消"
                         configure:configure
                     selectedIndex:selectedIndex
                    didClickHandle:didClickHandle
                     dismissHandle:dismissHandle];
}


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
                   dismissHandle:(void(^)(void))dismissHandle
{
    XCActionSheet *actionSheet = [[XCActionSheet alloc] initWithTitle:title
                                                        contentTitles:titles
                                                          cancelTitle:cancelTitle
                                                            configure:configure
                                                        selectedIndex:selectedIndex];
    
    actionSheet.didClickHandle = didClickHandle;
    actionSheet.dismissHandle  = dismissHandle;
    
    [actionSheet show];
}

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
                   dismissHandle:(void(^)(void))dismissHandle
{
    XCActionSheet *actionSheet = [[XCActionSheet alloc] initWithTitle:title
                                                        contentTitles:NULL
                                                          cancelTitle:@"取消"
                                                            configure:configure
                                                        selectedIndex:selectedIndex
                                                             isCustom:YES
                                                            cellCount:cellCount];
    
    actionSheet.cellConfigure      = cellConfigure;
    actionSheet.didSelectRowHandle = didSelectRowHandle;
    actionSheet.dismissHandle      = dismissHandle;
    
    [actionSheet show];
}

#pragma mark - 💉 👀 UITableViewDatasource 👀

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 是自定义的cell
    if (self.isCustom)
    {
        return self.cellCount;
    }
    
    return self.contentTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /// 自定义cell
    if (self.isCustom)
    {
        if (self.cellConfigure)
        {
            return self.cellConfigure(tableView, indexPath);
        }
    }
    
    /// 非自定义的cell
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        if (self.isCustom)
        {
            return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        else
        {
            /// 非自定义的cell
            cell = [[XCActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.contentTitles.count > indexPath.row)
    {
        NSString *title  = self.contentTitles[indexPath.row];
        UIButton *button = ((XCActionSheetCell *)cell).titleButton;
        button.tag = indexPath.row + CELL_BUTTON_TAG;
        [button addTarget:self action:@selector(didClickRowAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:self.configure.contentFontSize];
        
        UIColor *titleColor = self.configure.normalContentTextColor;
        
        /// 设置选中状态
        if (self.selectedIndex == indexPath.row)
        {
            titleColor = self.configure.selectedContentTextColor;
        }
        
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        [button setTitleColor:[titleColor colorWithAlphaComponent:.5f] forState:UIControlStateHighlighted];
    }
    
    return cell;
}

#pragma mark - 💉 👀 UITableViewDelegate 👀

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
    
    if (!self.isCustom)
    {
        return;
    }
    
    if (self.didSelectRowHandle)
    {
        self.didSelectRowHandle(indexPath.row);
    }
}

// 设置分隔线的样式
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end


