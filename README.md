# YTOSectionsViewController
一个顶部TableViewController的封装。基于UICollectionView和UIPageViewController的实现
#使用方法
    YTOSectionsViewController *yto = [[YTOSectionsViewController alloc] initWithTitles:@[@"测试1",@"测试2",@"测测试1试1"] pageViewControllerClasses:self.array];
    [yto yto_setNumber:10 AtIndex:1];
    [self addChildViewController:yto];
    [self.view addSubview:yto.view];
    [yto didMoveToParentViewController:self];
