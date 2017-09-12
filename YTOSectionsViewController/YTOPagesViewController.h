//
//  YTOPageViewController.h
//  testaa
//
//  Created by FlyOceanFish on 2017/8/10.
//  Copyright © 2017年 wangrifei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YTOPageViewControllerNavigationOrientation) {
    YTOPageViewControllerNavigationOrientationHorizontal = 0,
    YTOPageViewControllerNavigationOrientationVertical = 1
};
@interface YTOPagesViewController : UIViewController

/**
 当前显示的视图
 */
@property(nonatomic,strong)UIViewController * _Nonnull currentViewController;

/**
 要加载的ViewController，传ClassName即可
 */
@property(nonatomic,copy)NSArray<Class> * _Nonnull pageViewControllerClasses;

/**
 默认当前显示第几页
 */
@property(nonatomic,assign)NSUInteger defaultPage;

/**
 当滑动结束的时候回调
 currentPage 当前页
 */
@property(nonatomic,copy)void (^ _Nullable YTOPageViewControllerPageChanged)(NSUInteger currentPage);
/**
 将要滑动的时候回调
 currentPage 当前页
 */
@property(nonatomic,copy)void (^ _Nullable YTOPageViewControllerWillPageChanged)(UIViewController * _Nonnull controller);
/**
 实例化PagesViewController

 @param navigationOrientation 滑动方向
 @param betweenGap 两个ViewController的间距
 @return 对象
 */
- (instancetype _Nonnull )initWithNavigationOrientation:(YTOPageViewControllerNavigationOrientation)navigationOrientation betweenGap:(NSUInteger)betweenGap;

@end
