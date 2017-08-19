//
//  YTOSegmentControl.m
//
//  Created by FlyOceanFish on 2017/8/11.
//  Copyright © 2017年 FlyOceanFish. All rights reserved.
//

#import "YTOSegmentControl.h"
#import "YTOSectionTitleCollectionViewCell.h"
#import "UIView+WZLBadge.h"

const NSUInteger defaultTextSize = 12;
const NSUInteger selectionIndicatorHeight = 2;

@interface YTOSegmentControl()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)CALayer *selectionIndicatorArrowLayer;
@property(nonatomic,strong)NSIndexPath *preIndexPath;

@property(nonatomic,assign)NSInteger bagedNumber;
@property(nonatomic,assign)NSInteger bagedIndex;
@property(nonatomic,strong)UIColor *badgeBgColor;
@property(nonatomic,strong)UIColor *badgeTextColor;

@end

@implementation YTOSegmentControl
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefault];
        [self initUI:frame];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)sectionTitles{
    self = [self initWithFrame:frame];
    if (self) {
        self.sectionTitles = sectionTitles;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>*)sectionTitles segmentWidthStyle:(YTOSegmentedControlSegmentWidthStyle)segmentWidthStyle{
    self = [self initWithFrame:frame];
    if (self) {
        _sectionTitles = sectionTitles;
        _segmentWidthStyle = segmentWidthStyle;
        [self.collectionView reloadData];
    }
    return self;
}

#pragma mark - Init
- (void)initDefault{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionIndicatorColor = [UIColor redColor];
    self.selectionIndicatorHeight = selectionIndicatorHeight;
    self.segmentWidthStyle = YTOSegmentedControlSegmentWidthStyleFixed;
    self.selectionIndicatorLocation = YTOSegmentControlSelectionIndicatorLocationDown;
    self.selectedSegmentIndex = 0;
    self.bagedIndex = -1;
}
- (void)initUI:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[YTOSectionTitleCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView.layer addSublayer:self.selectionIndicatorArrowLayer];
}
#pragma mark - UICollectionViewDataSource&UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentWidthStyle == YTOSegmentedControlSegmentWidthStyleFixed) {
        return CGSizeMake(CGRectGetWidth(self.bounds)/self.sectionTitles.count,CGRectGetHeight(self.bounds));
    }
    return CGSizeMake([self private_textSizeWidth:indexPath.item], CGRectGetHeight(self.bounds));
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sectionTitles.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    YTOSectionTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (self.preIndexPath==indexPath) {
            [self private_setSelectionIndicatorArrowLayerOff:cell.frame.origin.x width:CGRectGetWidth(cell.bounds)];
    }
    cell.textLabel.font = self.titleTextFont==nil?[UIFont systemFontOfSize:defaultTextSize]:self.titleTextFont;
    cell.textLabel.text = self.sectionTitles[indexPath.row];
    cell.textLabel.highlightedTextColor = self.selectedTitleTextColor==nil?[UIColor redColor]:self.selectedTitleTextColor;
    cell.textLabel.textColor = (self.titleTextColor==nil?[UIColor blackColor]:self.titleTextColor);
    if (self.bagedIndex==indexPath.row) {
        [self private_setBadgeForCell:cell number:self.bagedNumber index:self.bagedIndex badgeBgColor:self.badgeBgColor badgeTextColor:self.badgeTextColor];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.preIndexPath&&self.preIndexPath!=indexPath) {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:self.segmentWidthStyle==YTOSegmentedControlSegmentWidthStyleFixed?UICollectionViewScrollPositionNone:UICollectionViewScrollPositionCenteredHorizontally];
        [collectionView deselectItemAtIndexPath:self.preIndexPath animated:NO];
        [self private_scrollIndicator:indexPath];
    }
    self.preIndexPath = indexPath;
}
#pragma mark - Action
- (void)yto_setNumber:(NSInteger)number AtIndex:(NSUInteger)index badgeBgColor:(UIColor *)badgeBgColor badgeTextColor:(UIColor *)badgeTextColor{
    NSAssert(index<self.sectionTitles.count, @"请先设置标题，数组越界了");
    YTOSectionTitleCollectionViewCell *cell = (YTOSectionTitleCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (cell) {
        [self private_setBadgeForCell:cell number:number index:index badgeBgColor:badgeBgColor badgeTextColor:badgeTextColor];
    }else{
        _bagedIndex = index;
        _bagedNumber = number;
        _badgeBgColor = badgeBgColor;
        _badgeTextColor = badgeTextColor;
    }
}
#pragma mark - Property
-(void)setSectionTitles:(NSArray<NSString *> *)sectionTitles{
    _sectionTitles = sectionTitles;
    [self.collectionView reloadData];
}
-(void)setSelectionIndicatorHeight:(CGFloat)selectionIndicatorHeight{
    _selectionIndicatorHeight = selectionIndicatorHeight;
    self.selectionIndicatorArrowLayer.frame = CGRectMake(self.selectionIndicatorArrowLayer.frame.origin.x+self.selectionIndicatorEdgeInsets.left, self.selectionIndicatorArrowLayer.frame.origin.y,CGRectGetWidth(self.selectionIndicatorArrowLayer.bounds)-self.selectionIndicatorEdgeInsets.left-self.selectionIndicatorEdgeInsets.right, _selectionIndicatorHeight);
}
-(CALayer *)selectionIndicatorArrowLayer{
    if (_selectionIndicatorArrowLayer == nil) {
        _selectionIndicatorArrowLayer = [[CALayer alloc] init];
        _selectionIndicatorArrowLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    }
    return _selectionIndicatorArrowLayer;
}
-(void)setSegmentWidthStyle:(YTOSegmentedControlSegmentWidthStyle)segmentWidthStyle{
    _segmentWidthStyle = segmentWidthStyle;
    if (_segmentWidthStyle==YTOSegmentedControlSegmentWidthStyleDynamic) {
        [self.collectionView reloadData];
    }
}
-(void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex{
    if (selectedSegmentIndex<self.sectionTitles.count) {
        self.preIndexPath = [NSIndexPath indexPathForRow:selectedSegmentIndex inSection:0];
        [self private_scrollIndicator:self.preIndexPath];
        [self.collectionView selectItemAtIndexPath:self.preIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }

}
-(void)setSelectionIndicatorLocation:(YTOSegmentedControlSelectionIndicatorLocation)selectionIndicatorLocation{
    _selectionIndicatorLocation = selectionIndicatorLocation;
    if (_selectionIndicatorLocation==YTOSegmentedControlSelectionIndicatorLocationNone) {
        [self.selectionIndicatorArrowLayer removeFromSuperlayer];
    }else if (_selectionIndicatorLocation==YTOSegmentControlSelectionIndicatorLocationUp){
        self.selectionIndicatorArrowLayer.frame = CGRectMake(self.selectionIndicatorArrowLayer.frame.origin.x, 0, CGRectGetWidth(self.selectionIndicatorArrowLayer.bounds), CGRectGetHeight(self.selectionIndicatorArrowLayer.bounds));
    }
}
-(void)setSelectionIndicatorEdgeInsets:(UIEdgeInsets)selectionIndicatorEdgeInsets{
    _selectionIndicatorEdgeInsets = selectionIndicatorEdgeInsets;
    self.selectionIndicatorArrowLayer.frame = CGRectMake(self.selectionIndicatorArrowLayer.frame.origin.x+self.selectionIndicatorEdgeInsets.left, self.selectionIndicatorArrowLayer.frame.origin.y,CGRectGetWidth(self.selectionIndicatorArrowLayer.bounds)-self.selectionIndicatorEdgeInsets.left-self.selectionIndicatorEdgeInsets.right, _selectionIndicatorHeight);
}
#pragma mark - Private
- (void)private_scrollIndicator:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.2 animations:^{
        YTOSectionTitleCollectionViewCell *cell = (YTOSectionTitleCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        [self private_setSelectionIndicatorArrowLayerOff:cell.frame.origin.x width:CGRectGetWidth(cell.bounds)];
        if (self.indexChangeBlock) {
            self.indexChangeBlock(indexPath.row);
        }
    }];
}
- (void)private_setBadgeForCell:(YTOSectionTitleCollectionViewCell *)cell number:(NSInteger)number index:(NSInteger)index badgeBgColor:(UIColor *)badgeBgColor badgeTextColor:(UIColor *)badgeTextColor{
    [cell.textLabel showNumberBadgeWithValue:number];
    CGPoint point = CGPointMake(-((CGRectGetWidth(cell.frame)-[self private_textSizeWidth:index])/2.0-6), (CGRectGetHeight(cell.frame)-cell.textLabel.font.lineHeight)/2.0);
    cell.textLabel.badgeCenterOffset = point;
    if (badgeBgColor) {
        cell.textLabel.badgeBgColor = badgeBgColor;
    }
    if (badgeTextColor) {
        cell.textLabel.badgeTextColor = badgeTextColor;
    }
}
- (CGFloat)private_textSizeWidth:(NSUInteger)index{
    NSString *string = self.sectionTitles[index];
    return ceil([string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.bounds)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSBackgroundColorAttributeName:[UIFont systemFontOfSize:defaultTextSize]} context:nil].size.width)+1;
}
- (void)private_setSelectionIndicatorArrowLayerOff:(CGFloat)offX width:(CGFloat)width{
    if (self.selectionIndicatorLocation==YTOSegmentControlSelectionIndicatorLocationDown) {
        self.selectionIndicatorArrowLayer.frame = CGRectMake(offX+self.selectionIndicatorEdgeInsets.left,CGRectGetHeight(self.frame)-self.selectionIndicatorHeight,width-self.selectionIndicatorEdgeInsets.left-self.selectionIndicatorEdgeInsets.right, self.selectionIndicatorHeight);
    }else if (self.selectionIndicatorLocation==YTOSegmentControlSelectionIndicatorLocationUp){
        self.selectionIndicatorArrowLayer.frame = CGRectMake(offX+self.selectionIndicatorEdgeInsets.left,0,width-self.selectionIndicatorEdgeInsets.left-self.selectionIndicatorEdgeInsets.right, self.selectionIndicatorHeight);
    }
}
@end
