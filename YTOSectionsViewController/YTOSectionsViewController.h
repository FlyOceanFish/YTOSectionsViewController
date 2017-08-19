//
//  YTOSectionsViewController.h
//
//  Created by FlyOceanFish on 2017/8/12.
//  Copyright © 2017年 FlyOceanFish. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^YTOSectionPageChanged)(NSUInteger index);
@interface YTOSectionsViewController : UIViewController
-(instancetype _Nonnull )initWithTitles:(NSArray<NSString *>* _Nonnull)sectionTitles pageViewControllerClasses:(NSArray<Class> * _Nonnull) pageViewControllerClasses;
/**
 需要显示的文本数组
 */
@property (nonatomic, strong)NSArray<NSString *> * _Nonnull sectionTitles;
/**
 要加载的ViewController，传ClassName即可
 */
@property(nonatomic, copy)NSArray<Class> * _Nonnull pageViewControllerClasses;

/**
 默认当前显示第几个
 */
@property(nonatomic, assign)NSUInteger defaultPage;

/**
 不选中时文本的颜色
 */
@property (nonatomic, strong) UIColor * _Nullable titleTextColor;
/**
 文字大小
 */
@property (nonatomic, strong) UIFont * _Nullable titleTextFont;

/**
 选中文本的颜色
 */
@property (nonatomic, strong) UIColor * _Nullable selectedTitleTextColor;

@property (nonatomic, copy)YTOSectionPageChanged _Nullable sectonsPageChanged;

/**
 设置顶部标题旁边的badge属性

 @param number 数字
 @param index 第几个
 */
- (void)yto_setNumber:(NSInteger)number AtIndex:(NSUInteger)index;

/**
 设置顶部标题旁边的badge属性

 @param number 数字
 @param index 第几个
 @param badgeBgColor badge背景颜色
 @param badgeTextColor badge数字颜色
 */
- (void)yto_setNumber:(NSInteger)number AtIndex:(NSUInteger)index badgeBgColor:(UIColor *_Nullable)badgeBgColor badgeTextColor:(UIColor *_Nullable)badgeTextColor;
@end
