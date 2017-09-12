//
//  YTOPageViewController.m
//  testaa
//
//  Created by FlyOceanFish on 2017/8/10.
//  Copyright © 2017年 wangrifei. All rights reserved.
//

#import "YTOPagesViewController.h"


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
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    if (self.YTOPageViewControllerWillPageChanged) {
        self.YTOPageViewControllerWillPageChanged(self.currentViewController);
    }
}
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
    if (completed) {
        self.currentViewController = [pageViewController.viewControllers firstObject];
        if (completed&&self.YTOPageViewControllerPageChanged) {
            self.YTOPageViewControllerPageChanged([self private_indexOfViewController:pageViewController.viewControllers.firstObject]);
        }
    }
}

#pragma mark - Private
- (NSString *)private_findXibName:(Class)className{
    [NSBundle mainBundle];
    NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass(className) ofType:@"nib"];
    Boolean exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!exist) {
        className = [className superclass];
        if ([className isSubclassOfClass:[UIViewController class]]&&![NSStringFromClass(className) isEqualToString:NSStringFromClass([UIViewController class])]) {
            [self private_findXibName:className];
        }
    }
    return NSStringFromClass(className);
}
- (UIViewController *)private_viewControllerForPage:(NSUInteger)pageIndex{
    if (pageIndex<self.pageViewControllerClasses.count) {
        if (pageIndex<self.cacheViewControllerArray.count&&[self.cacheViewControllerArray[pageIndex] isKindOfClass:[UIViewController class]]) {
            return self.cacheViewControllerArray[pageIndex];
        }else{
            Class controllerClass =  self.pageViewControllerClasses[pageIndex];
            NSString *xibName = [self private_findXibName:controllerClass];
            UIViewController *controller ;
            if (xibName.length) {
                controller = [[controllerClass alloc] initWithNibName:xibName bundle:nil];
            }else{
                controller = [[controllerClass alloc] init];
            }
            [self.cacheViewControllerArray replaceObjectAtIndex:pageIndex withObject:controller];
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
    if(defaultPage==[self private_indexOfViewController:self.currentViewController]){
        return;
    }
    _defaultPage = defaultPage;
    if (_defaultPage<_pageViewControllerClasses.count) {
        UIPageViewControllerNavigationDirection direction = defaultPage<[self private_indexOfViewController:self.pageViewController.viewControllers.firstObject]?UIPageViewControllerNavigationDirectionReverse:UIPageViewControllerNavigationDirectionForward;
        self.currentViewController = [self private_viewControllerForPage:_defaultPage];
       [self.pageViewController setViewControllers:@[self.currentViewController] direction:direction animated:YES completion:nil];
        if (self.YTOPageViewControllerWillPageChanged) {
            self.YTOPageViewControllerWillPageChanged(self.currentViewController);
        }
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
        for (NSObject *object in self.pageViewControllerClasses) {
            [_cacheViewControllerArray addObject:object];
        }
    }
    return _cacheViewControllerArray;
}
@end
