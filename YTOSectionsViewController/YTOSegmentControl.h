//
//  YTOSegmentControl.h
//  testaa
//
//  Created by FlyOceanFish on 2017/8/11.
//  Copyright © 2017年 FlyOceanFish. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IndexChangeBlock)(NSInteger index);

typedef NS_ENUM(NSInteger, YTOSegmentedControlSelectionIndicatorLocation) {
    YTOSegmentControlSelectionIndicatorLocationUp,
    YTOSegmentControlSelectionIndicatorLocationDown,
    YTOSegmentedControlSelectionIndicatorLocationNone
};
typedef NS_ENUM(NSInteger, YTOSegmentedControlSegmentWidthStyle) {
    YTOSegmentedControlSegmentWidthStyleFixed,
    YTOSegmentedControlSegmentWidthStyleDynamic,
};
@interface YTOSegmentControl : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>*)sectionTitles;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>*)sectionTitles segmentWidthStyle:(YTOSegmentedControlSegmentWidthStyle) segmentWidthStyle;

/**
 需要显示的文本数组
 */
@property (nonatomic, strong)NSArray<NSString *> *sectionTitles;

/**
 选中改变时的回调
 */
@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;

/**
 不选中时文本的颜色
 */
@property (nonatomic, strong) UIColor *titleTextColor;

/**
 选中文本的颜色
 */
@property (nonatomic, strong) UIColor *selectedTitleTextColor;

/**
 文字大小
 */
@property (nonatomic, strong) UIFont *titleTextFont;

/**
 设置当前选中第几个
 */
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

/**
 Indicator的高度
 */
@property (nonatomic, assign) CGFloat selectionIndicatorHeight;

/**
 Indicator左右边距
 */
@property (nonatomic, readwrite) UIEdgeInsets selectionIndicatorEdgeInsets;

/**
 Indicator的颜色
 */
@property (nonatomic, strong) UIColor *selectionIndicatorColor;

/**
 Indicator位置 支持上、下、无
 */
@property (nonatomic, assign) YTOSegmentedControlSelectionIndicatorLocation selectionIndicatorLocation;

@property (nonatomic, assign) YTOSegmentedControlSegmentWidthStyle segmentWidthStyle;

- (void)yto_setNumber:(NSInteger)number AtIndex:(NSUInteger)index badgeBgColor:(UIColor *)badgeBgColor badgeTextColor:(UIColor *)badgeTextColor;
@end
