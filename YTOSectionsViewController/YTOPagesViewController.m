//
//  YTOPageViewController.m
//
//  Created by FlyOceanFish on 2017/8/10.
//  Copyright © 2017年 FlyOceanFish. All rights reserved.
//

#import "YTOPagesViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface YTOPagesViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property(nonatomic,strong)UIPageViewController *pageViewController;
@property(nonatomic,strong)NSMutableArray *cacheViewControllerArray;
/**
 两个ViewController之间的间距
 */
@property(nonatomic,assign)NSUInteger betweenGap;
@property(nonatomic,assign)YTOPageViewControllerNavigationOrientation pageViewControllerNavigationOrientation;
@end

@implementation YTOPagesViewController
- (instancetype _Nonnull )initWithNavigationOrientation:(YTOPageViewControllerNavigationOrientation)navigationOrientation betweenGap:(NSUInteger)betweenGap{
    self = [super init];
    if (self) {
        self.pageViewControllerNavigationOrientation = navigationOrientation;
        self.betweenGap = betweenGap;
    }
    return  self;
}
#pragma mark - UIPageViewControllerDataSource&UIPageViewControllerDelegate
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [self private_indexOfViewController:viewController];
    if (currentIndex>0) {
        return [self private_viewControllerForPage:currentIndex-1];
    }
    return nil;
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [self private_indexOfViewController:viewController];
    if (currentIndex>=0) {
        return [self private_viewControllerForPage:currentIndex+1];
    }
    return nil;
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed&&self.YTOPageViewControllerPageChanged) {
        self.YTOPageViewControllerPageChanged([self private_indexOfViewController:pageViewController.viewControllers.firstObject]);
    }
}

#pragma mark - Private
- (UIViewController *)private_viewControllerForPage:(NSUInteger)pageIndex{
    if (pageIndex<self.pageViewControllerClasses.count) {
        if (pageIndex<self.cacheViewControllerArray.count) {
            return self.cacheViewControllerArray[pageIndex];
        }else{
            Class controllerClass =  self.pageViewControllerClasses[pageIndex];
            UIViewController *controller = [[controllerClass alloc] init];
            [self.cacheViewControllerArray insertObject:controller atIndex:pageIndex];
            return controller;
        }
    }
    
    return nil;
    
}
- (NSInteger)private_indexOfViewController:(UIViewController *)viewController{
    NSInteger index = [self.cacheViewControllerArray indexOfObject:viewController];
    return index;
}
#pragma mark - Property
-(void)setDefaultPage:(NSUInteger)defaultPage{
    _defaultPage = defaultPage;
    if (_defaultPage<_pageViewControllerClasses.count) {
        UIPageViewControllerNavigationDirection direction = defaultPage<[self private_indexOfViewController:self.pageViewController.viewControllers.firstObject]?UIPageViewControllerNavigationDirectionReverse:UIPageViewControllerNavigationDirectionForward;
       [self.pageViewController setViewControllers:@[[self private_viewControllerForPage:_defaultPage]] direction:direction animated:YES completion:nil];
    }

}

-(void)setPageViewControllerClasses:(NSArray<Class> *)childViewControllerClasses{
    _pageViewControllerClasses = childViewControllerClasses;
    NSAssert(_pageViewControllerClasses.count>0&&self.defaultPage<_pageViewControllerClasses.count, @"数组不能为空或默认页越界");
    if (self.pageViewController.viewControllers.count==0) {
        [self.pageViewController setViewControllers:@[[self private_viewControllerForPage:self.defaultPage]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}
-(UIPageViewController *)pageViewController{
    if (_pageViewController==nil) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:self.pageViewControllerNavigationOrientation==YTOPageViewControllerNavigationOrientationHorizontal?UIPageViewControllerNavigationOrientationHorizontal:UIPageViewControllerNavigationOrientationVertical options:@{UIPageViewControllerOptionInterPageSpacingKey:@(self.betweenGap)}];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [_pageViewController didMoveToParentViewController:self];
    }
    return _pageViewController;
}
-(NSMutableArray *)cacheViewControllerArray{
    if (_cacheViewControllerArray==nil) {
        _cacheViewControllerArray = [NSMutableArray array];
    }
    return _cacheViewControllerArray;
}
@end
