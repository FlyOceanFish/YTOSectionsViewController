# YTOSectionsViewController
一个顶部TableViewController的封装。基于UICollectionView和UIPageViewController的实现

# 使用方法
    YTOSectionsViewController *yto = [[YTOSectionsViewController alloc] initWithTitles:@[@"测试1",@"测试2",@"测测试1试1"] pageViewControllerClasses:self.array];
    [yto yto_setNumber:10 AtIndex:1];
    [self addChildViewController:yto];
    [self.view addSubview:yto.view];
    [yto didMoveToParentViewController:self];
## YTOPagesViewController
实现多个UIViewController上下或左右滑动

## YTOSegmentControl
实现了多个SementControl，支持将屏幕平分或者根据文字长度动态显示

# 效果
![效果.png](http://upload-images.jianshu.io/upload_images/6644906-c23a7e673aca129a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
