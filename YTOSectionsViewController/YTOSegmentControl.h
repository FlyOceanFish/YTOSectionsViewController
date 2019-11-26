//
//  YTOSegmentControl.h
//  testaa
//
//  Created by FlyOceanFish on 2017/8/11.
//  Copyright © 2017年 wangrifei. All rights reserved.
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
};@interface YTOSegmentControl : UIView

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
@property (nonatomic, strong) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;

/**
 选中文本的颜色
 */
@property (nonatomic, strong) UIColor *selectedTitleTextColor UI_APPEARANCE_SELECTOR;
/**
 选中背景的颜色
 */
@property (nonatomic, strong) UIColor *selectedBackgroundColor UI_APPEARANCE_SELECTOR;
/**
 不选中背景的颜色
 */
@property (nonatomic, strong) UIColor *defaultBackgroundColor UI_APPEARANCE_SELECTOR;
/**
 选中时的特效
 */
@property (nonatomic, assign) BOOL enableSelectedEffect UI_APPEARANCE_SELECTOR;
/**
 文字大小
 */
@property (nonatomic, strong) UIFont *titleTextFont UI_APPEARANCE_SELECTOR;

/**
 设置当前选中第几个
 */
@property (nonatomic, assign) NSInteger selectedSegmentIndex UI_APPEARANCE_SELECTOR;

/**
 Indicator的高度
 */
@property (nonatomic, assign) CGFloat selectionIndicatorHeight UI_APPEARANCE_SELECTOR;

/**
 Indicator左右边距
 */
@property (nonatomic, readwrite) UIEdgeInsets selectionIndicatorEdgeInsets UI_APPEARANCE_SELECTOR;

/**
 Indicator的颜色
 */
@property (nonatomic, strong) UIColor *selectionIndicatorColor UI_APPEARANCE_SELECTOR;

/**
 Indicator位置 支持上、下、无
 */
@property (nonatomic, assign) YTOSegmentedControlSelectionIndicatorLocation selectionIndicatorLocation;

@property (nonatomic, assign) YTOSegmentedControlSegmentWidthStyle segmentWidthStyle;

- (void)yto_setNumber:(NSInteger)number AtIndex:(NSUInteger)index badgeBgColor:(UIColor *)badgeBgColor badgeTextColor:(UIColor *)badgeTextColor badgeMaximumBadgeNumber:(NSInteger)badgeMaximumBadgeNumber;
@end
