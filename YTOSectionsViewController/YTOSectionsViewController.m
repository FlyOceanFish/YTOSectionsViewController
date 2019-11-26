//
//  YTOSectionsViewController.m
//  testaa
//
//  Created by FlyOceanFish on 2017/8/12.
//  Copyright © 2017年 wangrifei. All rights reserved.
//

#import "YTOSectionsViewController.h"
#import "YTOPagesViewController.h"
#import "YTOSegmentControl.h"

@interface YTOSectionsViewController ()
@property(nonatomic,strong)YTOPagesViewController *pageVC;
@property(nonatomic,strong)YTOSegmentControl *segmentControl;

@property(nonatomic,assign)NSInteger bagedNumber;
@property(nonatomic,assign)NSInteger bagedIndex;
@property(nonatomic,strong)UIColor *badgeBgColor;
@property(nonatomic,strong)UIColor *badgeTextColor;

@end

@implementation YTOSectionsViewController
-(instancetype _Nonnull)initWithTitles:(NSArray<NSString *>* _Nonnull)sectionTitles pageViewControllerClasses:(NSArray<Class> * _Nonnull) pageViewControllerClasses{
    self = [super init];
    if (self) {
        NSAssert(sectionTitles.count==pageViewControllerClasses.count, @"两个数组大小必须一致");
        self.sectionTitles = sectionTitles;
        self.pageViewControllerClasses = pageViewControllerClasses;
        [self initDefault];
        [self initUI];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)initDefault{
    self.bagedIndex = -1;
    self.bagedNumber = -1;
}
- (void)initUI{
    __weak typeof(self) this = self;
    self.segmentControl = [[YTOSegmentControl alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40)titles:self.sectionTitles segmentWidthStyle:YTOSegmentedControlSegmentWidthStyleFixed];
    if (self.titleTextColor) {
        self.segmentControl.titleTextColor = self.titleTextColor;
    }
    if (self.selectedTitleTextColor) {
        self.segmentControl.selectedTitleTextColor = self.selectedTitleTextColor;
    }
    if (self.titleTextFont) {
        self.segmentControl.titleTextFont = self.titleTextFont;
    }
    self.segmentControl.selectionIndicatorLocation = YTOSegmentControlSelectionIndicatorLocationDown;
    self.segmentControl.selectedSegmentIndex = self.defaultPage;
    if (self.selectionIndicatorColor) {
        self.segmentControl.selectionIndicatorColor = self.selectionIndicatorColor;
    }
    [self.segmentControl setIndexChangeBlock:^(NSInteger index){
        this.pageVC.defaultPage = index;
        if (this.sectonsPageChanged) {
            this.sectonsPageChanged(index);
        }
    }];
    if (self.bagedNumber!=-1) {
        [self yto_setNumber:self.bagedNumber AtIndex:self.bagedIndex badgeBgColor:self.badgeBgColor badgeTextColor:self.badgeTextColor];
    }
    [self.view addSubview:self.segmentControl];
    
    _segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(height)]|" options:0 metrics:@{@"height":@(CGRectGetHeight(self.segmentControl.frame))} views:@{@"view":_segmentControl}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":_segmentControl}]];

    self.pageVC = [[YTOPagesViewController alloc] initWithNavigationOrientation:YTOPageViewControllerNavigationOrientationHorizontal betweenGap:0];
    self.pageVC.pageViewControllerClasses = self.pageViewControllerClasses;
    self.pageVC.defaultPage = self.defaultPage;
    [self.pageVC setYTOPageViewControllerPageChanged:^(NSUInteger currentPage){
        this.segmentControl.selectedSegmentIndex = currentPage;
    }];
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    _pageVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"view":_pageVC.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view2]-0-[view]-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"view":_pageVC.view,@"view2":_segmentControl}]];
    [self.pageVC didMoveToParentViewController:self];
}
- (void)yto_addParentViewController:(UIViewController *)vc{
    [vc addChildViewController:self];
    [vc.view addSubview:self.view];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [vc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"view":self.view}]];
    [vc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"view":self.view}]];
    [self didMoveToParentViewController:vc];
}

-(void)yto_setNumber:(NSInteger)number AtIndex:(NSUInteger)index{
    [self yto_setNumber:number AtIndex:index badgeBgColor:nil badgeTextColor:nil];
}
- (void)yto_setNumber:(NSInteger)number AtIndex:(NSUInteger)index badgeBgColor:(UIColor *_Nullable)badgeBgColor badgeTextColor:(UIColor *_Nullable)badgeTextColor{
    if (self.segmentControl) {
        [self.segmentControl yto_setNumber:number AtIndex:index badgeBgColor:badgeBgColor badgeTextColor:badgeTextColor badgeMaximumBadgeNumber:self.badgeMaximumBadgeNumber];
    }else{
        self.bagedNumber = number;
        self.bagedIndex = index;
        self.badgeBgColor = badgeBgColor;
        self.badgeTextColor = badgeTextColor;
    }

}
-(void)setDefaultPage:(NSUInteger)defaultPage{
    if(_defaultPage!=defaultPage){
        _defaultPage = defaultPage;
        self.segmentControl.selectedSegmentIndex = _defaultPage;
    }
}
-(void)setSelectedTitleTextColor:(UIColor *)selectedTitleTextColor{
    _selectedTitleTextColor = selectedTitleTextColor;
    self.segmentControl.selectedTitleTextColor = self.selectedTitleTextColor;
}
-(void)setTitleTextFont:(UIFont *)titleTextFont{
    _titleTextFont = titleTextFont;
    self.segmentControl.titleTextFont = titleTextFont;
}
-(void)setTitleTextColor:(UIColor *)titleTextColor{
    _titleTextColor = titleTextColor;
    self.segmentControl.titleTextColor = titleTextColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
